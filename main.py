from fastapi import FastAPI
import os

app = FastAPI()


@app.get("/")
def shutdown():
    os.system("calc.exe")



