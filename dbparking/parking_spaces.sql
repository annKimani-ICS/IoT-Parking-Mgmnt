-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 10, 2024 at 11:36 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `parkingdetails`
--

-- --------------------------------------------------------

--
-- Table structure for table `parking_spaces`
--

CREATE TABLE `parking_spaces` (
  `sensor_id` varchar(50) NOT NULL,
  `status` varchar(10) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `parking_spaces`
--

INSERT INTO `parking_spaces` (`sensor_id`, `status`, `latitude`, `longitude`, `timestamp`) VALUES
('A1', 'OCCUPIED', -1.29210000, 36.82190000, '2024-06-10 09:29:54'),
('B2', 'VACANT', -1.30000000, 36.85000000, '2024-05-30 08:27:53'),
('C1', 'VACANT', -1.30000000, 36.85000000, '2024-05-30 09:25:53'),
('D2', 'VACANT', -31.33000000, 23.85400000, '2024-05-30 11:06:58');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `parking_spaces`
--
ALTER TABLE `parking_spaces`
  ADD PRIMARY KEY (`sensor_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
