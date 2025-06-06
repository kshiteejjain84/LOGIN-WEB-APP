pipeline {
 agent any
tools {
 maven 'apache-maven-3.9.10'
}
 stages {
  stage('build and create war file') {
   steps {
    dir('/mnt/project') {
        script {
     //cleaning the custom workspace and creating custom workspace
         sh 'rm -rf /mnt/project'
         sh 'mkdir -p /mnt/project'
     //cloning the git repository to custom workspace
         checkout scm
     //running maven build
         sh 'rm -rf /root/.m2/repository'
         sh 'mvn clean install'
        }
        stage('execute shell commands on remote server') {
         steps {
          publishOverSsh(
           server: 'server-1',
           sourceFiles:
           removePrefix:
           remoteDirectory:
           commands: 'rm -rf /mnt/apache-tomcat-10.1.41/webapps/*.war',
           execTimeout: 60000,
           verbose: true
          )
         }
        }
        stage('deployment on remote server') {
         steps {
          publishOverSsh(
           server: 'server-1',
           sourceFiles: 'target/*.war',
           removePrefix: 'target',
           remoteDirectory:
           commands: '''
                 cd /mnt/apache-tomcat-10.1.41/bin
                 ./startup.sh
           ''',
           execTimeout: 1200000,
           verbose: true
          )
         }
        }
        
    }
   }
  }
 }
}
