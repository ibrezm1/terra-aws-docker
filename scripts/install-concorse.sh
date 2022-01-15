#!/bin/bash
# added for testing
#exit 0

history | cut -c 8-
curl -O https://concourse-ci.org/docker-compose.yml
my_ip=$(curl http://checkip.amazonaws.com)
sed -i "s/localhost/$my_ip/g" docker-compose.yml
docker-compose up -d
docker-compose ps 
wget -O ~/fly "http://localhost:8080/api/v1/cli?arch=amd64&platform=linux" 
sudo mkdir -p /usr/local/bin
sudo mv ~/fly /usr/local/bin
sudo chmod 0755 /usr/local/bin/fly
 sudo ln -s /usr/local/bin/fly /usr/bin/fly
fly --target main login --concourse-url "http://localhost:8080" -u test -p test
git clone https://github.com/starkandwayne/concourse-tutorial.git
cd concourse-tutorial/tutorials/basic/task-hello-world
fly -t main execute -c task_hello_world.yml
history | cut -c 8-
docker run -d -v vault_home:/var -p 1234:1234 --cap-add=IPC_LOCK -e 'VAULT_DEV_ROOT_TOKEN_ID=myroot' -e 'VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:1234' vault

