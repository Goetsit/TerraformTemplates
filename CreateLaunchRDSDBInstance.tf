
# Cloud provider configuration

provider "aws" {
    region = "us-east-1"
    profile = "Enter Profile"
}


# If default VPC (virtual private cloud) does not exist, create

resource "aws_default_vpc" "default_vpc" {
   
    tags = {
        Name = "deafult vpc"
    }
}

# Get all AZ in region where we want to launch rds instace (us east 1 in this case)

data "aws_availability_zones" "availability_zones" {}

# If default subnet does not exist, create in az at index 0
resource "aws_default_subnet" "aws_subnet_az1" {
    availability_zone = data.aws_availability_zones.availability_zones.names[0]
}

# If default subnet does not exist, create in az at index 1
resource "aws_default_subnet" "aws_subnet_az2" {
    availability_zone = data.aws_availability_zones.availability_zones.names[1]
}

# Create security group for the web server 
resource "aws_security_group" "webserver_security_group" {
    name = "NAME OF SECURITY GROUP"
    description = "DESCRIPTION OF SECURITY GROUP"
    vpc_id = aws_default_vpc.default_vpc.id

    ingress {
    description =
    from_port =
    to_port =
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags {
    name = "NAME OF SECURITY GROUP"
    }
}

# Create DB security group
resource "aws_security_group" "db_security_group" {
    name = "NAME OF SECURITY GROUP"
    description = "DESCRIPTION OF SECURITY GROUP"
    vpc_id = aws_default_vpc.default_vpc.id

    ingress {
    description = "DB Access"
    from_port = 
    to_port = 
    protocol = "tcp"
    security_groups = [aws_security_group.webserver_security_group.id]
    }

    egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags {
    name = "NAME OF SECURITY GROUP"
    }
}

# DB subnet

resource "aws_db_subnet_group" "database_subnet_group" {
    name = "sql-server-db-subnet"
    subnet_ids = [aws_default_subnet.aws_subnet_az1.id, aws_default_subnet.aws_subnet_az2.id]
    description = "subnets for db instance"

  tags {
    name = "sql-server-db-subnet"
    }
}

# Launch rds instance

resource "aws_db_instance" "db_instance" {
    engine = ""
    engine_version = ""
    multi_az = True/False
    identifier = "rds-instance-name"
    username = "Username"
    password = "Password"
    instance_class = ""
    allocated_storage = ""
    db_subnet_group_name = aws_db_subnet_group.database_subnet_group.name
    vpc_security_group_ids = [aws_security_group.db_security_group.id]
    availability_zone = data.aws_availability_zones.availability_zones.names[0]
    db_name = "DBName"
    skip_final_snapshot = True/False
}
