resource "aws_lb_target_group" "catalogue" {
  name     = "${var.project}-${var.environment}-catalogue" # roboshop-dev-catalogue
  port     = 8080 # catalogue default port no is 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  health_check {
    healthy_threshold = 2
    interval = 5 # for every 5 seconds healthcheck should happen
    matcher = "200-299" # success responces
    path = "/health" # foe every backend there is a health you can check whether it is healthy or not
    port = 8080
    timeout = 2 # i should get responce in 2 sec
    unhealthy_threshold = 3
  }
}

resource "aws_instance" "catalogue" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.catalogue_sg_id]
  subnet_id = local.private_subnet_id
  
  tags = merge (
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-catalogue"
    }
  )
}


resource "terraform_data" "catalogue" {  # configuring data
  triggers_replace = [
    aws_instance.catalogue.id
  ]

  provisioner "file" {
    source      = "catalogue.sh"
    destination = "/tmp/catalogue.sh"
  }

  connection {
     type = "ssh"
     user = "ec2-user"
     password = "DevOps321"
     host = aws_instance.catalogue.private_ip
   }

  provisioner "remote-exec" {
    inline = [ 
      "chmod +x /tmp/catalogue.sh",
      "sudo sh /tmp/catalogue.sh catalogue"
     ]
   }
}

