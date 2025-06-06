pipeline {
agent any
 stages {
 stage(cleaning custom-workspace) {
  steps {
   sh '''rm -rf /mnt/project
   mkdir -p /mnt/project'''
  }
 }
  stage(clone repo on custom location) {
 steps {
  dir('/mnt/project') {
   checkout scm
  }
 }
}
  stage(dir1) {
 steps {
  sh 'mkdir dir1'
 }
}
 }
}
