pipeline {
        agent{
	      dockerfile {filename 'Dockerfile'
			   args '--network work'
			 }
        	}
	stages{
          stage('Make tests'){
           steps{
                sh '''
		rm -f artifacts/*
		export GOPATH=$WORKSPACE
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
               sh ''' export GOPATH=$WORKSPACE
               export PATH="$PATH:$(go env GOPATH)/bin"
	       go get github.com/tools/godep
               go get github.com/smartystreets/goconvey
               go get github.com/GeertJohan/go.rice/rice
               go get github.com/OBovtunov/word-cloud-generator/wordyapi
               go get github.com/gorilla/mux
	       sed -i 's/1.DEVELOPMENT/1.$BUILD_NUMBER/g' ./rice-box.go
               GOOS=linux GOARCH=amd64 go build -o ./artifacts/word-cloud-generator -v .
	       gzip -c ./artifacts/word-cloud-generator >./artifacts/word-cloud-generator.gz
               rm ./artifacts/word-cloud-generator
               mv ./artifacts/word-cloud-generator.gz ./artifacts/word-cloud-generator'''
                 }
           }
           stage('Upload artifacts'){
            steps{
                nexusArtifactUploader artifacts: [[artifactId: 'word-cloud-generator', classifier: '', file: 'artifacts/word-cloud-generator', type: 'gz']], credentialsId: '7adeda37-a6d0-4cb6-a8f2-71a826cfb3b1', groupId: '1', nexusUrl: 'nexus:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'word-cloud-builds', version: '1.$BUILD_NUMBER'                 }
                 }
		
       	   stage('Create container,download,start aplication'){
		   agent{
			   dockerfile {
				   dir 'stage'
			           filename 'Dockerfile'
				   args '--network work --name stage -p 88:8888'
				      }
		         }
		   steps {
                          sh '''
			curl -X GET -u downloader:downloader "http://nexus:8081/repository/word-cloud-builds/1/word-cloud-generator/1.$BUILD_NUMBER/word-cloud-generator-1.$BUILD_NUMBER.gz" -o /opt/wordcloud/word-cloud-generator.gz
                        gunzip -f /opt/wordcloud/word-cloud-generator.gz
                        chmod +x /opt/wordcloud/word-cloud-generator
			/opt/wordcloud/word-cloud-generator &
			sleep 3
			res=`curl -s -H "Content-Type: application/json" -d '{"text":"test"}' http://stage:8888/version | jq '. | length'`
                        if [ "1" != "$res" ]; then exit 99;
                             fi
	                 res=`curl -s -H "Content-Type: application/json" -d '{"text":"ths is a really really really important thing this is"}' http://stage:8888/api | jq '. | length'`
	                if [ "7" != "$res" ]; then exit 99;
                             fi
	        	    '''
		         }
         
	   }	   
   }
}
