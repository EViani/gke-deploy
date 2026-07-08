from datetime import datetime, time
from fastapi import FastAPI

app = FastAPI()

"""
Return
"""
@app.get("/status")
def health():
    """
    Status of app
    """
    return {"status":"OK"}

@app.get("/data")
def get_data():
    return {"date":datetime.now()}

@app.get("/name")
def get_name():
    return {"name":"EViani","repo":"gke"}

@app.get("/app")
def get_app():
    return {"app_name":"GKE_DEPLOY"}