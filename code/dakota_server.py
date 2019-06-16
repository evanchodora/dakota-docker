import os
from flask import Flask, request
from flask_restful import Resource, Api
import json
import subprocess
import uuid


# File upload settings
UPLOAD_FOLDER = '/code/uploads'
ALLOWED_EXTENSIONS = set(['txt', 'in', 'yml'])

# Initialize Flask app and API resource
dakota_server = Flask(__name__)
dakota_server.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
api = Api(dakota_server)

# Fucntion to correct for allowed filename
def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

# Function to request and capture the Dakota version
def get_dakota_version():
    proc = subprocess.run(["dakota", "-v"], encoding='utf-8', stdout=subprocess.PIPE)
    out = proc.stdout
    return out

class InputFile(Resource):

    # POST request to upload file
    def post(self):
        id = str(uuid.uuid4())
        file = request.files['file']
        if file and allowed_file(file.filename):
            filename = id + '.in'
            file_dir = os.path.join(dakota_server.config['UPLOAD_FOLDER'] + '/' + id, filename)
            os.makedirs(os.path.dirname(file_dir), exist_ok=True)
            file.save(file_dir)
            print('New Input File:', file_dir)
            return {'message': 'Success', 'data': {'fileID': id, 'location': file_dir}}, 200
        else:
            return {'message': 'Failure', 'data': 'Filetype not allowed or file not supplied'}, 500

# API endpoint for the current version of Dakota
class Version(Resource):
    
    # GET request
    def get(self):
        out = get_dakota_version()
        data = {'version': out.split('\n')[0],
                'build_info': out.split('\n')[1]}
        return {'message': 'Success', 'data': data}, 200

# Add API endpoints
api.add_resource(Version, '/get_version')
api.add_resource(InputFile, '/input_file')
