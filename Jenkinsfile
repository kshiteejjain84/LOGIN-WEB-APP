pipeline {
    agent any
    tools {
        maven 'apache-maven-3.9.10'
    }
    stages {
    stage('clone git repo') {
        steps {
           dir('/mnt/project') {
               sh 'rm -rf *'
               checkout scm
           }
            
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
