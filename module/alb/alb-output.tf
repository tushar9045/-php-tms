output "alb-arn" {
    value = {for k, v in aws_lb.test:k =>v.arn}
  
}

output "arn-tg" {
    value = {for k, v in aws_lb_target_group.tg:k =>v.arn}
     
}
output "alb-id" {
    value = {for k, v in aws_lb.test:k => v.id}

  
}
output "lb-dns" {
    value = {for k, v in aws_lb.test:k => v}
  
}