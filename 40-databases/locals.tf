locals {
  ami_id = data.aws_ami.roboshop.id
  mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_id.value
  redis_sg_id = data.aws_ssm_parameter.redis_sg_id.value
  mysql_sg_id = data.aws_ssm_parameter.mysql_sg_id.value
  rabbitmq_sg_id = data.aws_ssm_parameter.rabbitmq_sg_id.value


  database_subnet_id = split("," , data.aws_ssm_parameter.database_subnet_ids.value)[0] # split function is for taking only public 1a subnet... 0 indicating 1 st

    common_tags = {
      project =  var.project
      environment = var.environment
      terraform = "true"
  }
}