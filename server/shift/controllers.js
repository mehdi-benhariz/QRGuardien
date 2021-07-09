const Shift = require("../shift/model");
const { getShiftWorker, getToken } = require("../utils/shift");

exports.getShifts = async (req, res) => {
  try {
    var shifts = await Shift.find();
    // result = [];
    // shifts.forEach(async (shift) => {
    //   result.push(shift);
    //   const worker = await Worker.findById(shift.worker);
    //   result[result.length - 1].worker = worker;
    // });

    return res.status(200).json(shifts);
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
exports.submitShift = async (req, res) => {
  const token = getToken(req);
  var curruent = await getUserByToken(token);
  //   if (!curruent === getShiftWorker()) return res.json("this is not your shift");
  // TODO:add check for an existing shift and update it
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
