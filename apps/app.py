from datetime import datetime, time
from fastapi import FastAPI

app = FastAPI()

@app.get("/status")
def health():
    return {"status":"OK"}

@app.get("/data")
def get_data():
    return {"date":datetime.now()}

@app.update("/data")
def update_data():
    return {"date":datetime.now().day, "data":"OK"}

@app.get("/name")
def get_name():
    return {"name":"EViani","repo":"gke"}

@app.get("/app")
def get_app():
    return {"app_name":"GKE_DEPLOY"}