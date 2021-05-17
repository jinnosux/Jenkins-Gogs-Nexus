## Jenkins + Sonatype Nexus + Gogs stack
This is a CI/CD Stack for Java Apps. It uses Jenkins LTS version for pipeline, Gogs as a self hosted GIT service, and Sonatype Nexus Repository Manager for artifacts.

To Start, run in terminal (inside the directory where docker-compose.yml is located):

 - `docker-compose up -d`

Than, set up accounts for all 3 services :

 - Gogs : http://localhost:3000 - Create new account

 - Jenkins : http://localhost:8080 - For admin password, execute :
     - `docker exec neo_jenkins cat /var/jenkins_home/secrets/initialAdminPassword`

 - Nexus : http://localhost:8081 - Create new account (you will need it for settings.xml later)

Now that your stack is ready, you can connect your app to repository by adding ID and URL in your projects pom.xml :
```
<project>
  ...
  <distributionManagement>
    <snapshotRepository>
      <id>nexus-snapshots</id>
      <url>http://nexus1:8081/repository/maven-snapshots/</url>
    </snapshotRepository>
  </distributionManagement>
</project>
```
Than, you should install those plugins in Jenkins :

 - https://plugins.jenkins.io/gogs-webhook/ - Gogs webhook tutorial is on this page as well
 - https://plugins.jenkins.io/pipeline-maven/ - to use maven inside a pipeline code
 - https://plugins.jenkins.io/config-file-provider/ - to provide settings.xml as nexus auth

Last step is adding Maven Tool and Global Settings; Go to Jenkins Homepage > Manage Jenkins > Global Tool Configuration > Maven Installations at the bottom. Name should be "maven" and Installer from Apache. Next, go to Homepage > Manage Jenkins > Manage Files > Add A New Config, where ID should be "nexus-snapshots", and add username and password of your nexus instance at the bottom of "content", above the </settings> line:
```
<settings>
  ...
  <servers>
    <server>
      <id>nexus-snapshots</id>
      <username>your-nexus-username</username>
      <password>your-nexus-password</password>
    </server>
  </servers>
</settings>
```
Now you're ready to create a pipeline! Open jenkins Homepage, New Item > Pipeline > tick option "Build when a change is pushed to Gogs", paste the jenkins pipeline script. Save a pipeline, and build your java apps!

In case of the apocalypse, both nexus and gogs have persistent storage, so stopping docker containers will perserve your precious artifacts for further planetary inhabitation.

To stop all 3 containers, run:
stop: docker-compose down

Q&A:

TODO:
- jos dokumentacije
- terraform / cloudformation ?
- specificnosti instalacije
- sve na github-u
- hostanme umesto IP-a

-terraform sa lokalnim dokerom
