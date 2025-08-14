module "frontend" {
#   source = "../../terraform-aws-securitygroup"
  source = "git::https://github.com/shamvamshi/terraform-aws-securitygroup.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = var.frontend_sg_name
  sg_description = var.frontend_sg_description
  vpc_id = local.vpc_id
}

module "bastion" {
#   source = "../../terraform-aws-securitygroup"
  source = "git::https://github.com/shamvamshi/terraform-aws-securitygroup.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = var.bastion_sg_name
  sg_description = var.bastion_sg_description
  vpc_id = local.vpc_id
}

module "backend-alb" {
#   source = "../../terraform-aws-securitygroup"
  source = "git::https://github.com/shamvamshi/terraform-aws-securitygroup.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = "backend-alb"
  sg_description = "for backend alb"
  vpc_id = local.vpc_id
}

module "vpn" {
#   source = "../../terraform-aws-securitygroup"
  source = "git::https://github.com/shamvamshi/terraform-aws-securitygroup.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = "vpn"
  sg_description = "for vpn"
  vpc_id = local.vpc_id
}

module "mongodb" {
#   source = "../../terraform-aws-securitygroup"
  source = "git::https://github.com/shamvamshi/terraform-aws-securitygroup.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = "mongodb"
  sg_description = "for mongodb"
  vpc_id = local.vpc_id
}

module "redis" {
#   source = "../../terraform-aws-securitygroup"
  source = "git::https://github.com/shamvamshi/terraform-aws-securitygroup.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = "redis"
  sg_description = "for redis"
  vpc_id = local.vpc_id
}

module "mysql" {
#   source = "../../terraform-aws-securitygroup"
  source = "git::https://github.com/shamvamshi/terraform-aws-securitygroup.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = "mysql"
  sg_description = "for mysql"
  vpc_id = local.vpc_id
}

module "rabbitmq" {
#   source = "../../terraform-aws-securitygroup"
  source = "git::https://github.com/shamvamshi/terraform-aws-securitygroup.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = "rabbitmq"
  sg_description = "for rabbitmq"
  vpc_id = local.vpc_id
}


# bastion accepting connections from my laptop
resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}

# backend alb accepting connections from my bastion host on port no 80
resource "aws_security_group_rule" "backend_alb_bastion" { # it means backend alb accepting connections from bastion
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.backend-alb.sg_id
  }

  # vpn ports 22, 443, 1194, 943
resource "aws_security_group_rule" "vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
   security_group_id = module.vpn.sg_id
  }

  resource "aws_security_group_rule" "vpn_https" {
    type              = "ingress"
    from_port         = 443
    to_port           = 443
    protocol          = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.vpn.sg_id
    }

  resource "aws_security_group_rule" "vpn_1994" {
    type              = "ingress"
    from_port         = 1194  
    to_port           = 1194
    protocol          = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.vpn.sg_id
    }

  resource "aws_security_group_rule" "vpn_943" {
    type              = "ingress"
    from_port         = 943  
    to_port           = 943
    protocol          = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.vpn.sg_id
    }

# it means backend alb accepting connections from my vpn host on port no 80
resource "aws_security_group_rule" "backend_alb_vpn" { 
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.backend-alb.sg_id
  }

resource "aws_security_group_rule" "redis_vpn_ssh" { 
  count = length(var.redis_ports_vpn)
  type              = "ingress"
  from_port         = var.redis_ports_vpn[count.index]
  to_port           = var.redis_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id  # source is vpn, because it is coming from vpn
  security_group_id = module.redis.sg_id
  }

resource "aws_security_group_rule" "mysql_vpn_ssh" { 
  count = length(var.mysql_ports_vpn)
  type              = "ingress"
  from_port         = var.mysql_ports_vpn[count.index]
  to_port           = var.mysql_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id  # source is vpn, because it is coming from vpn
  security_group_id = module.mysql.sg_id
  }

resource "aws_security_group_rule" "rabbitmq_vpn_ssh" { 
  count = length(var.rabbitmq_ports_vpn)
  type              = "ingress"
  from_port         = var.rabbitmq_ports_vpn[count.index]
  to_port           = var.rabbitmq_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id  # source is vpn, because it is coming from vpn
  security_group_id = module.rabbitmq.sg_id
  }