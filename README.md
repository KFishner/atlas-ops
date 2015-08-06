HAProxy and Node.js
===================
This repository and walkthrough guides you through deploying HAProxy and Node.js on AWS with Consul for service discovery.

General setup
-------------
1. Clone this repository
2. Create an [Atlas account](https://atlas.hashicorp.com/account/new?utm_source=github&utm_medium=examples&utm_campaign=haproxy-nodejs)
3. Generate an [Atlas token](https://atlas.hashicorp.com/settings/tokens) and save as environment variable. 
`export ATLAS_TOKEN=<your_token>`
4. Download and install the latest versions of [Vagrant](https://www.vagrantup.com/downloads.html), [Packer](http://packer.io/downloads), and [Terraform](http://terraform.io/downloads). 

Introduction and Configuring HAProxy + Node.js
-----------------------------------------------
Before jumping into configuration steps, it's helpful to have a mental model for how services connect and how the Atlas workflow fits in. 

For HAProxy to work properly, it needs to have a real-time list of backend nodes to balance traffic between. In this example, HAProxy needs to have a real-time list of healthy Node.js nodes. To accomplish this, we use [Consul](https://consul.io) and [Consul Template](https://github.com/hashicorp/consul-template). Any time a server is created, destroyed, or changes in health state, the HAProxy configuration updates to match by using the Consul Template `haproxy.ctmpl`. Pay close attention to the backend stanza:

```
backend webs
    balance roundrobin
    mode http{{range service "nodejs.web"}}
    server {{.Node}} {{.Address}}:{{.Port}}{{end}}
```

Consul Template will query Consul for all web servers with the tag "nodejs", and then iterate through the list to populate the HAProxy configuration. When rendered, `haproxy.cfg` will look like:

```
backend webs
    balance roundrobin
    mode http
    server node1 172.29.28.10:8888
    server node2 172.56.28.10:8888
```
This setup allows us to destroy and create backend servers at scale with confidence that the HAProxy configuration will always be up-to-date. You can think of Consul and Consul Template as the connective webbing between services. 

Step 1: Create a Consul Cluster
-------------------------
For Consul Template to work for HAProxy, we first need to create a Consul cluster.
1. Build an AMI with Consul installed. To do this, update the `variables` stanza in the `consul.json` file with your Atlas username, and then run `packer push -create consul.json` in the Packer directory. This will send the build configuration to Atlas so it can build your Consul AMI remotely. 
2. View the status of your build in the Builds tab of your [Atlas account](https://atlas.hashicorp.com/builds).
3. The first build will fail since your AWS credentials are not set in Atlas. To do this, go to the "Variables" tab
of the Consul build and set the proper vaules for the keys `aws_access_key` and `aws_secret_key`

Step 2: Build a HAProxy AMI
---------------------
1. Build an AMI with HAProxy installed. To do this, update the `variables` stanza in the `haproxy.json` file with your Atlas username, and then run `packer push -create haproxy.json` in the Packer directory. This will send the build configuration to Atlas so it can build your HAProxy AMI remotely. 
2. View the status of your build in the Builds tab of your [Atlas account](https://atlas.hashicorp.com/builds).
3. The first build will fail since your AWS credentials are not set in Atlas. To do this, go to the "Variables" tab
of the HAProxy build and set the proper vaules for the keys `aws_access_key` and `aws_secret_key`

Step 3: Build a Node.js AMI
-------------------
1. Build an AMI with NodeJS installed. To do this, update the `variables` stanza in the `nodejs.json` file with your Atlas username, and then  run `packer push -create nodejs.json` in the Packer directory. This will send the build configuration to Atlas so it can build your NodeJS AMI remotely.
2. View the status of your build in the Builds tab of your [Atlas account](https://atlas.hashicorp.com/builds).
3. This creates an AMI with Node.js installed, and now you need to send the actual Node.js application code to Atlas and link it to the build configuration. To do this, simply update the Vagrantfile with your Atlas username, and then run `vagrant push` in the app directory. This will send your Node.js application, which is just the `server.js` file for now. Then link the Node.js application with the Node.js build configuration by clicking on your build configuration, then 'Links' in the left navigation. Complete the form with your username, 'nodejs' as the application name, and '/app' as the destination path.
4. Now that your application and build configuration are linked, simply rebuild the Node.js configuration and you will have a fully-baked AMI with Node.js installed and your application code in place.

Step 4: Deploy HAProxy, Node.js, and Consul
--------------------------
Now that all the AMIs are built, it's time to provision instances with Terraform. 
1. First, Atlas must be setup as a [remote state store](http://terraform.io/docs/state/remote.html) for Terraform. To do this, run:

`terraform remote config -backend-config="name=ATLAS_USERNAME/haproxy"`

2. Next, run `terraform get` to pull in the vpc module

3. Then, push the Terraform configuration to Atlas so Terraform can be run remotely. You need to pass in the required variables for the configuration (replace your Atlas username where necessary):

`terraform push -name="ATLAS_USERNAME/haproxy" -var "access_key=$AWSAccessKeyId" -var "secret_key=$AWSSecretKey" -var "atlas_username=ATLAS_USERNAME" -var "atlas_environment=haproxy" -var "atlas_user_token=$ATLAS_TOKEN" -var "key_name=AWS_SSH_KEY_NAME"`

4. Pushing the Terraform configuration will trigger a Terraform plan in Atlas. To view the plan, navigate to the [Environments tab in Atlas](https://atlas.hashicorp.com/environments) and click the environment name, then "Changes" in the left navigation. Click on the proposed change and review the Terraform plan output. If the changes look accurate, click "Confirm & Apply" to deploy infrastructure!

Final Step: Test HAProxy
------------------------
1. Navigate to your HAProxy stats page by going to it's Public IP on port 1936 and path /haproxy?stats. For example 52.1.212.85:1936/haproxy?stats
2. In a new tab, hit your HAProxy Public IP on port 8080 a few times. You'll see in the stats page that your requests are being balanced evenly between the Node.js instances. 
3. That's it! You just deployed HAProxy and Node.js
4. Navigate to the [Environments tab](https://atlas.hashicorp.com/runtime) in your Atlas account and click on the newly created infrastructure. You'll now see the real-time health of all your nodes and services!
