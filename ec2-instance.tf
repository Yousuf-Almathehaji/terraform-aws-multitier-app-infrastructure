resource "aws_instance" "web" {
  count = 2

  ami           = var.instance-ami
  instance_type = var.type-instance
  subnet_id     = local.prvnet-ids[count.index]

  root_block_device {
    encrypted = true
  }

  user_data = <<-EOF
    #!/bin/bash

    yum update -y
    yum install -y httpd

    systemctl enable --now httpd

    echo "This is server ${count.index + 1} in US-east-1" \
      > /var/www/html/index.html
  EOF

  tags = {
    Name      = "web-${count.index + 1}"
    terraform = "true"
  }
}

#  bin/bash
#       yum update -y
#       yum install httpd -y
#       systemctl start httpd
#       systemctl enable httpd
#       echo "this server${count.index} in US-east-1 .........." > var/www/html/index.html