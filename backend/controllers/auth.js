import { userModel } from "../model/user.js";
import bcryptjs from "bcryptjs";
import jwt from "jsonwebtoken";
import {
  sendResetEmail,
  sendResetSuccessEmail,
  sendVerificationEmail,
} from "../mailtrap/emails.js";
import crypto from "crypto";

export const verifyEmail = async (req, res) => {
  const { code } = req.body;
  try {
    const user = await userModel.findOne({
      verificationToken: code,
      verificationTokenExpiresAt: { $gt: Date.now() },
    });

    if (!user) {
      return res.status(400).json({
        success: false,
        message: "Invalid or expired verification code, try signing up again",
      });
    }

    user.isVerified = true;
    user.verificationToken = undefined;
    user.verificationTokenExpiresAt = undefined;

    await user.save();

    // JWT

    const token = jwt.sign(
      {
        userId: user._id,
      },
      process.env.JWT_SECRET,
      {
        expiresIn: "7d",
      },
    );

    res.status(200).json({
      success: true,
      message: "Email verified successfully ! user authorized",
      user: {
        ...user._doc,
        password: undefined,
      },
      token,
    });
  } catch (error) {
    console.log("error in verifying Email ", error);
    res.status(500).json({ success: false, message: "Server error" });
  }
};

export const signup = async (req, res) => {
  const { email, username, password } = req.body;

  try {
    if (!email || !username || !password) {
      throw new Error("All fields are required !");
    }

    const userExists = await userModel.findOne({ email });

    if (userExists && userExists.isVerified) {
      throw new Error("A user with that email already exists !");
    }

    const verificationToken = Math.floor(
      99999 + Math.random() * 900000,
    ).toString();

    if (userExists && !userExists.isVerified) {
      userExists.verificationToken = verificationToken;
      await userExists.save();

      // Fire-and-forget email send so signup isn't blocked if SMTP hangs
      sendVerificationEmail(userExists.email, verificationToken).catch((emailErr) => {
        console.log('Warning: verification email failed to send for existing user', emailErr);
      });

      res.status(201).json({
        success: true,
        message: "User exist but not verified ! verification email sent",
        user: {
          ...userExists._doc,
          password: undefined,
        },
      });
    } else {
      const hashedPass = await bcryptjs.hash(password, 10);

      const user = new userModel({
        email: email,
        password: hashedPass,
        username: username,
        verificationToken: verificationToken,
        verificationTokenExpiresAt: Date.now() + 60 * 1000,
      });

      await user.save();

      // Email - do not block signup if email sending fails
      // Fire-and-forget email send so signup isn't blocked if SMTP hangs
      sendVerificationEmail(user.email, verificationToken).catch((emailErr) => {
        console.log('Warning: verification email failed to send for new user', emailErr);
      });

      res.status(201).json({
        success: true,
        message: "User created succesfuly ! verification email sent",
        user: {
          ...user._doc,
          password: undefined,
        },
      });
    }
  } catch (error) {
    res.status(400).json({ success: false, message: error.message });
  }
};

export const login = async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await userModel.findOne({ email });

    if (!user) {
      return res.status(400).json({
        success: false,
        message: "Invalid credentials",
      });
    }

    const isPassValid = await bcryptjs.compare(password, user.password);
    if (!isPassValid) {
      return res.status(400).json({
        success: false,
        message: "Invalid credentials",
      });
    }

    if (!user.isVerified) {
      return res.status(400).json({
        success: false,
        message: "Email not verified. Please verify your email before login.",
      });
    }

    // JWT

    const token = jwt.sign(
      {
        userId: user._id,
      },
      process.env.JWT_SECRET,
      {
        expiresIn: "7d",
      },
    );

    user.lastLogin = new Date();

    await user.save();

    res.status(200).json({
      success: true,
      message: "Logged in succesfully",
      user: {
        ...user._doc,
        password: undefined,
      },
      token,
    });
  } catch (error) {
    console.log("Error in login function :", error);
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

export const logout = async (req, res) => {
  try {
    console.log(`User logged out at ${new Date()}`);

    res.status(200).json({
      success: true,
      message: "Logged out successfully",
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Logout failed",
    });
  }
};

export const forgotPassword = async (req, res) => {
  const { email } = req.body;

  try {
    const user = await userModel.findOne({ email });

    if (!user) {
      return res.status(400).json({
        success: false,
        message: "User not found !",
      });
    }

    const resetToken = crypto.randomBytes(20).toString("hex");
    const resetTokenExpiresAt = Date.now() + 10 * 60 * 1000;

    user.resetPasswordToken = resetToken;
    user.resetPasswordExpiresAt = resetTokenExpiresAt;

    await user.save();

    await sendResetEmail(
      email,
      `${process.env.CLIENT_URL}/reset-password/${resetToken}`,
    );

    res.status(200).json({
      success: true,
      message: "Password reset link sent to your email",
    });
  } catch (error) {
    console.log("Error in forgot password", error);
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

export const resetPassword = async (req, res) => {
  try {
    const { token } = req.params;
    const { password } = req.body;

    const user = await userModel.findOne({
      resetPasswordToken: token,
      resetPasswordExpiresAt: { $gt: Date.now() },
    });

    if (!user) {
      return res.status(400).json({
        success: false,
        message: "User doesn't exist or expired reset token",
      });
    }

    const hashedPass = await bcryptjs.hash(password, 10);

    ((user.password = hashedPass), (user.resetPasswordToken = undefined));
    user.resetPasswordExpiresAt = undefined;

    user.save();

    await sendResetSuccessEmail(user.email);

    res.status(200).json({
      success: true,
      message: "Password reset success !",
    });
  } catch (error) {
    console.log("Error in reseting password ! ", error);
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};
