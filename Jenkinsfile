pipeline {
    agent {
        kubernetes {
            serviceAccount 'jenkins-sa'
            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command: ["cat"]
    tty: true
    volumeMounts:
    - name: kaniko-secret
      mountPath: /kaniko/.docker
  - name: kubectl
    image: bitnami/kubectl:latest
    command: ["cat"]
    tty: true
    securityContext:
      runAsUser: 1000
  - name: jnlp
    image: jenkins/inbound-agent:latest
  volumes:
  - name: kaniko-secret
    emptyDir: {}
"""
        }
    }
    
    environment {
        DOCKERHUB_REPO = "mahmoudah98/eks"
        // Store credentials in Jenkins credentials store
        DOCKERHUB = credentials('dockerhub-credentials')
    }
    
    stages {

        stage("Source Code Checkout") {
            steps {
                container('jnlp') {
                    checkout scm
                }
            }
        }
        
        stage("Setup Docker Credentials") {
            steps {
                container('kaniko') {
                    sh '''
                        echo "{\\"auths\\":{\\"https://index.docker.io/v1/\\":{\\"auth\\":\\"$(echo -n ${DOCKERHUB_USR}:${DOCKERHUB_PSW} | base64)\\"}}}" > /kaniko/.docker/config.json
                    '''
                }
            }
        }
        stage("Build Image & push to Dockerhub (Kaniko)") {
            steps {
                container('kaniko') {
                    sh '''
                        /kaniko/executor \
                          --dockerfile Dockerfile \
                          --context $(pwd) \
                          --destination ${DOCKERHUB_REPO}:latest \
                          --cache=true
                    '''
                }
            }
        }
        
        stage("Deploy to EKS Cluster") {
            steps {
                container('kubectl') {
                    sh '''
                        kubectl apply -f service.yaml
                        kubectl delete pod eks-app -n app --ignore-not-found=true
                        kubectl apply -f pod.yaml
                    '''
                }
            }
        }
    }
}
