-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 29, 2024 at 04:22 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dbparking`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin_data`
--

CREATE TABLE `admin_data` (
  `admin_id` int(50) NOT NULL,
  `admin_fname` varchar(100) NOT NULL,
  `admin_lname` int(100) NOT NULL,
  `admin_gender` varchar(50) NOT NULL,
  `admin_email` varchar(100) NOT NULL,
  `admin_password` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lot_data`
--

CREATE TABLE `lot_data` (
  `lot_id` int(50) NOT NULL,
  `lot_name` varchar(100) NOT NULL,
  `lot_add` int(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `owner_data`
--

CREATE TABLE `owner_data` (
  `owner_id` int(50) NOT NULL,
  `owner_fname` varchar(100) NOT NULL,
  `owner_lname` varchar(100) NOT NULL,
  `owner_gender` varchar(50) NOT NULL,
  `owner_email` varchar(100) NOT NULL,
  `owner_add` varchar(200) NOT NULL,
  `owner_password` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
('A1', 'VACANT', -1.29210000, 36.82190000, '2024-06-11 09:03:12'),
('B2', 'VACANT', -1.30000000, 36.85000000, '2024-05-30 08:27:53'),
('C1', 'VACANT', -1.30000000, 36.85000000, '2024-05-30 09:25:53'),
('D2', 'VACANT', -31.33000000, 23.85400000, '2024-05-30 11:06:58');

-- --------------------------------------------------------

--
-- Table structure for table `p_manager`
--

CREATE TABLE `p_manager` (
  `manager_id` int(50) NOT NULL,
  `manager_fname` varchar(100) NOT NULL,
  `manager_lname` int(100) NOT NULL,
  `manager_gender` varchar(50) NOT NULL,
  `manager_email` varchar(100) NOT NULL,
  `manager_password` varchar(100) NOT NULL,
  `lot_id` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `space_data`
--

CREATE TABLE `space_data` (
  `space_no` int(50) NOT NULL,
  `space_status` tinyint(1) NOT NULL,
  `lot_id` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `space_history`
--

CREATE TABLE `space_history` (
  `space_id` int(50) NOT NULL,
  `lot_id` int(50) NOT NULL,
  `space_entry` datetime(6) NOT NULL,
  `space_exit` datetime(6) DEFAULT NULL,
  `space_payment` int(100) DEFAULT NULL,
  `vehicle_lpn` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_data`
--

CREATE TABLE `vehicle_data` (
  `vehicle_lpn` varchar(50) NOT NULL,
  `vehicle_model` varchar(100) NOT NULL,
  `vehicle_color` varchar(50) NOT NULL,
  `owner_id` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_data`
--
ALTER TABLE `admin_data`
  ADD PRIMARY KEY (`admin_id`);

--
-- Indexes for table `lot_data`
--
ALTER TABLE `lot_data`
  ADD PRIMARY KEY (`lot_id`);

--
-- Indexes for table `owner_data`
--
ALTER TABLE `owner_data`
  ADD PRIMARY KEY (`owner_id`);

--
-- Indexes for table `parking_spaces`
--
ALTER TABLE `parking_spaces`
  ADD PRIMARY KEY (`sensor_id`);

--
-- Indexes for table `p_manager`
--
ALTER TABLE `p_manager`
  ADD PRIMARY KEY (`manager_id`),
  ADD KEY `lot_id` (`lot_id`);

--
-- Indexes for table `space_data`
--
ALTER TABLE `space_data`
  ADD PRIMARY KEY (`space_no`),
  ADD KEY `lot_id` (`lot_id`);

--
-- Indexes for table `space_history`
--
ALTER TABLE `space_history`
  ADD PRIMARY KEY (`space_id`),
  ADD KEY `vehicle_lpn` (`vehicle_lpn`);

--
-- Indexes for table `vehicle_data`
--
ALTER TABLE `vehicle_data`
  ADD PRIMARY KEY (`vehicle_lpn`),
  ADD KEY `owner_id` (`owner_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin_data`
--
ALTER TABLE `admin_data`
  MODIFY `admin_id` int(50) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lot_data`
--
ALTER TABLE `lot_data`
  MODIFY `lot_id` int(50) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `p_manager`
--
ALTER TABLE `p_manager`
  MODIFY `manager_id` int(50) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `p_manager`
--
ALTER TABLE `p_manager`
  ADD CONSTRAINT `p_manager_ibfk_1` FOREIGN KEY (`lot_id`) REFERENCES `lot_data` (`lot_id`);

--
-- Constraints for table `space_data`
--
ALTER TABLE `space_data`
  ADD CONSTRAINT `space_data_ibfk_1` FOREIGN KEY (`lot_id`) REFERENCES `lot_data` (`lot_id`);

--
-- Constraints for table `space_history`
--
ALTER TABLE `space_history`
  ADD CONSTRAINT `space_history_ibfk_1` FOREIGN KEY (`vehicle_lpn`) REFERENCES `vehicle_data` (`vehicle_lpn`);

--
-- Constraints for table `vehicle_data`
--
ALTER TABLE `vehicle_data`
  ADD CONSTRAINT `vehicle_data_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `owner_data` (`owner_id`) ON DELETE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
