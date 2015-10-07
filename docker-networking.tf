provider "openstack" {

}

module "nodes" {
    source = "./nodes"

    servers = "${var.servers}"
    key_file = "${var.key_file}"
}