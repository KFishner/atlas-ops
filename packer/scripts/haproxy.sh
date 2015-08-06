# install HAproxy
sudo apt-get install -y haproxy
sudo chmod a+w /etc/rsyslog.conf
echo '$ModLoad imudp' >> /etc/rsyslog.conf
echo '$UDPServerAddress 127.0.0.1' >> /etc/rsyslog.conf
echo '$UDPServerRun 514' >> /etc/rsyslog.conf
sudo service rsyslog restart
sudo mkdir -m 777 /etc/ctmpl

# install consul template
wget https://github.com/hashicorp/consul-template/releases/download/v0.6.5/consul-template_0.6.5_linux_amd64.tar.gz
tar xzf consul-template_0.6.5_linux_amd64.tar.gz
sudo mv consul-template_0.6.5_linux_amd64/consul-template /usr/bin
sudo rmdir consul-template_0.6.5_linux_amd64
