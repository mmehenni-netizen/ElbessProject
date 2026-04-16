import { productModel } from "../model/product.js";
import { storeModel } from "../model/store.js";
import { userModel } from "../model/user.js";

export const getProducts = async (req, res) => {
  try {
    if (!req.query.categories) {
      const fetchedProducts = await productModel
        .find()
        .sort({ rating: -1 })
        .limit(4)
        .populate("store");

      if (!fetchedProducts || fetchedProducts.length === 0) {
        throw new Error("No products found !");
      }

      res.status(200).json({
        success: true,
        message: "Products fetched successfully !",
        products: fetchedProducts,
      });
    } else {
      const categories = req.query.categories.split(",");

      const fetchedProducts = await productModel
        .find({ category: { $in: categories } })
        .sort({ rating: -1 })
        .limit(4)
        .populate("store");

      if (!fetchedProducts || fetchedProducts.length === 0) {
        throw new Error(
          `No products found for categories: ${categories.join(", ")}`,
        );
      }

      res.status(200).json({
        success: true,
        message: "Products fetched successfully !",
        products: fetchedProducts,
      });
    }
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

export const getStores = async (req, res) => {
  try {
    const fetchedStores = await storeModel
      .find()
      .sort({ rating: -1 })
      .limit(6)
      .populate("products");

    if (!fetchedStores || fetchedStores.length === 0) {
      throw new Error("No stores found !");
    }

    res.status(200).json({
      success: true,
      message: "Stores fetched successfully !",
      stores: fetchedStores,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

export const getProductById = async (req, res) => {
  const { id } = req.params;
  try {
    const product = await productModel.findById(id).populate("store");
    if (!product) {
      throw new Error("Product not found !");
    }
    res.status(200).json({
      success: true,
      message: "Product fetched successfully !",
      product: product,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

export const getStoreById = async (req, res) => {
  const { id } = req.params;
  try {
    const store = await storeModel
      .findById(id)
      .populate("products")
      .select("-Password -isEmailVerified -EmailVerificationToken -Oreders");
    if (!store) {
      throw new Error("Store not found !");
    }
    res.status(200).json({
      success: true,
      message: "Store fetched successfully !",
      store: store,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

export const getOrders = async (req, res) => {
  try {
    const user = await userModel
      .findById(req.user._id)
      .populate({ path: "orders", populate: { path: "product" } });

    const orders = user.orders;

    let total = 0;

    if (!orders || orders.length === 0) {
      throw new Error("No orders found !");
    }

    for (let i = 0; i < orders.length; i++) {
      total = total + orders[i].product.price * orders[i].quantity;
    }

    res.status(200).json({
      success: true,
      message: "Orders fetched successfully !",
      orders: orders,
      total: total,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

export const getFavorites = async (req, res) => {
  try {
    const user = await userModel
      .findById(req.user._id)
      .populate({ path: "favorites", populate: { path: "store" } });

    if (!user.favorites || user.favorites.length === 0) {
      throw new Error("No favorites found !");
    }

    res.status(200).json({
      success: true,
      message: "Favorites fetched successfully !",
      favorites: user.favorites,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
