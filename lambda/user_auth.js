const jwt = require("jsonwebtoken");

const SECRET_KEY = process.env.JWT_SECRET_KEY;

exports.handler = async (event) => {
  try {
    if (!SECRET_KEY) {
      console.error("Environment variable JWT_SECRET_KEY is not set");
      return false;
    }

    const { action, resource, token } = JSON.parse(event.body);

    // Validate required fields
    if (!action || !resource || !token) {
      console.error("Missing required fields: action, resource, or token");
      return false;
    }

    // Verify and decode the JWT token
    let decodedToken;
    try {
      decodedToken = jwt.verify(token, SECRET_KEY);
    } catch (err) {
      console.error("Invalid or expired token");
      return false;
    }

    console.info("Token verified successfully:", decodedToken);

    // Handle DELETE action
    if (action === "DELETE") {
      // Check permissions
      if (decodedToken.role === "admin") {
        // Admin can delete any resource
        return true;
      } else if (decodedToken.role === "user" && decodedToken.id === resource) {
        // Users can only delete their own resource
        return true;
      } else {
        console.error("Permission denied for user:", decodedToken.id);
        return false;
      }
    } else {
      console.error("Unsupported action:", action);
      return false;
    }
  } catch (error) {
    console.error("Unhandled error in handler:", error);
    return false;
  }
};
