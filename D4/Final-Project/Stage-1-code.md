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
r = redis.Redis(host='172.31.19.169', port=6379, db=0)

@app.route('/')
def index():
    # Increment the "hits" key
    count = r.incr('hits')
    return f"Hello! This page has been visited {count} times."

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

* finally run the python code 
```
nohup python3 app.py > app.log 2>&1 &
```
Note , it could be python or python3 

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
sudo dnf install -y redis6
```
* Enable & start:
```
sudo systemctl enable redis6
sudo systemctl start redis6
sudo systemctl status redis6

```

By default, Redis binds only to `127.0.0.1` (loopback) for security.
If you want your EC2 instance’s **eth0** IP (private/public) to be accessible, you have to update the Redis config and firewall rules.

---

## **Steps to Make Redis Listen on All Interfaces in Amazon Linux 2023**

### **1️⃣ Edit Redis config**

The Redis config file is usually in `/etc/redis/redis.conf` or `/etc/redis.conf`.

```bash
sudo vi /etc/redis6/redis6.conf
```

* Find this line:

```
bind 127.0.0.1 ::1
```

* Change it to:

```
bind 0.0.0.0
```

* Also make sure:

```
protected-mode no
```

(If you keep `protected-mode yes`, Redis will still block external connections unless explicitly whitelisted.)

---

### **2️⃣ Restart Redis**

```bash
sudo systemctl restart redis
sudo systemctl status redis
```

### **4️⃣ Test from another machine**
* can be done on redis machine (Optional)

```bash
redis-cli -h <EC2-Public-IP> -p 6379 ping
```

Should return:

```
PONG
```


## Open the security group to access redis 
* on the exsisting your security group open
  * redis details
    * port -- 6379
    * source -- 192.168.0.0/20
    * type -- custom tcp
  * Python web server  details
    * port -- 5000
    * source -- 0.0.0.0/0
    * type -- All traffic
