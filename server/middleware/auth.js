const jwt = require("jsonwebtoken");
const Worker = require("../worker/model");

exports.auth = async (req, res, next) => {
  let { token } = req.cookies;
  //in case of using mobile flutter
  if (typeof token == "undefined") token = req.headers.cookies.substring(6);

  console.log(token);
  try {
    if (token) {
      const decode = await jwt.verify(
        token || req.cookies,
        process.env.TOKEN_SECRET
      );
      req.body = {
        ...req.body,
        user_id: decode.userId,
      };
      next();
    } else return res.status(403).json({ message: "access denied" });
  } catch (error) {
    console.log("error");
    console.log("err:", error);
  }
};

exports.admin = async (req, res, next) => {
  const { token } = req.cookies;
  if (typeof token == "undefined") token = req.headers.cookies.substring(6);

  try {
    const decode = await jwt.verify(token, process.env.TOKEN_SECRET);
    const worker = await Worker.findById(decode.userId);
    console.log(worker.isAdmin);
    if (worker.isAdmin) next();
    else return res.status(403).json({ message: "access denied" });
  } catch (error) {
    return res.status(403).json({ error });
  }
};
