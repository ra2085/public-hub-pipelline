const functions = require('@google-cloud/functions-framework');
const { PubSub } = require('@google-cloud/pubsub');

const pubsub = new PubSub();
const topicName = process.env.PUBSUB_TOPIC; // Get topic name from environment variable

exports.publishToPubSub = async (req, res) => {
  if (!topicName) {
    console.error('Error: PUBSUB_TOPIC environment variable is not set.');
    res.status(500).send('Error: PUBSUB_TOPIC environment variable is not set.');
    return;
  }

  try {
    if (!req.body) {
        res.status(400).send('No request body found');
        return
    }

    const dataBuffer = Buffer.from(JSON.stringify(req.body));
    const topic = pubsub.topic(topicName);
    const messageId = await topic.publishMessage({ data: dataBuffer });

    console.log(`Message ${messageId} published to topic ${topicName}`);
    res.status(200).send(`Message ${messageId} published successfully.`);
  } catch (error) {
    console.error('Error publishing message:', error);
    res.status(500).send(`Error publishing message: ${error.message}`);
  }
};
