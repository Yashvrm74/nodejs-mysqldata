resource "aws_instance" "tf_ec2_instance" {
  ami                         = "ami-0360c520857e3138f"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.tf_ec2_vpc1.id]
  key_name                    = "terraform"
  depends_on                  = [aws_s3_object.tf_s3_object]
  user_data = <<-EOF
#!/bin/bash
# Install dependencies
sudo apt update -y
sudo apt install -y git nodejs npm

# Clone repo
git clone https://github.com/Yashvrm74/nodejs-mysqldata.git /home/ubuntu/nodejs-mysqldata
cd /home/ubuntu/nodejs-mysqldata

# Create .env file
echo "DB_HOST=${local.rds_endpoint}" | sudo tee .env
echo "DB_USER=${aws_db_instance.tf_rds_instance1.username}" | sudo tee -a .env
echo "DB_PASS=${aws_db_instance.tf_rds_instance1.password}" | sudo tee -a .env
echo "DB_NAME=${aws_db_instance.tf_rds_instance1.db_name}" | sudo tee -a .env
echo "TABLE_NAME=users" | sudo tee -a .env
echo "PORT=3000" | sudo tee -a .env

# Install node modules
npm install

# Start app (run in background so user_data doesn’t hang)
nohup npm start > app.log 2>&1 &
EOF

                                 

  user_data_replace_on_change = true
  tags = {
    Name = "nodejs-server127"
  }
}

resource "aws_security_group" "tf_ec2_vpc1" {
  name        = "nodejs-mysqldata1"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = "vpc-0d2c649773a148713"

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TCP"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "ec2_pub_ip1" {
  value = "ssh -i ~/.ssh/terraform.pem ubuntu@${aws_instance.tf_ec2_instance.public_ip}"
}



