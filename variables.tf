variable "key_file" {
    description = "Private key file for connecting to new host"
}

variable "servers" {
    default = "2"
    description = "The number of servers to launch."
}
