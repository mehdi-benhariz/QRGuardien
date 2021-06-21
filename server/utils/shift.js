const Shift = require("../shift/model");

exports.getShiftWorker = async () => {
  try {
    let shifts = await Shift.find();
    return shifts;
  } catch (err) {
    return null;
  }
};
