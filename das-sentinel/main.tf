provider "aws" {
  region     = "ap-south-1"
}

#security group
resource "aws_security_group" "webserver_access" {
        name = "webserver_access"
        description = "allow ssh and http"
        vpc_id      = "vpc-3345b25a"
        ingress {
                from_port = 80
                to_port = 80
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }

        ingress {
                from_port = 22
                to_port = 22
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }

        egress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
        }


}
#security group end here
resource "aws_instance" "statemove" {
  ami           = "ami-0447a12f28fddb066"
  availability_zone = "ap-south-1a"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.webserver_access.name}"]
  /* the key zoomkey must be downloaded in your machine from where
  you are executing this code. So first create the key, download it
  and then use it */
 
  user_data = <<-EOF
        #!/bin/bash
        sudo yum install httpd -y
        sudo systemctl start httpd
        sudo systemctl enable httpd
        echo "<h1>sample webserver using terraform</h1>" | sudo tee /var/www/html/index.html
  EOF

  tags = {
    Name  = "das"
    Stage = "testing"
    Location = "India"
  }

}