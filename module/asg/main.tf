locals {
  user_data_template = <<-EOF
    #!/bin/bash
    set -xe
     CONFIG_FILE="/var/www/html/TMS/tms/includes/config.php"
    
    if [ -f "$CONFIG_FILE" ]; then
        echo "Config file exists." >> /var/log/user-data.log
        sed -i "s#define('DB_HOST',.*#define('DB_HOST', '%s');#" $CONFIG_FILE && echo "DB_HOST updated" >> /var/log/user-data.log
        sed -i "s#define('DB_USER',.*#define('DB_USER', '%s');#" $CONFIG_FILE && echo "DB_USER updated" >> /var/log/user-data.log
        sed -i "s#define('DB_PASS',.*#define('DB_PASS', '%s');#" $CONFIG_FILE && echo "DB_PASS updated" >> /var/log/user-data.log
        sed -i "s#define('DB_NAME',.*#define('DB_NAME', '%s');#" $CONFIG_FILE && echo "DB_NAME updated" >> /var/log/user-data.log
    else
        echo "Config file not found." >> /var/log/user-data.log
    fi
    
    cat $CONFIG_FILE >> /var/log/user-data.log
  EOF
}

resource "aws_launch_template" "template" {
  vpc_security_group_ids = var.lt_sg
  image_id               = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  iam_instance_profile {
    name = var.iam_instance_profile
  }
  user_data = base64encode(
    format(local.user_data_template, var.db_host, "admin", "tushar", "tms")
  )

  tags = {
    Name = "LaunchTemplateWithUserData"
  }
}

resource "aws_autoscaling_group" "asg" {
  name_prefix               = var.test_asg
  health_check_type         = "ELB"
  health_check_grace_period = 300
  target_group_arns         = var.target_group_arns
  launch_template {
    id = aws_launch_template.template.id
  }
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.vpc_zone_identifier
}

resource "aws_autoscaling_policy" "example" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  name                   = "asg-policy"
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 40
  }
}

