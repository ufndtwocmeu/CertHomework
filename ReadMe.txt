This Jenkinsfile pipeline was tested on Ubuntu 18.04 with Jenkins 2.263.1.

By default us-east-2 AWS region is used. If you use the other region edit Terraform/vars.tf and Ansible/r_common/defaults/main.yml.

After deployment project is accessible at http://your_aws_prod_public_ip_address:8080/hello-1.0