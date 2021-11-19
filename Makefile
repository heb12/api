# Run this as the user you want to run the API on.
# Tested on Debian

# Web server home directory
WWW=/var/www/api

# Heb12 config dir
DIR=/home/$(USER)/.local/share/heb12/

# Default translation
TRANSLATION=web

# location ~ /\. {
# deny all;
# }

all: confirm packages pull setup_biblesearch setup_cbiblesearch git_translations add_biblec

confirm:
	echo "Will perform the following:"
	echo "Install NodeJS, Go, GCC, Python3 and Pip3"
	echo "Pull bibleget, cbibleget, bsearchpyjs, and biblec into $(shell printf ~)"
	echo "Install systemd services 'biblesearch' and 'cbibleget'"
	echo "Pull 2.3GB of Bible data into $(WWW)/translations"
	echo ""
	echo "Ctrl+C to cancel, or press any key to begin."
	read

packages:
	sudo apt install nodejs go gcc python3 python3-pip
	pip3 install flask waitress

pull:
	git clone https://code.theres.life/heb12/bibleget --recurse-submodules
	git clone https://code.theres.life/heb12/cbibleget --recurse-submodules
	git clone https://code.theres.life/heb12/bsearchpyjs --recurse-submodules
	git clone https://code.theres.life/heb12/biblec --recurse-submodules

setup_biblesearch:
	-cd bsearchpyjs; mkdir data; mkdir data/$(TRANSLATION)
	cd bsearchpyjs; node compile.js $(WWW)/translations/json/en/$(TRANSLATION).json data/$(TRANSLATION)
	sudo sh -c 'echo "[Unit]\n\
	Description=biblesearch service\n\
	After=network.target\n\
	StartLimitIntervalSec=0\n\
	\n\
	[Service]\n\
	Type=simple\n\
	Restart=always\n\
	RestartSec=1\n\
	User=$(USER)\n\
	ExecStart=/usr/bin/python3 /home/$(USER)/bsearchpyjs/server.py /home/$(USER)/bsearchpyjs/data/web\n\
	\n\
	[Install]\n\
	WantedBy=multi-user.target\n" > /etc/systemd/system/biblesearch.service'

setup_cbibleget:
	sudo sh -c 'echo "[Unit]\n\
	Description=cbibleget service\n\
	After=network.target\n\
	StartLimitIntervalSec=0\n\
	\n\
	[Service]\n\
	Type=simple\n\
	Restart=always\n\
	RestartSec=1\n\
	User=$(USER)\n\
	ExecStart=sh -c \"cd /home/$(USER)/cbibleget; go run .\"\n\
	\n\
	[Install]\n\
	WantedBy=multi-user.target\n" > /etc/systemd/system/cbibleget.service'

git_translations:
	mkdir $(WWW)/translations
	cd $(WWW)/translations; git clone https://github.com/heb12/gratis.json json; rm -rf .git
	cd $(WWW)/translations; git clone https://github.com/gratis-bible/bible xml; rm -rf .git
	cd $(WWW)/translations; git clone --branch split https://github.com/gratis-bible/bible split; rm -rf .git

add_biblec:
	echo Creating Biblec $(TRANSLATION)
	-mkdir $(DIR)
	-mkdir $(WWW)/translations/biblec
	cd biblec; node compiler.js $(WWW)/translations/json/en/$(TRANSLATION).json i $(DIR)
	-cp $(DIR)/$(TRANSLATION).* $(WWW)/translations/biblec

remove:
	cd; rm -rf $(WWW)/translations
	cd; rm -rf bibleget cbibleget biblesearch
	rm -rf /etc/systemd/system/cbibleget*
	rm -rf /etc/systemd/system/biblesearch*