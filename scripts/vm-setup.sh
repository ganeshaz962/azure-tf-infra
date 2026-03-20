#!/bin/bash
# vm-setup.sh – Installs Nginx and configures 5 path-based applications.
# Executed via Azure Custom Script Extension (runs as root).
set -e

echo ">>> Updating package lists and installing Nginx..."
apt-get update -y
apt-get install -y nginx

echo ">>> Creating application directories and HTML pages..."
for app in app1 app2 app3 app4 app5; do
  mkdir -p /var/www/${app}
  cat > /var/www/${app}/index.html << EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${app} - AppGW Demo</title>
  <style>
    body  { font-family: Arial, sans-serif; display: flex; align-items: center;
            justify-content: center; height: 100vh; margin: 0; background: #f0f4f8; }
    .box  { text-align: center; padding: 40px 60px; background: #fff;
            border-radius: 8px; box-shadow: 0 2px 12px rgba(0,0,0,.1); }
    h1    { color: #0078d4; margin-bottom: 8px; }
    p     { color: #555; }
    .path { font-family: monospace; background: #e8f0fe; padding: 4px 10px;
            border-radius: 4px; color: #1a73e8; }
  </style>
</head>
<body>
  <div class="box">
    <h1>Welcome to ${app}</h1>
    <p>This application is routed via Azure Application Gateway</p>
    <p>Path: <span class="path">/${app}/</span></p>
    <p>Backend: Ubuntu VM &rarr; Nginx</p>
  </div>
</body>
</html>
EOF
done

echo ">>> Writing Nginx site configuration..."
# Single-quoted heredoc marker ('NGINX_CONF') prevents bash from
# expanding Nginx variables such as $uri inside the block.
cat > /etc/nginx/sites-available/default << 'NGINX_CONF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;

    # Default response for the root path (also used by App Gateway default backend)
    location = / {
        return 200 'Application Gateway Demo\n';
        add_header Content-Type text/plain;
    }

    # Application 1 – path: /app1/
    location /app1/ {
        alias /var/www/app1/;
        index index.html;
    }

    # Application 2 – path: /app2/
    location /app2/ {
        alias /var/www/app2/;
        index index.html;
    }

    # Application 3 – path: /app3/
    location /app3/ {
        alias /var/www/app3/;
        index index.html;
    }

    # Application 4 – path: /app4/
    location /app4/ {
        alias /var/www/app4/;
        index index.html;
    }

    # Application 5 – path: /app5/
    location /app5/ {
        alias /var/www/app5/;
        index index.html;
    }
}
NGINX_CONF

echo ">>> Setting permissions and restarting Nginx..."
chown -R www-data:www-data /var/www/
chmod -R 755 /var/www/

nginx -t
systemctl enable nginx
systemctl restart nginx

echo ">>> Setup complete. Applications available at /app1/ through /app5/"
