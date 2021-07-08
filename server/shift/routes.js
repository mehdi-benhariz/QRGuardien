const express = require("express");
const router = express.Router();
const {
  getShifts,
  deleteShift,
  updateShift,
  submitShift,
} = require("../shift/controllers");
const { auth, admin } = require("../middleware/auth");

router.post("/submitShift", auth, submitShift);
router.post("/all", auth, admin, getShifts);
router.delete("/remove/:id", auth, admin, deleteShift);
router.put("/edit/:id", auth, admin, updateShift);
module.exports = router;
