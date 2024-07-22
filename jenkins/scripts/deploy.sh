#!/usr/bin/env sh

# Check if a container with the name 'my-apache-php-app' is already running and remove it if necessary
if [ $(docker ps -aq -f name=my-apache-php-app) ]; then
    docker rm -f my-apache-php-app
fi

set -x
docker run -d -p 9090:80 --name my-apache-php-app -v C:\\Users\\rudyh\\Desktop\\jenkins-php-selenium-test\\src:/var/www/html php:7.2-apache
sleep 1
set +x

echo 'Now...'
echo 'Visit http://localhost to see your PHP application in action.'

