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
