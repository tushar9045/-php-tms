output "subnet-id" {
    value = {for k, v in aws_subnet.public-sub: k => v.id}
   
 }
 
 output "vpc-id" {
  value = aws_vpc.vpc-1.id
   
 }
 output "pvt-sub-id" {
   value = {for k, v in aws_subnet.pvt-sub: k =>v.id}
   
 }
 output "eip-id" {
   value =  {for k, v in aws_eip.name: k =>v.id}

 }
 output "nat-id" {
   value =  {for k, v in aws_nat_gateway.nat: k =>v.id}

   
 }
 output "rt-id" {
   value =  {for k, v in aws_route_table.pvt-rt: k =>v.id}

   
 }