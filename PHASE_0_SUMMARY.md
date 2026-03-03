# Phase 0 Summary: Baseline Assessment & Architecture

## **Your Project Decisions** ✅ LOCKED IN

| Aspect | Decision |
|--------|----------|
| **Git Provider** | GitHub + GitHub Actions |
| **Container Registry** | GitHub Container Registry (ghcr.io) |
| **Kubernetes Cluster** | kind/minikube (local, free, scalable to EKS later) |
| **AWS Budget** | $0 for now (all local) – Terraform/EKS infrastructure deferred |
| **Infrastructure-as-Code** | Terraform (future Phase 10, for EKS migration) |
| **CI/CD Strategy** | GitHub Actions workflows |
| **Learning Timeline** | 10 phases, ~4–6 weeks (part-time) |

---

## **Recommended Architecture**

Your system will look like this:

```
┌─ GitHub Codespaces (Ubuntu 24.04 LTS) ─────────────────────────────┐
│                                                                       │
│  ┌─ Local kind Cluster (K8s) ─────────────────────────────────────┐ │
│  │                                                                  │ │
│  │  • flux-system namespace (FluxCD controllers)                   │ │
│  │  • flux-<app>-dev namespace (app deployments)                   │ │
│  │  • flux-<app>-prod namespace (app deployments)                  │ │
│  │                                                                  │ │
│  │  Flux watches GitOps repo for changes ───────┐                │ │
│  │                                               ↓                │ │
│  └───────────────────────────────────────────────┼────────────────┘ │
│                                                   │                   │
│    ┌──────────────────────────────────────────────┴──────────────┐  │
│    │                                                              │  │
│    │  GitHub Repositories (all in one GitHub account):          │  │
│    │                                                              │  │
│    │  1. Application Repo (e.g., "sample-app")                  │  │
│    │     ├─ src/ (app code)                                     │  │
│    │     ├─ Dockerfile                                          │  │
│    │     ├─ appInfo.json (app metadata)                         │  │
│    │     ├─ environmentInfo.json (dev/prod settings)            │  │
│    │     ├─ build.json (build config)                           │  │
│    │     └─ .github/workflows/ (GitHub Actions triggers)        │  │
│    │                                                              │  │
│    │  2. GitOps Repo (e.g., "flux-manifests")                   │  │
│    │     ├─ apps/sample-app/dev/kustomization.yaml             │  │
│    │     ├─ apps/sample-app/prod/kustomization.yaml            │  │
│    │     ├─ clusters/local-kind/sources.yaml                   │  │
│    │     └─ clusters/local-kind/kustomization.yaml             │  │
│    │        (Flux sources config to watch this repo)             │  │
│    │                                                              │  │
│    │  GitHub Container Registry (ghcr.io)                        │  │
│    │  ├─ ghcr.io/<username>/sample-app:latest                  │  │
│    │  ├─ ghcr.io/<username>/sample-app:abc1234                 │  │
│    │  └─ (image artifacts from CI builds)                       │  │
│    │                                                              │  │
│    └──────────────────────────────────────────────────────────┘  │
│                                                                     │
│  GitHub Actions Workflows Triggered On:                           │
│  • Push to app repo → build-app-image → push image to ghcr.io    │
│  • New image pushed → deploy-image → update GitOps repo          │
│  • Config change → manage-namespace → update manifests            │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## **How Data Flows**

1. **You code** → Push to application repo
2. **GitHub Actions triggers** → build-app-image workflow
3. **Build & push** → Image lands in ghcr.io with a tag (git SHA or version)
4. **Next job runs** → deploy-image workflow updates GitOps repo with new image tag
5. **Flux sees change** → Automatically syncs from GitOps repo
6. **Deployment rolls out** → New pod with new image starts in the cluster

---

## **Required Tools** (Pre-installed in Codespaces)

✓ kubectl, kind, helm, flux, git, docker, python3, yq, jq

See [TOOLS.md](TOOLS.md) for verification and installation steps.

---

## **Next Steps (Phase 1)**

1. **Verify tools**: Run the verification script from [TOOLS.md](TOOLS.md)
2. **Create kind cluster**: `kind create cluster --name flux-learning`
3. **Install Flux**: `flux install`
4. **Test with "hello world"** deployment to confirm Flux works
5. **Report back** with verification outputs

Detailed walkthrough in [PHASE_1_LOCAL_SETUP.md](PHASE_1_LOCAL_SETUP.md)

---

## **Key Design Decisions**

### **Why kind/minikube first, not EKS?**
- **Zero AWS cost** (no credit card charges for learning)
- **Instant cluster** (creates in <2 min vs. 15 min for EKS)
- **Perfect for learning** FluxCD, pipelines, config schemas
- **Scalable to EKS** (when you have budget, we'll just swap the cluster endpoint)

### **Why GitHub not GitLab?**
- **Native Codespaces** integration
- **Free Container Registry** (ghcr.io)
- **GitHub Actions** (built-in, zero setup)
- **Simpler for learning** (fewer systems to manage)

### **Why these pipelines (manage-namespace, build-app-image, deploy-image)?**
- They match the **ArgoPlatform** patterns you're studying
- They separate concerns:
  - **manage-namespace** = infrastructure (namespaces, RBAC, Flux setup)
  - **build-app-image** = app compilation (Docker, registry)
  - **deploy-image** = rollout (GitOps update, automated by Flux)
- They're **reusable** for multiple apps

---

## **Future Scaling (Phase 10+)**

When you're ready and have AWS budget:
- Replace kind cluster with **small EKS cluster** (same deployments, same workflows)
- Add **Route 53 DNS** and **ACM TLS certificates**
- Add **AWS Load Balancer Controller** for Ingress
- Add **CloudWatch** for logging/metrics
- Add **Terraform** for IaC-managed infrastructure
- Reuse **all pipelines** (no changes needed)

---

## **Project Tracking**

- Main checklist: [PROJECT_CHECKLIST.md](PROJECT_CHECKLIST.md)
- Phase 1 details: [PHASE_1_LOCAL_SETUP.md](PHASE_1_LOCAL_SETUP.md)
- Tools guide: [TOOLS.md](TOOLS.md)
- System prompt (your blueprint): [System-prompt.md](System-prompt.md)

---

## **Ready?**

You're all set for Phase 1! Start with [PHASE_1_LOCAL_SETUP.md](PHASE_1_LOCAL_SETUP.md).

**Questions before you start?** Feel free to ask, but I recommend diving in and hitting the first checkpoint (kind cluster + Flux running). 🚀
