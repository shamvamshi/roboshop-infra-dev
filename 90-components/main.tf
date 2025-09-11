module "components" {
  for_each = var.components
  source = "git::https://github.com/shamvamshi/terraform-aws-roboshop.git?ref=main"
  component = each.key
  rule_priority = each.value.rule_priority # so each value is rule_priority, so u define value using (.)
}