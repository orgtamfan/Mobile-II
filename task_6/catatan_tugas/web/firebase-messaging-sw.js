importScripts(
  'https://www.gstatic.com/firebasejs/10.13.2/firebase-app-compat.js',
);
importScripts(
  'https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging-compat.js',
);

firebase.initializeApp({
  apiKey: 'AIzaSyAUzaLtPLoK0FMjzcLYE_xvPlXAxJNWVsc',
  appId: '1:548593578568:web:821ebaa57a0dd9a2e61e7d',
  messagingSenderId: '548593578568',
  projectId: 'olan-ajah',
  authDomain: 'olan-ajah.firebaseapp.com',
  storageBucket: 'olan-ajah.firebasestorage.app',
});

firebase.messaging();
