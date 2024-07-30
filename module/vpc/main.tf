resource "aws_vpc" "vpc-1" {
    cidr_block = var.cidr  
    
}

resource "aws_subnet" "public-sub" {
    for_each = var.pub-sub
    
    vpc_id = aws_vpc.vpc-1.id 
    availability_zone = each.value["a-z"]
    cidr_block =  each.value["cidr"]
    map_public_ip_on_launch = true
    tags = {
     Name = "sub-${each.key}"
}
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.vpc-1.id
  
}
resource "aws_route_table" "pub-rt" {
    vpc_id = aws_vpc.vpc-1.id
    route  {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.myigw.id
    }
    tags = {
      Name = "public-route-1"
    } 
}
resource "aws_route_table_association" "pubrt-pubsub" {
     for_each = aws_subnet.public-sub
     subnet_id = each.value.id
     route_table_id = aws_route_table.pub-rt.id
   }

resource "aws_subnet" "pvt-sub" {
 for_each = var.pvt-sub
 
 availability_zone = each.value["a-z"]
 cidr_block = each.value["cidr"]
 vpc_id = aws_vpc.vpc-1.id
  map_public_ip_on_launch = false
  tags = {
    Name =  "p-${each.key}"
  }
} 

resource "aws_eip" "name" { 
  # count = length(aws_subnet.pvt-sub)
  for_each = var.eip
  
  
 }



 resource "aws_nat_gateway" "nat" {
  for_each = var.nat-gw
  #allocation_id = each.value["allocation_id"]
  allocation_id = each.value["allocation_id"]
  subnet_id  =  each.value["subnet_id"]
   depends_on = [  
   aws_eip.name
  ]
}


 resource "aws_route_table" "pvt-rt" {
 # count = length(aws_nat_gateway.nat)
 
 for_each = var.pvt-rt
  vpc_id = aws_vpc.vpc-1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = each.value["gateway_id"]
  }
  tags = {
  Name = "n-${each.key}"
}

 }
 
      
    
    
    
    
resource "aws_route_table_association" "pvt-rt-assot" {
    for_each = var.pvt-rt-association
    route_table_id = each.value["route_table_id"]
    subnet_id = each.value["subnet_id"]
}

