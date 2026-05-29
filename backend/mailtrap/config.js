import dotenv from "dotenv";
import nodemailer from "nodemailer"


dotenv.config()


console.log("MAILTRAP_USER:", process.env.MAILTRAP_USER)
console.log("MAILTRAP_PASS:", process.env.MAILTRAP_PASS ? "OK" : "MISSING")

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

    export const sender = `"Elbess" <${process.env.MAILTRAP_USER}>`;
