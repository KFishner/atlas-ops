sudo apt-get -y update
sudo apt-get -y install curl

# Setup a proper node PPA
sudo curl -sL https://deb.nodesource.com/setup | sudo bash -

# Install requirements
sudo apt-get install -y -qq \
    nodejs
