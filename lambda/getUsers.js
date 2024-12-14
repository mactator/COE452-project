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

    // Prepare DynamoDB scan parameters
    const params = {
      TableName: tableName,
    };

    // Scan the table and fetch all items
    try {
      const result = await dynamoDB.scan(params).promise();
      console.info("Fetched users from DynamoDB:", result.Items);
      return {
        statusCode: 200,
        body: JSON.stringify(result.Items),
      };
    } catch (dynamoError) {
      console.error("Error fetching users from DynamoDB:", dynamoError);
      return {
        statusCode: 500,
        body: JSON.stringify({
          message: "Internal Server Error: Unable to fetch users",
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
