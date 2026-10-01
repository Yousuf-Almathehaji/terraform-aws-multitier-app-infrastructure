resource "aws_security_group" "albSG" {
  name = "albSG"
  vpc_id = aws_vpc.app-vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.albSG.id
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.albSG.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  cidr_ipv4 = "0.0.0.0/0"
}
resource "aws_vpc_security_group_egress_rule" "access-web" {
  security_group_id = aws_security_group.albSG.id
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
  referenced_security_group_id = aws_security_group.webSG.id
}

resource "aws_security_group" "webSG" {
  name = "webSG"
  vpc_id = aws_vpc.app-vpc.id
}
resource "aws_vpc_security_group_ingress_rule" "web-http" {
  security_group_id = aws_security_group.webSG.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  referenced_security_group_id = aws_security_group.albSG.id

}

resource "aws_vpc_security_group_egress_rule" "ec2-update" {
  security_group_id = aws_security_group.webSG.id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}


resource "aws_security_group" "dbSG" {
  name = "dbSG"
  vpc_id = aws_vpc.app-vpc.id
}
resource "aws_vpc_security_group_ingress_rule" "db-access" {
  security_group_id = aws_security_group.webSG.id
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
  referenced_security_group_id = aws_security_group.webSG.id

}
resource "aws_vpc_security_group_egress_rule" "db-update" {
  security_group_id = aws_security_group.dbSG.id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}