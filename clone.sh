#!/bin/bash

read -p "URL du dépôt public à cloner : " PUBLIC_REPO
read -p "Nom du dossier local (ou vide pour nom auto) : " LOCAL_FOLDER
read -p "URL du dépôt privé (HTTPS avec .git à la fin) : " PRIVATE_REPO

# Authentification GitHub
if [[ "$PRIVATE_REPO" == https://* ]]; then
  read -p "Nom d'utilisateur GitHub : " GITHUB_USER
  read -s -p "Token GitHub (PAT si 2FA activé) : " GITHUB_TOKEN
  echo
  PRIVATE_REPO=$(echo "$PRIVATE_REPO" | sed "s|https://|https://$GITHUB_USER:$GITHUB_TOKEN@|")
fi

# Nom de dossier local
if [ -z "$LOCAL_FOLDER" ]; then
  LOCAL_FOLDER=$(basename "$PUBLIC_REPO" .git)
fi

echo "[+] Clonage de $PUBLIC_REPO..."
git clone "$PUBLIC_REPO" "$LOCAL_FOLDER" || { echo "[!] Échec du clonage."; exit 1; }

cd "$LOCAL_FOLDER" || exit 1

# Détection de la branche par défaut AVANT suppression d'origin
DEFAULT_BRANCH=$(git remote show origin | grep 'HEAD branch' | awk '{print $NF}')
if [ -z "$DEFAULT_BRANCH" ]; then
  echo "[!] Aucune branche par défaut trouvée. Tentative avec 'main'..."
  DEFAULT_BRANCH="main"
fi

# S'assurer d’être sur la bonne branche
git checkout "$DEFAULT_BRANCH" 2>/dev/null || {
  echo "[!] La branche '$DEFAULT_BRANCH' n'existe pas localement."
  echo "[i] Branches disponibles :"
  git branch -a
  exit 1
}

# Changer l'origine
git remote remove origin 2>/dev/null
git remote add origin "$PRIVATE_REPO"

# Pousser vers le dépôt privé vide
echo "[+] Push vers le dépôt privé (branche $DEFAULT_BRANCH)..."
git push -u origin "$DEFAULT_BRANCH"

echo "[✓] Transfert effectué avec succès."

