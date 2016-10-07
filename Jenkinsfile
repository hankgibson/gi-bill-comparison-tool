def notify(message, color='good') {
    if (notify_slack) {
        slackSend message: message,
                  color: color,
                  failOnError: true
    }
}

pipeline {
  agent label:''
  stages {
    stage('Notify Slack') {
      notify """Deploying `gi-bill-comparison-tool` to `${environment}`.
               |${currentBuild.rawBuild.getCauses()[0].getShortDescription()}
               |${currentBuild.getAbsoluteUrl()}""".stripMargin()
    }

    stage('Checkout Code') {
      checkout changelog: false,
               poll: false,
               scm: [$class: 'GitSCM', branches: [[name: '*/master']],
               doGenerateSubmoduleConfigurations: false,
               extensions: [
                 [$class: 'SubmoduleOption', disableSubmodules: false, parentCredentials: false, recursiveSubmodules: true, reference: '', trackingSubmodules: false]
               ],
               submoduleCfg: [],
               userRemoteConfigs: [[url: 'git@github.com:department-of-veterans-affairs/devops.git']]]
    }

    stage('Create virtualenv') {
      dir('ansible') {
        sh 'virtualenv venv'
        sh 'venv/bin/pip install -r requirements.txt'
      }
    }

    stage('Run Ansible deploy') {
      dir('ansible') {
        sh  "bash -c 'source venv/bin/activate && ansible-playbook " +
            "-e env=${environment} " +
            "-e app_name=gi-bill-comparison-tool " +
            "-e force_ami=${force_ami} " +
            "-i inventory " +
            "aws-deploy-app.yml'"
      }
    }
  }

  notifications {
    success {
      notify """Successfully deployed `gi-bill-comparison-tool` to `${environment}`.
               |Took ${currentBuild.rawBuild.getDurationString()}""".stripMargin()
    }
    failure {
      notify "Failed to deploy `gi-bill-comparison-tool` to `${environment}`!", 'danger'
    }
  }
}

