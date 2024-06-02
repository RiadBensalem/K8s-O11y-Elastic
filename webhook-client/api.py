import json
import requests
from flask import Flask, jsonify, request
import pystache

import os



app = Flask(__name__)


@app.route('/', methods=['POST'])
def get():
    response = json.loads(request.data)
    persist_response(response)
    terraform_token = os.environ['TERRAFORM_TOKEN']
    get_outputs(response["plan_json_api_url"],terraform_token)
    callback(response["task_result_callback_url"],response["access_token"])
    generate_config("./data-output.json","./elastic-agent-managed-kubernetes-template.yml")
    return '', 200

def persist_response(response,seq="1"):
    with open('data-'+seq+'.json', 'w') as fp:
        json.dump(response, fp)

def callback(url,token):
    headers = {
        'Authorization': f'Bearer {token}',
        'Content-Type': 'application/vnd.api+json'
    }
    payload={
        "data": {
        "type": "task-results",
        "attributes": {
            "status": "passed",
            "message": "Hello task",
            "url": "https://example.com",
            "outcomes": []
            }
        }
    }

    response = requests.patch(url, headers=headers, json=payload)
    try:
        persist_response(response.json(),"2")
    except:
        print("persist error")
    if response.status_code == 200 or response.status_code == 201:
        return response.json()  
    else:
        return {
            'status_code': response.status_code,
            'error_message': response.text
        }

def get_outputs(url,token):
    headers = {
        'Authorization': f'Bearer {token}',
        'Content-Type': 'application/vnd.api+json'
    }
    res=requests.get(url, headers=headers)
    persist_response(res.json(),"output")

def generate_config(values: str,template: str,final_config_file="./elastic-agent-managed-kubernetes.yml"):
   with open(values, 'r') as fp:
        data=json.load(fp)
        outputs=data["planned_values"]["outputs"]
        outputs_changes=data["output_changes"] 
        variables = {
        "fleet_endpoint":outputs["fleet_endpoint"]["value"],
        "enrollment_token":outputs_changes["enrollment_tokens"]["before"][0]["api_key"]
        }
        config = open(template, 'r')
        config_template = config.read()
        final_config = pystache.render(config_template, variables)
        write =open(final_config_file, "w")
        write.write(final_config)
if __name__ == '__main__':
   app.run(port=5000)
