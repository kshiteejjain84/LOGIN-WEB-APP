pipeline{
  agent none
  tools {
    maven 'apache-maven-3.9.10'
  }
stages{
  stage('clone git repo to custom location') {
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
  stage('database configuration') {
    agent {
      label 'built-in'
    }
  environment {
    DB_URL = 'jdbc:mysql://database-1.cf08a8wsmd7q.us-east-2.rds.amazonaws.com:3306/loginwebapp'
    DB_USER = 'admin'
    DB_PASS = '12345678'
  }
    steps {
    dir('/mnt/project/src/main/webapp') {
      sh '''
      # Replace the DB connection line with placeholders
        sed -i 's|DriverManager.getConnection(.*);|DriverManager.getConnection("DB_URL_PLACEHOLDER", "DB_USER_PLACEHOLDER", "DB_PASS_PLACEHOLDER");|' userRegistration.jsp

        # Inject real values
        sed -i "s|DB_URL_PLACEHOLDER|${DB_URL}|" userRegistration.jsp
        sed -i "s|DB_USER_PLACEHOLDER|${DB_USER}|" userRegistration.jsp
        sed -i "s|DB_PASS_PLACEHOLDER|${DB_PASS}|" userRegistration.jsp
        '''
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
  stage('deploy of warfile on slave-2') {
    agent {
      label 'slave-2'
    }
    steps {
      unstash 'warfile'
      sh 'sudo cp -r target/*.war /mnt/apache-tomcat-10.1.42/webapps'
      sh 'sudo chmod -R 777 /mnt/apache-tomcat-10.1.42'
      sh 'sudo cd /mnt/apache-tomcat-10.1.42/bin'
      sh 'sudo ./startup.sh'
    }
  }
}
}
