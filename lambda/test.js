const jwt = require("jsonwebtoken");

const secretKey = "07916a11c0a168104468e6ef39f463c49c4448e2e80f595a8fb084304ac97557902ed16454eefc0be817949cdc2463f1750686131e0e53f1d5060d371ac57c80"; // Replace with your actual secret key
const payload = {
  id: "user123", // User's ID
  role: "user"   // User's role (e.g., "admin" or "user")
};

const token = jwt.sign(payload, secretKey, { expiresIn: "1h" }); // Token valid for 1 hour
console.log("Generated Token:", token);
