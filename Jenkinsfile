pipeline {
  agent none
  tools {
    maven 'apache-maven-3.9.10'
  }
  stages {
    stage('cloning git repo to custom location') {
      agent {
        label 'built-in'
      }
        steps {
        dir('/mnt/project') {
          sh 'rm -rf *'
          checkout scm
        }
      }
    }
    stage('build with maven') {
      agent {
        label 'built-in'
      }
        steps {
        dir('/mnt/project') {
        sh 'rm -rf /root/.m2/repository'
        sh 'mvn clean install'
        stash includes: 'target/*.war', name: 'warfile'
        }
        }
      }
   stage('parallel stages') {
     parallel {
       stage('deploy of war file on slave-1') {
          agent {
            label 'slave-1'
          }
            steps {
              unstash 'warfile'
              sh 'cp target/*.war /mnt/apache-tomcat-10.1.41/webapps'
              sh '''
              cd /mnt/apache-tomcat-10.1.41/bin
              sudo ./startup.sh
              '''
            }
    }
    stage('deploy of war file on slave-2') {
          agent {
            label 'slave-2'
          }
            steps {
              unstash 'warfile'
              sh 'cp target/*.war /mnt/apache-tomcat-10.1.41/webapps'
              sh '''
              cd /mnt/apache-tomcat-10.1.41/bin
              sudo ./startup.sh
              '''
            }
    }
     }
   }
    
  }
}
