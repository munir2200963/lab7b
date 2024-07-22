pipeline {
    agent none
    stages {
        stage('Integration UI Test') {
            parallel {
                stage('Deploy') {
                    agent any
                    steps {

                        // Ensure scripts have execute permissions
                        sh 'chmod +x ./jenkins/scripts/deploy.sh'
                        sh 'chmod +x ./jenkins/scripts/kill.sh'

                        // Execute the deploy script
                        sh './jenkins/scripts/deploy.sh'

                        // Wait for user input with a timeout
                        timeout(time: 10, unit: 'MINUTES') {
                            input message: 'Finished using the web site? (Click "Proceed" to continue)'
                        }

                        // Execute the kill script
                        sh './jenkins/scripts/kill.sh'
                    }
                }
                stage('Headless Browser Test') {
                    agent {
                        docker {
                            image 'maven:3-alpine'
                            args '-v /root/.m2:/root/.m2'
                        }
                    }
                    steps {
                        cleanWs() // Clean up the workspace before starting

                        // Ensure Maven build and test steps with increased logging
                        script {
                            try {
                                sh 'mvn -B -DskipTests clean package'
                            } catch (Exception e) {
                                echo "Error during Maven clean package: ${e}"
                            }
                        }

                        script {
                            try {
                                sh 'mvn test'
                            } catch (Exception e) {
                                echo "Error during Maven test: ${e}"
                                // Print Docker container logs
                                sh 'docker logs my-apache-php-app'
                                error "Test failed"
                            }
                        }
                    }
                    post {
                        always {
                            // Record test results
                            junit 'target/surefire-reports/*.xml'
                        }
                    }
                }
            }
        }
    }
}
