## Creating a Hello World Flask App in Docker hosted on AWS EC2 Instance in CentOS 7

### Motivation 
Setting up Docker with AWS seems like a useful thing to know how to do. Therefore, these are some notes detailing the steps I took to set up a very simple "Hello, World" Flask App running in Docker and hosted on an Amazon EC2 CentOS 7 instance. I can refer back to these notes later if I need to set this up again.

### General EC2 Terminology & Notes
* EC2 Stands for “Elastic Compute Cloud”
* Provides scalable computing capacity
* Launches virtual servers
* Instances are virtual computing environments
* AMI is an Amazon Machine Image
  * Comes with preconfigured instances 
  * Includes OS / other software
* Instance Store Volumes are temporary storage
* Amazon EBS Volumes are persistent storage
* IAM is Identity and Access Management. Allows you to access instances securely.

## Walkthrough for setting up AWS with Docker and Flask

### Part 1: Setting up AWS 
* Created a new AWS account
* Created a new user called Administrator
* Set Permissions for group
  * Create a group to set the permissions policies of that group
  * Name group Administrators → Select AdministratorAccess
  * Administrator user will be added to this group
* Logout of your AWS account and login as the administrator account we just created using the account number: 
  * Account Number is found in support section in upper right corner
  * Login page: https://ACCOUNT_NUMBER.signin.aws.amazon.com/console/
  * Username: Administrator, Password: what we just set
* Create a key pair to login to instance securely
  * Go to Networks & Security → Key Pairs → Create Key Pair → Enter a key pair name
  * KEY_PAIR_NAME.pem is downloaded
  * Go to where KEY_PAIR_NAME.pem was downloaded and set permissions on the file with `chmod 400 KEY_PAIR_NAME.pem`
    * Notes on chmod: sets (READ/WRITE/EXECUTE) for USER/GROUP/OTHERS. If we have 400 we split it into 3 digits: 4, 0, 0
      * 4 is 100 in binary, so it would be read only for current user
      * 0 is 000 in binary, so group would not be able to read/write/execute on the file
      * 0 is 000 in binary, so group would not be able to read/write/execute on the file
* To connect to instance:
  * Use SSH with -i “path/to/KEY_PAIR_NAME.pem”
* Create an instance
  * Go to AWS Console and click on Launch Instance → Click on AWS Marketplace on Left → Search CentOS and select `CentOS 7 (x86_64) - with Updates HVM`
  * Review & Launch
  * Launch Micro t2 instance
* Allow inbound HTTP requests [(official guide here)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/authorizing-access-to-an-instance.html)
  * Go to AWS console → On lefthand nav under Networks & Security choose Security Groups → Inbound → Edit, then add following:
  ![](https://i.imgur.com/WYEN75N.png)
* Logging into the instance
  * For Centos AMI, the user name is centos
  * Login with `ssh -i KEY_PAIR_NAME.pem centos@PUBLIC_DNS_IPV4_ADDRESS`
  * We can find the PUBLIC_DNS_IPV4_ADDRESS by going to the [EC2 console](https://us-east-2.console.aws.amazon.com/ec2/v2/home?region=us-east-2) → Instances → Public DNS IPv4
  

### Part 2: Setting Up the Instance & Docker On CentOS 7 AMI
* After we SSH into the instance, we can begin git setup:
  * Install git: `sudo yum install git`
  * Set up github keys: 
    * Generate the key: `ssh-keygen -t rsa -b 4096 -C "EMAIL_NAME@SOME_EMAIL_DOMAIN.COM"`
    * Start ssh agent in background: eval "$(ssh-agent -s)"
    * Add password to the ssh agent: ssh-add ~/.ssh/id_rsa
    * Add private key to github account
      * `cat ~/.ssh/id_rsa.pub` → Copy this and go to [github keys settings](https://github.com/settings/keys) and paste it there
* Install software collections:`sudo yum install centos-release-scl`
* Install docker: use official documentation available [here](https://docs.docker.com/install/linux/docker-ce/centos/)
* Install docker-compose
  * `sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`
  * `sudo chmod +x /usr/local/bin/docker-compose`
* Start the docker daemon with: `sudo systemctl start docker`

### Finishing up
* At this point, we should be ready to write the hello-world flask app, add the `Dockerfile` and `docker-compose.yml`, and add them to a github repo
* Then, we simply SSH into the instance and `git clone repo_clone_address` 
* Finally, we can use `docker-compose up -d --build` to run the docker image in detached mode
* If everything went well, we can visit the AWS Console → Instances → Select the instance → IPv4 Public IP → Copy that IP into the address bar of your browser to view the hello world message

### Troubleshooting
* `ERROR: Couldn't connect to Docker daemon at http+docker://localhost - is it running?`
  * Solved this error by confirming that docker was running with `sudo systemctl status docker` and then restarting my AMI.
