import json
import requests
from flask import Flask, jsonify, request
app = Flask(__name__)


@app.route('/', methods=['POST'])
def get():
    response = json.loads(request.data)
    persist_response(response)
    call_back(response["task_result_callback_url"],response["access_token"])
    return '', 200

def persist_response(response):
    with open('data.json', 'w') as fp:
        json.dump(response, fp)

def call_back(url,token):
    headers = {
        'Authorization': f'Bearer {token}',
        'Content-Type': 'application/vnd.api+json'
    }
    payload={
        "data": {
        "type": "task-results",
        "attributes": {
            "status": "running",
            "message": "Hello task",
            "url": "https://example.com",
            "outcomes": []
            }
        }
    }

    response = requests.get(url, headers=headers, json=payload)

    if response.status_code == 200 or response.status_code == 201:
        return response.json()  
    else:
        return {
            'status_code': response.status_code,
            'error_message': response.text
        }


if __name__ == '__main__':
   app.run(port=5000)
