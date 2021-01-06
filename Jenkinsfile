// Build and deploy Boxfuse project using AWS EC2 and S3
pipeline {

  agent any

  stages {


    stage('Git clone Terraform and Ansible scripts') {
      steps {
        git(url: 'https://github.com/ufndtwocmeu/CertHomework.git', branch: 'master')
      }
    }


    stage ('Install Terraform')  {

        steps {
                echo 'Install Terraform'

                sh 'sudo wget -r https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip'
                sh 'sudo unzip -o releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip'
                sh 'sudo cp -f terraform /bin/'
            
        }
    }

    stage ('Install Boto and Ansible')  {

        steps {
                echo 'Install Boto and Ansible'

                sh 'sudo apt update'
                sh 'sudo apt install software-properties-common'
                sh 'sudo apt-add-repository -y universe'
                sh 'sudo apt-add-repository -y ppa:deadsnakes/ppa'
                sh 'sudo apt-add-repository --yes --update ppa:ansible/ansible'
                sh 'sudo apt update'
                sh 'sudo apt install -y python3.9'
                sh 'sudo apt install -y python3-pip'
                sh 'sudo pip3 install boto3'
                sh 'sudo apt install ansible'
                sh 'sudo ansible-galaxy collection install amazon.aws'
                sh 'sudo ansible-galaxy collection install community.docker'
        }
    }

   
stage("Request data for AWS") {
            steps {
                script {

                    // Get the input to work with AWS
                    def userInput = input(
                            id: 'userInput', message: 'Enter your data for AWS:',
                            parameters: [

                                    string(defaultValue: '',
                                            description: 'AWS Access Key',
                                            name: 'AK'),
                                    string(defaultValue: '',
                                            description: 'AWS Secret Key',
                                            name: 'SK'),
                                    string(defaultValue: '',
                                            description: 'AWS Bucket Name',
                                            name: 'BN'),        
                                    string(defaultValue: '',
                                            description: 'RSA Public Key',
                                            name: 'PK')        
                            ])


                    // Assign inputs to variables
                    MY_AWS_ACCESS_KEY = userInput.AK?:''
                    MY_AWS_SECRET_KEY = userInput.SK?:''
                    MY_RSA_PUB_KEY = userInput.PK?:''
                    MY_AWS_S3_BUCKET = userInput.BN?:''

                }
            }
        }  


    stage ('Provision infrastructure at AWS with Terraform')  {

        steps {
            dir('Terraform') {
                echo 'Provision infrastructure at AWS with Terraform'

                sh 'sudo terraform init'
                sh "sudo terraform plan -out  boxfuse.tfplan -var \"my_aws_access_key=${MY_AWS_ACCESS_KEY}\" -var \"my_aws_secret_key=${MY_AWS_SECRET_KEY}\" -var \"my_rsa_pub_key=${MY_RSA_PUB_KEY}\""
                sh 'sudo terraform apply boxfuse.tfplan'
            }

        }
    }

    stage ('Build and deploy Boxfuse project at AWS with Ansible')  {

        steps {
            dir('Ansible') {
                echo 'Build and deploy Boxfuse project at AWS with Ansible'

                sh "sudo ansible-playbook boxfuse.yml --ssh-extra-args=\"-o StrictHostKeyChecking=no\" --extra-vars \"AWS_AK_ID=${MY_AWS_ACCESS_KEY} AWS_SA_KEY=${MY_AWS_SECRET_KEY} s3bucket=${MY_AWS_S3_BUCKET}\""
            }
        }
    }

  }
}