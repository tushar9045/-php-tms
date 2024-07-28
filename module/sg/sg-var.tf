variable "sg-details" {
  type = map(object({
    name = string
    ingress_rules = list(object({
      from_port = number 
      to_port  = number
      protocol = string
      cidr_blocks = list(string)
      security_groups = list(string)
    }))
  }))
}
variable "v-id" {
  
}