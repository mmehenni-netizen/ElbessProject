import { sender, transporter } from "./config.js"
import { PASSWORD_RESET_REQUEST_TEMPLATE, PASSWORD_RESET_SUCCESS_TEMPLATE, VERIFICATION_EMAIL_TEMPLATE } from "./emailTemplate.js"
import { Resend } from "resend"

const resend = process.env.RESEND_API_KEY ? new Resend(process.env.RESEND_API_KEY) : null
const resendSender = process.env.RESEND_FROM || sender

const sendEmail = async ({ to, subject, text, html }) => {
    if (resend) {
        const { data, error } = await resend.emails.send({
            from: resendSender,
            to: [to],
            subject,
            text,
            html,
        })

        if (error) {
            throw new Error(error.message || JSON.stringify(error))
        }

        console.log("Email accepted by Resend", {
            to,
            id: data?.id,
            provider: "resend",
        })

        return data
    }

    const response = await transporter.sendMail({
        from: sender,
        to,
        subject,
        text,
        html,
    })

    if (!response.accepted?.includes(to)) {
        throw new Error(`Email provider did not accept recipient. rejected=${response.rejected?.join(", ") || "none"}`)
    }

    console.log("Email accepted by SMTP", {
        to,
        messageId: response.messageId,
        accepted: response.accepted,
        rejected: response.rejected,
        provider: "smtp",
    })

    return response
}

export const sendVerificationEmail = async (email, verificationToken) => {

    try {
        return await sendEmail({
            to: email,
            subject: "Verify your email",
            text: `Your Elbess verification code is ${verificationToken}`,
            html: VERIFICATION_EMAIL_TEMPLATE.replace("{verificationCode}", verificationToken)
        })
    } catch (error) {
        console.error("Error sending verification email !", error)
        throw new Error(`Error sending verification email ! : ${error}`)
    }
}

export const sendResetEmail = async (email, resetUrl) => {
    try {
        return await sendEmail({
            to: email,
            subject: "Password Reset Request",
            text: `Reset your password using this link: ${resetUrl}`,
            html: PASSWORD_RESET_REQUEST_TEMPLATE.replace("{resetURL}", resetUrl)
        })
    } catch (error) {
        console.error("Error sending password reset email !", error)
        throw new Error(`Error sending password reset email ! : ${error}`)
    }
}

export const sendResetSuccessEmail = async (email) => {
    try {
        return await sendEmail({
            to: email,
            subject: "Password Reset Success",
            text: "Your Elbess password was reset successfully.",
            html: PASSWORD_RESET_SUCCESS_TEMPLATE
        })
    } catch (error) {
        console.error("Error sending password reset success email !", error)
        throw new Error(`Error sending password reset success email ! : ${error}`)
    }
}
