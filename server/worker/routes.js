const express = require("express");
const router = express.Router();
const { signup, signin, logOut, workerInfo } = require("../worker/controllers");
const { auth } = require("../middleware/auth");

router.post("/signup", signup);
router.post("/signin", signin);
router.post("/logOut", auth, logOut);
router.get("/userInfo", workerInfo);
module.exports = router;
//60db022d83dc28633d296d57
