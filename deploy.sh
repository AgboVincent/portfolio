#!/usr/bin/env bash
# Publishes this folder to GitHub Pages at https://agbovincent.github.io/portfolio/
# Needs: git, and the GitHub CLI (brew install gh && gh auth login)
set -e
cd "$(dirname "$0")"
rm -f site.tgz
REPO=portfolio
git init -q 2>/dev/null || true
git checkout -q -B main
git add index.html .nojekyll lab media deploy.sh
git commit -qm "Portfolio with AI Lab prototypes" || true
if ! gh repo view "AgboVincent/$REPO" >/dev/null 2>&1; then
  gh repo create "AgboVincent/$REPO" --public --source=. --remote=origin --push
else
  git remote get-url origin >/dev/null 2>&1 || git remote add origin "https://github.com/AgboVincent/$REPO.git"
  git push -u origin main
fi
gh api -X POST "repos/AgboVincent/$REPO/pages" -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 || true
echo "Live in about a minute at: https://agbovincent.github.io/$REPO/"
