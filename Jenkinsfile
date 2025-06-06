pipeline {
    agent any

    tools {
        maven 'apache-maven-3.9.10'
    }

    stages {
        stage('Prepare Workspace and Checkout') {
            steps {
                script {
                    sh 'rm -rf /mnt/project'
                    sh 'mkdir -p /mnt/project'
                }
                dir('/mnt/project') {
                    checkout scm
                }
            }
        }

        stage('Build WAR File') {
            steps {
                dir('/mnt/project') {
                    script {
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

        stage('Deploy WAR to Remote Server') {
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

