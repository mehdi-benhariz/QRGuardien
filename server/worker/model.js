const mongoose = require("mongoose");
const Schema = mongoose.Schema;
// Create Schema
const WorkerSchema = new Schema({
  name: {
    type: String,
    required: true,
  },
  phone: {
    type: String,
    required: true,
  },
  password: {
    type: String,
    required: true,
  },
  isAdmin: {
    type: Boolean,
    required: true,
    default: false,
  },
});
module.exports = Worker = mongoose.model("workers", WorkerSchema);
