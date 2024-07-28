 output "sg-id" {
    value = {for k , v in aws_security_group.my-sg: k => v.id}
   
 }