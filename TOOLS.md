# Tools Installation & Verification Guide

## Overview
All these tools should be pre-installed in GitHub Codespaces (Ubuntu 24.04 LTS), but we'll verify each one and provide install commands if needed.

---

## **Core Tools**

### 1. **kubectl** – Kubernetes CLI
**Purpose**: Control and inspect Kubernetes clusters
```bash
# Verify installation
kubectl version --client -o json | jq '.clientVersion.gitVersion'

# If not installed (shouldn't be needed):
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

### 2. **kind** – Kubernetes in Docker
**Purpose**: Run local Kubernetes clusters in containers
```bash
# Verify
kind version

# If not installed:
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

### 3. **helm** – Kubernetes Package Manager
**Purpose**: Deploy Helm charts (we'll use for optional apps later)
```bash
# Verify
helm version

# If not installed:
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

### 4. **flux** – FluxCD CLI
**Purpose**: Bootstrap and manage Flux in cluster
```bash
# Verify
flux version

# If not installed:
curl -s https://fluxcd.io/install.sh | sudo bash
```

### 5. **git** – Version Control
**Purpose**: Clone repos, commit, push
```bash
# Verify
git --version

# Should be pre-installed in Codespaces
```

### 6. **docker** – Container Runtime
**Purpose**: Build and run containers (though kind provides its own)
```bash
# Verify
docker version

# Pre-installed in Codespaces
```

---

## **Utilities & Helpers**

### 7. **python3** – Scripting
**Purpose**: Automation scripts for JSON parsing, manifest generation
```bash
# Verify
python3 --version

# Pre-installed in Codespaces
```

### 8. **yq** – YAML Processor
**Purpose**: Edit/query YAML files programmatically
```bash
# Verify
yq --version

# If not installed:
curl -sL https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /usr/local/bin/yq
sudo chmod +x /usr/local/bin/yq
```

### 9. **jq** – JSON Processor
**Purpose**: Edit/query JSON files programmatically
```bash
# Verify
jq --version

# If not installed:
sudo apt-get update && sudo apt-get install -y jq
```

### 10. **kubectx / kubens** – (Optional but helpful)
**Purpose**: Easier Kubernetes context and namespace switching
```bash
# Verify
kubectx --version

# If not installed:
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
```

---

## **Quick Verification Script**

Run this in your terminal to verify all core tools:

```bash
#!/bin/bash
echo "=== Verifying Required Tools ==="
echo ""

tools=(
  "kubectl:kubectl version --client -o json | jq -r '.clientVersion.gitVersion'"
  "kind:kind version"
  "helm:helm version --short"
  "flux:flux --version"
  "git:git --version"
  "docker:docker --version"
  "python3:python3 --version"
  "yq:yq --version"
  "jq:jq --version"
)

for tool_check in "${tools[@]}"; do
  IFS=':' read -r tool cmd <<< "$tool_check"
  echo -n "Checking $tool... "
  if eval "$cmd" > /dev/null 2>&1; then
    echo "✓ INSTALLED"
    eval "$cmd"
  else
    echo "✗ NOT FOUND"
  fi
  echo ""
done

echo "=== Verification Complete ==="
```

Save as `tools-verify.sh`, then run:
```bash
chmod +x tools-verify.sh
./tools-verify.sh
```

---

## **GitHub Setup (Manual)**

### GitHub Personal Access Token (PAT)
Needed for pushing to private GitHub repos and Container Registry.

1. Go to: https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Name: `flux-cicd-learning`
4. Scopes needed:
   - `repo` (full control of private repos)
   - `write:packages` (push to Container Registry)
   - `read:packages` (pull from Container Registry)
   - `workflow` (run GitHub Actions)
5. Save the token in a safe place (you'll need it later)

### Store PAT in Codespaces

In your Codespaces terminal:
```bash
# Create a local .env file (do NOT commit this)
cat > ~/.github_token << EOF
GITHUB_TOKEN=<your-PAT-here>
GITHUB_USERNAME=<your-github-username>
EOF

chmod 600 ~/.github_token
```

Then load it when needed:
```bash
source ~/.github_token
```

---

## **Next Steps**

Once you've verified all tools, proceed to **Phase 1** to:
1. Create a kind cluster
2. Deploy FluxCD to it
3. Test a simple "hello world" app

Let me know when you've verified all tools! ✓
