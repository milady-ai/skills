#!/bin/bash
# Publish remaining skills to ClawHub (run after rate limit resets)
cd /tmp/milady-skills-repo

REMAINING=(
  "milady-development"
  "binance-query-address-info"
  "binance-query-token-audit"
  "binance-query-token-info"
  "binance-simple-earn"
  "binance-sub-account"
  "binance-tokenized-securities-info"
  "binance-vip-loan"
)

# Skills that need different slugs (taken by others)
SLUG_REMAP=(
  "bags:milady-bags"
  "moltbook:milady-moltbook"
)

echo "Publishing remaining skills..."
for skill in "${REMAINING[@]}"; do
  echo -n "$skill: "
  clawhub publish "$skill/" --version 1.0.0 --changelog "Initial release from milady-ai/skills" 2>&1 | grep -E "✔|Error" | head -1
  sleep 2
done

echo ""
echo "Publishing skills with remapped slugs..."
for entry in "${SLUG_REMAP[@]}"; do
  dir="${entry%%:*}"
  slug="${entry##*:}"
  echo -n "$dir → $slug: "
  clawhub publish "$dir/" --slug "$slug" --version 1.0.0 --changelog "Initial release from milady-ai/skills" 2>&1 | grep -E "✔|Error" | head -1
  sleep 2
done

echo ""
echo "Done. Check: clawhub search milady"
