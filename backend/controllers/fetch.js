import { productModel } from "../model/product.js";
import { storeModel } from "../model/store.js";
import { userModel } from "../model/user.js";

const normalizeProductImages = (product) => {
  const baseProduct =
    typeof product?.toObject === "function" ? product.toObject() : product;

  let imageUrl = [];

  if (Array.isArray(baseProduct?.imageUrl)) {
    imageUrl = baseProduct.imageUrl.filter(
      (url) => typeof url === "string" && url.trim().length > 0,
    );
  } else if (
    typeof baseProduct?.imageUrl === "string" &&
    baseProduct.imageUrl.trim().length > 0
  ) {
    imageUrl = [baseProduct.imageUrl];
  } else if (
    typeof baseProduct?.image === "string" &&
    baseProduct.image.trim().length > 0
  ) {
    imageUrl = [baseProduct.image];
  }

  return {
    ...baseProduct,
    imageUrl,
    image: imageUrl[0] || "",
  };
};

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

      const products = fetchedProducts.map(normalizeProductImages);

      res.status(200).json({
        success: true,
        count: products.length,
        message: "Products fetched successfully !",
        products,
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

      const products = fetchedProducts.map(normalizeProductImages);

      res.status(200).json({
        success: true,
        count: products.length,
        message: "Products fetched successfully !",
        products,
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
      product: normalizeProductImages(product),
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
      const unitPrice = Number.isFinite(Number(orders[i].price))
        ? Number(orders[i].price)
        : orders[i].product.price;

      total = total + unitPrice * orders[i].quantity;
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

export const getProfile = async (req, res) => {
  try {
    const user = await userModel.findById(req.user._id).select(
      "username email firstName lastName phone address dateOfBirth gender",
    );

    if (!user) {
      throw new Error("User not found !");
    }

    res.status(200).json({
      success: true,
      message: "Profile fetched successfully !",
      user: user,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
