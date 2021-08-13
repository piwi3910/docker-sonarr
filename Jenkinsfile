pipeline {
    environment {
        imagename = "piwi3910/sonarr"
        registryCredential = 'docker_reg'
        alpine_dockerImage = ''
        version = ''
        dockerhubToken = 'dockerhub_token'

    }
    agent {
        kubernetes {
        yamlFile 'buildpod.yaml'
        }
    }
    stages {
        stage('Check Github releases') {
            steps {
                container('ubuntu-base') {
                    script {
                        version = sh (
                            script: """curl --silent "https://api.github.com/repos/Sonarr/Sonarr/tags" | jq -r '.[0].name' | sed -r 's/^.{1}//'""",
                            returnStdout: true
                        ).trim()
                    }
                }
            }    
        }
        stage('Build image based on latest base image with dind') {
            steps {
                container('docker') {
                    script {
                        alpine_dockerImage = docker.build("${env.imagename}:${BUILD_ID}", "--build-arg VERSION=${version} ${WORKSPACE}" ) 
                    }
                }
            }    
        }
        stage('Push build image to DockerHub') {
            steps {
                container('docker') {
                    script {
                        docker.withRegistry( '', registryCredential ) {
                        alpine_dockerImage.push("${version}")
                        alpine_dockerImage.push('latest')
                        }
                    }
                }
            }    
        }
/*        stage('Push README.md DockerHub') {
            steps {
                container('ubuntu-base') {
                    script {
                        code = sh (
                            script: """jq -n --arg msg "\$(<README.md)" \
                                    '{"registry":"registry-1.docker.io","full_description": \$msg }' | \
                                    curl -s -o /dev/null  -L -w "%{http_code}" \
                                    https://cloud.docker.com/v2/repositories/"${imagename}"/ \
                                    -d @- -X PATCH \
                                    -H "Content-Type: application/json" \
                                    -H "Authorization: JWT ${dockerhubToken}"""
                            )
                        sh """if [[ "${code}" = "200" ]]; then
                        printf "Successfully pushed README to Docker Hub"
                        else
                        printf "Unable to push README to Docker Hub, response code: %s\n" "${code}"
                        exit 1
                        fi"""
                    }
                }
            }    
        } */ 
    }
}
