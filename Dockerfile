FROM jenkins/jenkins:lts
USER root

# Update packages and install prerequisites
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    nano \
    software-properties-common

# Add Docker’s official GPG key
RUN curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the Docker stable repository
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker CE CLI and Docker Engine
RUN apt-get update && apt-get install -y docker-ce-cli docker-ce && \
    apt-get clean && \
    usermod -aG docker jenkins

# Add Docker Compose
# Replace latest with the specific version of Docker Compose if needed.
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER jenkins

# Install specified Jenkins plugins
# Uncomment and adjust the plugin versions as necessary
# RUN jenkins-plugin-cli --plugins blueocean:1.25.6 docker-workflow:1.29 ansicolor