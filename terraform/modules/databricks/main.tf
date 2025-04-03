resource "databricks_cluster" "shared_autoscaling" {
  cluster_name            = var.cluster_name
  spark_version          = "13.3.x-scala2.12"
  node_type_id           = var.worker_type
  driver_node_type_id    = var.driver_type
  autotermination_minutes = 60
  min_workers            = var.min_workers
  max_workers            = var.max_workers
  spark_conf = {
    "spark.databricks.cluster.profile" : "serverless"
    "spark.databricks.repl.allowedLanguages" : "python,sql"
  }
}

resource "databricks_notebook" "resource_monitor" {
  path     = var.notebook_path
  language = "PYTHON"
  content_base64 = base64encode(<<-EOT
    ${file("${path.module}/notebooks/resource_monitor.py")}
  EOT
  )
}

resource "databricks_job" "resource_monitor" {
  name = var.job_name

  new_cluster {
    num_workers   = var.min_workers
    spark_version = "13.3.x-scala2.12"
    node_type_id  = var.worker_type
    driver_node_type_id = var.driver_type
  }

  notebook_task {
    notebook_path = databricks_notebook.resource_monitor.path
  }

  schedule {
    quartz_cron_expression = var.schedule_quartz_cron_expression
    timezone_id           = var.timezone
  }

  email_notifications {
    on_success = []
    on_failure = []
  }
} 