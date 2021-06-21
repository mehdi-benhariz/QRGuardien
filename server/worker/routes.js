const express = require("express");
const router = express.Router();
const {
  signup,
  signin,
  logOut,
  workerInfo,
  submitShift,
} = require("../worker/controllers");
const { auth } = require("../middleware/auth");

router.post("/signup", signup);
router.post("/signin", signin);
router.post("/logOut", auth, logOut);
router.get("/userInfo", workerInfo);
router.post("/submitShift", auth, submitShift);
module.exports = router;
