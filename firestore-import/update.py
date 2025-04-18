import firebase_admin
from firebase_admin import credentials, firestore
import random

# Initialiser Firebase Admin
cred = credentials.Certificate("/Users/Min_Nahna/Downloads/flutter-pharmacie-firebase-adminsdk-lqef5-c83f8969ef.json")  # Remplace avec ton fichier JSON
firebase_admin.initialize_app(cred)

db = firestore.client()

def update_status():
    docs = db.collection("users").where("status", "==", "unknown").stream()
    
    for doc in docs:
        new_status = random.choice(["open", "close"])
        doc.reference.update({"status": new_status})
        print(f"Updated {doc.id} to {new_status}")

update_status()
