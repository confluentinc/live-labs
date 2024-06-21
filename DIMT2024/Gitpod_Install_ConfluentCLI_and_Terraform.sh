echo "Installing Confluent CLI

------------------------------

"
sudo apt install curl gnupg
sudo mkdir -p /etc/apt/keyrings
curl https://packages.confluent.io/confluent-cli/deb/archive.key | sudo gpg --dearmor -o /etc/apt/keyrings/confluent-cli.gpg
sudo chmod go+r /etc/apt/keyrings/confluent-cli.gpg
echo "deb [signed-by=/etc/apt/keyrings/confluent-cli.gpg] https://packages.confluent.io/confluent-cli/deb stable main" | sudo tee /etc/apt/sources.list.d/confluent-cli.list >/dev/null
sudo apt update
sudo apt install confluent-cli

echo "Installing Terraform

--------------------------

"
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
