import { sendEmail } from "./config.js";
import {
  PASSWORD_RESET_REQUEST_TEMPLATE,
  PASSWORD_RESET_SUCCESS_TEMPLATE,
  VERIFICATION_EMAIL_TEMPLATE,
} from "./emailTemplate.js";

export const sendVerificationEmail = async (email, verificationToken) => {
  try {
    await sendEmail({
      to: email,
      subject: "Verify your email",
      text: `Your Elbess verification code is ${verificationToken}`,
      html: VERIFICATION_EMAIL_TEMPLATE.replace("{verificationCode}", verificationToken),
    });
  } catch (error) {
    console.error("Error sending verification email!", error);
    throw error;
  }
};

export const sendResetEmail = async (email, resetUrl) => {
  try {
    await sendEmail({
      to: email,
      subject: "Password Reset Request",
      text: `Reset your password using this link: ${resetUrl}`,
      html: PASSWORD_RESET_REQUEST_TEMPLATE.replace("{resetURL}", resetUrl),
    });
  } catch (error) {
    console.error("Error sending password reset email!", error);
    throw error;
  }
};

export const sendResetSuccessEmail = async (email) => {
  try {
    await sendEmail({
      to: email,
      subject: "Password Reset Success",
      text: "Your Elbess password was reset successfully.",
      html: PASSWORD_RESET_SUCCESS_TEMPLATE,
    });
  } catch (error) {
    console.error("Error sending password reset success email!", error);
    throw error;
  }
};
