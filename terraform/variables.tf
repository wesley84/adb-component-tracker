variable "databricks_host" {
  description = "The Databricks workspace URL"
  type        = string
}

variable "databricks_token" {
  description = "The Databricks access token"
  type        = string
  sensitive   = true
}

variable "cluster_name" {
  description = "Name of the Databricks cluster"
  type        = string
  default     = "resource-limits-monitor"
}

variable "driver_type" {
  description = "The instance type for the driver node"
  type        = string
  default     = "Standard_DS3_v2"
}

variable "worker_type" {
  description = "The instance type for the worker nodes"
  type        = string
  default     = "Standard_DS3_v2"
}

variable "min_workers" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "max_workers" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 1
}

variable "notebook_path" {
  description = "Path to the notebook in the Databricks workspace"
  type        = string
  default     = "/Shared/resource-limits-monitor"
}

variable "job_name" {
  description = "Name of the Databricks job"
  type        = string
  default     = "Resource Limits Monitor"
}

variable "schedule_quartz_cron_expression" {
  description = "Cron expression for job scheduling"
  type        = string
  default     = "0 0 * * * ?" # Run every hour
}

variable "timezone" {
  description = "Timezone for the job schedule"
  type        = string
  default     = "UTC"
} 