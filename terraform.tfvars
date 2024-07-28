region = "ap-south-1"
vpc-cidr = "10.0.0.0/16"
pub-snet-1-cidr = "10.0.0.0/19"
pub-snet-2-cidr = "10.0.32.0/20"
pvt-snet-1-cidr = "10.0.48.0/20"
pvt-snet-2-cidr = "10.0.64.0/18"
pvt-snet-3-cidr = "10.0.128.0/18"


instance_type = "t2.micro"
key_name = "clims-mumbai-key"


###------asg----####
desired_capacity = 1
asg-ami = "ami-01483f5a92825f326"




db-server-ami = "ami-0693150b8c3e6e140"