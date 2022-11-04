#Create RDS Instance

resource "aws_db_instance" "mysqldb" {
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.dbsubnet.id
  engine                 = "mysql"
  engine_version         = "8.0.20"
  instance_class         = "db.t2.micro"
  multi_az               = true
  db_name                = "mydb"
  username               = "username"
  password               = "password"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]
}

resource "aws_db_subnet_group" "dbsubnet" {
  name       = "main"
  subnet_ids = [aws_subnet.database-subnet-1.id, aws_subnet.database-subnet-2.id]

  tags = {
    Name = "My DB subnet group"
  }
}