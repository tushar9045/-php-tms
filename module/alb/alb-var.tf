variable "alb" {
    type = map(object({
       sg-id   =  list(string)
       subnet-id = list(string)

    }))
  
}

variable "vpc-id" {
    type = string
  
}
variable "arn" {
    type = string
  
}
 variable "tg" {
    type = map(object({
      port = number
      protcol = string
    }))
   
 }
  
  variable "tg-arn" {
     
  }
