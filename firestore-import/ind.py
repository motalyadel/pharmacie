# import pandas as pd
# import firebase_admin
# from firebase_admin import credentials, firestore

# # 1. Initialiser Firebase
# def initialize_firebase():
#     if not firebase_admin._apps:
#         cred = credentials.Certificate('/Users/Min_Nahna/Downloads/flutter-pharmacie-firebase-adminsdk-lqef5-c83f8969ef.json')
#         firebase_admin.initialize_app(cred)

# # 2. Lire le fichier Excel
# def read_excel():
#     # Lire le fichier Excel
#     df = pd.read_excel("/Users/Min_Nahna/Downloads/pharmacies.xlsx")
#     # Convertir le DataFrame en liste de dictionnaires
#     data = df.to_dict(orient='records')
#     return data

# # 3. Importer les données dans Firestore
# def import_to_firestore(collection_name, data):
#     db = firestore.client()
#     for item in data:
#         db.collection(collection_name).add(item)
#         print(f"Document ajouté : {item}")

# # 4. Fonction principale
# def main():
#     # Chemin vers la clé de service Firebase
#     service_account_key_path = "chemin/vers/votre/serviceAccountKey.json"
    
#     # Chemin vers le fichier Excel
#     excel_file_path = "chemin/vers/votre/fichier.xlsx"
    
#     # Nom de la collection Firestore
#     collection_name = "nom_de_votre_collection"

#     # Initialiser Firebase
#     initialize_firebase(service_account_key_path)

#     # Lire le fichier Excel
#     data = read_excel(excel_file_path)

#     # Importer les données dans Firestore
#     import_to_firestore(collection_name, data)

# if _name_ == "_main_":
#     main()

# ********************************

import pandas as pd
import firebase_admin
from firebase_admin import credentials, firestore

# إعداد Firebase Admin SDK
cred = credentials.Certificate("/Users/Min_Nahna/Downloads/flutter-pharmacie-firebase-adminsdk-lqef5-c83f8969ef.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

# قراءة ملف Excel
excel_file = "/Users/Min_Nahna/Downloads/pharmacies.xlsx"
data = pd.read_excel(excel_file)

# طباعة أسماء الأعمدة للتأكد
print(data.columns)

# استيراد البيانات إلى Firestore
collection_name = "users"

for index, row in data.iterrows():
    document_data = {
        "name": row["Nom"],  # العمود 'Nom' للصيدلية
        "city": row["Wilaya"],  # العمود 'Wilaya' للمدينة
        "region": row["Commune"],  # العمود 'Commune' للمنطقة
        "status": "unknown",  # إذا كنت لا تملك حالة الصيدلية يمكنك استخدام "unknown"
        "coordinates": {
            "latitude": row["Latitude"],  # العمود 'Latitude' للخط العرض
            "longitude": row["Longitude"]  # العمود 'Longitude' للطول الجغرافي
        }
    }
    db.collection(collection_name).add(document_data)
    print(f"تمت إضافة الصيدلية: {row['Nom']}")

print("تم استيراد جميع البيانات بنجاح!")


