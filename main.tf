##############################################################################
# Variables
##############################################################################
# Required for the IBM Cloud provider for Bluemix resources
variable bxapikey {}
variable slusername {}
variable slapikey {}

##############################################################################
# Configures the IBM Cloud provider
# https://ibm-bluemix.github.io/tf-ibm-docs/
##############################################################################
provider "ibm" {
  bluemix_api_key    = "${var.bxapikey}"
  softlayer_username = "${var.slusername}"
  softlayer_api_key  = "${var.slapikey}"
}

#############################################################################
# Require terraform 0.9.3 or greater to run this template
# https://www.terraform.io/docs/configuration/terraform.html
#############################################################################
terraform {
  required_version = ">= 0.9.3"
}

data "ibm_compute_ssh_key" "YOURSSHKEYNAME" {
    label = "YOURSSHKEYNAME"
}


resource "ibm_compute_vm_instance" "minio" {
    hostname = "minio"
    domain = "example.com"
    os_reference_code = "UBUNTU_LATEST_64"
    datacenter = "wdc07"
    network_speed = 1000
    hourly_billing = true
    private_network_only = false
    cores = 2
    memory = 4096
    disks = [100]
    local_disk = false
    ssh_key_ids = ["${data.ibm_compute_ssh_key.YOURSSHKEYNAME.id}"]
    provisioner "file" {
    source      = "$HOME/.softlayer"
    destination = "/root/.softlayer"
    }
    provisioner "file" {
    source      = "hapostinstall.sh"
    destination = "/tmp/hapostinstall.sh"
    }
    provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/hapostinstall.sh",
      "/tmp/hapostinstall.sh",
    ]
    }
    provisioner "file" {
    source      = "haproxy.cfg"
    destination = "/etc/haproxy/haproxy.cfg"
    }
    provisioner "remote-exec" {
      inline = [
            "sleep 120",
            "shutdown -r now",
    ]
}
}

resource "ibm_compute_vm_instance" "s1" {
    hostname = "s1"
    domain = "example.com"
    os_reference_code = "UBUNTU_LATEST_64"
    datacenter = "wdc07"
    network_speed = 1000
    hourly_billing = true
    private_network_only = false
    cores = 2
    memory = 4096
    disks = [100, 2000, 2000, 2000, 2000]
    local_disk = false
    user_metadata = "{\"MINIO_ACCESS_KEY=YOURSUPERAWESOMEACCESSKEY\" : \"MINIO_SECRET_KEY=YOURSUPERAWESOMESECRETKEY\"}"
    ssh_key_ids = ["${data.ibm_compute_ssh_key.YOURSSHKEYNAME.id}"]
    provisioner "file" {
    source      = "$HOME/.softlayer"
    destination = "/root/.softlayer"
}
    provisioner "file" {
    source      = "postinstall.sh"
    destination = "/tmp/postinstall.sh"
    }
    provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/postinstall.sh",
      "/tmp/postinstall.sh",
    ]
  }
}

resource "ibm_compute_vm_instance" "s2" {
    hostname = "s2"
    domain = "example.com"
    os_reference_code = "UBUNTU_LATEST_64"
    datacenter = "wdc07"
    network_speed = 1000
    hourly_billing = true
    private_network_only = false
    cores = 2
    memory = 4096
    disks = [100, 2000, 2000, 2000, 2000]
    local_disk = false
    user_metadata = "{\"MINIO_ACCESS_KEY=YOURSUPERAWESOMEACCESSKEY\" : \"MINIO_SECRET_KEY=YOURSUPERAWESOMESECRETKEY\"}"
    ssh_key_ids = ["${data.ibm_compute_ssh_key.YOURSSHKEYNAME.id}"]
    provisioner "file" {
    source      = "$HOME/.softlayer"
    destination = "/root/.softlayer"
}
    provisioner "file" {
    source      = "postinstall.sh"
    destination = "/tmp/postinstall.sh"
    }
    provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/postinstall.sh",
      "/tmp/postinstall.sh",
    ]
  }
}


