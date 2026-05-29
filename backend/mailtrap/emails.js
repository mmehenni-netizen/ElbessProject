import { sender, transporter } from "./config.js"
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

        if (!response.accepted?.includes(email)) {
            throw new Error(`Email provider did not accept recipient. rejected=${response.rejected?.join(", ") || "none"}`)
        }

        console.log("Verification email accepted", {
            to: email,
            messageId: response.messageId,
            accepted: response.accepted,
            rejected: response.rejected,
        })

        return response
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

        if (!response.accepted?.includes(email)) {
            throw new Error(`Email provider did not accept recipient. rejected=${response.rejected?.join(", ") || "none"}`)
        }

        console.log("Password reset email accepted", {
            to: email,
            messageId: response.messageId,
            accepted: response.accepted,
            rejected: response.rejected,
        })

        return response
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

        if (!response.accepted?.includes(email)) {
            throw new Error(`Email provider did not accept recipient. rejected=${response.rejected?.join(", ") || "none"}`)
        }

        console.log("Password reset success email accepted", {
            to: email,
            messageId: response.messageId,
            accepted: response.accepted,
            rejected: response.rejected,
        })

        return response
    } catch (error) {
        console.error("Error sending password reset success email !", error)
        throw new Error(`Error sending password reset success email ! : ${error}`)
    }
}
