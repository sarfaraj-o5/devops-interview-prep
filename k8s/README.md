## NAMESPACE
kubectl create ns dev
kubectl get ns

## labels & annotations
labels:
    app: frontend
annotatioin --> metadata, version, build info
selector in svc --> use labels
svc discovery in k8s works using labels

## env or from configmap/secret
env:
    - name: DB_HOST
      value: mysql

## configmap -- non-sensitive config
kubectl create configmap app-config --from-literal=env=prod

## secrets -- Base64
kubectl create secret generic db-secret --from-literal=password=MyPass

## for large scale use aws secrets manager + CSI driver

## horizontal vs vertical scaling
kubectl scale deploy web --replicas=5

## cluster ip = internal-only svc == microsvc to microsvc communicate
type: ClusterIP

## nodeport = expose app externally via node's IP: port(30000-32767) = limitation = no built-in LB
type: NodePort

## LB -- provision cloud LB
type: LoadBalancer

# replicaSet -- ensure desired no. of pods -- auto recreated if deleted
replicas: 3
    selector:
        matchLabels:
            app: nginx

## deployment -- manages replicaSets --> rolling updates --> version control, rollback, rolling updates
kubectl rollout undo deploy web

## volumes -- emptyDir, hostPath, NFS, EFS, EBS, PVC
## PV, PVC, SC
storageClassName: gp2

## Headless svc
ClusterIP: None -- used for direct pod discovery(DNS returns pod IPs)

## HPA(HORIZONTAL POD AUTOSCALING) -- auto adjusts replicas based on cpu/memory
kubectl autoscale deploy web --min=2 --max=10 --cpu-percent=70

## taints & tolerations -- taint(node)=restrict pods, toleration(pod)=allow scheduling
kubectl taint nodes node1 key=value: NoSchedule

## NodeAffinity & AntiAffinity - control pod scheduling based on node labels
nodeAffinity:
    requiredDuringSchedulingIgnoreDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
            - key: region
              values: [us-east-1]

## podAffinity & PodAntiAffinity -- schedule pods together or apart --> multi replicas of DB --> use PodAntiAffinity
PodAffinity: Place near
PodAntiAffinity: Spread out

## Helm --> package mang for k8s(like apt/yum/dnf for containers)
helm create chartname
helm install myapp ./chartname
helm upgrade --install myapp ./chartname

## helm recap
templates + values --> reusuable deployn
supports versioning & rollbacks

## Ingress controller --> manages external HTTP/S traffic
Ingress Resource: routing rules
Ingress controller: implements the (nginx, ALB)

host: app.example.com
serviceName: web

## RBAC -- Role / clusterRole, Rolebinding / clusterRoleBinding

## Service Accounts -- Identify for pods --> access Api securely
serviceAccountName: backend-sa

# InitContainers -- run before main app starts(for setup/config)
initContainers:
- name: inti-db
  image: busybox

## emptyDir - temp storage shared by containers within pod

## fetching secret from AWS Secrets Manager -- use CSI secret store driver
secretProviderClass: aws-secrets

## hostpath : mounts host dir into pods ; daemonset: ensures one pod per node -- node exporter(monitoring agent)

## liveness & Readiness probe 
liveness: checks if pod should restart
readiness: checks if pod ready for traffic
livenessProbe:
    httpGet:
        path: /health

## network poicy -- controls traffic between(firewall for k8s)
policyTypes:
- Ingress
- Egress

## deploy strategies 
Rolling Update = gradual pod replacement
Recreate = stops old, starts new
Blue-Green = two envs, switch
canary = gradual % traffic shift

kubectl describe pod --> check event nodes had taint ${app=backend} not tolerated

## troubleshoot
pod pending -> "0/3 nodes available" -> check affinity conditions
kubectl describe pod pod_name

## daemonset troubleshoot
deploy node exporter on every node for prometheus monitoring
Daemonset pods not scheduled -> check taints/tolerations or nodeSelector mismatch

## init containers & emptyDir
## helm troubleshoot
helm template ./chart -> render yaml locally to debug
if upgrade fails -> use --debug --dry-run

## ingress-controller
options: nginx, alb, traefik
single alb routes /api -> backend / -> frontend
ingress not working
kubectl get ingress
kubectl describe ingress web-ingress
Check contoller pod logs, dns map(route53 -> LB DNS)

## rbac
kubectl get rolebinding
kubectl auth can-i list pods --as system:serviceaccount:dev:backend-sa

