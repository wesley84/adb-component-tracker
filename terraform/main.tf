terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.0.0"
    }
  }
}

provider "databricks" {
  host = var.databricks_host
  token = var.databricks_token
}

module "databricks_job" {
  source = "./modules/databricks"

  cluster_name = var.cluster_name
  driver_type = var.driver_type
  worker_type = var.worker_type
  min_workers = var.min_workers
  max_workers = var.max_workers
  notebook_path = var.notebook_path
  job_name = var.job_name
  schedule_quartz_cron_expression = var.schedule_quartz_cron_expression
  timezone = var.timezone
} 