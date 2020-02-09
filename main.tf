provider "google" {
  project = "${var.project}"
  region  = "${var.region}"
  zone    = "${var.region_zone}"
}

resource "google_compute_network" "vpc_network" {
  
  name                    = "jenkins-network"
  auto_create_subnetworks = "true"
}


resource "google_compute_address" "test-static-ip-address" {
  name = "my-test-static-ip-address"
}

resource "google_compute_instance" "default" {
  
  name         = "jenkins"
  machine_type = "n1-standard-2"
  zone         = "us-central1-a"

  tags = ["kubernetes", "jenkins"]

connection {
    host = "${google_compute_address.test-static-ip-address.address}"
    type = "ssh"
    user = "deniz"
    private_key = "${file("~/.ssh/google_compute_engine")}"
  }

  boot_disk {
    
      initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  network_interface {
    network = "default"
    
access_config {
nat_ip = "${google_compute_address.test-static-ip-address.address}"

}
    }
  
provisioner "file" {
    source      = "/Users/deniz/terraform/ansible.yaml"
    destination = "/tmp/ansible.yaml"
  }

provisioner "file" {
    source      = "/Users/deniz/terraform/persistentv.yaml"
    destination = "/tmp/persistentv.yaml"
  }

provisioner "file" {
    source      = "/Users/deniz/terraform/deploy.yaml"
    destination = "/tmp/deploy.yaml"
  }

provisioner "file" {
    source      = "/Users/deniz/terraform/service.yaml"
    destination = "/tmp/service.yaml"
  }


 provisioner "remote-exec" {
      inline = [ "sudo yum update -y && sudo yum install ansible -y",
                 "sudo ansible-playbook /tmp/ans.yaml",
 
]

}

service_account {
    scopes = ["compute-ro", "storage-ro"]
  }

}

resource "google_compute_firewall" "jenkins" {
  name = "default-allow-http-jenkins"
  network = "jenkins-network"

allow {
protocol = "tcp"
ports = ["30007"]
}
source_ranges = ["0.0.0.0/0"]
target_tags = ["jenkins"]
}


