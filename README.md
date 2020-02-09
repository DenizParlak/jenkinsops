# Jenkins deployment with Terraform - Docker - Kubernetes - Ansible on Google Cloud Platform

This project deploys Jenkins using different applications in the SysOps ecosystem.

# Requirements

- The user have to prepare their own SSH key.
- Google Cloud Platform authentication must be defined to use the APIs.
- Terraform must be installed in the local machine.

# How does it work?

Terraform will create a GCE with these specifications:

- n1-standard-2 machine type for minimum kubernetes cluster requirements.
- OS: CentOS 7
- Static IP address
- Region: us-central1 / Zone: us-central1-a
- Firewall rule for port access.

After that, Terraform will trigger the Ansible playbook in the GCE instance. This playbook contains all tasks to setup the Kubernetes cluster via kubeadm with Docker.

Kubernetes section separated as three component:

- Persistent Volume / Persistent Volume Claim
- Jenkins deployment
- Jenkins service


You can change all directives in the main.tf, ansible.yaml file as you want.

### Note: All .yaml files must be represented in the same directory unless specify the directory paths in related files.

Just type:

```terraform apply```

All tasks may take ~5 minutes.

Finally, you can access Jenkins installation page through http://GCE_IP:30007

It's not just for Jenkins, you can also use your own web service with the same configurations.

<img src="https://github.com/DenizParlak/jenkinsops/blob/master/jen1.png" width="700">
<img src="https://github.com/DenizParlak/jenkinsops/blob/master/jen2.png" width="700">

<img src="https://github.com/DenizParlak/jenkinsops/blob/master/jen3.png" width="700">
