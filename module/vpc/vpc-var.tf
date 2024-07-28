variable "cidr" {
    type = string
  
}
 variable "pub-sub" {
    type = map(object({
       a-z = string
       cidr = string

    }))
  
}

variable "pvt-sub" {
    type = map(object({
       a-z = string
       cidr = string
    }))
  
}
variable "nat-gw" {
  type = map(object({
      allocation_id = string
       subnet_id = string
    }))
}
  

 variable "eip" {
  type = map(object({
  }))
   
 }
 variable "pvt-rt" {
  type = map(object({
    gateway_id = string
    
  }))
   
 }
 variable "pvt-rt-association" {
  type = map(object({
    route_table_id = string
    subnet_id = string
  }))
   
 }

