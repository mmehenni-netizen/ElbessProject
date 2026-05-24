import dotenv from 'dotenv';
import mongoose from 'mongoose';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const mongoUrl = process.env.MONGO_URL;

if (!mongoUrl) {
  console.error('MONGO_URL is not set in environment.');
  process.exit(1);
}

const run = async () => {
  const emailArg = process.argv[2];
  if (!emailArg) {
    console.error('Usage: node scripts/findUser.js <email>');
    process.exit(1);
  }

  try {
    await mongoose.connect(mongoUrl, { dbName: undefined });

    // Import the user model from the project
    const userModule = await import(join(__dirname, '..', 'model', 'user.js'));
    const userModel = userModule.userModel;

    const email = emailArg.toLowerCase().trim();
    const user = await userModel.findOne({ email }).lean();

    if (!user) {
      console.log(`User not found for email: ${email}`);
      process.exit(0);
    }

    // Print a small summary
    const out = {
      email: user.email,
      isVerified: user.isVerified,
      createdAt: user.createdAt,
      lastLogin: user.lastLogin,
      passwordHashPresent: !!user.password,
      verificationToken: !!user.verificationToken,
    };

    console.log(JSON.stringify(out, null, 2));
    process.exit(0);
  } catch (err) {
    console.error('Error querying DB:', err);
    process.exit(1);
  }
};

run();
