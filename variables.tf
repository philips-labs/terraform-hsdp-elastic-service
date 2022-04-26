variable "cf_space_id" {
  description = "Cloudfoundry space id to provision resources in"
  type        = string
}

variable "name_postfix" {
  type        = string
  description = "The postfix string to append to the space, hostname, etc. Prevents namespace clashes"
  default     = ""
}

variable "exporter_image" {
  description = "Image to use for Kafka exporter"
  default     = "quay.io/prometheuscommunity/elasticsearch-exporter"
  type        = string
}

variable "docker_username" {
  description = "Docker username to use"
  type        = string
  default     = ""
}

variable "docker_password" {
  description = "Docker password to use"
  type        = string
  default     = ""
}

variable "exporter_memory" {
  type        = number
  description = "Exporter memory settings"
  default     = 128
}

variable "exporter_disk_quota" {
  type        = number
  description = "Exporter disk quota"
  default     = 1024
}

variable "exporter_environment" {
  type        = map(any)
  description = "Additional configuration for the exporter"
  default     = {}
}

variable "service_plan" {
  description = "Plan to use"
  type      = string
  default = "es7-standard-3"
}

variable "elastic_options" {
  description = "Options to pass when creating Elastic cluster"
  type        = string
  default     = <<EOF
  {"EnableAPMServer": true}
EOF
}