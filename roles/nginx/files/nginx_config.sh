# Certbot will then configure the https

server {
	listen 80 default_server;
	listen [::]:80 default_server;
	root /var/www/html;

	index index.html;

	server_name dsgdevbraga.ddns.net;

	location / {
		try_files $uri $uri/ =404;
	}
}
