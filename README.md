# Mini Projet Flutter

Application Flutter connectée à une API Flask (authentification + catalogue produits).

## Prérequis

- [Python 3](https://www.python.org/) installé
- [Flutter](https://docs.flutter.dev/get-started/install) installé
- Un terminal (PowerShell, CMD, etc.)

## 1. Lancer le serveur Flask

Ouvrez un **premier terminal** :

```bash
cd projet_devoir
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
cd server
python server.py
```

Le serveur démarre sur **http://localhost:5000**.

Laissez ce terminal ouvert tant que vous utilisez l'application.

## 2. Lancer l'application Flutter

Ouvrez un **second terminal** :

```bash
cd mini_projet
flutter pub get
flutter run -d chrome
```

Autres plateformes possibles :

```bash
flutter run -d windows    # Application Windows
flutter run -d android    # Émulateur ou téléphone Android
```

## 3. Se connecter

Identifiants de test :

| Email | Mot de passe |
|---|---|
| `jonny@example.com` | `motdepasse123` |
| `marie.martin@example.com` | `motdepasse123` |

## Fonctionnement

1. **Connexion** : l'app envoie les identifiants à `POST /api/login`
2. **Session** : en cas de succès, les infos utilisateur sont sauvegardées localement (`shared_preferences`)
3. **Produits** : la liste est chargée via `GET /api/produits`
4. **Déconnexion** : supprime la session et retourne à l'écran de connexion
5. **Auto-login** : si une session existe déjà, l'app ouvre directement la liste des produits

## API disponible

| Méthode | Route | Description |
|---|---|---|
| POST | `/api/login` | Connexion |
| GET | `/api/produits` | Liste des produits |
| GET | `/api/produits/<id>` | Détail d'un produit |

## Dépannage

**« Impossible de contacter le serveur »**

- Vérifiez que le serveur Flask tourne (`python server.py`)
- Sur **Chrome / Windows** : l'URL utilisée est `http://localhost:5000`
- Sur **émulateur Android** : l'URL utilisée est `http://10.0.2.2:5000`
- Relancez l'app après un changement : `flutter run -d chrome`

**Erreur CORS sur le web**

- Redémarrez le serveur Flask après modification de `server.py`
# mini_projet
