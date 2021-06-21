const mongoose = require("mongoose");
const Schema = mongoose.Schema;
// Create Schema
const ShiftSchema = new Schema({
  date: {
    type: Date,
    required: true,
  },
  worker: {
    type: Schema.Types.ObjectId,
    ref: "workers",
    required: true,
  },
  done: {
    type: Boolean,
    required: true,
    default: false,
  },
});
module.exports = Shift = mongoose.model("shifts", ShiftSchema);
