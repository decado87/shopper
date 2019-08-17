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
sudo docker-compose run -d web
```
After build, application is running at: http://localhost:3000

#### Running tests
User is at application directory.
```cassandraql
sudo docker-compose build test
sudo docker-compose run test
```
To get report file .html after tests:
```cassandraql
sudo docker-compose run -d test
container_id=$(sudo docker ps -qf "name=shopper_test")
sudo docker cp "$container_id":/usr/src/myapp/report.html test-reports/report.html
```

### CI/CD process
- commit and push to Git repository
- webhook to Jenkins running on AWS: [Jenkins](http://13.58.62.105:8080/)
- Jenkins job - shopper_test runs test and generate report.html in Jenkins
- if tests passed, trigger new job shopper_build to build and deploy new version
