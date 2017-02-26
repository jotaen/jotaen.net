import argparse
import requests
from requests.auth import HTTPBasicAuth
import os

# Parse cli args
parser = argparse.ArgumentParser(description="Registers an article at j4n.io")
parser.add_argument('path', help='Path of the blogpost')
options = parser.parse_args()

# Read env vars
api_key =  os.environ.get('API_KEY')

# Setup data
j4n_url = "http://www.j4n.io"
jotaen_url = "https://www.jotaen.net"
path = options.path.strip("/")
void = {
    "url": j4n_url,
    "status_code": 404
}

# Create placeholder resource (to obtain new token)
create = requests.post(j4n_url, json=void, auth=HTTPBasicAuth('admin', api_key))
if create.status_code!=201:
    print(create.json())
    exit(1)

# Update this token with real information
token = create.json()["token"]
data = {
    "url": "/".join([jotaen_url, token, path]),
    "status_code": 302
}
url = "/".join([j4n_url, token])
update = requests.post(url, json=data, auth=HTTPBasicAuth('admin', api_key))
if update.status_code==200:
    print("Token: " + token)
else:
    print(update.json())
    exit(1)
