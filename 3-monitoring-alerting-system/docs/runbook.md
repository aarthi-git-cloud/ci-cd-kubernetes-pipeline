# Incident Response Runbook

Quick reference guide for responding to monitoring alerts. Use this during on-call incidents.

---

## Alert: InstanceDown

**What it means:** Prometheus cannot reach a monitored instance. Could be a crash, network issue, or the Node Exporter process stopped.

**Steps:**
1. Check AWS Console → EC2 → verify the instance state (running/stopped/terminated)
2. If instance is running, SSH in and check Node Exporter: `systemctl status node_exporter`
3. If Node Exporter stopped: `systemctl restart node_exporter`
4. If instance is unreachable: check security group — port 9100 must be open to Prometheus server
5. If instance is stopped unexpectedly: check Auto Scaling Group events for a scale-in event

---

## Alert: HighCPUUsage / CriticalCPU

**What it means:** One or more EC2 instances are running hot.

**Steps:**
1. Open Grafana → Infrastructure Dashboard → find the affected instance
2. SSH into instance: `top` or `htop` to identify the high-CPU process
3. Check app logs: `tail -f /var/log/app/application.log`
4. If a runaway process: `kill -9 <pid>` and investigate root cause
5. If legitimate load increase: check if Auto Scaling triggered — it should scale out at 75% CPU
6. If ASG didn't scale: check ASG health in AWS Console and verify scaling policies

---

## Alert: PodCrashLooping

**What it means:** A Kubernetes pod is repeatedly crashing and restarting.

**Steps:**
1. Get pod details: `kubectl get pods -n production`
2. Check pod logs: `kubectl logs <pod-name> -n production --previous`
3. Describe pod for events: `kubectl describe pod <pod-name> -n production`
4. Common causes:
   - **OOMKilled** — pod ran out of memory, increase memory limits in deployment.yaml
   - **Config error** — wrong env variable or missing secret
   - **Image pull error** — ECR credentials or image tag issue
5. If critical: scale down the bad deployment and roll back:
   `kubectl rollout undo deployment/my-app -n production`

---

## Alert: DiskSpaceLow / DiskSpaceCritical

**What it means:** A disk partition is running out of space.

**Steps:**
1. SSH into instance
2. Find what's using space: `du -sh /* 2>/dev/null | sort -rh | head -20`
3. Common culprits:
   - `/var/log` — old log files. Run: `find /var/log -name "*.log" -mtime +7 -delete`
   - Docker images — clean up: `docker system prune -af`
   - Application temp files in `/tmp`
4. If disk is above 95%: escalate immediately — services will fail if disk hits 100%

---

## Alert: HighErrorRate

**What it means:** More than 5% of HTTP requests are returning 5xx errors.

**Steps:**
1. Check app logs: `tail -f /var/log/app/error.log`
2. Check Grafana → Application Dashboard → error rate graph to see when it started
3. Correlate with recent deployments — did a deploy just happen?
4. If caused by a bad deploy: roll back immediately via Jenkins or:
   `kubectl rollout undo deployment/my-app -n production`
5. Check downstream dependencies: database connections, external API calls
6. Check CloudWatch → RDS metrics for database issues

---

## General Escalation Path

```
Alert fires
    │
    ▼
On-call engineer investigates (15 min)
    │
    ├── Resolved → document in incident log
    │
    └── Not resolved → escalate to senior engineer
                           │
                           └── Still not resolved → escalate to team lead
```

---

## Useful Commands Quick Reference

```bash
# Kubernetes
kubectl get pods -n production
kubectl logs <pod> -n production --previous
kubectl rollout undo deployment/my-app -n production
kubectl top nodes
kubectl top pods -n production

# System
top / htop
df -h
free -m
systemctl status <service>

# Docker
docker ps
docker logs <container>
docker system prune -af    # Clean up unused images/containers

# AWS CLI
aws ec2 describe-instances --filters Name=instance-state-name,Values=running
aws cloudwatch get-metric-statistics ...
```