resource "ibm_compute_vm_instance" "s3" {
    hostname = "s3"
    domain = "example.com"
    os_reference_code = "UBUNTU_LATEST_64"
    datacenter = "wdc07"
    network_speed = 1000
    hourly_billing = true
    private_network_only = false
    cores = 2
    memory = 4096
    disks = [100, 2000, 2000, 2000, 2000]
    local_disk = false
    user_metadata = "{\"MINIO_ACCESS_KEY=YOURSUPERAWESOMEACCESSKEY\" : \"MINIO_SECRET_KEY=YOURSUPERAWESOMESECRETKEY\"}"
    ssh_key_ids = ["${data.ibm_compute_ssh_key.YOURSSHKEYNAME.id}"]
    provisioner "file" {
    source      = "$HOME/.softlayer"
    destination = "/root/.softlayer"
}
    provisioner "file" {
    source      = "postinstall.sh"
    destination = "/tmp/postinstall.sh"
    }
    provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/postinstall.sh",
      "/tmp/postinstall.sh",
    ]
  }
}


resource "ibm_compute_vm_instance" "s4" {
    hostname = "s4"
    domain = "example.com"
    os_reference_code = "UBUNTU_LATEST_64"
    datacenter = "wdc07"
    network_speed = 1000
    hourly_billing = true
    private_network_only = false
    cores = 2
    memory = 4096
    disks = [100, 2000, 2000, 2000, 2000]
    local_disk = false
    user_metadata = "{\"MINIO_ACCESS_KEY=YOURSUPERAWESOMEACCESSKEY\" : \"MINIO_SECRET_KEY=YOURSUPERAWESOMESECRETKEY\"}"
    ssh_key_ids = ["${data.ibm_compute_ssh_key.YOURSSHKEYNAME.id}"]
    provisioner "file" {
    source      = "$HOME/.softlayer"
    destination = "/root/.softlayer"
    }
    provisioner "file" {
    source      = "postinstall.sh"
    destination = "/tmp/postinstall.sh"
    }
    provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/postinstall.sh",
      "/tmp/postinstall.sh",
    ]
  }
}


##############################################################################
# Creating the DNS entries
# https://ibm-bluemix.github.io/tf-ibm-docs/v0.4.0/r/dns_record.html
##############################################################################

# Load the domain as `domain_id` to be used when creating the DNS records
data "ibm_dns_domain" "domain_id" {
    name = "example.com"
}


resource "ibm_dns_record" "minio" {
    data = "${ibm_compute_vm_instance.minio.ipv4_address}"
    domain_id = "${data.ibm_dns_domain.domain_id.id}"
    host = "minio"
    responsible_person = "user@example.com"
    ttl = 900
    type = "a"
}

resource "ibm_dns_record" "s1" {
    data = "${ibm_compute_vm_instance.s1.ipv4_address_private}"
    domain_id = "${data.ibm_dns_domain.domain_id.id}"
    host = "s1"
    responsible_person = "user@example.com"
    ttl = 900
    type = "a"
}


resource "ibm_dns_record" "s2" {
    data = "${ibm_compute_vm_instance.s2.ipv4_address_private}"
    domain_id = "${data.ibm_dns_domain.domain_id.id}"
    host = "s2"
    responsible_person = "user@example.com"
    ttl = 900
    type = "a"
}

resource "ibm_dns_record" "s3" {
    data = "${ibm_compute_vm_instance.s3.ipv4_address_private}"
    domain_id = "${data.ibm_dns_domain.domain_id.id}"
    host = "s3"
    responsible_person = "user@example.com"
    ttl = 900
    type = "a"
}

resource "ibm_dns_record" "s4" {
    data = "${ibm_compute_vm_instance.s4.ipv4_address_private}"
    domain_id = "${data.ibm_dns_domain.domain_id.id}"
    host = "s4"
    responsible_person = "user@example.com"
    ttl = 900
    type = "a"
}

