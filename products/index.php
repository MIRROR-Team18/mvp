<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Products - MIRЯOR</title>
	<link rel="stylesheet" href="../_stylesheets/main.css">
    <link rel="stylesheet" href="../_stylesheets/products.css">
    <script src="../_scripts/productsListing.js" defer async></script>
</head>
<body>
    <?php include '../_components/header.php'; ?>
    <header>
        <h1>PRODUCTS</h1>
        <p>we have products. see them.</p>
    </header>
    <main>
        <section id="productsGrid">
            <div class="left">
                <div id="forProductType" class="filterGroup">
                    <div class="title">
                        <h2>Type</h2>
                        <a href="#" id="productType_any" class="selected">Any of...</a>&nbsp;|&nbsp;<a href="#" id="productType_only">Only...</a>
                    </div>
                    <div class="inputLabelGroup">
                        <input type="checkbox" name="tops" id="tops">
                        <label for="tops">Tops</label>
                    </div>
                    <div class="inputLabelGroup">
                        <input type="checkbox" name="bottoms" id="bottoms">
                        <label for="bottoms">Bottoms</label>
                    </div>
                    <div class="inputLabelGroup">
                        <input type="checkbox" name="socks" id="socks">
                        <label for="socks">Socks</label>
                    </div>
                    <div class="inputLabelGroup">
                        <input type="checkbox" name="shoes" id="shoes">
                        <label for="shoes">Shoes</label>
                    </div>
                    <div class="inputLabelGroup">
                        <input type="checkbox" name="accessories" id="accessories">
                        <label for="accessories">Accessories</label>
                    </div>
                </div>
            </div>
            <div class="right">
                <?php
                require_once '../_components/database.php';
                $db = new Database();
                try {
					$products = $db->getAllProducts();

					foreach ($products as $product) {
                        $pathForPhoto = "../_images/products/" . $product->productID . "/";
                        $photo = file_exists($pathForPhoto) ? $pathForPhoto . scandir($pathForPhoto)[2] : "https://picsum.photos/512"; // [0] is ".", [1] is ".."

                        $price = "Unknown...";

                        if (sizeof($product->sizes) > 0) {
                            // Add all available prices into an array
                            $prices = array();
                            foreach ($product->sizes as $size) {
                                if (isset($size->price)) $prices[] = $size->price;
                            }

							if (sizeof($prices) > 2) { $price = "From £" . min($prices); } // If there's more than one price, provide the lowest price.
                            else if (sizeof($prices) == 1) { $price = "£" . $prices[0]; } // Only one price, just provide that price
                            // No final else, because price is already set
                        }

                    ?>
                        <div class="product" id="<?= $product->productID ?>" data-product-type="<?= $product->type ?>" onclick="window.location.href='./product.php?id=<?= $product->productID ?>'">
                            <img src="<?= $photo ?>" alt="<?= $product->productID . "_image" ?>">
                            <h1><?= $product->name ?></h1>
                            <h2><?= $price ?></h2>
                        </div>
                    <?php
					}
                } catch (Exception $e) {
                    echo $e->getMessage();
                }
                ?>
            </div>
        </section>
    </main>
    <?php include '../_components/footer.php'; ?>
</body>
</html>