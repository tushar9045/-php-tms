terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = var.region
}

module "vpc-1" {
    source = "./module/vpc"
    cidr = var.vpc-cidr
    pub-sub = {
    pub-snet-1 = {
      a-z  = "ap-south-1a"
      cidr = var.pub-snet-1-cidr
    },
    pub-snet-2 = {
      a-z  = "ap-south-1b"
      cidr = var.pub-snet-2-cidr
    }
  }
  pvt-sub = {
    # pvt-snet-1 = {
    #   a-z  = "ap-south-1a"
    #   cidr = var.pvt-snet-1-cidr

    # },
    pvt-snet-2 = {
      a-z  = "ap-south-1b"
      cidr = var.pvt-snet-2-cidr
    }
    pvt-snet-3 ={
      a-z = "ap-south-1a"
      cidr = var.pvt-snet-1-cidr
    }
  }
  nat-gw = {
    net-1 = {
      allocation_id  = lookup(module.vpc-1.eip-id,"eip1", null )
      subnet_id = lookup(module.vpc-1.subnet-id,"pub-snet-1", null )
    },
    # net-2 = {
    #  allocation_id = lookup(module.vpc-1.eip-id,"eip2", null )
    #  subnet_id =  lookup(module.vpc-1.subnet-id,"pub-snet-2", null )            
    # }
  }
  eip = {
    eip1={

    }

    
    # eip2={

    # }
  }
  pvt-rt = {
    pvt-rt-1 ={
      gateway_id = lookup(module.vpc-1.nat-id, "net-1", null)
    }
    # pvt-rt-2 ={
    #   gateway_id = lookup(module.vpc-1.nat-id, "net-2", null)
    # }
  }
  pvt-rt-association = {
    association-1 ={
      route_table_id = lookup(module.vpc-1.rt-id,"pvt-rt-1",null)
      subnet_id = lookup(module.vpc-1.pvt-sub-id, "pvt-snet-2", null)

    }
    #  association-2 ={
    #   route_table_id = lookup(module.vpc-1.rt-id,"pvt-rt-2",null)
    #   subnet_id = lookup(module.vpc-1.pvt-sub-id, "pvt-snet-2", null)

    # }
  }
  
  }

  
  
  



module "sg" {
  source = "./module/sg"
  v-id = module.vpc-1.vpc-id
  sg-details = {
    "lb-sg" = {
    
      name   = "lb-sg"
      ingress_rules = [
        
        {
          from_port       = 80
          to_port         = 80
          protocol        = "tcp"
          cidr_blocks     = ["0.0.0.0/0"]
          security_groups = null
        }
      ]
    }
  }

    }
  
  module "sg-2" {
    source = "./module/sg"
      v-id = module.vpc-1.vpc-id

    sg-details = {
  
    "web-sg" = {
      
      name   = "web-sg"
      ingress_rules = [
        
        {
          from_port       = 80
          to_port         = 80
          protocol        = "tcp"
          cidr_blocks     = null
          security_groups = [lookup(module.sg.sg-id , "lb-sg", null)]
        }
      ]
    }
    
  }
  }


module "sg-3" {
  source = "./module/sg"
  v-id = module.vpc-1.vpc-id
    sg-details = {
      "rds-sg"= {
     
      name   = "rds-sg"
      ingress_rules = [
        {
          cidr_blocks     = null
          from_port       = 3306
          protocol        = "tcp"
          to_port         = 3306
          security_groups = [lookup(module.sg-2.sg-id ,"web-sg", null) ]
 }

      ]
}
  
}
}




module "alb" {
  source = "./module/alb"
  alb = {
    "alb-1" = {
      sg-id     = [lookup(module.sg.sg-id, "lb-sg", null)]
      subnet-id = [lookup(module.vpc-1.subnet-id, "pub-snet-1", null), lookup(module.vpc-1.subnet-id, "pub-snet-2", null)]
    }

  }
  vpc-id = module.vpc-1.vpc-id 
  arn =  lookup(module.alb.alb-arn, "alb-1", null)
  tg =  {
    "tg-1" = {
      port = 80
      protcol = "HTTP"
    }
  }
  tg-arn = lookup(module.alb.arn-tg, "tg-1", null)
  
}
module "data-base" {
  source = "./module/data-base"
  key_name = var.key_name
  instance_type = "t2.micro"
  ami = var.db-server-ami
  iam_instance_profile = module.role.role-name
  ec2-server = {
   "db-server" = {
     subnet_id = lookup(module.vpc-1.pvt-sub-id, "pvt-snet-3", null)
     security_groups = [lookup(module.sg-3.sg-id, "rds-sg", null)]
    
   }
 }
}

module "asg" {
  source = "./module/asg"
  ami = var.asg-ami
  instance_type = var.instance_type
  db_host = lookup(module.data-base.db-server-ip, "db-server", null)
  iam_instance_profile = module.role.role-name
  key_name = var.key_name
  lt_sg = [lookup(module.sg-2.sg-id, "web-sg", null)]
  

 

asg-zones = ["ap-south-1a", "ap-south-1b"]
desired_capacity = var.desired_capacity
max_size = 2
min_size = 1

test_asg = "asg-3-tier"
vpc_zone_identifier = [ lookup(module.vpc-1.pvt-sub-id, "pvt-snet-2" , null)]
  target_group_arns = [lookup(module.alb.arn-tg, "tg-1", null)]
}



output "lb-dns" {
value = lookup(module.alb.lb-dns, "alb-1", null).dns_name
  
}

module "role" {
  source = "./module/role"
  
}

output "db-ip" {
  value = lookup(module.data-base.db-server-ip, "db-server", null)
  
}
