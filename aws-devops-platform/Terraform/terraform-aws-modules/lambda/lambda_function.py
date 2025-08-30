import os
import json
import boto3
import pymysql
from datetime import datetime

def lambda_handler(event, context):
    secret_name = os.environ["SECRET_NAME"]
    region_name = os.environ["AWS_REGION"]

    host = os.environ["DB_HOST"]
    port = int(os.environ.get("DB_PORT", 3306))
    db   = os.environ["DB_NAME"]

    sm = boto3.client("secretsmanager", region_name=region_name)
    secret = json.loads(sm.get_secret_value(SecretId=secret_name)["SecretString"])
    user = secret["username"]
    pwd  = secret["password"]

    conn = pymysql.connect(host=host, port=port, user=user, password=pwd, database=db)
    try:
        with conn.cursor() as cur:
            cur.execute(
                "UPDATE tasks SET status='overdue' WHERE due_date < %s AND status='pending'",
                (datetime.utcnow(),)
            )
            updated = cur.rowcount
        conn.commit()
    finally:
        conn.close()

    return {"updated_tasks": updated}
