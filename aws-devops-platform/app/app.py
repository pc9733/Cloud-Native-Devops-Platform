from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import boto3
import psycopg2
import os
from datetime import datetime

app = FastAPI()

# Model for incoming task data
class Task(BaseModel):
    title: str
    due_date: datetime

# Function to fetch DB creds from Secrets Manager
def get_db_connection():
    secret_name = os.getenv("SECRET_NAME", "mydb-credentials-1")
    region_name = os.getenv("AWS_REGION", "us-east-1")

    session = boto3.session.Session()
    client = session.client(service_name="secretsmanager", region_name=region_name)
    secret_value = client.get_secret_value(SecretId=secret_name)
    secret_dict = eval(secret_value["SecretString"])

    conn = psycopg2.connect(
        host=secret_dict["host"],
        port=secret_dict["port"],
        user=secret_dict["username"],
        password=secret_dict["password"],
        dbname=secret_dict["dbname"]
    )
    return conn

@app.post("/tasks")
def create_task(task: Task):
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute(
            "INSERT INTO tasks (title, due_date) VALUES (%s, %s) RETURNING id",
            (task.title, task.due_date)
        )
        task_id = cur.fetchone()[0]
        conn.commit()
        cur.close()
        conn.close()
        return {"id": task_id, "title": task.title, "status": "pending"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/tasks")
def list_tasks():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT id, title, status, created_at, due_date FROM tasks")
        rows = cur.fetchall()
        cur.close()
        conn.close()

        tasks = [
            {"id": r[0], "title": r[1], "status": r[2], "created_at": r[3], "due_date": r[4]}
            for r in rows
        ]
        return tasks
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
