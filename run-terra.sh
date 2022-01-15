file=./virginia-region-key-pair
if [ ! -e "$file" ]; then
    ssh-keygen -f virginia-region-key-pair -b 2048 -t rsa -q -N ""
fi

terraform init
(($? != 0)) && { printf '%s\n' "Command exited with non-zero"; exit 1; }
terraform plan -out terraform.out
(($? != 0)) && { printf '%s\n' "Command exited with non-zero"; exit 1; }
terraform apply terraform.out
(($? != 0)) && { printf '%s\n' "Command exited with non-zero"; exit 1; }

publicip=$(terraform output -json | jq ".instance_public_ip.value" | tr -d '"')
ssh -i virginia-region-key-pair ec2-user@$publicip
