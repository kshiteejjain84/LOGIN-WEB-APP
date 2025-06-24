pipeline{
  agent none
  tools {
    maven 'apache-maven-3.9.10'
  }
  options {
    skipDefaultCheckout()
  }
stages{
  stage('clone git repo to custom location') {
    agent {
      label 'built-in'
    }
    steps {
      dir('/mnt/project-2') {
        sh 'rm -rf *'
        checkout scm
        stash includes: 'Dockerfile', name: 'dockerfile'
        stash includes: 'init.sql', name: 'sqlfile'
      }
    }
  }
  stage('database configuration') {
    agent {
      label 'built-in'
    }
  environment {
    DB_URL = 'jdbc:mysql://mysqlcontainer:3306/loginwebapp'
    DB_USER = 'admin'
    DB_PASS = '12345678'
  }
    steps {
    dir('/mnt/project-2/src/main/webapp') {
      sh """
      # Replace the DB connection line with placeholders
        sed -i 's|DriverManager.getConnection("jdbc:mysql://localhost:3306/test", "root", "root");|DriverManager.getConnection("DB_URL_PLACEHOLDER", "DB_USER_PLACEHOLDER", "DB_PASS_PLACEHOLDER");|' userRegistration.jsp
        
        # Inject real values
        sed -i "s|DB_URL_PLACEHOLDER|${DB_URL}|" userRegistration.jsp
        sed -i "s|DB_USER_PLACEHOLDER|${DB_USER}|" userRegistration.jsp
        sed -i "s|DB_PASS_PLACEHOLDER|${DB_PASS}|" userRegistration.jsp
        """
    }
  }
  }
  stage('build with maven') {
    agent {
      label 'built-in'
    }
    steps {
      dir('/mnt/project-2') {
        sh 'rm -rf /root/.m2/repository'
        sh 'mvn clean install'
        stash includes: 'target/*.war', name: 'warfile'
      }
    }
  }
  stage('build and run docker container mysqlcontainer on slave-1') {
    agent {
      label 'slave-1'
    }
    steps {
      unstash 'dockerfile'
      unstash 'sqlfile'
      sudo chmod -R 777 /mnt/jenkins-slave1/workspace/war-file-deploy-on-containers/init.sql
      sh 'sudo docker build -t customsql:1.0 .'
      sh 'sudo docker run -dp 3306:3306 --name mysqlcontainer customsql:1.0'
    }
  }
  stage(' run tomcat container and deploy war file in it') {
    agent {
      label 'slave-1'
    }
    steps {
      sleep 10
      sh 'sudo docker run -dp 8080:8080 --name tomcat10 tomcat:10'
      unstash 'warfile'
      sh 'sudo docker cp target/*.war tomcat10:/usr/local/tomcat/webapps'
    }
  }
}
}
