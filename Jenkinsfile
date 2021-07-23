pipeline {
        agent { dockerfile true }
	
	
        stages{
          stage('Get source code'){
           steps{git 'https://github.com/Obovtunov/word-cloud-generator.git'}
          }
          stage('Make tests'){
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
          stage('Build'){
           steps{
               sh ''' go get github.com/tools/godep
               go get github.com/smartystreets/goconvey
               go get github.com/GeertJohan/go.rice/rice
               go get github.com/OBovtunov/word-cloud-generator/wordyapi
               go get github.com/gorilla/mux
               sed -i 's/1.DEVELOPMENT/1.$BUILD_NUMBER/g' ./rice-box.go
               GOOS=linux GOARCH=amd64 go build -o ./artifacts/word-cloud-generator -v .
               gzip -c ./artifacts/word-cloud-generator >./artifacts/word-cloud-generator.gz
               rm ./artifacts/word-cloud-generator
               mv ./artifacts/word-cloud-generator.gz ./artifacts/word-cloud-generator '''
                 }
           }
           stage('Upload artifacts'){
            steps{
                nexusArtifactUploader artifacts: [[artifactId: 'word-cloud-generator', classifier: '', file: 'artifacts/word-cloud-generator', type: 'gz']], credentialsId: 'nexus-creds', groupId: 'web-app-pipeline', nexusUrl: 'nexus:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'word-cloud-generator',   version: '1.$BUILD_NUMBER'
                 }
           }    
        }
}
