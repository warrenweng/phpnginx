#借助docker-hub镜像编译。 镜像名字为： xltxlm/phpnginx
FROM php:7.3.21-fpm-buster

COPY / /root/



#运维基础工具
RUN  apt-get update && apt-get -y install  vim  bc dnsutils tree  openssh-server   telnet  procps  iputils-ping wget curl jq lsof

#解压frp客户端
RUN  cd /root/frp-base/ && wget https://oss.xialintai.com/soft/frp_0.30.0_linux_amd64.tar.gz && tar xzf frp_0.30.0_linux_amd64.tar.gz && chmod +x /root/frp-base/client.sh

#php扩展安装
RUN     apt-get update && apt-get -y install  libzip-dev  git librdkafka-dev unzip  zlib1g-dev vim libldap2-dev libmagickwand-dev  \
        && ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
        && /usr/local/bin/docker-php-ext-install mysqli bcmath  pdo_mysql zip pcntl ldap exif xmlrpc \
        && apt-get -y install libcurl4-openssl-dev pkg-config libssl-dev net-tools strace psmisc librabbitmq-dev \
        #👇👇---- 下一个版本出现了大面积的取消函数。所以不能升级了  https://pecl.php.net/package-changelog.php?package=imagick&release=3.4.3
        && pecl install http://pecl.php.net/get/imagick-3.4.3.tgz \
        && pecl install ds mongodb   AMQP xdebug redis && docker-php-ext-enable mysqli bcmath ds mongodb  imagick amqp xdebug redis exif xmlrpc\
        && apt-get install -y \
            libfreetype6-dev \
            libjpeg62-turbo-dev \
            libmcrypt-dev \
            libpng-dev \
            libxpm-dev \
        && docker-php-ext-install gd

#
RUN     cd /root/ &&  tar -xzf /root/donkeyid-donkeyid-1.0.tar.gz && cd /root/donkeyid-donkeyid-1.0/donkeyid/  \
        && /usr/local/bin/phpize && ./configure --with-php-config=/usr/local/bin/php-config && make && make install \
        && echo "extension=donkeyid.so" >/usr/local/etc/php/conf.d/donkeyid.ini \
        && cp -f /root/phpconfig/php.ini /usr/local/etc/php/conf.d/ \
        && cp -f /root/phpconfig/www.conf  /usr/local/etc/php-fpm.d


#安装nginx服务
RUN curl 'https://xialintai.com:30735/?c=Download/TargzRun&id=5de4eb06c032a' | bash

#服务器健壮保证
RUN curl 'https://xialintai.com:30735/?c=Download/TargzRun&id=5df1a742577b2' | bash


#ssh服务
RUN    apt-get update && apt-get -y install openssh-server  rsync  mariadb-client p7zip-full  apache2-utils   redis-tools axel cron rsyslog sshfs \
        && mkdir -p /etc/nginx/sites-enabled/ \
        && cp /root/www.conf /etc/nginx/sites-enabled/ \
        && touch /var/www/html/nginxlocation.conf \
        && mkdir -p /var/run/sshd &&  chmod 0755 /var/run/sshd \
        && chmod 700 /root/.ssh/ \
        && chmod 600 /root/.ssh/config

ENV LANG zh_CN.utf-8
ENV LANGUAGE zh_CN.utf-8
ENV LC_ALL zh_CN.utf-8
#解决中文乱码的问题
RUN  apt-get update && apt-get install -y locales && localedef -f UTF-8 -i zh_CN zh_CN.UTF-8 \
#日志
    && mkdir -p /opt/logs && chmod 0777 /opt/logs

#安装youtube-dl
RUN apt-get update && apt-get install -y python axel ffmpeg atomicparsley && wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl \
    && chmod a+rx /usr/local/bin/youtube-dl

#安装java
RUN mkdir -p /usr/share/man/man1mkdir -p /usr/share/man/man1 && apt-get update && apt-get install -y openjdk-11-jre

#安装composer
RUN curl -sS https://getcomposer.org/installer | php \
    && cp composer.phar /usr/bin/composer


RUN     cp --force /usr/share/zoneinfo/Asia/Shanghai /etc/localtime  \
        #记录编译的日期
        &&  echo `date`>/v \
        && rm -rf /project
