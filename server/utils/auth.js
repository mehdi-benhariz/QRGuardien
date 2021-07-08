const jwt = require("jsonwebtoken");

exports.createJWT = (phone, userId, duration) => {
  const payload = {
    phone,
    userId,
    duration,
  };
  return jwt.sign(payload, process.env.TOKEN_SECRET, {
    expiresIn: duration,
  });
};

exports.getUserByToken = async (token) => {
  const decode = await jwt.verify(token, process.env.TOKEN_SECRET);
  const worker = await Worker.findById(decode.userId);
  return worker;
};
exports.getToken = (req) => {
  let { token } = req.cookies;
  //in case of using mobile flutter
  if (typeof token == "undefined") token = req.headers.cookies.substring(6);
  return token;
};
