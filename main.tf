terraform {
  required_providers {
    # This is the current syntax, which is still supported
    # This is the new syntax. "source" and "version" are both
    # optional, though in the future "source" will be required for
    # any provider that isn't maintained by HashiCorp.
    vscale = {
      source  = "vscale.com/edu/vscale"
      version = ">= 0.1"
    }
  }
}

provider "vscale" {
  token = var.do_token
}
# data sourse не поддерживает
#data "vscale_ssh_key" "rebrain_ssh_key" {
#name = "REBRAIN.SSH.PUB.KEY"
#key  = "ssh-rsa "
#}

# Add my ssh key
resource "vscale_ssh_key" "my_ssh" {
  key  = var.my_ssh
  name = "my_ssh"
}
# Не поддерживает передачу tags
#resource "vscale_tags" {
#name  = "devops"
#email = "oxlamons_at_gmail_com"
#}

#resource "vscale_tag" "my_email" {
#name = "oxlamons_at_gmail_com"
#}
# Create a new provider-vscale using the SSH key
resource "vscale_scalet" "test" {
  name      = var.devs[count.index]
  count     = length(var.devs)
  make_from = var.vscale_centos_7
  rplan     = "small"
  location  = "spb0"
  ssh_keys  = [vscale_ssh_key.my_ssh.id]
  #vscale_ssh_key.rebrain_ssh_key.id]
  #tags = [vscale_tags.devops.name, vscale_tag.my_email.name]
  connection {
    type = "ssh"
    user = "root"
  }
}
output "Name" {
  value = "${vscale_scalet.test.*.name}"
}
# не возвращает IP
output "public_address" {
  value = "${vscale_scalet.test.*.public_address}"
}
