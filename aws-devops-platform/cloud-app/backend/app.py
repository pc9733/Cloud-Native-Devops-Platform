import socket
from flask import Flask, jsonify

app = Flask(__name__)

@app.get("/health")
def health():
    return jsonify(
        status="ok",
        host=socket.gethostname()
    )
