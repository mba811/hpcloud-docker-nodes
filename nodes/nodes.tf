resource "openstack_compute_secgroup_v2" "docker-networking" {
    name = "docker-networking"
    description = "Docker Networking"
    rule {
        from_port = 1
        to_port = 65535
        ip_protocol = "tcp"
        self = true
    }
    rule {
        from_port = 1
        to_port = 65535
        ip_protocol = "udp"
        self = true
    }
}

resource "openstack_networking_floatingip_v2" "dockerfip" {
  pool = "Ext-Net"
  count = "${var.servers}"
}

resource "openstack_compute_instance_v2" "docker" {
    name = "docker${count.index}"
    flavor_id = "102"
    image_id = "564be9dd-5a06-4a26-ba50-9453f972e483"
    key_pair = "als"
    security_groups = [ "default", "docker-networking" ]

	floating_ip = "${element(openstack_networking_floatingip_v2.dockerfip.*.address,count.index)}"
    count = "${var.servers}"

    connection {
        host = "${element(openstack_networking_floatingip_v2.dockerfip.*.address,count.index)}"
        user = "ubuntu"
        key_file = "${var.key_file}"
    }

    provisioner "remote-exec" {
        inline = [
        "sudo apt-get install -y wget",
        "wget -qO- https://get.docker.com/ | sh",
        "sudo usermod -aG docker ubuntu",
        # We have to reboot since this switches our kernel.
        "sudo reboot && sleep 10",
        ]
    }
}