import dotenv from "dotenv";
dotenv.config();

export const sendEmail = async ({ to, subject, html, text }) => {
  const response = await fetch("https://api.brevo.com/v3/smtp/email", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "api-key": process.env.BREVO_API_KEY,
    },
    body: JSON.stringify({
      sender: { name: "Elbess", email: "mehennimohamed095@gmail.com" },
      to: [{ email: to }],
      subject,
      htmlContent: html,
      textContent: text,
    }),
  });

  if (!response.ok) {
    const err = await response.json();
    console.error("Brevo API error:", err);
    throw new Error(err.message);
  }

  console.log("Email sent successfully via Brevo API ✅");
  return response.json();
};
