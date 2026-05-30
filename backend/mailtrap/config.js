import dotenv from "dotenv";
import nodemailer from "nodemailer";

dotenv.config();

const mailUser = process.env.BREVO_USER;
const mailPass = process.env.BREVO_PASS;

console.log("SMTP_USER:", mailUser);
console.log("SMTP_PASS:", mailPass ? "OK" : "MISSING");

export const transporter = nodemailer.createTransport({
  host: "smtp-relay.brevo.com",
  port: 587,
  secure: false,
  auth: {
    user: mailUser,
    pass: mailPass,
  },
});

transporter.verify((error, success) => {
  if (error) {
    console.error("SMTP transporter verification failed:", error.message);
  } else {
    console.log("SMTP transporter verified successfully");
  }
});

export const sender = '"Elbess" <mehennimohamed095@gmail.com>';
