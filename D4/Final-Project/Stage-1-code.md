## Python Code

* install python on the centos and create this file in the home directory.
```
sudo dnf update -y

sudo dnf install -y python3 python3-pip python3-virtualenv
python3 --version
pip3 --version
```

* Create and use a virtual environment
```
python3 -m venv myenv
source myenv/bin/activate
pip install flask redis

```
* create an "app.py" file and copy the below code.
Note: Make sure to change the host value instead of 'loclahost' to "private ip of redis ec2"
```
import redis
from flask import Flask

app = Flask(__name__)

# Connect to Redis
# Change host if Redis is on another machine
r = redis.Redis(host='localhost', port=6379, db=0)

@app.route('/')
def index():
    # Increment the "hits" key
    count = r.incr('hits')
    return f"Hello! This page has been visited {count} times."

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```


## Redis setup.
* Amazon Linux 2023 replaced amazon-linux-extras with dnf repos, and Redis is often found in the epel-like packages.
```
# Update system
sudo dnf update -y

# Search for Redis
dnf search redis
```
* If you see something like redis6 or redis7, install it:
```
sudo dnf install -y redis
```
* Enable & start:
```
sudo systemctl enable redis
sudo systemctl start redis
sudo systemctl status redis

```

## Open the security group to access redis 
* on the exsisting your security group open
    * port -- 6379
    * source -- 192.168.0.0/20
    * type -- custom tcp

