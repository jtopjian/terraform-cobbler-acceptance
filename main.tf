resource "openstack_compute_keypair_v2" "cobbler" {
  name = "cobbler"
  public_key = "${file("key/id_rsa.pub")}"
}

resource "openstack_compute_instance_v2" "cobbler" {
  name = "cobbler"
  image_name = "Ubuntu 14.04"
  flavor_name = "m1.small"
  key_pair = "${openstack_compute_keypair_v2.cobbler.name}"
  security_groups = ["default"]
  user_data = "#cloud-config\ndisable_root: false"

  connection {
    user = "ubuntu"
    key_file = "key/id_rsa"
    host = "${openstack_compute_instance_v2.cobbler.access_ip_v6}"
  }

  provisioner file {
    source = "files"
    destination = "/home/ubuntu/files"
  }

  provisioner "remote-exec" {
    inline = [
      "bash /home/ubuntu/files/deploy.sh",
    ]
  }
}
