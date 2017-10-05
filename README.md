# schematics-ha-minio
**NOT CURRENTLY READY FOR PRIME TIME**
Example repo for deploying a distributed minio cluster using IBM Schematics (terraform) 

## Prerequisites
 - SoftLayer username and API key. Instructions on generating an API key can be found [here](http://knowledgelayer.softlayer.com/procedure/generate-api-key).
 - SSH key from the server you will be running the commands from [added to the SoftLayer customer portal](http://knowledgelayer.softlayer.com/procedure/add-ssh-key).
 - Terraform (ver 0.9.8) installed. Newer versions will work, but you may get warnings when running `terraform plan` or `terraform apply`. I am running terraform on a Linux server so the commands for me are:

 	```
 	$ wget https://releases.hashicorp.com/terraform/0.9.8/terraform_0.9.8_linux_amd64.zip
 	$ unzip terraform_0.9.8_linux_amd64.zip
 	$ mv terraform /usr/local/bin/terraform
 	```

 - IBM Cloud Provider for Terraform installed. 

 	```
 	$ wget https://github.com/IBM-Bluemix/terraform-provider-ibm/releases/download/v0.4.0/terraform-provider-ibm_linux_amd64.zip
 	$ unzip terraform-provider-ibm_linux_amd64.zip
 	$ mv terraform-provider-ibm /usr/local/bin/terraform-provider-ibm
 	```

 - Create a `.terraformrc` file that points to the Terraform binary. Since we moved the binary to /usr/local/bin/terraform-provider-ibm the `.terraformrc` file will look like this:

 	```
 	providers {
		ibm = "/usr/local/bin/terraform-provider-ibm"
	}
 	```

### Optional
 - A domain hosted with SoftLayer. If you done have a domain hosted with SoftLayer you can use the `nodns.main.tf` file in place of the `main.tf`. You will be prompted about this when you run the configuration script. 

## Configuring the terraform environment 
 
 With the pre-reqs taken care of we will now move on to configuring our terraform environment	

1. [Fork this repository](https://help.github.com/articles/fork-a-repo/)
2. Clone the repo to the machine you will be running terraform on 
3. cd in to the `schematics-ha-minio` directory
4. Run `configure.sh`
5. Answer all the questions 

