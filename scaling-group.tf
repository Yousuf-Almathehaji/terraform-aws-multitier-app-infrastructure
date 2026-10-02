resource "aws_launch_template" "server-details" {
  name_prefix = "server-"
  image_id = var.instance-ami
  instance_type = var.type-instance
  vpc_security_group_ids = [ aws_security_group.webSG.id ]
  user_data = base64encode(<<-EOF
#!/bin/bash

yum update -y
yum install -y httpd

systemctl enable --now httpd

echo "Hello from Auto Scaling .......!" > /var/www/html/index.html
EOF
)
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      encrypted = true
      volume_size = 8
      volume_type = "gp3"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-asg"
    }
  }
}


resource "aws_autoscaling_group" "bar" {
  name                      = "web-asg"
  max_size                  = 5
  min_size                  = 2
  desired_capacity          = 2
  vpc_zone_identifier       = local.prvnet-ids
  health_check_type = "ELB"
  target_group_arns = [ aws_lb_target_group.webtarget.arn ]

  launch_template {
    id = aws_launch_template.server-details.id
    version = "$Latest"
  }
  
  tag {
    key                 = "Name"
    value               = "web-asg"
    propagate_at_launch = true
  }
  depends_on = [ aws_nat_gateway.natgateway ]
}


