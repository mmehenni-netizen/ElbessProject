import { productModel } from "../model/product.js";
import { storeModel } from "../model/store.js";
import { userModel } from "../model/user.js";
import { orderModel } from "../model/order.js";

//setfavorite
//checkout

export const setProfile = async (req, res) => {
  const { firstName, lastName, phone, dateOfBirth, address, gender } =
    req.body || {};

  try {
    if (
      !firstName ||
      !lastName ||
      !phone ||
      !dateOfBirth ||
      !address ||
      !gender
    ) {
      throw new Error("All fields are required !");
    }

    const user = await userModel.findById(req.user._id);

    if (!user) {
      throw new Error("User not found !");
    }

    const date = new Date(dateOfBirth); // we gonna fix UTC timezones parsing problem

    user.firstName = firstName;
    user.lastName = lastName;
    user.phone = phone;
    user.dateOfBirth = new Date(
      Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()),
    );
    user.address = address;
    user.gender = gender;

    await user.save();

    return res.status(200).json({
      success: true,
      message: "Profile updated successfully !",
      user: {
        firstName: user.firstName,
        lastName: user.lastName,
        phone: user.phone,
        dateOfBirth: user.dateOfBirth,
        address: user.address,
        gender: user.gender,
      },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

export const setFavorite = async (req, res) => {
  const { productId } = req.body || {};

  try {
    if (!productId) {
      throw new Error("Product ID is required !");
    }

    const product = await productModel.findById(productId);

    if (!product) {
      throw new Error("No product found !");
    }

    const user = await userModel.findById(req.user._id);

    if (!user) {
      throw new Error("User not found !");
    }

    const isFavorite = user.favorites.includes(productId);

    if (isFavorite) {
      user.favorites = user.favorites.filter(
        (id) => id.toString() !== productId,
      );

      await user.save();

      return res.status(200).json({
        success: true,
        message: "Product removed from favorites !",
        isFavorite: false,
        favorites: user.favorites,
      });
    } else {
      user.favorites.push(productId);

      await user.save();

      return res.status(200).json({
        success: true,
        message: "Product added to favorites !",
        isFavorite: true,
        favorites: user.favorites,
      });
    }
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

export const rate = async (req, res) => {
  const { storeId, productId, rating } = req.body || {};

  let type = "";

  try {
    if (!storeId && !productId) {
      throw new Error("Store ID or Product ID is required !");
    }

    if (!rating || rating < 1 || rating > 5) {
      throw new Error("Rating must be between 1 and 5 !");
    }

    const user = await userModel.findById(req.user._id);

    if (!user) {
      throw new Error("User not found !");
    }

    let entry;

    if (productId) {
      entry = await productModel.findById(productId);
      type = "product";

      if (!entry) {
        throw new Error("No product found !");
      }
    } else if (storeId) {
      entry = await storeModel.findById(storeId);
      type = "store";

      if (!entry) {
        throw new Error("No store found !");
      }
    }

    const hasRated = entry.rates.some(
      (r) => r.user.toString() === user._id.toString(),
    );

    if (hasRated) {
      entry.rates = entry.rates.map((r) => {
        if (r.user.toString() === user._id.toString()) {
          r.rate = rating;
        }
        return r;
      });
    } else {
      entry.rates.push({
        user: user._id,
        rate: rating,
      });
    }

    // Recalculate the average rating

    const newRating =
      Math.floor(
        (entry.rates.reduce((acc, r) => acc + r.rate, 0) / entry.rates.length) *
          10,
      ) / 10;
    entry.rating = newRating;

    await entry.save();

    return res.status(200).json({
      success: true,
      message: `Rating ${type} submitted successfully !`,
      rating: newRating,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

export const checkout = async (req, res) => {
  let orders = [];
  let createdOrders = [];

  try {
    if (req.body.office === null || req.body.domicile === null) {
      throw new Error("Office and domicile are required !");
    }

    if (!req.body.orders) {
      throw new Error("Orders are required !");
    }

    if (Array.isArray(req.body.orders)) {
      orders = req.body.orders;
    } else if (typeof req.body.orders === "object") {
      orders = [req.body.orders];
    } else {
      throw new Error("Invalid order format !");
    }

    const user = await userModel.findById(req.user._id);

    if (!user) {
      throw new Error("User not found !");
    }

    // now creating orders for each item in the orders array

    for (const item of orders) {
      if (!item.productId || !item.quantity || !item.size) {
        throw new Error(
          "Invalid order item format ! productId, quantity, size, are required for each order item !",
        );
      }

      const product = await productModel.findById(item.productId);

      if (!product) {
        throw new Error("No product found ! invalid productId");
      }

      const productQuantity = product.sizeQuantities.find(
        (s) => s.size === item.size,
      )?.quantity;

      if (!productQuantity || productQuantity < item.quantity) {
        throw new Error(
          `Size not found or not enough quantity for product ${product.name} in size ${item.size} !`,
        );
      }

      const order = await orderModel.create({
        user: req.user._id,
        store: product.store,
        product: item.productId,
        quantity: item.quantity,
        size: item.size,
        office: req.body.office,
        domicile: req.body.domicile,
      });

      createdOrders.push(order);

      await user.updateOne({ $push: { orders: order._id } });

      // now reducing the quantity of the product in the database
      product.sizeQuantity = product.sizeQuantities.map((s) => {
        if (s.size === item.size) {
          s.quantity -= item.quantity;
        }
        return s;
      });

      await product.save();
    }

    return res.status(200).json({
      success: true,
      message: "Orders placed successfully !",
      orders: createdOrders,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
      successfullyCreatedOrders: createdOrders,
    });
  }
};
