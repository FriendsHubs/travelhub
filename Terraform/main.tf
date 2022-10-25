provider "aws" {
  region = "eu-west-3"
}

resource "aws_security_group" "frontend_sg" {
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
resource "aws_instance" "public_frontend" {
  ami                    = "ami-0493936afbe820b28"
  instance_type          = "t2.micro"
  key_name               = "jenkins-key"
  vpc_security_group_ids = ["${aws_security_group.frontend_sg.id}"]

  tags = {
    "Name" = "travelhub_frontend"
  }
}

# output "frontend_ip" {
#   value = "aws_instance.public_frontend.public_ip"
# }
