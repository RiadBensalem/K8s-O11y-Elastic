import json
from flask import Flask, jsonify, request
app = Flask(__name__)


@app.route('/', methods=['POST'])
def get():
    response = json.loads(request.data)
    persist_response(response)
    return '', 200

def persist_response(response):
    with open('data.json', 'w') as fp:
        json.dump(response, fp)
        
if __name__ == '__main__':
   app.run(port=5000)