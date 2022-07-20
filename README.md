### GDP Infra Test Assignment
Disclaimer: As my laptop is in the shop for repair I had to use a low ram environment. I tried my best, to create a lab to showcase my automation skills as I was experimenting with the solution, but I run out of RAM most times. Helm/Cassandra are the first time I used and such there was a lot of trial and failure, so I eventually created a terraform environment for experimenting with k8s/helm/cassandra at will. I didn't manage to complete the 1st task but I think I was on the right track.

## What is included in this repo
- A Virtualbox environment with a ready made k3d server, loaded with jupyter so I could save the output and experiment. 
Requirements: Virtualbox+Vbox_extensions+vagrant installed on an amd64 capable machine.
- A Terraform environment for Azure that is meant for use with acloudguru sandboxes. It requires only terraform 1.2.5 and a file (which is gitgnored) with the random generated resource_group name. You can of course use your own azure subscription but you need to create the resource group beforehand.


## Folder Structure/ Repo Map/Prethoughts
- Configuration Management is done via masterless saltstack. Recipes can be found at infra/salt/base/stack. Such as installation of docker/helm e.t.c was done through it.
- Terraform environments for the exercices and this lab are in terraform/envs
- Some security considerations were discarded for convience as the cloud playground is deleted every few hours
- I have also included a small snippet for terraform cdk, because for really complex landing zones and layers I like to use the python language for more power



### Virtualbox environment
- After installing the requirements. CD into the repo and run `vagrant up k3d` It will bootstrap a k3d ready server for you to experiment with a notebook.
- Navigate to 127.0.0.1:8888, password is vagrant for this environment.


### Terraform environments
- Simply run `terraform init && terraform apply` inside the 3 folders. `envs/exercise2.1`, `envs/exercise2.2`, `envs/k8splay` 
- On k8splay the outputs are the public ip and the password you need to connect to it.
- The rest are pretty easy. I uploaded the state files (although they are in the .ignore) for you to check.


