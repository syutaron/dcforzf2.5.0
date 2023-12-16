FROM php:5.5-fpm

RUN <<EOF
    echo "" > /etc/apt/sources.list
    echo "deb [trusted=yes] http://archive.debian.org/debian/ jessie main non-free contrib" >> /etc/apt/sources.list
    echo "deb-src [trusted=yes] http://archive.debian.org/debian/ jessie main non-free contrib" >> /etc/apt/sources.list
    echo "deb [trusted=yes] http://archive.debian.org/debian-security/ jessie/updates main non-free contrib" >> /etc/apt/sources.list
    echo "deb-src [trusted=yes] http://archive.debian.org/debian-security/ jessie/updates main non-free contrib" >> /etc/apt/sources.list
EOF

RUN <<EOF
    apt update
    apt install debian-archive-keyring -y
    apt update
EOF

RUN apt upgrade -y

RUN apt install -y git

RUN <<EOF 
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
EOF

RUN mv composer.phar /usr/local/bin/composer

RUN mkdir /www

WORKDIR /www
