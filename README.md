## Jenkins + Sonatype Nexus + Gogs stack in Docker
This is a CI/CD Stack for Java Apps. It uses Jenkins LTS version for pipeline, Gogs as a self hosted GIT service, and Sonatype Nexus Repository Manager for artifacts.

## Instructions to run locally

To Start, run in terminal (inside the directory where docker-compose.yml is located):

 - `docker-compose up -d`

Than, set up accounts for all 3 services :

 - Gogs : http://localhost:3000 - Create new account

 - Jenkins : http://localhost:8080 - Default user/pass is created, check in "Dockerfile"

 - Nexus : http://localhost:8081 - Create new account (you will need it for settings.xml later)

Now that your stack is up and ready, you can connect your Java app to Nexus repository by adding ID and URL in your projects pom.xml:
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

Last step is adding Maven Tool and Global Settings; Go to Jenkins Homepage > Manage Jenkins > Global Tool Configuration > Maven Installations at the bottom. Name should be "maven" and Installer from Apache. Next, go to Homepage > Manage Jenkins > Manage Files > Add A New Config, where ID should be "nexus-snapshots", and add username and password of your nexus instance at the bottom of "content", above the </settings> line, like this:
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
Now you're ready to create a pipeline! Open jenkins Homepage, New Item > Pipeline > tick option "Build when a change is pushed to Gogs", and paste the jenkins pipeline script. Save a pipeline, and add a webhook in Gogs (localhost:3000) > your_java_project > Settings > Webhooks > Add a new webhook :

` http://gogs1:8080/gogs-webhook/?job=your_jenkins_job_name `

# That's all folks!

In case of the apocalypse, both nexus and gogs have persistent storage, so stopping docker containers will perserve your precious artifacts for further planetary inhabitation.

To stop all 3 containers, run:
stop: docker-compose down

TODO:
- ~~dockerfile for jenkins plugins~~
- ~~jenkins init setup disable, default user/pass~~
- terraform / cloudformation ?
