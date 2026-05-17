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

