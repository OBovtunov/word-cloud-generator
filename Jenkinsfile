pipeline {
          agent { dockerfile true }
          
       stages{
          stage('Get source code'){
            steps{git 'https://github.com/Obovtunov/word-cloud-generator.git'
            }
          }
       
           stage('Using Make tests'){
            steps{
                sh '''export GOPATH=$WORKSPACE
                export PATH="$PATH:$(go env GOPATH)/bin"
                go get github.com/GeertJohan/go.rice/rice
                go get github.com/Obovtunov/word-cloud-generator/wordyapi
                go get github.com/gorilla/mux
                make lint
                make test'''
                }
            }
       }        
}
