import dotenv from "dotenv";
import nodemailer from "nodemailer"


dotenv.config()


export const transporter = nodemailer.createTransport({
  host: "smtp.gmail.com",
  port: 587,
  secure: false,
  auth: {
    user: process.env.MAILTRAP_USER,
    pass: process.env.MAILTRAP_PASS
  },
  tls: {
    rejectUnauthorized: false, // This bypasses certificate validation
    ciphers: 'SSLv3' // Sometimes needed for Gmail
  }
});
