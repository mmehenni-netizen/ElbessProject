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
    console.error("Rate handler error:", error);
    // Include stack trace in response for debugging (redeploy to remove in prod)
    const stack = error && error.stack ? error.stack : '';
    return res.status(500).json({
      success: false,
      message: `${error.message}${stack ? '\n' + stack : ''}`,
    });
  }
};

export const setFavorite = async (req, res) => {
  const productId =
    typeof req.body?.productId === "string" ? req.body.productId.trim() : "";

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

    const isFavorite = user.favorites.some(
      (id) => id.toString() === productId,
    );

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
  const body = req.body || {};

  const rawProductId = body.productId ?? body.productID ?? body.product_id ?? '';
  const rawStoreId   = body.storeId   ?? body.storeID   ?? body.store_id   ?? '';
  const rawRating    = body.rating    ?? body.Rating     ?? body.rate       ?? '';

  const productId   = String(rawProductId).trim();
  const storeId     = String(rawStoreId).trim();
  const parsedRating = Number(rawRating);

  if (!productId && !storeId) {
    return res.status(400).json({ success: false, message: 'Store ID or Product ID is required!' });
  }

  if (!Number.isFinite(parsedRating) || parsedRating < 1 || parsedRating > 5) {
    return res.status(400).json({ success: false, message: 'Rating must be between 1 and 5!' });
  }

  let type = '';

  try {
    const user = await userModel.findById(req.user._id);
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found!' });
    }

    let entry;

    if (productId) {
      entry = await productModel.findById(productId);
      type  = 'product';
      if (!entry) {
        return res.status(404).json({ success: false, message: 'No product found!' });
      }
    } else {
      entry = await storeModel.findById(storeId);
      type  = 'store';
      if (!entry) {
        return res.status(404).json({ success: false, message: 'No store found!' });
      }
    }

    const hasRated = entry.rates.some(
      (r) => r.user.toString() === user._id.toString()
    );

    if (hasRated) {
      entry.rates = entry.rates.map((r) => {
        if (r.user.toString() === user._id.toString()) r.rate = parsedRating;
        return r;
      });
    } else {
      entry.rates.push({ user: user._id, rate: parsedRating });
    }

    const newRating =
      Math.floor(
        (entry.rates.reduce((acc, r) => acc + r.rate, 0) / entry.rates.length) * 10
      ) / 10;

    entry.rating = newRating;
    await entry.save();

    return res.status(200).json({
      success: true,
      message: `Rating ${type} submitted successfully!`,
      rating: newRating,
    });
  } catch (error) {
    console.error('Rate handler error:', error);
    return res.status(500).json({ success: false, message: error.message });
  }
};

export const checkout = async (req, res) => {
  let orders = [];
  let createdOrders = [];
  const name = typeof req.body.name === "string" ? req.body.name.trim() : "";
  const location =
    typeof req.body.location === "string" ? req.body.location.trim() : "";
  const numero =
    typeof req.body.numero === "string" ? req.body.numero.trim() : "";

  try {
    if (
      typeof req.body.office !== "boolean" ||
      typeof req.body.domicile !== "boolean"
    ) {
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

    const validatedItems = [];

    for (const item of orders) {
      const productId =
        typeof item?.productId === "string" ? item.productId.trim() : "";
      const size = typeof item?.size === "string" ? item.size.trim() : "";
      const quantity = Number(item?.quantity);
      const price = Number(item?.price);

      if (
        !productId ||
        !size ||
        !Number.isFinite(quantity) ||
        quantity <= 0
      ) {
        throw new Error(
          "Invalid order item format ! productId, quantity, size, are required for each order item !",
        );
      }

      const product = await productModel.findById(productId);

      if (!product) {
        throw new Error("No product found ! invalid productId");
      }

      const productQuantity = product.sizeQuantities.find(
        (s) => s.size === size,
      )?.quantity;

      if (productQuantity === undefined || productQuantity < quantity) {
        throw new Error(
          `Size not found or not enough quantity for product ${product.name} in size ${size} !`,
        );
      }

      const orderPrice =
        Number.isFinite(price) && price >= 0 ? price : product.price;

      validatedItems.push({
        product,
        productId,
        quantity,
        size,
        orderPrice,
      });
    }

    for (const item of validatedItems) {
      const order = await orderModel.create({
        user: req.user._id,
        store: item.product.store,
        product: item.productId,
        quantity: item.quantity,
        price: item.orderPrice,
        name: name,
        location: location,
        numero: numero,
        size: item.size,
        office: req.body.office,
        domicile: req.body.domicile,
      });

      createdOrders.push(order);
      await user.updateOne({ $push: { orders: order._id } });

      // Reduce inventory without re-saving the entire product document.
      await productModel.updateOne(
        {
          _id: item.product._id,
          "sizeQuantities.size": item.size,
        },
        {
          $inc: {
            "sizeQuantities.$.quantity": -item.quantity,
            totalQuantity: -item.quantity,
          },
        },
      );
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
export const getRate = async (req, res) => {
  const productId = typeof req.query.productId === 'string' ? req.query.productId.trim() : '';
  const storeId   = typeof req.query.storeId   === 'string' ? req.query.storeId.trim()   : '';

  if (!productId && !storeId) {
    return res.status(400).json({ success: false, message: 'Store ID or Product ID is required!' });
  }

  try {
    const user = await userModel.findById(req.user._id);
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found!' });
    }

    let entry;
    let type;

    if (productId) {
      entry = await productModel.findById(productId).select('rates rating');
      type  = 'product';
      if (!entry) {
        return res.status(404).json({ success: false, message: 'No product found!' });
      }
    } else {
      entry = await storeModel.findById(storeId).select('rates rating');
      type  = 'store';
      if (!entry) {
        return res.status(404).json({ success: false, message: 'No store found!' });
      }
    }

    const userRate = entry.rates.find(
      (r) => r.user.toString() === user._id.toString()
    );

    return res.status(200).json({
      success: true,
      type,
      rating: entry.rating,        // average rating
      totalRates: entry.rates.length,
      userRate: userRate ? userRate.rate : null, // current user's rating or null
    });
  } catch (error) {
    console.error('GetRate handler error:', error);
    return res.status(500).json({ success: false, message: error.message });
  }
};

export const getProfile = async (req, res) => {
  try {
    const user = await userModel.findById(req.user._id).select(
      'username email firstName lastName phone address dateOfBirth gender isSeller isVerified lastLogin createdAt'
    );

    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found!' });
    }

    return res.status(200).json({
      success: true,
      user: {
        id:          user._id,
        username:    user.username,
        email:       user.email,
        firstName:   user.firstName,
        lastName:    user.lastName,
        phone:       user.phone,
        address:     user.address,
        dateOfBirth: user.dateOfBirth,
        gender:      user.gender,
        isSeller:    user.isSeller,
        isVerified:  user.isVerified,
        lastLogin:   user.lastLogin,
        createdAt:   user.createdAt,
      },
    });
  } catch (error) {
    console.error('GetProfile handler error:', error);
    return res.status(500).json({ success: false, message: error.message });
  }
};
