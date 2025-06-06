resource "aws_waf_web_acl" "example" {
  name        = "example-waf"
  metric_name = "exampleWAF"
  default_action {
    type = "ALLOW"
  }

  rule {
    name     = "SQLInjectionRule"
    priority = 1

    action {
      type = "BLOCK"
    }

    predicate {
      data_id = aws_waf_sql_injection_match_set.sql.id
      negated = false
      type    = "SQL_INJECTION_MATCH"
    }
  }
}
