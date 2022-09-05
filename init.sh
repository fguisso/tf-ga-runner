#!/bin/bash
sudo apt update -y
# install github runner application
sudo -u ubuntu mkdir -p /home/ubuntu/actions-runner
sudo -u ubuntu curl -o /home/ubuntu/actions-runner-linux-x64-${github_runner_version}.tar.gz -L https://github.com/actions/runner/releases/download/v${github_runner_version}/actions-runner-linux-x64-${github_runner_version}.tar.gz
sudo -u ubuntu tar xzf /home/ubuntu/actions-runner-linux-x64-${github_runner_version}.tar.gz -C /home/ubuntu/actions-runner
sudo -u ubuntu EC2_INSTANCE_ID=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id` bash -c 'cd /home/ubuntu/actions-runner/;./config.sh --url ${github_repo_url} --token ${github_repo_token} --name "${runner_name}-$${EC2_INSTANCE_ID}" --unattended;./run.sh'
