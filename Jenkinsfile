pipeline {
 agent any
tools {
 maven 'apache-maven-3.9.10'
}
 stages {
  stage('build and create war file') {
   steps {
    dir('mnt/project') {
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
    }
   }
  }
        stage('Cleanup Remote Server') {
            steps {
                script {
                    step([
                        $class: 'PublishOverSSH',
                        publishers: [
                            [
                                configName: 'server-1',
                                transfers: [[
                                    execCommand: 'rm -rf /mnt/apache-tomcat-10.1.41/webapps/*.war'
                                ]],
                                execTimeout: 60000,
                                verbose: true
                            ]
                        ]
                    ])
                }
            }
        }
        stage('deployment on remote server') {
            steps {
                script {
                    step([
                        $class: 'PublishOverSSH',
                        publishers: [
                            [
                                configName: 'server-1',
                                transfers: [[
                                    sourceFiles: 'target/*.war',
                                    removePrefix: 'target',
                                    remoteDirectory: '/mnt/apache-tomcat-10.1.41/webapps',
                                    execCommand: '''
                                        cd /mnt/apache-tomcat-10.1.41/bin
                                        ./startup.sh
                                    '''
                                ]],
                                execTimeout: 120000,
                                verbose: true
                            ]
                        ]
                    ])
                }
            }
        }
       }
      }
 
