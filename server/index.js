const keys = require("./keys");

// Express App Setup
const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(bodyParser.json());

// Create and Connect to Postgres Client

const {
    Pool
} = require("pg");

const pgClient = new Pool({
    user: keys.pgUser,
    host: keys.pgHost,
    database: keys.pgDatabase,
    password: keys.pgPassword,
    port: keys.pgPort,
});
pgClient.on('connect', () => {
    pgClient
        .query('CREATE TABLE IF NOT EXISTS values (number INT)')
        .catch((err) => console.log(err))
})


// Create and Connect to Redis Client
const redis = require("redis");
const redisClient = redis.createClient({
    host: keys.redisHost,
    port: keys.redisPort,
    retry_strategy: () => 1000,
});

const redisPublisher = redisClient.duplicate();

// Express Route Handlers

// Test Route
app.get("/", (req, res) => {
    res.send("Hello there");
});

// All indices submitted to DB
app.get("/values/all", async(req, res) => {
    const values = await pgClient.query("SELECT * FROM values");

    res.send(values.rows);
    // res.send(values.map(x => x.number))
});

// Get current indices in Redis
app.get("/values/current", async(req, res) => {
    redisClient.hgetall("values", (err, values) => {
        res.send(values);
    });
});

// Receive new values
app.post("/values", async(req, res) => {

    const index = req.body.index;

    if (parseInt(index) > 40) {
        return res.status(422).send("Index too high, try smaller number");
    }

    redisClient.hset("values", index, "Nothing yet!");

    redisPublisher.publish("insert", index);

    pgClient.query("INSERT INTO values(number) VALUES($1)", [index]);

    res.send({
        working: true
    });
});

app.listen(5000, (error) => {
    console.log("Listening");
});