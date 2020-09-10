FROM centos:centos6

# Set timezone
RUN /bin/cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# Install modules
RUN yum install -y epel-release
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN yum install -y --enablerepo=remi,remi-php70 php php-devel php-mbstring php-pdo php-mysql php-gd php-mcrypt libmcrypt
RUN yum -y install httpd mysql-server tar wget

WORKDIR /tmp/

# Setup wordpress
RUN wget https://ja.wordpress.org/latest-ja.tar.gz
RUN tar xvfz ./latest-ja.tar.gz -C /var/www/html
RUN rm -f ./latest-ja.tar.gz
RUN cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
RUN sed -i -e 's/database_name_here/wordpress/g' -e 's/username_here/wordpress/g' -e 's/password_here/wppass/g' /var/www/html/wordpress/wp-config.php
RUN chown -R apache.apache /var/www/html/
RUN service mysqld start && mysql -u root -e "CREATE DATABASE wordpress; GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY 'wppass'; FLUSH PRIVILEGES;" && service mysqld stop
RUN echo -e "service mysqld start\nservice httpd start\n/bin/bash" > /startService.sh
RUN chmod o+x /startService.sh

# expose port
EXPOSE 80

# start
CMD /startService.sh
