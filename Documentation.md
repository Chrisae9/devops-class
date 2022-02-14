# Docker Jenkins Pipeline Process

## Installing Docker
https://docs.docker.com/engine/install/ubuntu/

Add repository key to system:
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

Setup `stable` repository:
```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
```

Update & Install Docker:
```bash
apt update
apt install docker-ce docker-ce-cli containerd.io
```


## Installing Docker Jenkins
https://hub.docker.com/r/jenkins/jenkins
```bash
sudo docker pull jenkins/jenkins:lts-jdk11
```

## Running Docker Jenkins
https://github.com/jenkinsci/docker/blob/master/README.md

Run the docker container:
```bash
docker run -p 8080:8080 -p 50000:50000 --name jenkins jenkins/jenkins:lts-jdk11
docker start jenkins
```

Login to the web interface on localhost:8080
```bash
Jenkins initial setup is required. An admin user has been created and a password generated.
Password located at: /var/jenkins_home/secrets/initialAdminPassword
```

Follow setup process and proceed to configuring first agent node.

## Configure Docker Jenkins Agent
https://github.com/jenkinsci/docker-agent

Permanent container, for temp add `--rm` flag
```
docker run -i -d --net="host" --name agent --init jenkins/agent:latest-jdk11 java -jar /usr/share/jenkins/agent.jar  -jnlpUrl http://localhost:8080/computer/Kiwi/jenkins-agent.jnlp -secret fb985fd1efc1056fbe6ef934db20290752bc4c0b753c4840735b323bfd872c31 -workDir "/home/jenkins/agent"
```

Jenkins Master additional config steps:
- Set number of executors on the build node to 0 
- Set home directory of agent node to `/home/jenkins/agent`





