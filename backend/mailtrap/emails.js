import {sender, transporter} from "./config.js"
import { PASSWORD_RESET_REQUEST_TEMPLATE, PASSWORD_RESET_SUCCESS_TEMPLATE, VERIFICATION_EMAIL_TEMPLATE } from "./emailTemplate.js"

export const sendVerificationEmail = async (email, verificationToken) => {

    try {
        const response = await transporter.sendMail({
            from: sender,
            to: email,
            subject: "Verify your email",
            text: `Your Elbess verification code is ${verificationToken}`,
            html: VERIFICATION_EMAIL_TEMPLATE.replace("{verificationCode}", verificationToken)
           
        })

        console.log("Email sent succesfully", response)
    } catch (error) {
        console.error("Error sending verification email !", error)
        throw new Error(`Error sending verification email ! : ${error}`)
    }
}

export const sendResetEmail = async (email, resetUrl) => {
    try {
        const response = await transporter.sendMail({
            from: sender,
            to: email,
            subject: "Password Reset Request",
            text: `Reset your password using this link: ${resetUrl}`,
            html: PASSWORD_RESET_REQUEST_TEMPLATE.replace("{resetURL}", resetUrl)
        })

        console.log("Email sent succesfully", response)
    } catch (error) {
        console.error("Error sending password reset email !", error)
        throw new Error(`Error sending password reset email ! : ${error}`)
    }
}

export const sendResetSuccessEmail = async (email) => {
    try {
        const response = await transporter.sendMail({
            from: sender,
            to: email,
            subject: "Password Reset Success",
            text: "Your Elbess password was reset successfully.",
            html: PASSWORD_RESET_SUCCESS_TEMPLATE
        })

        console.log("Email sent succesfully", response)
    } catch (error) {
        console.error("Error sending password reset success email !", error)
        throw new Error(`Error sending password reset success email ! : ${error}`)
    }
}
