-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 20, 2023 at 03:49 AM
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
-- Database: `u207645337_pakar`
--

-- --------------------------------------------------------

--
-- Table structure for table `check_everyday`
--

CREATE TABLE `check_everyday` (
  `id` int(11) NOT NULL,
  `reportby` varchar(255) DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  `designation` varchar(255) DEFAULT NULL,
  `contactno` varchar(255) DEFAULT NULL,
  `locationno` varchar(255) DEFAULT NULL,
  `asset_no` varchar(255) DEFAULT NULL,
  `detailsreport` varchar(255) DEFAULT NULL,
  `main_workno` varchar(255) DEFAULT NULL,
  `date_req` varchar(255) DEFAULT NULL,
  `helpdesk` varchar(255) DEFAULT NULL,
  `wo_category` varchar(255) DEFAULT NULL,
  `date` varchar(255) DEFAULT NULL,
  `branch_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `check_everyday`
--

INSERT INTO `check_everyday` (`id`, `reportby`, `company`, `designation`, `contactno`, `locationno`, `asset_no`, `detailsreport`, `main_workno`, `date_req`, `helpdesk`, `wo_category`, `date`, `branch_id`) VALUES
(3, 'siti nor bin Alii', 'JDS HTAA', 'ACOOO', '1528', 'L1-CA-045(luar)', 'WV109000101A', 'Door Access Tercabut ', 'MWRWAC/F/2022/006426', '2022-08-11T04:31', 'INAA', 'normal', '2022-11-03 06:55:39', 1),
(8, 'Ilyas', 'HTA', 'ACO', '01112345374', 'L2-CA-23', 'WF653006576A', 'TEST', 'PMWWAC/F/2023/004835', '20/7/2023', 'ina', 'Normal', '2023-07-20 09:39:16', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `check_everyday`
--
ALTER TABLE `check_everyday`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `check_everyday`
--
ALTER TABLE `check_everyday`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
