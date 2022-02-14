# Docker Jenkins Pipeline Process

## Installing Docker
https://docs.docker.com/engine/install/ubuntu/

Add repo key to system

```
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

Setup stable repo

```
 echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Install Docker:

```
 sudo apt-get update
 sudo apt-get install docker-ce docker-ce-cli containerd.io
```

## Installing Docker Jenkins
https://hub.docker.com/r/jenkins/jenkins
```
sudo docker pull jenkins/jenkins:lts-jdk11
```

## Running Docker Jenkins
https://github.com/jenkinsci/docker/blob/master/README.md

```
docker run -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts-jdk11
```

```
Jenkins initial setup is required. An admin user has been created and a password generated.
Password located at: /var/jenkins_home/secrets/initialAdminPassword
```