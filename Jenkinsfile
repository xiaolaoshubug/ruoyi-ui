pipeline {
  agent {
    node {
      label 'nodejs'
    }

  }
  stages {
    stage('拉取代码') {
      agent none
      steps {
        container('nodejs') {
          git(url: 'https://gitee.com/ouay/ruoyi-ui.git', credentialsId: 'gitee-id', changelog: true, poll: false)
          sh 'ls -al'
        }

      }
    }

    stage('编译代码') {
      agent none
      steps {
        container('nodejs') {
          sh 'npm install --registry=https://registry.npm.taobao.org'
          sh 'npm run build:prod'
          sh 'ls -al'
        }

      }
    }

    stage('制作镜像') {
      agent none
      steps {
        container('nodejs') {
          sh 'ls dist/'
          sh 'docker build -t ruoyi-ui:latest .'
        }

      }
    }

    stage('推送镜像') {
      agent none
      steps {
        container('nodejs') {
          withCredentials([usernamePassword(credentialsId : 'aliyun-docker-registry' ,passwordVariable : 'DOCKER_USER_PASS' ,usernameVariable : 'DOCKER_USER_NAME' ,)]) {
            sh 'echo "$DOCKER_USER_PASS" | docker login $REGISTRY -u "$DOCKER_USER_NAME" --password-stdin'
            sh 'docker tag ruoyi-ui:latest $REGISTRY/$ALIYUNHUB_NAMESPACE/ruoyi-ui:SNAPSHOT-$BUILD_NUMBER'
            sh 'docker push  $REGISTRY/$ALIYUNHUB_NAMESPACE/ruoyi-ui:SNAPSHOT-$BUILD_NUMBER'
          }

        }

      }
    }

    stage('部署到开发环境') {
      agent none
      steps {
        container('nodejs') {
          kubernetesDeploy(enableConfigSubstitution: true, deleteResource: false, kubeconfigId: 'demo-kubeconfig', configs: 'deploy/**')
        }

      }
    }

    stage('邮件通知') {
      agent none
      steps {
        mail(to: 'aoyio@qq.com', subject: '"Jenkins 【$BUILD_NUMBER】 自动部署结果"', body: '"Jenkins 【$BUILD_NUMBER】 自动部署结果"')
      }
    }

  }
  environment {
    DOCKER_CREDENTIAL_ID = 'dockerhub-id'
    GITHUB_CREDENTIAL_ID = 'github-id'
    KUBECONFIG_CREDENTIAL_ID = 'demo-kubeconfig'
    REGISTRY = 'registry.cn-qingdao.aliyuncs.com'
    ALIYUNHUB_NAMESPACE = 'ruoyi_images'
    GITHUB_ACCOUNT = 'kubesphere'
    APP_NAME = 'devops-java-sample'
  }
  parameters {
    string(name: 'TAG_NAME', defaultValue: '', description: '')
  }
}
