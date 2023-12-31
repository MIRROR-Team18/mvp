<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Shopping Basket - MIЯЯOR</title>
    <link rel="stylesheet" href="_stylesheets/main.css">
    <link rel="stylesheet" href="_stylesheets/basket.css">
</head>
<body>
    <?php include '_components/header.php'; ?>

    <main class="basket-container">
        <h1>Your Shopping Basket</h1>
        <table id="basket">
            <thead>
                <tr>
                    <th>Product</th>
                    <th>Description</th>
                    <th>Quantity</th>
                    <th>Price</th>
                </tr>
            </thead>
            <tbody>
                <?php
				    require_once '_components/database.php';
				    if (session_status() === PHP_SESSION_NONE) session_start();
				    $total = 0; // Used at the bottom

                    if (isset($_SESSION['basket'])) {
						// Fixes __PHP_Incomplete_Class_Name. Did you know I dislike PHP? - Pawel
						$basket = array_map(function ($item) {
							return unserialize(serialize($item));
						}, $_SESSION['basket']);

                        foreach ($basket as $item) {
							/* @var $item Product */

                            $MAX_QUANTITY = 10;
                            $quantityOptions = "";
                            for ($i = 1; $i <= $MAX_QUANTITY; $i++) {
                                $quantityOptions .= "<option value='$i'>$i</option>";
                            }

							$pathForPhoto = "./_images/products/" . $item->productID . "/";
							$photo = file_exists($pathForPhoto) ? $pathForPhoto . scandir($pathForPhoto)[2] : "https://picsum.photos/512"; // [0] is ".", [1] is ".."

                            $sizeName = $item->sizes[0]->name ?? "One Size";
                            $sizePrice = $item->sizes[0]->price ?? 0;

                            echo <<<EOT
                            <tr id="{$item->productID}">
                                <td><img src="{$photo}" alt="{$item->name}" class="product-image"></td>
                                <td>
                                    <p class="name">{$item->name}</p>
                                    <p>Color: {$sizeName}</p>
                                </td>
                                <td>
                                    <select>$quantityOptions</select>
                                </td>
                                <td class="price">£{$sizePrice}</td>
                            </tr>      
                            EOT;

                            $total += $sizePrice;
                        }
                    } else {
                        echo "<tr><td colspan='4'>Your basket is empty!</td></tr>";
                    }
				?>
            </tbody>
        </table>

        <!-- Order Summary Section -->
        <div id="order-summary">
            <h2>Order Summary</h2>
            <!-- <p>Order Value: £19.99</p> Reimplement after MVP -->
            <!-- Add other order summary details as needed -->
            <div id="total">TOTAL: £0.00</div>
            <!-- Use an anchor tag around the button for navigation -->
            <button onclick="storeQuantityData()" id="continue-to-checkout">Continue to Checkout</button>
        </div>
    </main>

    <script>
        function storeQuantityData() {
            const basket = document.getElementById("basket");
            const quantities = {};
            for (let i = 1; i < basket.rows.length; i++) {
                if (basket.rows[i].cells.length === 1) continue; // Skip if the row is empty
                quantities[`${basket.rows[i].id}`] = basket.rows[i].cells[2].children[0].value
            }
            // Save cookie
            document.cookie = `quantities=${JSON.stringify(quantities)}; path=/`;

            window.location.href = "checkout.php";
        }

        function calculateTotal() {
            const basket = document.getElementById("basket");
            const total = document.getElementById("total");

            // Add up all totals
            let totalValue = 0;
            for (let i = 1; i < basket.rows.length; i++) {
                totalValue += parseFloat(basket.rows[i].cells[3].innerText.replace("£", "")) * parseInt(basket.rows[i].cells[2].children[0].value)
            }
            total.innerText = `TOTAL: £${totalValue.toFixed(2)}`;
        }

        window.addEventListener("load", calculateTotal)
        document.querySelectorAll("select").forEach(select => select.addEventListener("change", calculateTotal));
    </script>

    <?php include '_components/footer.php'; ?>
</body>
</html>
