from flask import Flask, jsonify, request
from flask_cors import CORS
import json, os

app = Flask(__name__)
CORS(app, resources={r"/api/*": {"origins": "*"}})

DATA_DIR = os.path.join(os.path.dirname(__file__), "data")


def load_json(filename):
    with open(os.path.join(DATA_DIR, filename), encoding="utf-8") as f:
        return json.load(f)


@app.route("/api/login", methods=["POST"])
def login():
    data = request.get_json(silent=True)

    if not data or "email" not in data or "password" not in data:
        return jsonify({"error": "Email et mot de passe requis"}), 400

    email = data.get("email")
    password = data.get("password")

    users = load_json("users.json")

    for user in users:
        if user["email"] == email and user["password"] == password:
          
            user_sans_mdp = {
                "id": user["id"],
                "email": user["email"],
                "nom": user["nom"],
                "prenom": user["prenom"],
            }
            return jsonify(user_sans_mdp), 200

    return jsonify({"error": "Email ou mot de passe incorrect"}), 401


@app.route("/api/produits", methods=["GET"])
def get_produits():
    produits = load_json("ventes.json")
    return jsonify(produits), 200


@app.route("/api/produits/<int:produit_id>", methods=["GET"])
def get_produit(produit_id):
    produits = load_json("ventes.json")

    for p in produits:
        if p["id"] == produit_id:
            return jsonify(p), 200

    return jsonify({"error": "Produit non trouvé"}), 404


@app.errorhandler(404)
def not_found(e):
    return jsonify({"error": "Route non trouvée"}), 404


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)