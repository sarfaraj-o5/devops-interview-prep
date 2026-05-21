backup $JENKINS_HOME 

## Monitoring & observability
login api slow -> traced to auth svc -> db query latency -> missing index

TSDB(time series db)
stores data as:
metric_name{label=value} -> timestamp -> value

http_requests_total{servie="login",status="500"}

scrape_interval: 15s

exporters(metirc producers) /metrics
node expoter -> cpu, memory, disk
kube-state-metrics -> pod status, replicas
app exporter -> jvm, python, nod.js

service discovery flow
prometheus talks to k8s api -> discover pods/svc -> scraper/metircs -> stores in TSDB

PromQL
rate(container_cpu_usage_seconds_total[5m])

data dog + k8s flow
pod/node -> datadog agent -> datadog cloud -> dashboards + alerts + traces

ELK
elasticsearch -> storage & search
logstash -> parsing
kibana -> ui

kubeclt rollout undo deployment

ILM(index lifecycle policy)

