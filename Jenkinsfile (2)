pipeline {
    agent any

    tools {
        maven 'Maven3'   // Name must match a Maven install configured in Jenkins Global Tool Config
        jdk 'JDK21'      // Name must match a JDK install configured in Jenkins Global Tool Config
    }

    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'staging', 'prod'],
            description: 'Target environment for this build/run'
        )
        string(
            name: 'BRANCH_NAME',
            defaultValue: 'main',
            description: 'Git branch to build'
        )
        string(
            name: 'DOCKER_IMAGE_TAG',
            defaultValue: 'latest',
            description: 'Tag to apply to the built Docker image'
        )
        string(
            name: 'CONTAINER_PORT',
            defaultValue: '8081',
            description: 'Host port to map to the container\'s port 8080'
        )
        booleanParam(
            name: 'SKIP_TESTS',
            defaultValue: false,
            description: 'Skip unit tests during the Maven build'
        )
        booleanParam(
            name: 'USE_COPY_ARTIFACT',
            defaultValue: false,
            description: 'Instead of building, copy the WAR from another Jenkins job (Copy Artifact plugin)'
        )
        string(
            name: 'UPSTREAM_JOB_NAME',
            defaultValue: '',
            description: 'Upstream job name to copy the WAR artifact from (used only if USE_COPY_ARTIFACT is true)'
        )
    }

    environment {
        APP_NAME          = 'student-management'
        DOCKER_IMAGE      = "student-management-app"
        DOCKER_TAG        = "${params.DOCKER_IMAGE_TAG}"
        CONTAINER_NAME    = "student-management-${params.ENVIRONMENT}"
        WAR_FILE          = "target/${APP_NAME}.war"
    }

    options {
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: "${params.BRANCH_NAME}",
                    url: 'https://github.com/dineshbeece2013-dot/mavenrepo.git'
            }
        }

        stage('Build & Unit Test') {
            when {
                expression { return !params.USE_COPY_ARTIFACT }
            }
            steps {
                script {
                    if (params.SKIP_TESTS) {
                        sh 'mvn clean package -DskipTests'
                    } else {
                        sh 'mvn clean package'
                    }
                }
            }
        }

        stage('Generate Test Report') {
            when {
                allOf {
                    expression { return !params.USE_COPY_ARTIFACT }
                    expression { return !params.SKIP_TESTS }
                }
            }
            steps {
                sh 'mvn surefire-report:report-only'
            }
        }

        stage('Publish HTML Report') {
            when {
                expression { return !params.USE_COPY_ARTIFACT && !params.SKIP_TESTS }
            }
            steps {
                // Requires the HTML Publisher plugin
                publishHTML(target: [
                    allowMissing: true,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'target/site',
                    reportFiles: 'surefire-report.html',
                    reportName: 'Surefire Test Report'
                ])
            }
        }

        stage('Copy Artifact From Upstream Job') {
            when {
                expression { return params.USE_COPY_ARTIFACT && params.UPSTREAM_JOB_NAME?.trim() }
            }
            steps {
                // Requires the Copy Artifact plugin
                copyArtifacts(
                    projectName: "${params.UPSTREAM_JOB_NAME}",
                    filter: '**/*.war',
                    fingerprintArtifacts: true,
                    flatten: true,
                    target: 'target',
                    selector: lastSuccessful()
                )
            }
        }

        stage('Archive WAR Artifact') {
            steps {
                archiveArtifacts artifacts: 'target/*.war', fingerprint: true
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }

        stage('Run Docker Container') {
            steps {
                sh """
                    docker rm -f ${CONTAINER_NAME} || true
                    docker run -d --name ${CONTAINER_NAME} -p ${params.CONTAINER_PORT}:8080 ${DOCKER_IMAGE}:${DOCKER_TAG}
                """
            }
        }
    }

    post {
        success {
            echo "Build succeeded. App '${APP_NAME}' running in container '${CONTAINER_NAME}' on port ${params.CONTAINER_PORT}."
        }
        failure {
            echo 'Build failed. Check console output above for details.'
        }
        always {
            cleanWs(deleteDirs: true, notFailBuild: true)
        }
    }
}
