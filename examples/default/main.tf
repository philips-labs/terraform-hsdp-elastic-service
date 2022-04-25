module "elastic-service" {
  source       = "philips-labs/elastic-service/hsdp"
  
  // es7-standard-3 is the default plan selected in this module. This field can be overrided with the plan which is suitable as per your requirements
  service_plan = "es7-standard-3"

  cf_space_id = var.cf_space_id
}
  
