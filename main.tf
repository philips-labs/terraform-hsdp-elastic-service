locals {
  postfix            = var.name_postfix != "" ? var.name_postfix : random_pet.name.id
}

resource "random_pet" "name" {
  #length = 2 is default
}

resource "cloudfoundry_service_instance" "elasticsearch" {
  name  = "tf-elasticsearch-${local.postfix}"
  space = var.cf_space_id
  //noinspection HILUnresolvedReference
  service_plan                   = data.cloudfoundry_service.elastic.service_plans[var.service_plan]
}

resource "cloudfoundry_service_key" "key" {
  name             = "tf-key-${local.postfix}"
  service_instance = cloudfoundry_service_instance.elasticsearch.id
}

resource "cloudfoundry_app" "exporter" {
  name         = "tf-elasticsearch-exporter-${local.postfix}"
  space        = var.cf_space_id
  docker_image = var.exporter_image
  disk_quota   = var.exporter_disk_quota
  memory       = var.exporter_memory
  health_check_type = "none"
  docker_credentials = {
    username = var.docker_username
    password = var.docker_password
  }

  command = "elasticsearch_exporter --es.uri=${cloudfoundry_service_key.key.credentials.uri} --es.all --es.cluster_settings --es.indices"
  
  environment = merge({}, var.exporter_environment)

  //noinspection HCLUnknownBlockType
  routes {
    route = cloudfoundry_route.exporter.id
  }
  labels = {
    "variant.tva/exporter" = true,
  }
  annotations = {
    "prometheus.exporter.type" = "elasticsearch_exporter"
    "prometheus.exporter.port" = "9114"
    "prometheus.exporter.path" = "/metrics"
  }
}

resource "cloudfoundry_route" "exporter" {
  domain   = data.cloudfoundry_domain.apps_internal_domain.id
  space    = var.cf_space_id
  hostname = "tf-elasticsearch-exporter-${local.postfix}"
}