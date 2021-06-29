const Worker = require("../worker/model");

const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const { createJWT, getUserByToken } = require("../utils/auth");
const { getShiftWorker } = require("../utils/shift");
const phoneRegexp = /^[0-9]{8}$/;
const maxAge = 3600 * 24 * 10;

//finding error
const findError = (req) => {
  var errors = [];
  let { name, phone, password, password_confirmation } = req.body;

  if (!name) errors.push({ name: "required" });
  if (!phone) errors.push({ phone: "required" });

  if (!phoneRegexp.test(phone)) errors.push({ phone: "invalid" });

  if (!password) errors.push({ password: "required" });

  if (!password_confirmation) {
    errors.push({
      password_confirmation: "required",
    });
  }
  if (password != password_confirmation) errors.push({ password: "mismatch" });

  return errors;
};
//creating an account
exports.signup = (req, res, next) => {
  let { name, phone, password } = req.body;
  let errors = findError(req);

  if (errors.length > 0) return res.status(422).json({ errors: errors });

  Worker.findOne({ phone: phone })
    .then((worker) => {
      if (worker) {
        return res
          .status(422)
          .json({ errors: [{ worker: "phone already exists" }] });
      } else {
        const worker = new Worker({
          name,
          phone,
          password,
        });

        bcrypt.genSalt(10, function (err, salt) {
          bcrypt.hash(password, salt, function (err, hash) {
            if (err) throw err;
            worker.password = hash;
            //saving worker to db
            worker
              .save()
              .then((response) => {
                let access_token = createJWT(worker.phone, worker._id, 3600);
                res
                  .status(200)
                  .cookie("token", access_token, {
                    httpOnly: true,
                    maxAge: maxAge * 1000,
                  })
                  .json({
                    success: true,
                    message: response,
                  });
              })
              .catch((err) => {
                res.status(400).json({
                  errors: [{ error: err }],
                });
              });
          });
        });
      }
    })
    .catch((err) => {
      res.status(400).json({
        errors: [{ error: "Something went wrong" }],
      });
    });
};

//login to the account
exports.signin = (req, res) => {
  let { phone, password } = req.body;
  let errors = [];

  if (!phone) errors.push({ phone: "required" });
  if (!phoneRegexp.test(phone)) errors.push({ phone: "invalid" });
  if (!password) errors.push({ passowrd: "required" });

  if (errors.length > 0) return res.status(400).json({ errors });

  Worker.findOne({ phone: phone })
    .then((worker) => {
      if (!worker)
        return res.status(400).json({
          errors: [{ worker: "not found" }],
        });
      else {
        console.log(worker);
        bcrypt
          .compare(password, worker.password)
          .then((isMatch) => {
            if (!isMatch)
              return res
                .status(400)
                .json({ errors: [{ password: "incorrect" }] });

            let access_token = createJWT(worker.phone, worker._id, 3600);
            jwt.verify(
              access_token,
              process.env.TOKEN_SECRET,
              (err, decoded) => {
                if (err) res.status(400).json({ erros: err });

                if (decoded)
                  return res
                    .status(200)
                    .cookie("token", access_token, {
                      httpOnly: true,
                      maxAge: maxAge * 1000,
                    })
                    .json({
                      success: true,
                      message: worker,
                    });
              }
            );
          })
          .catch((err) => res.status(400).json({ erros: err }));
      }
    })
    .catch((err) => res.status(400).json({ erros: err }));
};
//loggin out
exports.logOut = (req, res) => {
  res.cookie("token", "", { maxAge: 1 });
  res.json("logged Out");
};
//check whether the worker is logged or not
exports.workerInfo = async (req, res) => {
  const token = getToken(req);
  if (token) {
    var worker = await getUserByToken(token);
    return res.status(200).json({ isLogged: true, isAdmin: worker.isAdmin });
  }
  return res.json({ isLogged: false });
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
const getToken = (req) => {
  let { token } = req.cookies;
  //in case of using mobile flutter
  if (typeof token == "undefined") token = req.headers.cookies.substring(6);
  return token;
};
