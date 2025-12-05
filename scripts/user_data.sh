#!/bin/bash
set -xe
yum update -y
yum install -y python3 python3-venv python3-pip

mkdir -p /opt/fastapi/app
cd /opt/fastapi

python3 -m venv venv
source venv/bin/activate
pip install fastapi uvicorn[standard]


# Create FastAPI application
cat > /opt/fastapi/app/main.py << 'EOF'
from fastapi import FastAPI

app = FastAPI()

@app.get("/", status_code=200)
def read_root():
    return {"status": "ok"}

@app.get("/health", status_code=200)
def health():
    return {"health": "ok"}
EOF


# Create systemd service for FastAPI
cat > /etc/systemd/system/fastapi.service << 'EOF'
[Unit]
Description=FastAPI Application
After=multi-user.target

[Service]
User=root
WorkingDirectory=/opt/fastapi
ExecStart=/opt/fastapi/venv/bin/uvicorn app.main:app --forwarded-allow-ips="*" --host=0.0.0.0 --port 8080
Restart=always

EOF

# Start and enable FastAPI service
systemctl daemon-reload
systemctl enable fastapi
systemctl start fastapi
