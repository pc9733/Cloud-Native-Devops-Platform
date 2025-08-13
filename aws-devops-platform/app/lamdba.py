import boto3
import psycopg2
from datetime import datetime

def lambda_handler(event, context):
    secret_name = "mydb-credentials-1"
    region_name = "us-east-1"

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

    cur = conn.cursor()
    cur.execute(
        "UPDATE tasks SET status='overdue' WHERE due_date < %s AND status='pending'",
        (datetime.utcnow(),)
    )
    updated_count = cur.rowcount
    conn.commit()
    cur.close()
    conn.close()

    return {"updated_tasks": updated_count}
