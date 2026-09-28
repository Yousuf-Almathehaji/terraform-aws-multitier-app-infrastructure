resource "aws_security_group" "webSG" {
  name = SGweb
  vpc_id = aws_vpc.app-vpc.id

}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.webSG.id
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.webSG.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.webSG.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}