variable "cluster_name" {
  description = "Name of the Databricks cluster"
  type        = string
}

variable "driver_type" {
  description = "The instance type for the driver node"
  type        = string
}

variable "worker_type" {
  description = "The instance type for the worker nodes"
  type        = string
}

variable "min_workers" {
  description = "Minimum number of worker nodes"
  type        = number
}

variable "max_workers" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "notebook_path" {
  description = "Path to the notebook in the Databricks workspace"
  type        = string
}

variable "job_name" {
  description = "Name of the Databricks job"
  type        = string
}

variable "schedule_quartz_cron_expression" {
  description = "Cron expression for job scheduling"
  type        = string
}

variable "timezone" {
  description = "Timezone for the job schedule"
  type        = string
} 