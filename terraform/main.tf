resource "openstack_compute_instance_v2" "instance" {
  name            = "guacamole-test"
  image_name      = var.image_name
  flavor_name     = var.flavor_name
  key_pair        = var.ssh_key_name
  security_groups = var.security_groups
  user_data = file("./instance-init.sh")

  network {
    uuid = openstack_networking_network_v2.private_net.id
  }

  connection {
    type = "ssh"
    user = "debian"
    host = openstack_networking_floatingip_v2.floating_ip.address
  }

  provisioner "file" {
    destination      = "/tmp/keycloak-init.sh"
    content = templatefile(
      "${path.module}/keycloak-init.tftpl",
      { 
        "kc_hostname": var.keycloak_hostname,
        "guacamole_hostname" : var.guacamole_hostname,
      }
    )
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/keycloak-init.sh",
      "/tmp/keycloak-init.sh",
    ]
  }
}

resource "openstack_networking_floatingip_v2" "floating_ip" {
  pool = var.public_network_name
}

resource "openstack_compute_floatingip_associate_v2" "floating_ip_association" {
  floating_ip = openstack_networking_floatingip_v2.floating_ip.address
  instance_id = openstack_compute_instance_v2.instance.id
}

// Print the Floating IP after the creation
output "instance_fip_address" {
  value = openstack_networking_floatingip_v2.floating_ip.address
}
