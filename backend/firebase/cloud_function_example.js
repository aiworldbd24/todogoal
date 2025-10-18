/**
 * Firebase Cloud Function example to mirror Hostinger API functionality.
 */
const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
const db = admin.firestore();

exports.syncTask = functions.https.onRequest(async (req, res) => {
  if (req.method === 'OPTIONS') {
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'POST, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type');
    res.status(204).send('');
    return;
  }

  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }

  try {
    const payload = req.body;
    await db.collection('tasks').doc(payload.id).set(payload);
    res.json({ status: 'ok', id: payload.id });
  } catch (error) {
    functions.logger.error('Failed to sync task', error);
    res.status(500).json({ error: error.message });
  }
});
