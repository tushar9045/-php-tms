resource "aws_instance" "ec2-server" {
   for_each = var.ec2-server
   instance_type = var.instance_type
   ami = var.ami
   subnet_id = each.value["subnet_id"]
   key_name = var.key_name
   security_groups = each.value["security_groups"]
   iam_instance_profile = var.iam_instance_profile
   tags = {
    Name =  "p-${each.key}"
   }
}
