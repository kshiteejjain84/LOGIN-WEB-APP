pipeline {
    agent any
    tools {
        maven 'apache-maven-3.9.10'
    }
    stages {
        stage('cloning git repo to custom location') {
            steps {
                dir('/mnt/project') {
                    sh 'rm -rf /mnt/project/*'
                    sh 'checkout scm'
                }
            }
        }
      stage('build with maven') {
          steps {
              dir('/mnt/project') {
                  sh 'rm -rf /root/.m2/repository'
                  sh 'mvn clean install'
              }
          }
      }
        stage('deploy war file on remote server') {
              steps {
                  sh 'scp -o StrictHostKeyChecking=no -i /root/key.pem /mnt/project/*.war ec2-user@172.31.34.100:/mnt/apache-tomcat-10.1.41/webapps
              }
        }
        stage('execute shell commands on remote server') {
            steps {
sh '''
ssh -T -o StrictHostKeyChecking=no -i /root/key.pem ec2-user@172.31.34.100 << 'EOF'
cd /mnt/apache-tomcat-10.1.41/bin
sudo ./startup.sh
EOF
 '''
            }
        }
        stage('execute shell commands on remote server giving permisiion to extracted war file') {
            steps {
                sleep 10
                sh '''
ssh -T -o StrictHostKeyChecking=no -i /root/key.pem ec2-user@172.31.34.100 << 'EOF'
cd /mnt
sudo chmod -R 777 apache-tomcat-10.1.41
EOF
 '''
            }
        }
    }
}
