FROM jenkins/jenkins:latest

ENV JENKINS_USER admin
ENV JENKINS_PASS admin

# Skip initial setup
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Pre-Install necessary plugins
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt || echo "Error occurred during plugins installation."