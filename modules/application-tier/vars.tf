variable "vpc_id" {
  description = "The VPC ID in AWS"
}

variable "name" {
  description = "Name to be used for the Tags"
}

variable "route_table_id" {
  description = "The ID of the route table to be associated with the subnet"
}

variable "cidr_block" {
  description = "Representing an IP address and its network mask"
}

variable "user_data" {
  description = "Script or data that can configure the instances"
}

variable "ami_id" {
  description = "ID that is used to launch the instances"
}

variable "map_public_ip_on_launch" {
  default = false
  
}

variable "ingress" {
  description = "Providing the public IP on launch of the module"
  type = list
}