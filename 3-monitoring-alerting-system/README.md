# Monitoring & Alerting System

A centralized monitoring stack using **Prometheus**, **Grafana**, and **AWS CloudWatch** to provide full observability across application and infrastructure layers. Includes pre-built dashboards and alerting rules for proactive incident detection.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│                   Monitored Systems                  │
│   EC2 Instances │ EKS Pods │ RDS │ ALB │ Lambda      │
└────────┬──────────────┬────────────────┬────────────┘
         │              │                │
    [Node Exporter] [kube-state-    [CloudWatch
    [App /metrics]   metrics]        Agent]
         │              │                │
         └──────────────┼────────────────┘
                        │
                 [Prometheus]
                 (scrapes metrics)
                        │
              ┌─────────┴──────────┐
              │                    │
          [Grafana]         [Alertmanager]
          (dashboards)      (routes alerts)
                                   │
                        ┌──────────┴──────────┐
                        │                     │
                   [Slack Alert]        [Email Alert]
```

---

## Repository Structure

```
monitoring-alerting-system/
├── prometheus/
│   ├── prometheus.yml           # Prometheus config — what to scrape
│   └── alert-rules.yml          # Alerting rules (CPU, memory, downtime)
├── grafana/
│   └── dashboards/
│       └── infrastructure.json  # Pre-built Grafana dashboard
├── cloudwatch/
│   └── cloudwatch-agent.json    # CloudWatch agent config for EC2
├── ansible/
│   └── install-monitoring.yml   # Ansible playbook to deploy the stack
└── docs/
    └── runbook.md               # Incident response runbook
```

---

## What Gets Monitored

### Infrastructure Metrics
- CPU utilization per instance and cluster
- Memory usage and swap
- Disk usage and I/O
- Network throughput

### Application Metrics
- HTTP request rate and error rate
- Response latency (p50, p90, p99)
- Active connections

### Kubernetes Metrics
- Pod restart count
- Pod CPU/memory vs limits
- Node resource utilization
- Deployment replica availability

---

## Alerting Rules

| Alert | Condition | Severity |
|-------|-----------|---------|
| HighCPU | CPU > 80% for 5 min | Warning |
| CriticalCPU | CPU > 95% for 2 min | Critical |
| HighMemory | Memory > 85% for 5 min | Warning |
| PodCrashLoop | Pod restarting repeatedly | Critical |
| InstanceDown | Target unreachable for 1 min | Critical |
| DiskSpaceLow | Disk > 85% full | Warning |
| HighErrorRate | HTTP 5xx > 5% of requests | Critical |

---

## Key Results
- Reduced mean time to detect (MTTD) incidents by **30%**
- Proactive disk alerts prevented 3 outages in 6 months
- Grafana dashboards reduced on-call investigation time from 15 min to under 5 min

---

## Setup

See [ansible/install-monitoring.yml](ansible/install-monitoring.yml) to deploy the full stack automatically via Ansible.

### Quick Start (Docker Compose)
```bash
docker-compose up -d
# Prometheus: http://localhost:9090
# Grafana:    http://localhost:3000 (admin/admin)
```
