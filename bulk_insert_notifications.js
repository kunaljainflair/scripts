const { Client } = require("pg");
const { v4: uuidv4 } = require("uuid");
const { faker } = require("@faker-js/faker");

const client = new Client({
  host: "localhost",
  port: 5432,
  user: "root",
  password: "Root@123",
  database: "test",
});

const TYPES = ["GENERIC", "CUSTOM"];
const PRIORITIES = ["HIGH", "LOW"];
const STATUSES = ["CREATED"];
const OBJECT_TYPES = ["payment", "order", "ticket", "system"];

const TENANT_ID = "e2268e91-8d03-4028-b8c5-e439d2b4aeda"; // use same tenant for many rows

function randomElement(arr) {
  return arr[Math.floor(Math.random() * arr.length)];
}

function randomMetadata() {
  return {
    title: faker.lorem.sentence(),
    message: faker.lorem.paragraph(),
    amount: faker.number.int({ min: 100, max: 10000 }),
    currency: "INR",
  };
}

function randomActionMapping() {
  return {
    approveApi: "/api/approve",
    rejectApi: "/api/reject",
  };
}

function randomAccountContext() {
  const list = [
    "accountType", "region", "subscriptionLevel", "lastLogin",
    "customerId", "accountStatus", "preferredLanguage", "timezone",
    "notificationPreferences", "lastActivity", "totalPurchases",
    "lifetimeValue", "churnRisk", "customerSegment"
  ];

  const context = {};
  const sublist = faker.helpers.arrayElements(
    list,
    faker.number.int({ min: 2, max: 5 })
  );

  sublist.forEach((key) => {
    switch (key) {
      case "accountType":
        context[key] = faker.helpers.arrayElement(["free", "premium", "enterprise"]);
        break;
      case "region":
        context[key] = faker.location.country();
        break;
      case "subscriptionLevel":
        context[key] = faker.helpers.arrayElement(["basic", "standard", "pro"]);
        break;
      case "accountStatus":
        context[key] = faker.helpers.arrayElement(["active", "inactive", "suspended"]);
        break;
      case "preferredLanguage":
        context[key] = faker.helpers.arrayElement(["en", "es", "fr", "de", "hi"]);
        break;
      case "notificationPreferences":
        context[key] = faker.helpers.arrayElement(["email", "sms", "push"]);
        break;
      case "totalPurchases":
        context[key] = faker.number.int({ min: 0, max: 100 }).toString();
        break;
      case "churnRisk":
        context[key] = faker.helpers.arrayElement(["low", "medium", "high"]);
        break;
      case "customerSegment":
        context[key] = faker.helpers.arrayElement(["new", "loyal", "at-risk"]);
        break;
    }
  });

  return context;
}

async function insertBatch(batchSize) {
  const values = [];
  const placeholders = [];

  for (let i = 0; i < batchSize; i++) {
    const index = i * 18;

    placeholders.push(`(
      $${index + 1}, $${index + 2}, $${index + 3}, $${index + 4},
      $${index + 5}, $${index + 6}, $${index + 7}, $${index + 8},
      $${index + 9}, $${index + 10}, $${index + 11}, $${index + 12},
      $${index + 13}, $${index + 14}, $${index + 15}, $${index + 16},
      $${index + 17}, $${index + 18}
    )`);

    values.push(
      uuidv4(),                      // id
      new Date(),                    // created_at
      TENANT_ID,                     // tenant_id
      new Date(),                    // updated_at
      JSON.stringify(randomAccountContext()), // account_context
      faker.date.recent(),           // acted_at
      JSON.stringify(randomActionMapping()), // action_mapping
      faker.lorem.paragraph(),       // body
      "/deeplink/path",              // deeplink
      "icon.png",                    // icon
      faker.datatype.boolean(),      // is_push_enabled
      JSON.stringify(randomMetadata()), // metadata
      randomElement(STATUSES),      // status
      faker.lorem.sentence(),       // title
      randomElement(TYPES),         // type
      uuidv4(),                     // user_id
      randomElement(OBJECT_TYPES),  // object_type
      randomElement(PRIORITIES)     // priority
    );
  }

  const query = `
    INSERT INTO notification (
      id, created_at, tenant_id, updated_at, account_context,
      acted_at, action_mapping, body, deeplink, icon,
      is_push_enabled, metadata, status, title, type,
      user_id, object_type, priority
    )
    VALUES ${placeholders.join(",")}
  `;

  await client.query(query, values);
}

async function run() {
  try {
    await client.connect();
    console.log("Connected to DB");

    const TOTAL = 10000000;
    const BATCH_SIZE = 1000;

    for (let i = 0; i < TOTAL / BATCH_SIZE; i++) {
      await insertBatch(BATCH_SIZE);
      console.log(`Inserted batch ${i + 1}`);
    }

    console.log("Bulk insert completed");
    await client.end();
  } catch (err) {
    console.error(err);
  }
}

run();