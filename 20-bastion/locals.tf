locals {
  ami_id = data.aws_ami.roboshop.id
  bastion_sg_id = data.aws_ssm_parameter.bastion_sg_id.value
  public_subnet_id = split("," , data.aws_ssm_parameter.public_subnet_ids.value)[0] # split function is for taking only public 1a subnet... 0 indicating 1 st

    common_tags = {
      project =  var.project
      environment = var.environment
      terraform = "true"
  }
}