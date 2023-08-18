rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /predefined-data/predefined-categories {
      allow get: if request.auth != null;
    }
    match /predefined-data/predefined-exercises {
      allow get: if request.auth != null;
    }
    match /predefined-data/predefined-routines {
      allow get: if request.auth != null;
    }
    match /predefined-data/predefined-training-plans {
      allow get: if request.auth != null;
    }
    match /user-data/{user}/{document=**} {
      allow read, update, delete: if request.auth != null && request.auth.uid == user;
      allow create: if request.auth != null;
    }
    match /food-data/{barcode=**} {
      allow read, update: if request.auth != null;
      allow create: if request.auth != null;
    }
    match /recipe-data/{barcode=**} {
      allow read, update: if request.auth != null;
      allow create: if request.auth != null;
    }
  }
}