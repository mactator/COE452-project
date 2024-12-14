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

    // Extract user ID from path parameters
    const userId = event.pathParameters?.id;

    if (!userId) {
      console.error("Missing user ID in path parameters");
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: "Bad Request: Missing user ID in path parameters",
        }),
      };
    }

    // Prepare DynamoDB delete parameters
    const params = {
      TableName: tableName,
      Key: {
        id: userId,
      },
    };

    // Attempt to delete the item from DynamoDB
    try {
      await dynamoDB.delete(params).promise();
      console.info("User deleted from DynamoDB:", userId);
      return {
        statusCode: 200,
        body: JSON.stringify({ message: "User deleted successfully" }),
      };
    } catch (dynamoError) {
      console.error("Error deleting user from DynamoDB:", dynamoError);
      return {
        statusCode: 500,
        body: JSON.stringify({
          message: "Internal Server Error: Unable to delete user",
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
