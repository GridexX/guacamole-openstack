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
