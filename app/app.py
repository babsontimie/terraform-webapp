from flask import Flask
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

@app.route("/")
def index():
    db_user = os.getenv("DbUsername")
    db_pass = os.getenv("DbPassword")
    db_name = os.getenv("DbName")
    db_server = os.getenv("DbServer")

    conn_string = f"Server=tcp:{db_server};Database={db_name};User ID={db_user};Password={db_pass};Encrypt=True;"
    return f"Connected to: {conn_string}"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)