## networking
policy applied but traffic blocked
verify cni plugin supports policies(calico, cilium)
check kubectl describe netpol

### terraform aws
aws eks describe-cluster

## pod restarting repeatedly --> livenessProbe failing
kubectl describe pod pod_name
adjust intialDelaySeconds & timeoutSeconds

## hostpath vol
mounts host dir inside pod
used for logs, daemon agents --> daemonset collecting node logs

Pod can't start --> hostPath path missing --> pre-create it

## eks blue-green upgrade
terraform apply new version
new node group --> validate pods scheduling
kubectl drain old-nodes
delete old node-group

node drain stuck --> check PodDisruptionBudgets
validations fails --> rollback via terraform state restore

## CrashLoopBackOff --> kubectl logs --previous
ImagePullBackOff - kubectl create secret docker-registry
Service unreachable - selector mismatch = kubectl get pods --show-labels
DNS not resolving - kubeclt logs -n kube-system coredns-*
Node not ready - kubelet down - systemctl restart kubelet
pvc pending - no storageclass/wrongAZ - kubectl describe pvc
ingress not routing - controller misconfig - kubectl describe ingress
hpa not scaling - metrics-server missing - kubectl top pods
readinessProbe failing - startup delay - adjust probe timing

## troubleshoot k8s
kubectl get pods -o wide
describe pod --> check logs, configmap, secrets or resource limits. 
If cluster-wide -> check kubelet, node health, CNI status

## eks security & iam integration
enable oidc provider
aws eks update-cluster-config --region ap-south-1 --name mycluster --associate-oidc-provider

annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::12345:role/s3-access-role

## secrets encryp with kms
encryption_config {
    resources = ["secrets"]
    provider {
        key_arn = aws_kms_key.eks.arn
    }
}

## audit log
enable api audit log in eks -> CW logs for trace prometheus+grafana
Deploy with helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install monitoring prometheus-community/kube-prometheus-stack

## log aggrgation - loki/efk
loki + promtail + grafana - lightweight log stack
efk - elasticsearch + fluentd + kibana - for deep search

Pod crashes = checks logs in grafana via loki filter {namespace="prod",pod="api-xyz"}

## rollback mechanism
helm rollback relase rev
state revert + terraform destroy(old resources)
github actions:: conditional rollback job on failure

## Crashloopbackoff after configmap change
kubectl rollout restart deployment app_name

## service unreachable from ingress
kubectl describe ingress -> verify servicePort, ensure ingress controller healthy

## ebs vol not attach
pvc pending - ensure ebs vol az matches node az, define StorageClass provisioner ebs.csi.aws.com

## hpa not scaling under load 
pods stuck at min replicas
install metrics-server, validate metrics api - kubectl get apiservices

## node pressure evicts pods
prometheus alert= NodePressureDiskSpace

## terraform state drift
terraform refresh & plan 

## ingress tls error
alb.ingres.kubernetes.io/certificate-arn

## pods can't access external internet
public eks nodes - check natgw / rtb table; pvt cluster - add vpc endpoint
 
##  helm chart rollback
helm history release - find stable rev = helm rollback release 

## k8s cluster is running but app are not starting
kubectl get nodes
kubectl get pods -n kube-system

## pod stuck in pending state
no node enough cpu/memory
node selectors/affintiy mismatch
taints withour tolerations
scheduler unable to place pod
kubectl describe pod pod_name

## container inside a pod crashes
kubelet restarts container -> pod ip remains same -> restart count increases -> pod enters CrashLoopBackOff

## app broke
kubectl rollout undo deployment deploy/name ## switch back to previous ReplicaSet auto

## scale an app manual
kubectl scale deployment name --replica=5

## external traffic reach a pod
client -> service -> kube-proxy -> pod

## troubleshoot failting pod
kubectl get pods
kubectl describe pod pod_name
kubectl logs pod_name
kubectl exec -it pod_name -- /bin/sh

## master node goes down 
no new deploy/scailing, existing pods keep running on worker node, kubectl stop working
kubectl cluster-info ## api-server availabilty

## kubectl uses
$HOME/.kube/config
context(cluster + user + namespace)

## nodeselector
nodeSelector:
    disktype: ssd

kubectl taint nodes node1 key=value:NoSchedule
kubectl taint nodes node1 key:NoSchedule- ## to remove taint

KUBECONFIG ENV
--kubeconfig flag

## cmds
kubectl rollout history deployment/deploy_name

