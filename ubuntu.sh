#!/bin/bash
# Nginx Bad Bots Blocker Auto Installer (ubuntu)
# Recode by: c0g4n
# Original code:
# Nginx Bad Bots Blocker Auto Installer (centos)
# Teguh Aprianto
# https://bukancoder | https://teguh.co
# https://raw.githubusercontent.com/teguhmicro/Bots-Blocker-with-Nginx-IP-Tables/master/bots.sh

IJO='\e[38;5;82m'
MAG='\e[35m'
RESET='\e[0m'

echo -e "$MAG--=[ To start blocking bad bots to access your server, press any key to continue ]=--$RESET"
read answer 

echo -e "$MAG--=[ Creating bots.d directory ]=--$IJO"
if [ ! -d /etc/nginx/bots.d  ]; then
  mkdir /etc/nginx/bots.d 
fi
echo
echo

echo -e "$MAG--=[ Download bot list from Bukan Coder Archive ]=--$IJO"
apt-get install wget -y
cd /etc/nginx/bots.d 
wget https://arc.bukancoder.co/Nginx-Bad-Bot-Blocker/blacklist.conf.txt -O blacklist.conf
wget https://arc.bukancoder.co/Nginx-Bad-Bot-Blocker/blockips.conf.txt -O blockips.conf
#wget https://pastebin.com/raw/mhM7tarG -O blacklist.conf
#wget https://pastebin.com/raw/Dsk3p83w -O blockips.conf
    
echo
echo

echo -e "$MAG--=[ Updating Nginx Configuration ]=--$IJO"
rm -rf /etc/nginx/nginx.conf 
cat >/etc/nginx/nginx.conf<<eof
user www-data;
worker_processes auto;
pid /run/nginx.pid;

events {
    worker_connections 1024;
    # multi_accept on;
}

http {

    ##
    # Basic Settings
    ##

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    client_max_body_size 500M;
    types_hash_max_size 2048;
    # server_tokens off;

     server_names_hash_bucket_size 64;
    # server_name_in_redirect off;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    ##
    # SSL Settings
    ##

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
    ssl_prefer_server_ciphers on;

    ##
    # Logging Settings
    ##
    log_format main '$remote_addr - $remote_user [$time_local] "$request"'
            '$status $body_bytes_sent "$http_referer"'
            '"$http_user_agent" "$http_x_forwarded_for"';
    
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    ##
    # Gzip Settings
    ##

    gzip on;
    gzip_disable "msie6";

    # gzip_vary on;
    # gzip_proxied any;
    # gzip_comp_level 6;
    # gzip_buffers 16 8k;
    # gzip_http_version 1.1;
    # gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

    ##
    # Virtual Host Configs
    ##

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
    include /etc/nginx/bots.d/*;
}


#mail {
#   # See sample authentication script at:
#   # http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript
# 
#   # auth_http localhost/auth.php;
#   # pop3_capabilities "TOP" "USER";
#   # imap_capabilities "IMAP4rev1" "UIDPLUS";
# 
#   server {
#       listen     localhost:110;
#       protocol   pop3;
#       proxy      on;
#   }
# 
#   server {
#       listen     localhost:143;
#       protocol   imap;
#       proxy      on;
#   }
#}

eof
echo
echo

echo -e "$MAG--=[ Blocking bots with iptables ]=--$IJO"
cd ~
wget https://arc.bukancoder.co/Bots-Iptables/block.txt -O block
wget https://arc.bukancoder.co/Bots-Iptables/ips.txt -O ips
#wget https://pastebin.com/raw/Ud3bNsQZ -O block 
#wget https://pastebin.com/raw/VH3VHeLh -O ips 
chmod +x block 
./block

echo -e "$MAG--=[ Save iptables ]=--$IJO"
iptables-save

echo
echo -e "$MAG--=[Done! Bots has been blocked using Nginx Bad Bots Blocker and iptables]=--$IJO"
