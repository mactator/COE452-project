const jwt = require("jsonwebtoken");
const AWS = require("aws-sdk");
const dynamoDB = new AWS.DynamoDB.DocumentClient();
const bcrypt = require("bcryptjs");

const SECRET_KEY = process.env.JWT_SECRET_KEY;
const USERS_TABLE = process.env.USERS_TABLE;

exports.handler = async (event) => {
  try {
    if (!SECRET_KEY || !USERS_TABLE) {
      console.error("Environment variables JWT_SECRET_KEY or USERS_TABLE are not set");
      return {
        statusCode: 500,
        body: JSON.stringify({
          message: "Internal Server Error: Configuration missing",
        }),
      };
    }

    const body = JSON.parse(event.body);

    // Validate required fields for login
    if (!body.email || !body.password) {
      console.error("Missing required fields: email or password");
      return {
        statusCode: 400,
        body: JSON.stringify({ message: "Email and password are required" }),
      };
    }

    // Fetch user from DynamoDB
    const params = {
      TableName: USERS_TABLE,
      Key: {
        email: body.email,
      },
    };

    let user;
    try {
      const result = await dynamoDB.get(params).promise();
      user = result.Item;
      if (!user) {
        console.error("User not found for email:", body.email);
        return {
          statusCode: 401,
          body: JSON.stringify({ message: "Invalid email or password" }),
        };
      }
    } catch (dbError) {
      console.error("Error retrieving user from DynamoDB:", dbError);
      return {
        statusCode: 500,
        body: JSON.stringify({ message: "Internal Server Error" }),
      };
    }

    // Verify password
    const validPassword = await bcrypt.compare(body.password, user.password);
    if (!validPassword) {
      console.error("Invalid password for user:", body.email);
      return {
        statusCode: 401,
        body: JSON.stringify({ message: "Invalid email or password" }),
      };
    }

    // Generate JWT token
    const token = jwt.sign(
      { id: user.id, email: user.email, role: user.role },
      SECRET_KEY,
      { expiresIn: "1h" }
    );

    console.info("User authenticated successfully:", user.email);
    return {
      statusCode: 200,
      body: JSON.stringify({
        message: "Authentication successful",
        token: token,
      }),
    };
  } catch (error) {
    console.error("Unhandled error in auth handler:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "Internal Server Error",
        error: error.message,
      }),
    };
  }
};
