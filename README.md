# README

This web app is a simple e-shop written in Ruby on Rails.
Application is running in a docker container at AWS: [Shopper](http://13.58.62.105:3000/)


## Building application

#### Pre-requisites: 
- Installed Docker

For Ubuntu users there is script for installation Docker: 
```
./install_docker_ubuntu
```

#### Building application

User is at application directory.
```cassandraql
sudo docker-compose build web db
sudo docker-compose up -d --force-recreate web db
sudo docker-compose run -d db rake db:create db:schema:load db:seed
sudo docker-compose run -d web
```
After build, application is running at: http://localhost:3000

#### Running tests
User is at application directory.
```cassandraql
sudo docker-compose build db test
sudo docker-compose run --name=test -v <your_path_to_application>/test_reports/:/usr/src/myapp/test_reports test

```
Run test will generate report.html to app directory /test_reports


### CI/CD process
- commit and push to Git repository
- webhook to Jenkins running on AWS: [Jenkins](http://13.58.62.105:8080/)
- Jenkins job - shopper_test runs test and generate report.html in Jenkins
- if tests passed, trigger new job shopper_build to build and deploy new version
