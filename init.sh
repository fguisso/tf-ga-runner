#!/bin/bash
sudo yum update -y
# install github runner application
sudo -u ec2-user mkdir /home/ec2-user/actions-runner
sudo -u ec2-user curl -o /home/ec2-user/actions-runner-linux-x64-2.289.2.tar.gz -L https://github.com/actions/runner/releases/download/v2.289.2/actions-runner-linux-x64-2.289.2.tar.gz
sudo -u ec2-user tar xzf /home/ec2-user/actions-runner-linux-x64-2.289.2.tar.gz -C /home/ec2-user/actions-runner
sudo -u ec2-user EC2_INSTANCE_ID=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id` bash -c 'cd /home/ec2-user/actions-runner/;./config.sh --url ${github_repo_url} --token ${github_repo_token} --name "${runner_name}-$${EC2_INSTANCE_ID}" --unattended;./run.sh'
