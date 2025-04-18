// const admin = require('firebase-admin');
//      const serviceAccount = require('./Users/Min_Nahna/Downloads/flutter-pharmacie-firebase-adminsdk-lqef5-36b057ed6e.json'); // Téléchargez cette clé depuis Firebase Console > Paramètres du projet > Comptes de service
//      const fs = require('fs');

//      admin.initializeApp({
//        credential: admin.credential.cert(serviceAccount)
//      });

//      const db = admin.firestore();

//      const data = JSON.parse(fs.readFileSync('./Users/Min_Nahna/Downloads/Development/copy_pharmacie/firestore-import/index.js', 'utf8'));

//      data.forEach((item) => {
//        db.collection('users').add(item)
//          .then(() => console.log('Document added successfully'))
//          .catch((error) => console.error('Error adding document: ', error));
//      });


/Users/Min_Nahna/Downloads/tableConvert.com_gthqh8.json