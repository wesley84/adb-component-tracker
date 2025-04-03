# Databricks notebook source
# DBTITLE=1, Import required libraries
from pyspark.sql.functions import *
from datetime import datetime
import json

# DBTITLE=2, Define resource limits from documentation
RESOURCE_LIMITS = {
    "clusters": {
        "attached_notebooks": 145,
        "autoscaling_workers": 100
    },
    "workspace": {
        "notebooks": 10000,
        "libraries": 1000,
        "repos": 1000
    },
    "jobs": {
        "concurrent_runs": 1000,
        "max_retries": 3
    },
    "sql": {
        "warehouses": 100,
        "queries_per_warehouse": 100
    }
}

# DBTITLE=3, Query system tables for current usage
def get_cluster_usage():
    return spark.sql("""
        SELECT 
            cluster_id,
            cluster_name,
            state,
            num_workers,
            driver_type,
            node_type_id,
            autotermination_minutes
        FROM system.information_schema.clusters
        WHERE state != 'TERMINATED'
    """)

def get_workspace_usage():
    return spark.sql("""
        SELECT 
            object_type,
            COUNT(*) as count
        FROM system.information_schema.objects
        GROUP BY object_type
    """)

def get_job_usage():
    return spark.sql("""
        SELECT 
            job_id,
            job_name,
            creator_user_name,
            schedule_quartz_cron_expression,
            max_concurrent_runs,
            max_retries
        FROM system.information_schema.jobs
    """)

def get_sql_warehouse_usage():
    return spark.sql("""
        SELECT 
            warehouse_id,
            warehouse_name,
            state,
            cluster_size,
            running_queries
        FROM system.information_schema.warehouses
        WHERE state != 'STOPPED'
    """)

# DBTITLE=4, Analyze and report resource usage
def analyze_usage():
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    report = {
        "timestamp": timestamp,
        "clusters": {
            "current_usage": get_cluster_usage().count(),
            "limits": RESOURCE_LIMITS["clusters"]
        },
        "workspace": {
            "current_usage": get_workspace_usage().collect(),
            "limits": RESOURCE_LIMITS["workspace"]
        },
        "jobs": {
            "current_usage": get_job_usage().count(),
            "limits": RESOURCE_LIMITS["jobs"]
        },
        "sql_warehouses": {
            "current_usage": get_sql_warehouse_usage().count(),
            "limits": RESOURCE_LIMITS["sql"]
        }
    }
    
    # Save report to a Delta table
    report_df = spark.createDataFrame([(json.dumps(report), timestamp)], ["report", "timestamp"])
    report_df.write.format("delta").mode("append").saveAsTable("system.resource_usage_reports")
    
    return report

# DBTITLE=5, Generate and display report
report = analyze_usage()
print(json.dumps(report, indent=2))

# DBTITLE=6, Display historical trends
spark.sql("""
    SELECT 
        timestamp,
        clusters.current_usage as cluster_count,
        jobs.current_usage as job_count,
        sql_warehouses.current_usage as warehouse_count
    FROM system.resource_usage_reports
    ORDER BY timestamp DESC
    LIMIT 10
""").display() 