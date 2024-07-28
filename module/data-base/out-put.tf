output "db-server-ip" {
     value = {for k, v in aws_instance.ec2-server:k =>v.private_ip}
}