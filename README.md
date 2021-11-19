# api
Heb12 API Setup Script

# Setup
Will consume around 5 gigabytes. Most is for hosting Bible data,  
the rest is for packages (which you probably have anyway).  

Pull the repository, and run "make". Should be fairly straightforward.  
```
make
```

# Removal
```
make remove
```

## Apache2 Configuration
```
DocumentRoot /var/www/api
ServerName api.heb12.com

<Location /search>
	ProxyPass http://localhost:5000
</Location>

<Location /get>
	ProxyPass http://localhost:5500/get/
</Location>
```

## Nginx configuration
```
server_name api.heb12.com;

autoindex on;

root /var/www/api;
index index.html index.php;

location /search {
	proxy_pass http://localhost:1235/;
}

location /get {
	proxy_pass http://localhost:1234/;
}
```