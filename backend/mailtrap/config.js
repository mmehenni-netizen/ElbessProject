import dotenv from "dotenv";
import nodemailer from "nodemailer"


dotenv.config()

const mailUser = process.env.GMAIL_USER || process.env.MAILTRAP_USER
const mailPass = process.env.GMAIL_PASS || process.env.MAILTRAP_PASS

console.log("SMTP_USER:", mailUser)
console.log("SMTP_PASS:", mailPass ? "OK" : "MISSING")

export const transporter = nodemailer.createTransport({
  host: "smtp.gmail.com",
  port: 587,
  secure: false,
  requireTLS: true,
  connectionTimeout: 10000,
  greetingTimeout: 10000,
  socketTimeout: 15000,
  auth: {
    user: mailUser,
    pass: mailPass
  },
});

export const sender = `"Elbess" <${mailUser}>`;
