# Docker Jenkins Pipeline Documented Process

## Summary

- Jenkins is running through a Docker Container on my personal website at https://jenkins.chis.dev.
- There is a connected [Jenkins Agent](/agent/Dockerfile) that is running in a privileged docker container to leverage Docker in Docker.
- This GitHub repo has a webhook that sends a POST to https://jenkins.chis.dev/github-webhook/ when code is committed.
- There is a project in Jenkins that will recieve this POST data and kick off an automated build.
- The build will run this [Jenkinsfile](./Jenkinsfile) which will:
  - Build the [Dockerfile](./Dockerfile) image that will be used to containerize the website located under [website/](./website/)
  - Deploy the website image by starting a docker container that hosts the static folder using nginx on port 9000
  - Push the docker website image to docker hub. [Docker Hub Image](https://hub.docker.com/repository/docker/chrisae9/website).

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

### Running Docker Jenkins
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

## Configure Jenkins to Run on Personal Website (extra)

- Make `jenkins.chis.dev` entry on https://cloudflare.com
- Create nginx file `/etc/nginx/sites-available/jenkins.chis.dev`

```bash
map $http_upgrade $connection_upgrade {
  default upgrade;
  '' close;
}
server {
    listen          80;

    server_name jenkins.chis.dev;
    access_log /var/log/nginx/jenkins.access.log;
    error_log /var/log/nginx/jenkins.error.log;

    location / {
        proxy_set_header   Connection        $connection_upgrade;
        proxy_set_header   Upgrade           $http_upgrade;
        include /etc/nginx/proxy_params;
        proxy_pass http://localhost:8080;
        proxy_read_timeout  90s;
        proxy_redirect http://localhost:8080 http://jenkins.chis.dev;
    }
}
```

- Test configuration using `nginx -t`
- Enable website `ln -s /etc/nginx/sites-available/jenkins.chis.dev /etc/nginx/sites-enabled`
- Restart nginx `systemctl restart nginx.service`
- Verify webiste is up and running https://jenkins.chis.dev

## Configure Docker Jenkins Agent with Docker in Docker (dind)
https://github.com/jenkinsci/docker-agent

[Here](/agent/Dockerfile) is the Dockerfile for the custom agent.

Temporary container, for permanent remove the `--rm` flag:
```
docker run -i --rm --net="host" --name agent -v /var/run/docker.sock:/var/run/docker.sock --privileged -u root --init chrisae9/dockeragent:latest java -jar /usr/share/jenkins/agent.jar  -jnlpUrl http://localhost:8080/computer/Kiwi/jenkins-agent.jnlp -secret <SECRET> -workDir "/home/jenkins/agent"

```

Jenkins Master additional config steps:
- Set number of executors on the build node to 0 
- Set home directory of agent node to `/home/jenkins/agent`

## Link GitHub Repo to Jenkins Pipeline

### GitHub Personal Access Token
- Go to User Settings -> Dev Settings -> Personal Access Tokens
- Generate new token called `jenkins`
- Enable repo flag
- Save token for next step

### Make Pipeline
- Create a new `Multibranch Pipeline` on Jenkins Master named `docker-jenkins-pipeline`
- Under branch sources add GitHub, paste repo into box `https://github.com/Chrisae9/devops-class.git`
- Make a new username and password credential:
  - Username: `github-username`
  - Password: `github-personal-access-token`
- Click verify to ensure everything is okay
- Under behaviours add `Advanced sub-module behaviours`-> recursively update submodules

### Enable GitHub Webhooks for Push Related events
- Go to GitHub repository -> settings -> Webhooks -> New
- Add `https://jenkins.chis.dev/github-webhook/` as payload URL (make sure slash is at the end)
- Create a new credential to house GitHub webhook credentials.

## Create Containerized Website for CI/CD Pipeline
https://github.com/gatsbyjs/gatsby-starter-default

- First create the gatsby starter by running `gatsby init new`
- Follow the on screen steps to name the website and create a topdir folder called `website`

[Here](./Dockerfile) is the Dockerfile for building the gatsby website.

In this file there are steps to copying the website and building using a node image.
After the website is built, it is hosted on a nginx image.

## Adding Docker Credentials

- Create an account on Docker Hub and add global username and password credentials to Jenkins

## Creating the Jenkinsfile

[Here](./Jenkinsfile) is the main Jenkinsfile.

Steps:
- Build
  - This builds the newly created website container
- Deploy
  - Removes previously running website container
  - Runs a new website container binding hosted website to port 9000
- Docker Push
  - Takes the built image and pushes it to Docker Hub using provided credentials
