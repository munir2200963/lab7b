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

                        // Execute the deploy script with increased logging
                        script {
                            try {
                                sh './jenkins/scripts/deploy.sh'
                            } catch (Exception e) {
                                echo "Error during deploy: ${e}"
                            }
                        }

                        // Wait for user input with a timeout
                        timeout(time: 10, unit: 'MINUTES') {
                            input message: 'Finished using the web site? (Click "Proceed" to continue)'
                        }

                        // Execute the kill script
                        script {
                            try {
                                sh './jenkins/scripts/kill.sh'
                            } catch (Exception e) {
                                echo "Error during kill: ${e}"
                            }
                        }
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
