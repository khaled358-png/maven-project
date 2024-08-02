pipeline{

    agent any
    
    environment{
        NUMBER = "${env.BUILD_ID}"
        recipientEmails = "pvganesh4@gmail.com"
    }
    tools { 
      maven 'Maven-3.8.7' 
      jdk 'Java-11' 
    }

    stages{

        stage("Git checkout"){

            steps{
               git branch: 'main',  
               url: 'https://github.com/ganeshpv7/SDLC-project2.git'
            }
        }
        stage("Unit test"){

            steps{
                sh 'mvn test'
            }
        }
        stage("Integration test"){
            steps{
                sh 'mvn verify -DskipUnitTest'
            }
        }
        stage("Maven build"){
            steps{
                sh 'mvn clean install'
            }
        }
//        stage("Sonarqube analysis"){
//            steps{
//                script{
//                    withSonarQubeEnv(credentialsId: 'sonar-pd'){
//                        sh 'mvn clean package sonar:sonar'
//                   }
//                }
//            }
//        }
//        stage("Quality gate analysis"){
//            steps{
//                script{
//                    waitForQualityGate abortPipeline: false, 
//                    credentialsId: 'sonar-pd'
//                }
//            }
//        }

//        stage("Push artifacts to nexus"){
//            steps{
//                script{
//
//                    def PomVersion = readMavenPom file: 'pom.xml'
//                    def NexusRepo = PomVersion.version.endsWith("SNAPSHOT") ? "demoapp-snapshot" : "demoapp-release" 
//
//                    nexusArtifactUploader artifacts: [[artifactId: 'CubeGeneratorWeb', 
//                    classifier: '', 
//                    file: "target/SDLC-both.war", 
//                    type: 'war']], 
                    
//                    credentialsId: 'nexus', 
//                    groupId: 'com.javatpoint',
//                    nexusUrl: '34.201.5.4:8081', 
//                    nexusVersion: 'nexus3', 
//                    protocol: 'http', 
//                    repository: "${NexusRepo}", 
//                    version: "${PomVersion.version}"
//                }
//            }
//        }

        stage("Push to S3 bucket"){
            steps{
                script{

                    s3Upload consoleLogLevel: 'INFO', 
                    dontSetBuildResultOnFailure: false, 
                    dontWaitForConcurrentBuildCompletion: false, 
                    entries: [[bucket: 'artifact-from-jenkinsfile', 
                    excludedFile: '', 
                    flatten: false, 
                    gzipFiles: false, 
                    keepForever: false, 
                    managedArtifacts: false, 
                    noUploadOnFailure: true, 
                    selectedRegion: 'us-east-1', 
                    showDirectlyInBrowser: false, 
                    sourceFile: 'target/SDLC-check.jar', 
                    storageClass: 'STANDARD', 
                    uploadFromSlave: false, 
                    useServerSideEncryption: false]], 
                    pluginFailureResultConstraint: 'FAILURE', 
                    profileName: 'AWS-S3', 
                    userMetadata: []
                
                }
            }
        }
        stage("Build docker image and tag and push"){
            steps{
                script{
                        sh '''
                         docker build -t "cube-${NUMBER}" .
                         docker tag cube-${NUMBER} ganeshpv/cube-generator:v1.${NUMBER}                  
                         
                        '''
                }
            }
        }

        stage("Push image to Dockerhub and nexus"){
            steps{
                script{

                    withCredentials([string(credentialsId: 'docker_pd', variable: 'docker_pass')]){
                        sh 'docker login -u ganeshpv -p ${docker_pass}'
                        sh 'docker push ganeshpv/cube-generator:v1.${NUMBER}'
                    }
//                    withCredentials([string(credentialsId: 'nexus_pd', variable: 'nexus_pass')]){
//                        sh 'docker login -u admin -p ${nexus_pass} 18.209.248.162:8081'
//                        sh 'docker push ganeshpv/cube-generator:v1.${NUMBER}'
//                    }
                }
            }
        }
    }
}











//     post{
//        always{
//            emailext to: "${recipientEmails}",
//            subject: "Jenkins build:${currentBuild.currentResult}: ${env.JOB_NAME}",
//            body: "${currentBuild.currentResult}: Job ${env.JOB_NAME}\nMore Info can be found here: ${env.BUILD_URL}"
//        }
//    }

