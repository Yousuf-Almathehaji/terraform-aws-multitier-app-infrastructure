resource "aws_db_instance" "mysql-db" {
  identifier = "mysql-database"
  engine = "mysql"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_encrypted = true
  storage_type = "gp3"

  db_name = "appdb"
  username = var.db-username
  password = var.db-password

  port = 3306
  vpc_security_group_ids = [aws_security_group.dbSG.id]
  db_subnet_group_name = aws_db_subnet_group.mysql.name

  multi_az = true
  
  publicly_accessible = false

  skip_final_snapshot = true

  tags = {
    Name = "mysql-multi-az"
  }
}

resource "aws_db_subnet_group" "mysql" {
  name = "mysql-private-subnet-group"

  subnet_ids = local.dbnet-ids

  tags = {
    Name      = "mysql-subnet-group"
  }
}