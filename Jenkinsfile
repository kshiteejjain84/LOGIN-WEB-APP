pipeline {
    agent any
    tools {
        maven 'apache-maven-3.9.10'
    }
    stages {
    stage('clone git repo') {
        steps {
            sh 'rm -rf /mnt/project'
            sh 'mkdir -p /mnt/project'
            sh 'git clone https://github.com/kshiteejjain84/project.git /mnt/project
        }
    }
        stage('mvn build') {
            steps {
                dir('/mnt/project') {
                    // cleaning maven repo first
                    sh 'rm -rf /root/.m2/repository'
                    sh 'mvn clean install'
                }
            }
        }
    } 
}
