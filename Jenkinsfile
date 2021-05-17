pipeline{
    agent any
    tools {
        maven 'maven'
    }
    stages {
    	stage("Clone") {
    	    steps{
    		    git 'http://gogs1:3000/username/JavaAppSample.git'
    	    }
    	}

    	stage("Build/Deploy") {
    	    steps{
    			withMaven(maven: 'maven',mavenSettingsConfig: 'nexus-snapshots'){
                        sh "mvn clean deploy"
    			    }
    			}
    	    }
    	}
    }