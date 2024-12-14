const AWS = require("aws-sdk");
const dynamoDB = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
  try {
    const tableName = process.env.USERS_TABLE;

    // Check if the environment variable is set
    if (!tableName) {
      console.error("Environment variable USERS_TABLE is not set");
      return {
        statusCode: 500,
        body: JSON.stringify({
          message: "Internal Server Error: USERS_TABLE not configured",
        }),
      };
    }

    // Parse the request body
    let body;
    try {
      body = JSON.parse(event.body);
    } catch (parseError) {
      console.error("Error parsing request body:", parseError);
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: "Invalid JSON format in request body",
        }),
      };
    }

    // Validate the required fields
    if (!body.id || !body.email || !body.name) {
      console.error("Missing required fields in request body:", body);
      return {
        statusCode: 400,
        body: JSON.stringify({ message: "Missing required fields" }),
      };
    }

    // Prepare DynamoDB put parameters
    const params = {
      TableName: tableName,
      Item: {
        id: body.id,
        email: body.email,
        name: body.name,
      },
    };

    // Attempt to save the item to DynamoDB
    try {
      await dynamoDB.put(params).promise();
      console.info("User saved to DynamoDB:", params.Item);
      return {
        statusCode: 201,
        body: JSON.stringify({ message: "User created successfully" }),
      };
    } catch (dynamoError) {
      console.error("Error saving to DynamoDB:", dynamoError);
      return {
        statusCode: 500,
        body: JSON.stringify({
          message: "Internal Server Error: Unable to save user",
          error: dynamoError.message,
        }),
      };
    }
  } catch (error) {
    console.error("Unhandled error:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "Internal Server Error",
        error: error.message,
      }),
    };
  }
};
