from flask import Flask, jsonify
import os
import psycopg2

app = Flask(__name__)

@app.route("/health")
def health():
    return jsonify(status="UP"), 200

@app.route("/")
def home():
    return jsonify(message="Backend API is running")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
