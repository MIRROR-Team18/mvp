-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 11, 2023 at 03:50 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mirror_mvp`
--

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `orderID` int(8) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `userID` varchar(8) NOT NULL,
  `status` enum('processing','dispatched') NOT NULL DEFAULT 'processing',
  `paidAmount` float(9,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `productID` varchar(32) NOT NULL PRIMARY KEY,
  `name` varchar(64) NOT NULL,
  `type` enum('tops','bottoms','socks','shoes','accessories') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products_in_orders`
--

CREATE TABLE `products_in_orders` (
  `orderID` int(8) NOT NULL,
  `productID` varchar(32) NOT NULL,
  `sizeID` int(8) NOT NULL,
  `quantity` int(2) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_sizes`
--

CREATE TABLE `product_sizes` (
  `productID` varchar(32) NOT NULL,
  `sizeID` int(8) NOT NULL,
  `price` float(9,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sizes`
--

CREATE TABLE `sizes` (
  `sizeID` int(8) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `userID` varchar(8) NOT NULL PRIMARY KEY,
  `firstName` varchar(100) NOT NULL,
  `lastName` varchar(100) NOT NULL,
  `email` varchar(320) NOT NULL,
  `password` varchar(256) NOT NULL,
  `admin` int(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `contact`
--

CREATE TABLE `enquiries` (
  `enquiryID` int(8) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `type` enum('contact', 'refund') NOT NULL,
  `nameProvided` varchar(256) DEFAULT NULL,
  `emailProvided` varchar(320) DEFAULT NULL,
  `userID` varchar(8) DEFAULT NULL,
  `message` varchar(2000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
    reviewID int(8) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name varchar(100) NOT NULL,
    rating int(1) NOT NULL,
    comment varchar(2000) NOT NULL,
    date date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD KEY `FK_Orders_User` (`userID`),
  AUTO_INCREMENT=10000000;

--
-- Indexes for table `products_in_orders`
--
ALTER TABLE `products_in_orders`
  ADD PRIMARY KEY (`orderID`,`productID`),
  ADD KEY `FK_ProductsOrders_Product` (`productID`),
  ADD KEY `FK_ProductsOrders_Size` (`sizeID`);

--
-- Indexes for table `product_sizes`
--
ALTER TABLE `product_sizes`
  ADD PRIMARY KEY (`productID`,`sizeID`),
  ADD KEY `FK_ProductSizes_Size` (`sizeID`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `FK_Orders_User` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`);

--
-- Constraints for table `products_in_orders`
--
ALTER TABLE `products_in_orders`
  ADD CONSTRAINT `FK_ProductsOrders_Order` FOREIGN KEY (`orderID`) REFERENCES `orders` (`orderID`),
  ADD CONSTRAINT `FK_ProductsOrders_Product` FOREIGN KEY (`productID`) REFERENCES `products` (`productID`),
  ADD CONSTRAINT `FK_ProductsOrders_Size` FOREIGN KEY (`sizeID`) REFERENCES `sizes` (`sizeID`);

--
-- Constraints for table `product_sizes`
--
ALTER TABLE `product_sizes`
  ADD CONSTRAINT `FK_ProductSizes_Product` FOREIGN KEY (`productID`) REFERENCES `products` (`productID`),
  ADD CONSTRAINT `FK_ProductSizes_Size` FOREIGN KEY (`sizeID`) REFERENCES `sizes` (`sizeID`);

--
-- Constraints for table `contact`
--
ALTER TABLE `enquiries`
  ADD CONSTRAINT `FK_ContactUser_User` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`);

--
-- Inserts for table `products`
--

INSERT INTO `products` (`productID`, `name`, `type`) VALUES
    ('bag-bag', 'Bag Bag', 'accessories'),
    ('black-socks', 'Plain Black Socks', 'socks'),
    ('conversation-high-shoes', 'Conversation High-Top Shoes', 'shoes'),
    ('hardtail-shoes-men', 'Hardtail Mens Shoes', 'shoes'),
    ('headfirst-jeans', 'Headfirst Jeans', 'bottoms'),
    ('highrise-tee-unisex', 'Highrise Unisex Top', 'tops'),
    ('mirror-cap', 'MIRЯOR Cap', 'accessories'),
    ('pole-recycle-trousers', 'Recycleable Pole Trousers', 'bottoms'),
    ('shephard-tee-men', 'Shephard Mens Top', 'tops'),
    ('white-socks', 'Plain White Socks', 'socks');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
