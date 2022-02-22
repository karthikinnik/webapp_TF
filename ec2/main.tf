data "aws_availability_zones" "available" {}

resource "aws_key_pair" "mytest-key" {
  key_name   = "my-test-terraform-key"
  public_key = file(var.my_public_key)
}

resource "aws_instance" "my-test-instance" {
  count                  = 2
  ami                    = var.ami
  instance_type          = var.instances_type
  key_name               = aws_key_pair.mytest-key.id
  vpc_security_group_ids = [var.security_group]
  subnet_id              = element(var.subnets, count.index)
  user_data              = data.template_file.init.rendered
  tags = {
    Name = "my-instance-${count.index + 1}"
  }
}

data "template_file" "init" {
  template = file("${path.module}/userdata.tpl")
}