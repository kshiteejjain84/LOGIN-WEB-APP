pipeline{
  agent none
  tools {
    maven 'apache-maven-3.9.10'
  }
  options {
    skipDefaultCheckout()
  }
  environment {
    devip= "10.10.1.48"
    qaip= "10.10.2.20"
  }
  stages{
    stage('clone git repo containing source code to custom location') {
      agent {
        label 'built-in'
      }
      steps {
        dir('/mnt/loginwebapp-project') {
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
        dir('/mnt/loginwebapp-project') {
          sh 'rm -rf /root/.m2/repository'
          sh 'mvn clean install'
          sh 'rm -rf /mnt/wars/*'
          sh 'cp -r target/*.war /mnt/wars'
        }
      }
    }
    stage('copy war file to dev env and qa env') {
      agent {
        label 'built-in'
      }
      steps {
        sh 'scp -r /mnt/wars/*.war kshiteej@${devip}:/mnt/wars'
         sh 'scp -r /mnt/wars/*.war kshiteej@${qaip}:/mnt/wars'
      }
    }
  }
}
