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
        stage('deploy of war file on tomcat-server') {
            steps {
               sh 'scp -o StrictHostKeyChecking=no -i /root/key.pem /mnt/project/target/*.war ec2-user@172.31.40.247:/mnt/apache-tomcat-10.1.41/webapps'
            }
        }
       stage('execute command on remote server') {
    steps {
        sh '''
            ssh -o StrictHostKeyChecking=no -i /root/key.pem ec2-user@172.31.40.247 << 'EOF'
cd /mnt/apache-tomcat-10.1.41/bin
sudo systemctl start apache-tomcat-10.1.41.service
EOF
        '''
    }
}
    } 
}
