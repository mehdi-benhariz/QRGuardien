const Shift = require("../shift/model");
const { getShiftWorker } = require("../utils/shift");
const { createJWT, getUserByToken, getToken } = require("../utils/auth");

exports.getShifts = async (req, res) => {
  try {
    var shifts = await Shift.find();
    let result = [];
    for (let i = 0; i < shifts.length; i++) {
      var shift = shifts[i];
      const worker = await Worker.findById(shift.worker);
      shift["worker"] = worker;
      result.push(shift);
    }
    return res.status(200).json(result);
  } catch (error) {
    return res.status(500).json("internal error");
  }
};
exports.getShift = async (req, res) => {};
exports.deleteShift = async (req, res) => {
  const { id } = req.params;

  if (!id) return res.status(400).json({ error: "ID is required" });

  try {
    const removed = await Shift.findByIdAndRemove(id);
    if (!removed) return res.status(200).json({ success: true });
    else return res.status(404).json({ error: "shift doesn't exist" });
  } catch (err) {
    res.status(500).json({ error: "there was internal error" });
  }
};
exports.updateShift = async (req, res) => {
  const { id } = req.params;
  const { date, done, worker } = req.body.newShift;
  if (!id) return res.status(400).json({ error: "ID is required" });
  if (!date | !done | !worker)
    return res.status(400).json({ error: "all fields are required" });
  try {
    const newShift = await new Shift({ date, worker, done });
    const updated = await Shift.findByIdAndUpdate(id, newShift, { new: true });
    if (!updated) return res.status(500).json({ error: "couldn't update !" });
    return res.status(200).json({ success: true, message: updated });
  } catch (err) {
    res.status(500).json({ error: "there was internal error" });
  }
};
function getDifferenceInDays(date1, date2) {
  const diffInMs = Math.abs(date2 - date1);
  return diffInMs / (1000 * 60 * 60 * 24);
}
exports.submitShift = async (req, res) => {
  const token = getToken(req);

  var curruent = await getUserByToken(token);
  //   if (curruent !== getShiftWorker()) return res.json("this is not your shift");
  // TODO:add check for an existing shift and update it
  const lastOne = await Shift.findOne({ worker: curruent._id });
  if (lastOne && getDifferenceInDays(lastOne.date, new Date(Date.now())) > 1)
    return res.status(400).json("too late to submit");

  try {
    var newShift = await new Shift({
      date: Date.now(),
      worker: curruent,
      done: true,
    });
    newShift.save();
    if (!newShift) return res.status(500).json({ error: "couldn't submit !" });
    return res.status(200).json({ success: true });
  } catch (err) {
    res.status(500).json({ error: "there was an internal error" });
  }
};
