pipeline{
  agent none
  tools {
    maven 'apache-maven-3.9.10'
  }
stages{
  stage('clone git repo to custom location') {
    agent {
      lable 'built-in'
    }
    steps {
      dir('/mnt/project') {
        sh 'rm -rf *'
        checkout scm
      }
    }
  }
  stage('database configuration') {
    agent {
      label 'built-in'
    }
  steps {
    dir('/mnt/project/src/main/webapp') {
      sh '''
      
    }
  }
  }
  stage('build war file with maven') {
    agent {
      label 'built-in'
    }
  steps {
    dir('/mnt/project') {
    sh ' rm -rf /root/.m2/repository'
    sh 'mvn clean install'
    stash includes: 'target/*.war', name: 'warfile'
    }
    }
  }
  stage('deploy of warfile on slave-1') {
    agent {
      label 'slave-2'
    }
    steps {
      unstash 'warfile'
      sh 'cp -r target/*.war /mnt/apache-tomcat-10.1.42/webapps'
      sh 'chmod -R 777 /mnt/apache-tomcat-10.1.42'
      sh 'cd /mnt/apache-tomcat-10.1.42/bin && ./startup.sh'
    }
  }
}
}
