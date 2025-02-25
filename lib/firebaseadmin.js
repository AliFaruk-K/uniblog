
const admin = require('firebase-admin');
const serviceAccount = require("C:\\Users\\talha\\Downloads\\uniblogg-bf251-firebase-adminsdk-fbsvc-9d5ed90b0c.json"); // JSON dosyasının yolu

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: 'https://uniblogg-bf251-default-rtdb.europe-west1.firebasedatabase.app', // Firebase projenizin veritabanı URL'si
});

// Firebase Firestore kullanma örneği:
const db = admin.firestore();

async function getData() {
    const snapshot = await db.collection('users').get();
    snapshot.forEach(doc => {
        console.log(doc.id, '=>', doc.data());
    });
}

getData();
