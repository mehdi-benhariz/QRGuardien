const Shift = require("../shift/model");

exports.getShifts = async (req, res) => {
  try {
    var shifts = await Shift.find();
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
  const { newShift } = req.params;
  if (!id) return res.status(400).json({ error: "ID is required" });
  if (!newShift)
    return res.status(400).json({ error: "new Shift is required" });
  try {
    const updated = await Shift.findByIdAndUpdate(id, newShift, { new: true });
    if (!updated) return res.status(500).json({ error: "couldn't update !" });
    return res.status(200).json({ success: true });
  } catch (err) {
    res.status(500).json({ error: "there was internal error" });
  }
};
