const express = require("express");
const app = express();
const port = 5000;

const helmet = require("helmet");
const cors = require("cors");
const morgan = require("morgan");
const cookieParser = require("cookie-parser");

const path = require("path");
require("dotenv").config({
  path: path.join(process.cwd(), "/config/.env"),
});
// Connect to a data base
require("./db/db");

// parse application/x-www-form-urlencoded
app.use(
  express.urlencoded({
    extended: true,
  })
);

// parse application/json
app.use(express.json());
// cookie parser middleware
app.use(cookieParser());
// Morgan
app.use(morgan("common"));

//allow front end
app.use(
  cors({
    origin: true,
    credentials: true,
  })
);
app.use(function (req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");

  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept"
  );
  next();
});
//routes

app.use("/api/v1/worker", require("./worker/routes"));
app.use("/api/v1/shift", require("./shift/routes"));

// app.use("/api/v1/admin", require("./admin/routes"));

app.listen(port, () => console.log(`Example app listening on port ${port}!`));
