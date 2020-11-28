# Rails 6 Docker Template

This is a brand new Rails 6 / Passenger project running on Docker (docker-compose) that includes:

- Base Folders structure
- Base Gemfile for a Rails 6 project

## Instructions

1. Clone this repo
2. Make sure you set your own `VIRTUAL_HOSTNAME` value at `deploy/docker-files/.env.webapp`
3. Make sure you have [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy) container up and running
4. Build and Run the image:
```
docker-compose build
docker-compose up -d
```
5. Add the same hostname to your local `/etc/hosts` file to point to your dev server
6. Go to that url on your browser. You should see the "Yay! You’re on Rails!" message.
