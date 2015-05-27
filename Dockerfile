# Build your own php WebCamera Site: KitAzureDiscoveryPhp
FROM ubuntu:14.10
MAINTAINER Stephane Goudeau "@stephgou66"
RUN apt-get update

# Install base packages
RUN apt-get update && apt-get install -yq \
        curl \
        git \
        apache2 \
        libapache2-mod-php5 \
        php5-gd \
        php5-curl \
        php5-intl \
        php-pear \
        php-apc && \
        rm -rf /var/lib/apt/lists/*

# Configure PHP (CLI and Apache)
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini  && \
    sed -i "s/;date.timezone =*/date.timezone = \"Europe\/Paris\"/g" /etc/php5/apache2/php.ini  && \
    sed -i "s/;date.timezone =*/date.timezone = \"Europe\/Paris\"/g" /etc/php5/cli/php.ini

# Configure Apache vhost
RUN rm -rf /var/www/*
RUN a2enmod rewrite
ADD vhost.conf /etc/apache2/sites-available/000-default.conf

# Add image configuration and scripts also converting Windows CRLF to Linux LF with sed)
ADD run.sh /run.sh
RUN sed 's/\r//' -i run.sh
RUN chmod 755 /*.sh

# Configure /KitAzureDiscoveryPhp folder with code from Git repository 
WORKDIR /var/www
RUN git clone https://github.com/JohnStory/KitAzureDiscoveryPhp.git
WORKDIR /var/www/KitAzureDiscoveryPhp
RUN curl -sS https://getcomposer.org/installer | php -- --filename=composer
RUN php composer install
COPY parameters.yml app/config/parameters.yml
RUN php app/console assetic:dump --env=prod --no-debug

# Launch Web server
EXPOSE 80
CMD ["/run.sh"]