import argparse
import requests

parser = argparse.ArgumentParser(description="Registers an article at j4n.io")
parser.add_argument('path', help='Path of the blogpost')
options = parser.parse_args()

path = options.path.strip("/")
url = "http://j4n.io/" + path
