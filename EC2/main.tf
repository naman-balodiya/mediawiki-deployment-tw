resource "aws_key_pair" "instance_key" {
  key_name   = "${lower(var.envname)}-tw-key"
  public_key = file("${path.module}/key.pub")

  tags = {
    Name        = "${lower(var.envname)}-tw-key"
    Environment = var.envname
  }
}

resource "aws_security_group" "app_instance_sg" {
  name        = "${lower(var.envname)}-tw-app-sg"
  description = "${var.envname} tw app instance security group"
  vpc_id      = var.vpc_id
  depends_on  = [aws_security_group.clbsg]
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = var.dev_allowed_cidrs
  }

  ingress {
    from_port       = 80
    protocol        = "tcp"
    to_port         = 80
    security_groups = [aws_security_group.clbsg.id]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${lower(var.envname)}-tw-app-sg"
    Environment = var.envname
  }
}

resource "aws_instance" "app_instance" {
  count = var.app_instances

  depends_on = [aws_key_pair.instance_key]

  ami           = var.ami_id
  key_name      = element(aws_key_pair.instance_key.*.key_name, 0)
  instance_type = var.instance_type
  #disable_api_termination = true

  vpc_security_group_ids      = [element(aws_security_group.app_instance_sg.*.id, 0)]
  subnet_id                   = var.public_subnet

  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    encrypted   = true
  }

  provisioner "file" {
    content      = file("${path.module}/mediawiki_deployment.yml")
    destination = "/home/ec2-user/mediawiki_deployment.yml"

    connection {
      type     = "ssh"
      user     = "ec2-user"
      host     = self.public_ip
	  private_key = file("${path.module}/key.pem")
    }
  }

  provisioner "remote-exec" {
    inline = [
	  "sudo su",
	  "dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm",
	  "dnf config-manager --set-enabled codeready-builder-for-rhel-8-rhui-rpms",
	  "dnf install ansible -y",
	  "ansible-playbook /home/ec2-user/mediawiki_deployment.yml"
    ]
	connection {
      type     = "ssh"
      user     = "ec2-user"
      host     = self.public_ip
	  private_key = file("${path.module}/key.pem")
    }
  }

  tags = {
    Name        = "${var.envname}-tw-app-instance-${count.index}"
    Environment = var.envname
  }
}

resource "aws_security_group" "clbsg" {
  name        = "tw-${var.envname}-clb-sg"
  vpc_id      = var.vpc_id
  description = "Security group for clasic load-balancer"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTP traffic from anywhere"
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outgoing HTTP traffic to anywhere"
  }

  tags = {
    Name = "tw-${var.envname}-clb-sg"
  }
}

output "app_instance_ids" {
  value = aws_instance.app_instance[*].id
}

output "app_instance_sg" {
  value = aws_security_group.app_instance_sg.id
}

output "clbsg" {
  value = aws_security_group.clbsg.id
}
