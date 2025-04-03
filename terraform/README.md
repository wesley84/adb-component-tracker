# Databricks Resource Limits Monitor

This Terraform project deploys a Databricks job that monitors resource usage and limits in your Databricks workspace. The job queries system tables to gather information about clusters, jobs, SQL warehouses, and workspace objects, comparing them against known limits.

## Features

- Deploys a shared Databricks cluster with configurable driver and worker nodes
- Creates a scheduled job that runs hourly to monitor resource usage
- Stores historical data in a Delta table for trend analysis
- Monitors various resource types:
  - Clusters and their configurations
  - Workspace objects (notebooks, libraries, repos)
  - Jobs and their schedules
  - SQL warehouses and their usage

## Prerequisites

- Terraform installed (version 1.0.0 or later)
- Databricks workspace access
- Databricks access token with appropriate permissions

## Configuration

1. Create a `terraform.tfvars` file with your Databricks workspace configuration:

```hcl
databricks_host = "https://your-workspace.cloud.databricks.com"
databricks_token = "your-access-token"
```

2. (Optional) Customize other variables in `terraform.tfvars`:

```hcl
cluster_name = "resource-limits-monitor"
driver_type = "Standard_DS3_v2"
worker_type = "Standard_DS3_v2"
min_workers = 1
max_workers = 1
notebook_path = "/Shared/resource-limits-monitor"
job_name = "Resource Limits Monitor"
schedule_quartz_cron_expression = "0 0 * * * ?"  # Run every hour
timezone = "UTC"
```

## Deployment

1. Initialize Terraform:
```bash
cd terraform
terraform init
```

2. Review the plan:
```bash
terraform plan
```

3. Apply the configuration:
```bash
terraform apply
```

## Monitoring

The job will create a Delta table named `system.resource_usage_reports` that stores historical data about resource usage. You can query this table to analyze trends over time.

Example query:
```sql
SELECT 
    timestamp,
    clusters.current_usage as cluster_count,
    jobs.current_usage as job_count,
    sql_warehouses.current_usage as warehouse_count
FROM system.resource_usage_reports
ORDER BY timestamp DESC
LIMIT 10;
```

## Resource Limits

The monitor tracks the following resource limits (as per Azure Databricks documentation):

- Clusters:
  - Maximum 145 attached notebooks per cluster
  - Maximum 100 autoscaling workers
- Workspace:
  - Maximum 10,000 notebooks
  - Maximum 1,000 libraries
  - Maximum 1,000 repos
- Jobs:
  - Maximum 1,000 concurrent runs
  - Maximum 3 retries per job
- SQL Warehouses:
  - Maximum 100 warehouses
  - Maximum 100 queries per warehouse

## Cleanup

To remove the deployed resources:

```bash
terraform destroy
```

## Notes

- The job runs hourly by default. You can modify the schedule by updating the `schedule_quartz_cron_expression` variable.
- The cluster is configured to auto-terminate after 60 minutes of inactivity.
- The notebook is deployed to the `/Shared` folder in your workspace. 