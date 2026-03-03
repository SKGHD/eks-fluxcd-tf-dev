# EKS-FluxCD-Terraform Learning Project Checklist

## **Phase 0: Baseline assessment and choices** ✅ IN PROGRESS
- [x] **Decisions made**
  - Git provider: **GitHub + GitHub Actions**
  - Initial Kubernetes cluster: **kind/minikube** (local, cost-free)
  - Container registry: **GitHub Container Registry (ghcr.io)**
  - AWS budget: **None right now** (design for future EKS scaling)
  
- [ ] Install and verify all required tools (see TOOLS.md)
- [ ] Review and refine architecture diagram
- [ ] Create Phase 1 detailed plan

---

## **Phase 1: Local environment & AWS setup**
- [ ] Verify all tools installed and working
- [ ] Create kind/minikube cluster
- [ ] Test "hello world" namespace + deployment
- [ ] Set up GitHub credentials in Codespaces
- [ ] Create GitHub App or PAT for GitOps repo access

---

## **Phase 2: Git & registry setup**
- [ ] Create application repo (sample-app)
- [ ] Create GitOps repo (flux-manifests or similar)
- [ ] Set up GitHub Container Registry (create PAT)
- [ ] Create GitHub Actions workflow to build & push test image
- [ ] Verify image appears in ghcr.io

---

## **Phase 3: Define the app configuration model**
- [ ] Design appInfo.json schema
- [ ] Design environmentInfo.json schema
- [ ] Design build.json schema
- [ ] Create example JSONs for sample app
- [ ] Write CONFIG_MODEL.md documentation

---

## **Phase 4: Manage-namespace pipeline**
- [ ] Create manage-namespace GitHub Actions workflow
- [ ] Write Python/bash script to parse JSONs
- [ ] Script generates namespace YAML
- [ ] Script generates Flux HelmRelease/Kustomization manifests
- [ ] Test with sample app (dry-run first)
- [ ] Validate generated manifests with kubectl --dry-run=client

---

## **Phase 5: Build-app-image pipeline**
- [ ] Create sample app with Dockerfile
- [ ] Create build-app-image GitHub Actions workflow
- [ ] Implement image tagging strategy (git-sha or semver)
- [ ] Add basic "scan" placeholder step
- [ ] Test build and push to ghcr.io

---

## **Phase 6: Deploy-image pipeline**
- [ ] Create deploy-image GitHub Actions workflow
- [ ] Write script to update image tag in GitOps repo
- [ ] Implement commit & push with proper git configuration
- [ ] Set up Flux to auto-reconcile on push
- [ ] Test end-to-end image update → Flux deployment

---

## **Phase 7: End-to-end onboarding**
- [ ] Run manage-namespace pipeline for sample app
- [ ] Run build-app-image pipeline
- [ ] Run deploy-image pipeline
- [ ] Verify Flux applied manifests
- [ ] Verify app is running and reachable
- [ ] Debug common failure modes

---

## **Phase 8: DNS and TLS (simplified)**
- [ ] Create Ingress or LoadBalancer Service manifest
- [ ] Set up local /etc/hosts entry (or Route 53 if EKS later)
- [ ] Create self-signed certificate for testing
- [ ] Configure TLS in Ingress
- [ ] Verify HTTPS access

---

## **Phase 9: Observability basics**
- [ ] Verify application logs visible (kubectl logs)
- [ ] Add readiness/liveness probes to Deployment
- [ ] Set up basic health checks
- [ ] Optionally: add Prometheus/Grafana outline

---

## **Phase 10: Architecture review and extensions**
- [ ] Review against ArgoPlatform concepts
- [ ] Outline where WAF would fit (future EKS)
- [ ] Design for multi-app / multi-environment scaling
- [ ] Plan robustness improvements
- [ ] Suggest next exercises

---

## **Key Decisions Reference**

| Aspect | Choice | Rationale |
|--------|--------|-----------|
| Git provider | GitHub | Native Codespaces, GitHub Actions, free |
| K8s cluster | kind/minikube (local) | Zero AWS cost, fast, ideal for learning |
| Registry | ghcr.io (GitHub Container Registry) | Free, private, integrated with GitHub |
| Budget | $0 for now | Design scalable; migrate to EKS later |
| Infrastructure-as-code | Terraform (for future EKS phase) | Already mentioned in learning resource |
| CI strategy | GitHub Actions | Native GitHub integration |

---

## **Resources & Links**
- System Prompt: [System-prompt.md](System-prompt.md)
- Tools & Installation: [TOOLS.md](TOOLS.md) (to be created in Phase 1)
- Config Model Documentation: [CONFIG_MODEL.md](CONFIG_MODEL.md) (to be created in Phase 3)
- Sample App Repo: (to be created in Phase 2)
- GitOps Repo: (to be created in Phase 2)
