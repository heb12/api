# api
Heb12 API Setup Script

This is a draft of random scripts that will  
be put together one day.  

Apache2 configuration:
```
DocumentRoot /var/www/api
ServerName api.heb12.com

<Location /search>
	ProxyPass http://localhost:5000
</Location>

<Location /get>
	ProxyPass http://localhost:5500/get/
</Location>

<Location /getl>
	ProxyPass http://api.heb12.com/get.php
</Location>

<Location /download>
	ProxyPass http://api.heb12.com/download.php
</Location>
```

```
mkdir translations
cd translations
git clone https://github.com/heb12/gratis.json json
```

```
git clone code.heb12.com/heb12/biblesearch --recurse-submodules
git clone code.heb12.com/heb12/bibleget --recurse-submodules
```

That's it, I'm too lazy to do anything else.