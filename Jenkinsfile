pipeline {
    agent any
    environment {
        DOCKERHUB_USERNAME = "idrisniyi94"
        DEPLOYMENT_NAME = "eshop"
        IMAGE_NAME = "${env.DOCKERHUB_USERNAME}/${env.DEPLOYMENT_NAME}:v${env.BUILD_NUMBER}"
        NAMESPACE = "dev-namespace"
        DOCKER_CREDENTIALS = credentials('d4506f04-b98c-47db-95ce-018ceac27ba6')
        SCANNER_HOME = tool 'sonar-scanner'
    }
    stages {
        stage ('Clean Workspace') {
            steps {
                echo 'Cleaning workspace'
                cleanWs()
            }
        }
        stage ('Checkout') {
            steps {
                echo 'Checking out code'
                git branch: 'master', url: 'https://github.com/stwins60/eshop.git'
            }
        }
        stage ('SonarQube Analysis') {
            steps {
                script {
                    withSonarQubeEnv('sonar-server') {
                        sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=eshop -Dsonar.projectName=eshop"
                    }
                }
            }
        }
        stage ('Quality Gate') {
            steps {
                script {
                    withSonarQubeEnv('sonar-server') {
                        timeout(time: 1, unit: 'HOURS') {
                            def qg = waitForQualityGate()
                            if (qg.status != 'OK') {
                                error "Pipeline aborted due to quality gate failure: ${qg.status}"
                            }
                        }
                    }
                }
            }
        }
        stage ('OWASP Dependency Check') {
            steps {
                script {
                    dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit --nvdApiKey 4bdf4acc-8eae-45c1-bfc4-844d549be812', odcInstallation: 'DP-Check'
                    dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
                }
            }
        }
        stage ('Trivy FS Scan') {
            steps {
                script {
                    sh 'trivy fs --exit-code 0 --severity HIGH,CRITICAL --no-progress .'
                }
            }
        }
        stage ('Login to DockerHub') {
            steps {
                sh "echo ${DOCKER_CREDENTIALS_PSW} | docker login -u ${DOCKER_CREDENTIALS_USR} --password-stdin"
            }
        }
        stage ('Build Docker Image') {
            steps {
                script {
                    def imageName = "${env.IMAGE_NAME}"
                    def command = "docker inspect ${imageName}"
                    def returnStatus = sh(script: command, returnStatus: true)
                    if (returnStatus == 0) {
                        echo "Docker image already exists: ${imageName}"
                    } else {
                        sh "docker build -t ${imageName} ."
                        echo "Docker image built: ${imageName}"
                    }
                }
            }
        }
        stage ("Trivy Docker Image Scan") {
            steps {
                script {
                    sh "trivy image --exit-code 0 --severity HIGH,CRITICAL --no-progress ${IMAGE_NAME}"
                }
            }
        }
        stage ('Push Docker Image') {
            steps {
                script {
                    sh "docker push ${IMAGE_NAME}"
                    echo "Docker image pushed: ${IMAGE_NAME}"
                }
            }
        }
        stage ('Deploy to Kubernetes') {
            steps {
                script {
                    dir('./k8s') {
                        kubeconfig(credentialsId: '500a0599-809f-4de0-a060-0fdbb6583332', serverUrl: '') {
                            sh "sed -i 's|NAMESPACE|${NAMESPACE}|g' deployment.yaml"
                            sh "sed -i 's|NAMESPACE|${NAMESPACE}|g' service.yaml"

                            sh "sed -i 's|IMAGE_NAME|${IMAGE_NAME}|g' deployment.yaml"
                            sh "sed -i 's|DEPLOYMENT_NAME|${DEPLOYMENT_NAME}|g' deployment.yaml"

                            sh "kubectl apply -f deployment.yaml"
                            sh "kubectl apply -f service.yaml"
                        }
                    }
                }
            }
        }
    }
    post {
        success {
            slackSend channel: '#jenkins', color: 'good', message: "Pipeline ${env.JOB_NAME} #${env.BUILD_NUMBER} passed"
        }
        failure {
            slackSend channel: '#jenkins', color: 'danger', message: "Pipeline ${env.JOB_NAME} #${env.BUILD_NUMBER} failed"
        }
    }
}