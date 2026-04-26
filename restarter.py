import sqlite3
import json
import os


DB_path = "./x-ui.db"
JSON_PATH = "D:\\My Projects\\restrarter\\users.json"

def check_json_exists(J_path = JSON_PATH):
    return os.path.exists(path=J_path)

def get_data(inbount_id: tuple=(6,8), path: str = DB_path) -> int:
    conn = sqlite3.connect(database=DB_path)
    conn.cursor()
    users= list()
    for i in inbount_id:
        query = conn.execute(
            "SELECT email FROM client_traffics WHERE inbound_id = ? AND total is not 0 AND down + up - total>=0 ",(i,)).fetchall()
        users+= [r[0] for r in query]
    needed_users_count = {'user_count':users}
    return needed_users_count


def create_json(J_path=JSON_PATH,data:dict=get_data()):
    data = get_data() 
    with open(file=J_path,mode="w",encoding="utf-8") as test:
        json.dump(obj=data,fp=test)
        

def json_reader(J_path = JSON_PATH):
    if check_json_exists():
        with open(file=J_path,mode='r') as file:
            return json.load(fp=file)
    else:
        create_json()
        return json_reader()
    


def restarter():
    old_data = json_reader().get('user_count')
    new_data = get_data().get('user_count')

    print(old_data,new_data)

    if old_data != new_data:
        create_json()
        return os.system("x-ui restart")


restarter()