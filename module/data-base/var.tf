variable "key_name" {
    type = string
  
}
variable "ami" {
    type = string
  
}
variable "ec2-server" {
    type = map(object({
      subnet_id = string
      security_groups = list(string)
    }))
  
}
variable "instance_type" {
  
  type = string
}
variable "iam_instance_profile" {
  
}