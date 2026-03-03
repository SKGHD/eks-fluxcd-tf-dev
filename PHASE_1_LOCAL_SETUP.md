# Phase 1: Local Environment & AWS Setup (Learning Version)

## **Phase Goal** (2–4 hours)
Set up a fully functional local Kubernetes cluster with FluxCD running in your Codespaces. By the end, you'll have a "hello world" app deployed via Flux to confirm everything works.

---

## **What We're Building**

```
GitHub Codespaces (Ubuntu 24.04)
  ↓
kind cluster (1 control-plane, 1 worker or just control-plane)
  ↓
flux-system namespace (FluxCD controllers)
  ↓
flux-hello-world namespace
  ↓
hello-world Deployment + Service (to verify Flux is working)
```

---

## **Step-by-Step Implementation**

### **Step 1: Verify All Tools Are Installed** (5 min)

Run the verification script from TOOLS.md:
```bash
chmod +x tools-verify.sh
./tools-verify.sh
```

**Expected output**: ✓ for all 9 core tools (kubectl, kind, helm, flux, git, docker, python3, yq, jq)

**If any fail**: Follow the install instructions in TOOLS.md and re-run.

---

### **Step 2: Create a Kind Cluster** (5–10 min)

**Why kind?** Lightweight, runs on your machine, no AWS cost, perfect for learning.

**Create the cluster:**
```bash
kind create cluster --name flux-learning --image kindest/node:v1.33.1
```

**Verify it's running:**
```bash
kubectl cluster-info
kubectl get nodes
```

**Expected output:**
```
NAME                             STATUS   ROLES           AGE     VERSION
flux-learning-control-plane      Ready    control-plane   2m      v1.33.1
```

---

### **Step 3: Install FluxCD Into the Cluster** (10 min)

**Bootstrap Flux:**

First, you'll need:
- A GitHub repo for GitOps (to be created in Phase 2, but we can set up a placeholder now)
- A GitHub Personal Access Token (see TOOLS.md)

For now, let's do a **manual bootstrap** (we'll use GitHub Actions later):

```bash
# Set these to your GitHub details:
export GITHUB_USER=<your-github-username>
export GITHUB_TOKEN=<your-PAT-from-TOOLS.md>
export GITHUB_REPO=flux-manifests  # Name of your GitOps repo (create it first!)

# Install Flux manually (we'll sync with GitHub repo in Phase 2)
flux install --namespace=flux-system

# Verify Flux is running:
kubectl get deploy -n flux-system
kubectl logs -n flux-system deploy/source-controller (optional, to see it's happy)
```

**Expected Flux components:**
- `source-controller` – watches Git repos
- `kustomize-controller` – applies Kustomizations
- `helm-controller` – applies Helm releases
- `notification-controller` – event notifications

**Verify:**
```bash
kubectl get all -n flux-system
```

---

### **Step 4: Create a Test "Hello World" Namespace & Deployment** (10 min)

Create a simple test deployment to verify Flux can apply manifests.

**Create local manifests directory:**
```bash
mkdir -p ~/flux-test-manifests
cd ~/flux-test-manifests
```

**Create namespace manifest (namespace.yaml):**
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: flux-hello-world
```

**Create a simple Deployment (deployment.yaml):**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world
  namespace: flux-hello-world
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-world
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
      - name: hello-world
        image: nginx:latest
        ports:
        - containerPort: 80
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 10
          periodSeconds: 5
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 3
```

**Create a Service (service.yaml):**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: hello-world
  namespace: flux-hello-world
spec:
  type: LoadBalancer
  selector:
    app: hello-world
  ports:
  - port: 80
    targetPort: 80
```

**Apply these manually first (to verify cluster works):**
```bash
kubectl apply -f namespace.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

**Verify:**
```bash
# Check namespace created
kubectl get ns | grep hello-world

# Check pod is running
kubectl get pods -n flux-hello-world

# Check service
kubectl get svc -n flux-hello-world
```

**Expected output:**
```
NAME                  READY   STATUS    RESTARTS   AGE
hello-world-xxxxx     1/1     Running   0          1m

NAME          TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
hello-world   LoadBalancer   10.96.100.50   <pending>     80:31234/TCP   1m
```

(Note: In kind, `EXTERNAL-IP` will show as `<pending>`. That's normal. We can port-forward to test.)

---

### **Step 5: Test the Deployment is Accessible** (5 min)

**Port-forward to the service:**
```bash
kubectl port-forward -n flux-hello-world svc/hello-world 8080:80 &
```

**Test with curl:**
```bash
curl http://localhost:8080
```

**Expected**: You should see the nginx welcome page HTML.

---

### **Step 6: Clean Up & Prepare for Phase 2** (5 min)

Delete the test manifests (we'll set them up via Flux in Phase 2):
```bash
kubectl delete -f ~/flux-test-manifests/
```

**Verify Flux is still running:**
```bash
kubectl get deploy -n flux-system
```

---

## **Validation Checklist** ✓

- [ ] `kubectl cluster-info` shows kind cluster is active
- [ ] `kubectl get nodes` shows at least 1 Ready node
- [ ] `flux check --pre` shows no errors
- [ ] `kubectl get deploy -n flux-system` shows 4–5 Flux controllers Running
- [ ] Hello-world deployment ran and pod became Ready
- [ ] Service was created and accessible via port-forward
- [ ] Flux is healthy and ready to sync manifests

---

## **Common Issues & Troubleshooting**

### **Issue: Kind cluster creation fails**
```bash
# Check if Docker is running:
docker ps

# If Docker not running:
sudo systemctl start docker
```

### **Issue: Flux install fails or pods don't start**
```bash
# Check flux logs:
kubectl logs -n flux-system deploy/source-controller
kubectl logs -n flux-system deploy/helmrepo-controller

# Restart flux:
kubectl rollout restart deploy -n flux-system
```

### **Issue: Pod doesn't become Ready**
```bash
# Check pod details:
kubectl describe pod hello-world-xxxxx -n flux-hello-world

# Check logs:
kubectl logs hello-world-xxxxx -n flux-hello-world
```

---

## **Next: Phase 2**

Once Phase 1 is complete, we'll:
1. Create two GitHub repos:
   - **Application repo** (for sample app code, Dockerfile, configs)
   - **GitOps repo** (for Flux manifests that Flux will watch)
2. Set up Flux to watch the GitOps repo
3. Create a GitHub Actions workflow to build and push a test image

---

## **Homework Check**

When Phase 1 is complete, verify:
- [ ] Show me output of: `kind get clusters`
- [ ] Show me: `kubectl get nodes`
- [ ] Show me: `kubectl get all -n flux-system`
- [ ] Show me: `flux check`

**Ready for Phase 2 when all are ✓**


**bootstrap Flux to connect to your GitOps repo and complete Phase 1:**

flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=$GITHUB_REPO \
  --branch=main \
  --path=./clusters/local-kind \
  --personal

**Verify**
flux check && echo "---" && kubectl get all -n flux-system && echo "---" && flux get sources git && flux get kustomizations

## What Flux Just Did
## When you ran flux bootstrap github, it:

Created flux-system namespace in your cluster
Installed Flux controllers (source, kustomize, helm, notification)
Committed Flux manifests to flux-manifests repo at clusters/local-kind/
Created a deploy key in your GitHub repo (check repo Settings → Deploy keys)
Set up GitRepository and Kustomization resources to auto-sync
Now: Any YAML you commit to flux-manifests/clusters/local-kind/ will automatically deploy to your cluster! 🎯

