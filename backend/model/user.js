import mongoose from 'mongoose'

import {connectDB} from "../config/db.js"

const {Schema} = mongoose

const userSchema = new Schema({
    username: {
        type : String,
        required : true,
        unique : true,
    },
    email: {
        type : String,
        lowercase : true,
        required : true,
        unique : true,
    },
    password: {
        type : String,
        required : true,
   
    },
    lastLogin: {
        type : Date,
        default: Date.now
    },
    isVerified: {
        type : Boolean,
        default: false
    },
    isSeller: {
        type : Boolean,
        default : false
    },
    resetPasswordToken : String,
    resetPasswordExpiresAt : Date,
    verificationToken : String,
    verificationTokenExpiresAt : Date
}, {timestamps : true})

userSchema.index(
    { createdAt: 1 },  
    { 
        expireAfterSeconds: 60, 
        partialFilterExpression: { isVerified: false } 
    }
);

export const userModel = mongoose.model("user", userSchema)

