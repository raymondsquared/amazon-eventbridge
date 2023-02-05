import {
  // ActivateEventSourceCommand,
  EventBridgeClient,
  EventBridgeClientConfig,
  PutEventsCommand,
  PutEventsCommandInput,
} from "@aws-sdk/client-eventbridge";

// a client can be shared by different commands.
const config: EventBridgeClientConfig = {
  region: "ap-southeast-2"
};
const ebClient = new EventBridgeClient(config);

const run = async () => {
  try {
    const params: PutEventsCommandInput = {
      Entries: [
        {
          Detail: '{ "key1": "value1", "foo": "bar" }',
          // Detail: JSON.stringify({ foo: 'bar' }),
          DetailType: 'foo',
          Resources: [
            'fooBar',
          ],
          Source: 'ray-macbook',
          EventBusName: 'ray-eventbridge-bus',
        },
      ],
    };

    const data = await ebClient.send(new PutEventsCommand(params));
    console.log("Success, event sent; requestID:", data);
    // return data;
  } catch (err) {
    console.log("Error", err);
  }
};

// Uncomment this line to run execution within this file.
run();
