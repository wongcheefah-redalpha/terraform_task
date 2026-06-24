# modules/ec2/main.tf
# Provisions a security group and an EC2 instance in the public subnet.

# Latest Amazon Linux 2023 AMI for the active region (no hardcoded AMI IDs).
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "this" {
  name        = "${var.project_name}-sg"
  description = "Allow SSH from a single IP and HTTP from anywhere"
  vpc_id      = var.vpc_id

  # SSH restricted to the caller's IP only.
  ingress {
    description = "SSH from allowed IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # HTTP left open to the world.
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

resource "aws_instance" "this" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.this.id]
  key_name               = var.key_name != "" ? var.key_name : null

  tags = {
    Name = "${var.project_name}-ec2"
  }

  lifecycle {
    # The AMI comes from a most_recent data source whose result drifts as AWS
    # publishes new Amazon Linux 2023 builds. Ignore post-creation AMI changes
    # so the running instance is not replaced on every plan; new instances
    # still launch from the latest AMI at creation time.
    ignore_changes = [ami]
  }
}
