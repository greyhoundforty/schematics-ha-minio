# schematics-ha-minio
Example repo for deploying a distributed minio cluster using IBM Schematics (terraform) **NOT CURRENTLY READY FOR PRIME TIME**

## Pre-requisites
 - SoftLayer username and API key. Instructions on generating an API key can be found [here](http://knowledgelayer.softlayer.com/procedure/generate-api-key).
 - A domain hosted with SoftLayer. If you use another DNS provider you will need to add the appropriate provider and variables to the `main.tf` file. 
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

## Configuring the terraform environment 
 
 With the pre-reqs taken care of we will now move on to configuring our terraform environment	

1. [Fork this repository](https://help.github.com/articles/fork-a-repo/)
2. Clone the repo to the machine you will be running terraform on 
3. Export your SoftLayer username and API key as Terraform variables (subsitituting your own for $VALUE)

```
export TF_VAR_slusername="$VALUE"
export TF_VAR_slapikey="$VALUE"
```

4. Update the `main.tf` file with your details:
	* Lines 25,26,42,82,112,143, and 174 - Update `YOURSSHKEYNAME` with the name of the SSHkey as it appears in the portal. 
	* 
