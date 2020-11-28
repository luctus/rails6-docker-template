FROM phusion/passenger-ruby26:1.0.9
LABEL maintainer="luctus"

ARG APP_ENV=development

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Additional packages
RUN apt-get update && apt-get install -y -o Dpkg::Options::="--force-confold" tzdata

RUN apt-get install --yes curl
RUN curl -sL https://deb.nodesource.com/setup_15.x | bash -
RUN apt-get install --yes nodejs
RUN apt-get install --yes build-essential
RUN npm install -g yarn

# Enable Nginx and Passenger
RUN rm -f /etc/service/nginx/down

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Install gems: it's better to build an independent layer for the gems
# so they are cached during builds unless Gemfile changes
WORKDIR /tmp
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN bundle install --jobs 4 --retry 3

# Add virtual host entry for the application
RUN rm /etc/nginx/sites-enabled/default

# Nginx configuration
COPY deploy/nginx/${APP_ENV}/ /etc/nginx/
COPY deploy/nginx/default/ /etc/nginx/

# Copy application into the container and use right permissions: passenger
# uses the app user for running the application
RUN mkdir /home/app/webapp
COPY . /home/app/webapp
RUN usermod -u 1000 app
RUN chown -R app:app /home/app/webapp
WORKDIR /home/app/webapp

# RUN chmod a+w db/schema.rb || :

# precompile assets
RUN setuser app yarn install
RUN setuser app bundle exec rake assets:precompile RAILS_ENV=${APP_ENV}

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
