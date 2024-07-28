variable "ami" {
  
}
variable "instance_type" {
  
}
variable "key_name" {
  
}
variable "desired_capacity" {
  
}
variable "max_size" {
  
}
variable "min_size" {
  
}
variable "asg-zones" {
  type = list(string)
}

variable "lt_sg" {
    type = list(string)
  
}
variable "test_asg" {

  
}
variable "vpc_zone_identifier" {
    type = list(string)

  
}
variable "target_group_arns" {
  
  type = list(string)
}
variable "iam_instance_profile" {
  
}
variable "db_host" {
  
}