kubectl rollout undo deployment/deploy_name -to-revision=N

kubectl expose deployment nginx --port=80 --type=NodePort

kubectl get pods --all-namespaces | grep dns

kubectl exec -it busybox --nslook nginx

### ingress
kubectl expose deployment ghost --port=2368

kubectl proxy
curl -H "Contect-Type: application/json" -X POST --data @binding.json

## rbac
kubectl create role fluent-reader --verb=get --verb=list --verb=watch --resource=pod
kubectl create rolebinding foo --role=fluent-reader --user=kube
kubectl get rolebinding foo -o yaml

requiredDuringScheduling(hard)
prefferedDuringScheduling(soft)

PodAffinity = place pods together

PodAntiAffinity - ensures pods donot run on same node

Taints - apply on nodes - repel pods
kubectl taint nodes node1 key=value:NoSchedule

Tolerations - apply on pods - allow pods to tolerate taints

configmap - change config withour rebuilding image

kind: Deployment
spec: 
    replicas: 3

## frontend-> backend -> db flow
user -> lb svc -> frontnd pod(clusterip) -> backend pod(clusterip) -> db pod

## pv, pvc
pod -> pvc -> pv

## headless svc
clusterIP: None = statefulset direct pod DNS

full connectivity flow
user -> aws lb -> frontend pods(clusterip svc) -> backend pods(headless svc) -> mysql statefulset -> ebs vol.

## real flow end to end
developer -> dockerfile -> docker build -> docker image -> image registry(ecr/acr/hub) -> k8s pull images -> container runtime runs container

# how backend connects to rds
eks node sg -> rds sg(3306)
backend pod -> rds dns(direct)

user -> aws lb -> frontnd pod -> backend svc(clusterip) -> backend pod -> rds endpoint(managed db)

pod -> backend -> rds flow
pod eni ip (10.0.3.x) - routetable(local) - rdsip(10.0.5.x) - mysql

user -> frontend flow
browser -> internet -> alb(pub sub) - nodeport/podIP - frontend pod

aws iam + k8s rbac + aws-auth + irsa

## permissions
AmazonEKSClusterPolicy
AmazonEKS_CNI_Policy
AmazonEC2ContainerRegistryReadOnly

## aws-auth
namespace: kube-system
name: aws-auth

## node role mapping(mandatory)
mapRoles: |
    - rolearn: arn:aws:iam::<ACC_ID>:role/eks-nodegroup-role
    username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes

## EKS
kubectl get pods - cli calls - eks:GetToken

## map admin iam role
mapRoles: |
    - rolearn: arn:aws:iam::<ACC_ID>:role/platform-admin
    username: admin
      groups:
        - system:masters

## iam role : cicd-deployer role
eks:GetToken
sts:AssumeRol
mapped in aws-auth
mapRoles: |
    - rolearn: arn:aws:iam:<ACC_ID>:role/ci-cd-deployer-role
    username: cicd
    groups:
      - deployers

## backend connectivity 
backend pod -> pod eni ip (10.0.3.x) -> vpc route table -> rds eni(10.0.5.x) - mysql engine

## backend config(helm values)
db:
    host: mysql.cle2abcv.ap-suuth-1.rds.amazonaws.com

## 
until nc -z mydb.cleabc.ap-south-1.rds.amazonaws.com 3306; do sleep 5; done

## pooling
RDS max_connections = 500
backend pods = 10
connections per pod = 40
total = 400(safe)

subnet tagging
pub sub must have
kubernetes.io/role/elb = 1
kubernetes.io/cluster/<cluster_name> = owned

alb-ingress-controller-role

alb.ingress.kubernetes.io/scheme: internet-facing

alb.ingress.kubernetes.io/target-type: ip

alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80},{"HTTPS":443}]'

alb.ingress.kubernetes.io/certificat-arn: arn:aws:acm...

user = app.company.com -> dns -> alb dns -> alb -> pod ip

CNAME app.company.com -> k8s-prod-alb-12.elb.amazonaws.com

alb.ingress.kubernetes.io/wafv2-acl-arn: arn:aws:wafv2..

kubectl get ingress
kubectl describe ingress app-ingress
kubectl logs -n kube-system deploy/aws-load-balancer-controller

browser -> public dns(route53) -> alb dns name -> alb listener(443) -> tls termination(acm) -> target group -> pod ip(frontend)

domain: company.com
hostedzone: company.com

subdomain = app.company.com, api.company.com

kuectl -> iam -> eks api server




