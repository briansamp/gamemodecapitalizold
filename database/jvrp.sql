-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 17, 2023 at 03:55 PM
-- Server version: 10.4.25-MariaDB
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jvrp`
--

-- --------------------------------------------------------

--
-- Table structure for table `atms`
--

CREATE TABLE `atms` (
  `id` int(11) NOT NULL,
  `posx` float NOT NULL,
  `posy` float NOT NULL,
  `posz` float NOT NULL,
  `posrx` float NOT NULL,
  `posry` float NOT NULL,
  `posrz` float NOT NULL,
  `interior` int(11) NOT NULL DEFAULT 0,
  `world` int(11) NOT NULL DEFAULT 0,
  `status` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `atms`
--

INSERT INTO `atms` (`id`, `posx`, `posy`, `posz`, `posrx`, `posry`, `posrz`, `interior`, `world`, `status`) VALUES
(0, 2248.51, -1759.95, 1014.38, 0, 0, -176.5, 1, 0, 0),
(10, -31.9054, -57.9272, 1003.17, 0, 0, -179.9, 6, 43, 0),
(6, 391.069, -1805.93, 7.53812, 0, 0, 171, 0, 0, 0),
(7, -83.7463, -1182.51, 1.54701, 0, 0, -111.8, 0, 0, 0),
(1, 1966.06, 1166.25, -5.6387, 0, 0, 90.4001, 0, 0, 0),
(11, 1250.22, -1271.2, 13.151, 0, 0, 0.700018, 0, 0, 0),
(14, 2105.39, -1807.7, 13.0447, 0, 0, -91.9, 0, 0, 0),
(18, 1104.13, -1223.01, 15.481, 0, 0, -3.99999, 0, 0, 0),
(19, 2236.09, -1664.4, 15.0972, 0, 0, -104.1, 0, 0, 0),
(24, 1002.26, -1371.06, 13.1054, 0, 0, -88.3, 0, 0, 0),
(25, 178.043, -92.5971, 1031.05, 0, 0, 0, 255, 0, 0),
(15, 1240.7, -1291.17, 1060.62, 0, 0, 90.5001, 0, 0, 0),
(9, 1052.99, -907.522, 43.0656, 0, 1.4, -81.5, 0, 0, 0),
(5, 1372.83, -1765.73, 13.0969, 0, 0, 178.6, 0, 0, 0),
(3, 539.329, -1287.15, 16.9401, 0, 0, 0, 0, 0, 0),
(31, -185.762, 1211.3, 19.2954, 0, 0, 0, 0, 0, 0),
(2, 975.341, -1253.69, 16.5094, 0, 0, 0, 0, 0, 0),
(12, 1933.05, -1805.41, 13.0928, 0, 0, 179.1, 0, 0, 0),
(4, 1272.06, -1793.87, 13.0932, 0, 0, 0, 0, 0, 0),
(13, 2454.5, 2271.12, 91.3245, 0, 0, 113.4, 1, 0, 0),
(17, 3173.23, -1983.35, 2.47359, 0, 0, -90.8, 0, 0, 0),
(16, -2107.18, -2406.45, 30.8987, 0, 0, 140.7, 0, 0, 0),
(8, -2037.61, -103.953, 35.0676, 0, 0, -92.5, 0, 0, 0),
(20, 1122.74, -2040.4, 69.577, 0, 0, 89.6001, 0, 0, 0),
(21, 1553.91, -1678.66, 2112.65, 0, 0, 91.3, 0, 0, 0),
(22, -788.233, -130.839, 64.8334, 0, 0, 0, 0, 0, 0),
(23, -101.608, -1213.69, 3.17529, 0, 0, 0, 0, 0, 0),
(26, 739.458, -1452.87, 17.6953, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `banneds`
--

CREATE TABLE `banneds` (
  `id` int(11) UNSIGNED NOT NULL,
  `name` varchar(24) DEFAULT 'None',
  `ip` varchar(24) DEFAULT 'None',
  `longip` int(11) DEFAULT 0,
  `ban_expire` bigint(16) DEFAULT 0,
  `ban_date` bigint(16) DEFAULT 0,
  `last_activity_timestamp` bigint(16) DEFAULT 0,
  `admin` varchar(40) DEFAULT 'Server',
  `reason` varchar(128) DEFAULT 'None'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `berry`
--

CREATE TABLE `berry` (
  `id` int(11) NOT NULL,
  `posx` float DEFAULT NULL,
  `posy` float DEFAULT NULL,
  `posz` float DEFAULT NULL,
  `posrx` float DEFAULT NULL,
  `posry` float DEFAULT NULL,
  `posrz` float DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `berry`
--

INSERT INTO `berry` (`id`, `posx`, `posy`, `posz`, `posrx`, `posry`, `posrz`) VALUES
(0, -603.318, -1251.84, 20.031, 0, 0, 0),
(1, 1752.22, -1842.04, 12.5691, 0, 0, 0),
(2, 114.56, -1516.9, 7.21409, 0, 0, 0),
(3, -373.595, -1825.15, 1.31916, 0, 0, 0),
(4, -431.39, -1803.63, 3.6991, 0, 0, 0),
(5, -480.834, -1845.64, 12.2886, 0, 0, 0),
(6, -540.775, -1911.82, 8.30164, 0, 0, 0),
(7, -474.345, -1923.97, 13.0099, 0, 0, 0),
(8, -402.783, -1960.67, 19.9847, 0, 0, 0),
(9, -788.42, -1420.7, 107.79, 0, 0, 0),
(10, -1087.18, -1310.82, 128.219, 0, 0, 0),
(11, -1119.12, -907.329, 128.004, 0, 0, 0),
(12, -943.59, -579.313, 22.125, 0, 0, 0),
(13, -657.219, -477.599, 38.1617, 0, 0, 0),
(14, -363.576, -391.161, 6.35661, 0, 0, 0),
(15, 173.586, -579.03, 44.9579, 0, 0, 0),
(16, 233.812, -804.247, 17.3091, 0, 0, 0),
(17, 595.262, -969.145, 80.0207, 0, 0, 0),
(18, 1045.94, -705.469, 119.683, 0, 0, 0),
(20, 1090.43, -64.9905, 81.7068, 0, 0, 0),
(19, 2007.44, -791.426, 132.409, 0, 0, 0),
(21, 1988.21, -828.244, 127.458, 0, 0, 0),
(22, 2306.33, -954.233, 68.3845, 0, 0, 0),
(23, 1201.15, -2321.56, 13.821, 0, 0, 0),
(24, 1215.84, -1908.03, 28.9524, 0, 0, 0),
(25, 1954.71, -1151.9, 20.8412, 0, 0, 0),
(26, 575.51, -1820.22, 5.0625, 0, 0, 0),
(27, 455.533, -1680.71, 24.2058, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `bisnis`
--

CREATE TABLE `bisnis` (
  `ID` int(11) NOT NULL,
  `owner` varchar(40) NOT NULL DEFAULT '-',
  `name` varchar(40) NOT NULL DEFAULT 'Bisnis',
  `price` int(11) NOT NULL DEFAULT 500000,
  `type` int(11) NOT NULL DEFAULT 1,
  `locked` int(11) NOT NULL DEFAULT 1,
  `money` int(11) NOT NULL DEFAULT 0,
  `prod` int(11) NOT NULL DEFAULT 50,
  `bprice0` int(11) NOT NULL DEFAULT 500,
  `bprice1` int(11) NOT NULL DEFAULT 500,
  `bprice2` int(11) NOT NULL DEFAULT 500,
  `bprice3` int(11) NOT NULL DEFAULT 500,
  `bprice4` int(11) NOT NULL DEFAULT 500,
  `bprice5` int(11) NOT NULL DEFAULT 500,
  `bprice6` int(11) NOT NULL DEFAULT 500,
  `bprice7` int(11) NOT NULL DEFAULT 500,
  `bprice8` int(11) NOT NULL DEFAULT 500,
  `bprice9` int(11) NOT NULL DEFAULT 500,
  `bint` int(11) NOT NULL DEFAULT 0,
  `extposx` float NOT NULL DEFAULT 0,
  `extposy` float NOT NULL DEFAULT 0,
  `extposz` float NOT NULL DEFAULT 0,
  `extposa` float NOT NULL DEFAULT 0,
  `intposx` float NOT NULL DEFAULT 0,
  `intposy` float NOT NULL DEFAULT 0,
  `intposz` float NOT NULL DEFAULT 0,
  `intposa` float NOT NULL DEFAULT 0,
  `pointx` float DEFAULT 0,
  `pointy` float DEFAULT 0,
  `pointz` float DEFAULT 0,
  `visit` bigint(16) NOT NULL DEFAULT 0,
  `restock` tinyint(2) NOT NULL DEFAULT 0,
  `song` varchar(70) NOT NULL DEFAULT '-',
  `ph` mediumint(8) UNSIGNED NOT NULL,
  `pcx` float NOT NULL DEFAULT 0,
  `pcy` float NOT NULL DEFAULT 0,
  `pcz` float NOT NULL DEFAULT 0,
  `cargo` int(11) NOT NULL DEFAULT 80
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `bisnis`
--

INSERT INTO `bisnis` (`ID`, `owner`, `name`, `price`, `type`, `locked`, `money`, `prod`, `bprice0`, `bprice1`, `bprice2`, `bprice3`, `bprice4`, `bprice5`, `bprice6`, `bprice7`, `bprice8`, `bprice9`, `bint`, `extposx`, `extposy`, `extposz`, `extposa`, `intposx`, `intposy`, `intposz`, `intposa`, `pointx`, `pointy`, `pointz`, `visit`, `restock`, `song`, `ph`, `pcx`, `pcy`, `pcz`, `cargo`) VALUES
(0, '-', 'Dillimore', 10, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 811.614, -606.283, 16.3359, 279.462, 372.34, -133.25, 1001.49, 4.8, 0, 0, 0, 0, 0, '-', 0, 810.274, -597.065, 16.1875, 80);

-- --------------------------------------------------------

--
-- Table structure for table `cargo`
--

CREATE TABLE `cargo` (
  `ID` int(10) UNSIGNED NOT NULL,
  `Type` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `Vehicle` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `X` float DEFAULT NULL,
  `Y` float DEFAULT NULL,
  `Z` float DEFAULT NULL,
  `A` float DEFAULT NULL,
  `time` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `cargo`
--

INSERT INTO `cargo` (`ID`, `Type`, `Vehicle`, `X`, `Y`, `Z`, `A`, `time`) VALUES
(33, 1, 0, 815.64, -593.9, 16.18, 60.22, 1676642174);

-- --------------------------------------------------------

--
-- Table structure for table `contacts`
--

CREATE TABLE `contacts` (
  `ID` int(12) DEFAULT 0,
  `contactID` int(12) NOT NULL,
  `contactName` varchar(32) DEFAULT NULL,
  `contactNumber` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `dealership`
--

CREATE TABLE `dealership` (
  `ID` int(11) NOT NULL,
  `owner` varchar(40) CHARACTER SET latin1 NOT NULL DEFAULT '-',
  `name` varchar(40) CHARACTER SET latin1 NOT NULL DEFAULT 'Dealership',
  `price` int(11) NOT NULL DEFAULT 1,
  `type` int(11) NOT NULL DEFAULT 1,
  `locked` int(11) NOT NULL DEFAULT 1,
  `money` int(11) NOT NULL DEFAULT 0,
  `stock` int(11) NOT NULL DEFAULT 100,
  `posx` float NOT NULL DEFAULT 0,
  `posy` float NOT NULL DEFAULT 0,
  `posz` float NOT NULL DEFAULT 0,
  `posa` float NOT NULL DEFAULT 0,
  `pointx` float DEFAULT 0,
  `pointy` float DEFAULT 0,
  `pointz` float DEFAULT 0,
  `restock` tinyint(2) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `doors`
--

CREATE TABLE `doors` (
  `ID` int(11) NOT NULL,
  `name` varchar(50) DEFAULT 'None',
  `password` varchar(50) DEFAULT '',
  `icon` int(11) DEFAULT 19130,
  `locked` int(11) NOT NULL DEFAULT 0,
  `admin` int(11) NOT NULL DEFAULT 0,
  `vip` int(11) NOT NULL DEFAULT 0,
  `faction` int(11) NOT NULL DEFAULT 0,
  `family` int(11) NOT NULL DEFAULT -1,
  `garage` tinyint(3) NOT NULL DEFAULT 0,
  `custom` int(11) NOT NULL DEFAULT 0,
  `extvw` int(11) DEFAULT 0,
  `extint` int(11) DEFAULT 0,
  `extposx` float DEFAULT 0,
  `extposy` float DEFAULT 0,
  `extposz` float DEFAULT 0,
  `extposa` float DEFAULT 0,
  `intvw` int(11) DEFAULT 0,
  `intint` int(11) NOT NULL DEFAULT 0,
  `intposx` float DEFAULT 0,
  `intposy` float DEFAULT 0,
  `intposz` float DEFAULT 0,
  `intposa` float DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `doors`
--

INSERT INTO `doors` (`ID`, `name`, `password`, `icon`, `locked`, `admin`, `vip`, `faction`, `family`, `garage`, `custom`, `extvw`, `extint`, `extposx`, `extposy`, `extposz`, `extposa`, `intvw`, `intint`, `intposx`, `intposy`, `intposz`, `intposa`) VALUES
(0, 'San Andreas Police Departement', '', 19130, 0, 0, 0, 0, -1, 0, 1, 0, 0, 1555.3, -1675.69, 16.1953, 87.1144, 0, 0, 1552.64, -1675.01, 2113.03, 81.8709),
(1, 'Rooftop San Andreas Police Dapartment', '', 19130, 0, 0, 0, 1, -1, 0, 0, 0, 0, 1564.87, -1666.98, 28.3956, 181.587, 0, 0, 1569.48, -1678.93, 2113.03, 264.744),
(2, 'SAPD Backdoor ', '', 19130, 0, 0, 0, 0, -1, 0, 1, 0, 0, 1568.68, -1690.12, 6.21875, 184.131, 0, 0, 1569.48, -1674.7, 2113.03, 261.254),
(4, 'HALL CITY HBRP', '', 19130, 0, 0, 0, 0, -1, 0, 1, 0, 0, 1122.71, -2036.86, 69.8942, 80.4158, 0, 20, 2081.57, 744.111, 97.1939, 77.7754),
(8, 'All Saints General Hospital', '', 19130, 0, 0, 0, 0, -1, 0, 1, 0, 0, 1172.08, -1321.53, 15.3973, 89.181, 0, 0, 1240.71, -1293.38, 1061.15, 263.653),
(9, 'BACKDOOR ASGH Medical Dapartement', '', 19130, 0, 0, 0, 0, -1, 0, 1, 0, 0, 1144.91, -1321.81, 13.5783, 260.233, 0, 0, 1246.77, -1309.44, 1061.15, 69.6418),
(10, 'ROOFTOP ASGH Medical Dapartement', '', 19130, 0, 0, 0, 0, -1, 0, 1, 0, 0, 1163.51, -1329.69, 31.4851, 174.363, 0, 0, 1244.01, -1297.7, 1061.14, 181.8),
(11, 'San Andreas News Agency', '', 19130, 0, 0, 0, 0, -1, 0, 1, 0, 0, 649.275, -1360.77, 14.1287, 259.664, 0, 1, 2451.8, 2282.38, 91.6744, 232.272),
(12, 'Backdoor SanNews', '', 19130, 0, 0, 0, 4, -1, 0, 0, 0, 1, 2474.45, 2273.92, 91.6868, 261.417, 0, 0, 739.997, -1351.39, 14.7142, 88.5369),
(13, 'Bank Los Santos', '', 19130, 0, 0, 0, 0, -1, 0, 1, 0, 0, 1462.27, -1010.24, 26.8531, 1.08498, 0, 255, 2248.58, -1744.27, 1014.78, 2.82001),
(14, 'Taxi Longue', '', 19130, 0, 0, 0, 0, -1, 0, 1, 0, 0, 1752.5, -1893.96, 13.5526, 77.4167, 0, 1, -2158.5, 642.905, 1052.38, 184.752),
(15, 'VIP Longue', '', 19130, 0, 0, 1, 0, -1, 0, 1, 0, 0, 1797.65, -1578.89, 14.0861, 280.855, 0, 1, -4107.23, 906.906, 3.10072, 176.818),
(16, 'Rooftoop San News', '', 19130, 0, 0, 0, 4, -1, 0, 0, 0, 1, 2473.41, 2278.42, 91.6868, 178.715, 0, 0, 737.638, -1353.23, 25.2202, 85.8219),
(17, 'Studio Room San News', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 1, 248.513, 1783.63, 701.086, 345.861, 0, 1, 2452.24, 2265.36, 91.6868, 266.02),
(18, 'Black Market', '', 19130, 0, 5, 0, 0, 0, 0, 1, 0, 0, -1441.69, -943.603, 201.305, 267.569, 0, 1, -3799.72, 1319.11, 75.5875, 85.1959),
(19, 'SALVATRUCHA Club', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 3145.22, -2039.36, 2.87378, 6.25605, 0, 3, -2636.87, 1402.56, 906.461, 12.1067),
(31, 'Bar', '', 19130, 0, 4, 0, 0, -1, 0, 0, 0, 0, 203.456, -183.486, 1.57812, 173.666, 0, 18, -229.291, 1401.17, 27.7734, 92.7953),
(22, 'Pengadilan San Andreas', '', 19130, 0, 0, 0, 0, -1, 0, 1, 0, 0, 1726.92, -1636.4, 20.2181, 150.432, 0, 1, 1356.01, 717.951, -15.7573, 260.304),
(23, 'Ganton Gym', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 2229.83, -1721.33, 13.5619, 313.305, 0, 5, 772.173, -5.50659, 1000.73, 188.305),
(24, 'San News Parking', '', 19130, 0, 0, 0, 0, -1, 1, 0, 0, 0, 657.443, -1389.98, 13.6695, 261.751, 0, 0, 281.046, 1511.69, 1079.45, 350.448),
(25, 'San News Parking', '', 19130, 0, 0, 0, 0, -1, 1, 0, 0, 0, 660.416, -1325.23, 13.5667, 4.47028, 0, 0, 285.502, 1565.06, 1079.45, 173.479),
(26, 'Basement San News Agency Studio', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 267.967, 1530.33, 1079.78, 86.4677, 0, 1, 2473.99, 2263.5, 91.6868, 266.235),
(27, 'RACE ARENA', '', 19130, 0, 0, 0, 0, -1, 1, 1, 0, 0, 2716.18, -1766.62, 43.2215, 228.727, 0, 0, 2716.18, -1766.62, 43.2215, 228.727),
(28, 'MARKET PARKING ( /EN )', '', 19130, 0, 0, 0, 0, -1, 1, 0, 0, 0, 1636.54, -2695.47, -55.0529, 154.055, 0, 0, 1636.54, -2695.47, -54.6627, 94.9105),
(29, 'Driving License + Insurance', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, -2026.56, -102.063, 35.1641, 175.901, 0, 0, -2039.16, -134.518, -50.9141, 175.478),
(34, 'PABRIK DAGING', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, -1713.19, -61.8245, 3.55469, 310.093, 0, 1, 965.378, 2107.94, 1011.02, 267.987),
(41, 'Dirt track', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 18, 1735.08, -1654.21, 23.7316, 268.114, 0, 18, 1735.08, -1654.21, 23.7283, 268.114),
(38, 'Kickstart', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 18, 1735.1, -1660.18, 23.7185, 262.665, 0, 14, -1464.59, 1555.92, 1052.53, 177.847),
(37, 'Antariksa', '', 19130, 0, 0, 0, 0, -1, 1, 0, 8, 0, 1361.88, -2545.12, 1198.78, 150.716, 0, 0, 1618.36, -2629.46, 13.5469, 195.053),
(6, 'HELIPAD', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, -82.9517, -1220.07, 2.9753, 341.868, 0, 0, -89.9381, -1221.92, 12.4331, 24.4398),
(40, 'Lantai 7 - 8', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 2118.63, 2415.41, 36.6172, 264.606, 0, 0, 2118.63, 2417.93, 40.9219, 265.525),
(43, 'SHERIFF LOS SANTOS', '', 19130, 0, 0, 0, 1, -1, 0, 0, 0, 0, 1835.53, -1435.08, 13.6016, 87.9318, 0, 5, 322.219, 302.358, 999.148, 178.067),
(47, 'The Pig Pen', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 2421.55, -1219.24, 25.5616, 358.406, 0, 2, 1204.83, -13.8524, 1000.92, 178.497),
(49, 'STAR BUILDING', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1548.64, -1363.79, 326.218, 3.31068, 0, 0, 1570.44, -1337.46, 16.4844, 147.188),
(50, 'The Four Dragon Casino', '', 19130, 0, 0, 1, 0, -1, 0, 1, 0, 0, 2019.32, 1007.8, 10.8203, 88.0851, 0, 10, 2019.07, 1017.89, 996.875, 270.002),
(51, 'GYM', '', 19130, 0, 0, 0, 0, -1, 0, 0, 50, 0, 2485.33, -1958.75, 13.5802, 177.26, 0, 6, 774.064, -50.4723, 1000.59, 178.654),
(52, 'Parking San Andreas Police Dapartment', '', 19130, 0, 0, 0, 1, -1, 1, 1, 0, 0, 1589.03, -1632.33, 13.3828, 23.0325, 0, 0, 1596.31, -1673.75, 5.89062, 190.531),
(53, 'HOTELS HBRP', '', 19130, 0, 0, 1, 0, -1, 0, 0, 0, 0, 1568, -1898.01, 13.5545, 172.172, 0, 0, 1665.28, -158.906, 1208.62, 265.654),
(45, 'Bloodbowl', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 18, 1735.06, -1648.28, 23.7446, 261.639, 0, 15, -1443.02, 936.516, 1036.52, 338.138),
(3, 'San Andreas Goverment Service', '', 19130, 0, 0, 0, 2, -1, 0, 0, 0, 0, 1481.12, -1772.31, 18.7891, 175.968, 0, 0, 708.39, 376.03, 1023.59, 354.27),
(59, 'GO-JEK PARKING ( /EN )', '', 19130, 0, 0, 0, 0, -1, 1, 1, 0, 255, 1274.57, 1516.02, 1111.38, 4.42492, 0, 255, 1274.57, 1516.02, 1111.38, 4.42492),
(61, 'MENARA MINYAK', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 2723.69, -2565.55, 3, 92.2514, 0, 0, 2582.19, -3831.74, 17.1122, 185.861),
(5, 'backup', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 255, 185.893, -104.243, 1031.94, 205.82, 0, 0, 0, 0, 0, 0),
(20, 'Auction', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 941.093, -1719.72, 13.9691, 264.913, 0, 255, 189.734, -109.067, 1032.35, 174.804),
(65, 'Revolusi base', '', 19130, 0, 0, 0, 0, 3, 0, 0, 0, 0, -436.797, 1437.37, 21.1536, 269.299, 3, 1, -777.389, 496.24, 1368.52, 261.005),
(66, 'Gereja', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, -1989.9, 1117.89, 54.4688, 88.3283, 0, 0, -2024.93, 1142.77, 18.0688, 180.02),
(54, 'Millie Room', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 18, 1708.71, -1649.25, 27.1953, 90.2937, 0, 6, 343.718, 304.98, 999.148, 86.6384),
(68, 'Training Area', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 18, 1708.7, -1670.16, 23.7056, 86.5581, 0, 18, 1292.79, 7.25922, 1001.01, 359.96),
(69, 'CJ House', '', 19130, 0, 0, 0, 0, -1, 0, 1, 0, 18, 1735.1, -1660.18, 27.2127, 267.334, 0, 3, 2495.95, -1692.09, 1014.74, 359.921),
(72, 'OG House', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 18, 1735.05, -1642.33, 27.2392, 265.618, 0, 3, 513.868, -7.07582, 1001.57, 1.98751),
(55, 'Lantai 1 - 2', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 2118.12, 2416.69, 10.8203, 272.767, 0, 0, 2118.63, 2417.73, 15.1172, 269.434),
(74, 'Helena Room', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 18, 1708.71, -1659.74, 27.1953, 88.4224, 0, 3, 293.218, 310.047, 999.148, 265.747),
(76, 'Katie Room', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 18, 1708.7, -1670.19, 27.1953, 89.9093, 0, 2, 266.499, 304.966, 999.148, 87.0946),
(7, 'Perusahaan : Vin_MIguel', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, -2426.2, 338.095, 36.9922, 64.9761, 0, 3, 288.815, 166.94, 1007.17, 174.088),
(21, 'SAPD PRISON', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1829.94, -1418.87, 13.6016, 172.616, 0, 0, 1568.36, -1672.69, 2982.28, 9.84419),
(30, 'Up', '', 19130, 0, 0, 0, 0, -1, 0, 0, 10, 0, 3115.63, -1947.72, 696.191, 182.506, 0, 0, 0, 0, 0, 0),
(32, 'Hotel : Friz_Salvatrucha', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 3146.12, -2005.6, 2.87898, 179.292, 0, 0, -77.6573, 33.9917, -14.6766, 253.511),
(33, 'Floor 2', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, -103.619, 5.68195, -14.73, 165.748, 0, 0, -68.9196, 5.84407, -14.73, 158.317),
(35, 'Floor 3', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, -43.2583, 34.1101, -14.6766, 252.527, 0, 0, -8.35045, 34.0152, -14.6766, 251.477),
(36, 'Floor 4', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, -33.995, 5.68558, -14.73, 160.116, 0, 0, -58.9919, 65.9477, -14.73, 161.273),
(39, 'Top Terrace', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, -33.3365, 94.0952, -14.6766, 247.67, 0, 0, 3144.02, -2012.84, 6.87901, 172.858),
(42, 'Palomino Bank', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 2303.83, -16.1627, 26.4844, 270.41, 0, 0, -1328.01, 2894.4, 3014.21, 263.58),
(44, 'San Andreas Police Department Dillimore County', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 627.127, -571.779, 17.9145, 93.8419, 0, 6, 246.885, 62.337, 1003.64, 175.228),
(46, '1', '', 19130, 0, 0, 0, 0, -1, 0, 0, 1, 5, 226.296, 1114.32, 1080.99, 89.6696, 0, 0, 0, 0, 0, 0),
(48, 'parking', '', 19130, 0, 0, 0, 0, -1, 0, 0, 523, 1, 1261.36, -743.427, 1093.04, 176.619, 0, 0, 2118.62, 2415.41, 49.5234, 262.932),
(56, 'Lantai 2 - 3', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 2118.29, 2415.77, 15.1172, 266.217, 0, 0, 2118.63, 2417.92, 19.4219, 268.975),
(57, 'Lantai 3 - 4', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 2118.47, 2415.62, 19.4219, 264.544, 0, 0, 2118.63, 2417.94, 23.7188, 261.032),
(58, 'Lantai 4 - 5', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 2118.33, 2415.36, 23.7188, 272.061, 0, 0, 2118.37, 2418.28, 28.0234, 276.39),
(60, 'Lantai 5 - 6', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 2118.63, 2417.79, 32.3203, 273.633, 0, 0, 2118.62, 2415.43, 28.0234, 286.538),
(62, 'Lantai 6 - 7', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 2118.35, 2415.22, 32.3203, 262.603, 0, 0, 2118.63, 2417.95, 36.6172, 281.15),
(63, 'Lantai 8 - 9', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 2118.62, 2415.41, 40.9219, 261.389, 0, 0, 2118.62, 2417.94, 45.2188, 273.338),
(64, 'Lantai 9 - 10', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 2118.57, 2415.39, 45.2188, 268.677, 0, 0, 2118.63, 2417.87, 49.5234, 268.677),
(67, 'Private', '', 19130, 0, 1, 3, 0, -1, 1, 1, 0, 0, 745.181, -1442.22, 13.5391, 181.134, 0, 0, 711.44, -1443.45, 17.6953, 270.74),
(70, '1', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1492.07, -1753.06, 33.4297, 355.367, 0, 1, 1007.23, -558.081, 688.176, 359.577),
(71, '2', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1487.99, -1752.67, 33.4297, 350.312, 0, 1, 1207.1, -558.109, 688.176, 84.0618),
(73, '3', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1484.31, -1752.5, 33.4297, 359.503, 0, 1, 1206.63, -358.766, 688.176, 81.0095),
(75, '4', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1480.79, -1752.32, 33.4297, 0.126669, 0, 1, 1007.49, -357.58, 688.176, 270.365),
(77, '5', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1475.71, -1752.48, 33.4297, 357.075, 0, 1, 806.67, -358.837, 688.176, 67.3874),
(78, 'Masuk Basement', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1225.27, -2266.82, 13.5289, 69.3013, 0, 0, 1219.42, -2249.32, -47.2573, 11.6181),
(79, 'Keluar Basement', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1207.79, -2248.75, -47.2573, 171.397, 0, 0, 1220.75, -2265.22, 13.5326, 164.742),
(81, 'AvispaCorp', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, -2719.4, -319.195, 7.84375, 224.019, 0, 0, 0, 0, 0, 0),
(80, 'INT Bar', '', 19130, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1230.13, -2291.18, 13.1895, 75.7352, 20, 1, 678.42, -457.041, -25.6099, 0.305828);

-- --------------------------------------------------------

--
-- Table structure for table `familys`
--

CREATE TABLE `familys` (
  `ID` int(11) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT 'None',
  `leader` varchar(50) NOT NULL DEFAULT 'None',
  `motd` varchar(100) NOT NULL DEFAULT 'None',
  `color` int(11) DEFAULT 0,
  `extposx` float DEFAULT 0,
  `extposy` float DEFAULT 0,
  `extposz` float DEFAULT 0,
  `extposa` float DEFAULT 0,
  `intposx` float DEFAULT 0,
  `intposy` float DEFAULT 0,
  `intposz` float DEFAULT 0,
  `intposa` float DEFAULT 0,
  `fint` int(11) NOT NULL DEFAULT 0,
  `Weapon1` int(11) NOT NULL DEFAULT 0,
  `Ammo1` int(11) NOT NULL DEFAULT 0,
  `Weapon2` int(11) NOT NULL DEFAULT 0,
  `Ammo2` int(11) NOT NULL DEFAULT 0,
  `Weapon3` int(11) NOT NULL DEFAULT 0,
  `Ammo3` int(11) NOT NULL DEFAULT 0,
  `Weapon4` int(11) NOT NULL DEFAULT 0,
  `Ammo4` int(11) NOT NULL DEFAULT 0,
  `Weapon5` int(11) NOT NULL DEFAULT 0,
  `Ammo5` int(11) NOT NULL DEFAULT 0,
  `Weapon6` int(11) NOT NULL DEFAULT 0,
  `Ammo6` int(11) NOT NULL DEFAULT 0,
  `Weapon7` int(11) NOT NULL DEFAULT 0,
  `Ammo7` int(11) NOT NULL DEFAULT 0,
  `Weapon8` int(11) NOT NULL DEFAULT 0,
  `Ammo8` int(11) NOT NULL DEFAULT 0,
  `Weapon9` int(11) NOT NULL DEFAULT 0,
  `Ammo9` int(11) NOT NULL DEFAULT 0,
  `Weapon10` int(11) NOT NULL DEFAULT 0,
  `Ammo10` int(11) NOT NULL DEFAULT 0,
  `safex` float DEFAULT 0,
  `safey` float DEFAULT 0,
  `safez` float DEFAULT 0,
  `money` int(11) NOT NULL DEFAULT 0,
  `marijuana` int(11) NOT NULL DEFAULT 0,
  `component` int(11) NOT NULL DEFAULT 0,
  `material` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `farm`
--

CREATE TABLE `farm` (
  `ID` int(11) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT 'None',
  `leader` varchar(50) NOT NULL DEFAULT 'None',
  `motd` varchar(100) NOT NULL DEFAULT 'None',
  `plantx` float DEFAULT 0,
  `planty` float DEFAULT 0,
  `plantz` float DEFAULT 0,
  `safex` float DEFAULT 0,
  `safey` float DEFAULT 0,
  `safez` float DEFAULT 0,
  `money` int(11) NOT NULL DEFAULT 0,
  `potato` int(11) NOT NULL DEFAULT 0,
  `wheat` int(11) NOT NULL DEFAULT 0,
  `orange` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `flats`
--

CREATE TABLE `flats` (
  `ID` int(11) NOT NULL,
  `owner` varchar(50) NOT NULL DEFAULT '-',
  `address` varchar(50) DEFAULT 'None',
  `price` int(11) NOT NULL DEFAULT 500000,
  `type` int(11) NOT NULL DEFAULT 1,
  `locked` int(11) NOT NULL DEFAULT 1,
  `money` int(11) NOT NULL DEFAULT 0,
  `flatint` int(11) NOT NULL DEFAULT 0,
  `extposx` float NOT NULL DEFAULT 0,
  `extposy` float NOT NULL DEFAULT 0,
  `extposz` float NOT NULL DEFAULT 0,
  `extposa` float NOT NULL DEFAULT 0,
  `intposx` float NOT NULL DEFAULT 0,
  `intposy` float NOT NULL DEFAULT 0,
  `intposz` float NOT NULL DEFAULT 0,
  `intposa` float NOT NULL DEFAULT 0,
  `visit` bigint(16) DEFAULT 0,
  `flatWeapon1` int(12) DEFAULT 0,
  `flatAmmo1` int(12) DEFAULT 0,
  `flatWeapon2` int(12) DEFAULT 0,
  `flatAmmo2` int(12) DEFAULT 0,
  `flatWeapon3` int(12) DEFAULT 0,
  `flatAmmo3` int(12) DEFAULT 0,
  `flatWeapon4` int(12) DEFAULT 0,
  `flatAmmo4` int(12) DEFAULT 0,
  `flatWeapon5` int(12) DEFAULT 0,
  `flatAmmo5` int(12) DEFAULT 0,
  `flatWeapon6` int(12) DEFAULT 0,
  `flatAmmo6` int(12) DEFAULT 0,
  `flatWeapon7` int(12) DEFAULT 0,
  `flatAmmo7` int(12) DEFAULT 0,
  `flatWeapon8` int(12) DEFAULT 0,
  `flatAmmo8` int(12) DEFAULT 0,
  `flatWeapon9` int(12) DEFAULT 0,
  `flatAmmo9` int(12) DEFAULT 0,
  `flatWeapon10` int(12) DEFAULT 0,
  `flatAmmo10` int(12) DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `furniture`
--

CREATE TABLE `furniture` (
  `ID` int(12) DEFAULT 0,
  `furnitureID` int(12) NOT NULL,
  `furnitureName` varchar(32) DEFAULT NULL,
  `furnitureModel` int(12) DEFAULT 0,
  `furnitureX` float DEFAULT 0,
  `furnitureY` float DEFAULT 0,
  `furnitureZ` float DEFAULT 0,
  `furnitureRX` float DEFAULT 0,
  `furnitureRY` float DEFAULT 0,
  `furnitureRZ` float DEFAULT 0,
  `furnitureType` int(12) DEFAULT 0,
  `furnitureProperty` int(12) NOT NULL DEFAULT -1,
  `furnitureWorld` int(8) NOT NULL DEFAULT 0,
  `furnitureInterior` int(8) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `gates`
--

CREATE TABLE `gates` (
  `ID` int(11) NOT NULL,
  `model` int(11) NOT NULL DEFAULT 0,
  `password` varchar(36) NOT NULL DEFAULT '',
  `admin` tinyint(3) NOT NULL DEFAULT 0,
  `vip` tinyint(3) NOT NULL DEFAULT 0,
  `faction` tinyint(3) NOT NULL DEFAULT 0,
  `family` int(10) NOT NULL DEFAULT -1,
  `speed` float NOT NULL DEFAULT 2,
  `cX` float NOT NULL,
  `cY` float NOT NULL,
  `cZ` float NOT NULL,
  `cRX` float NOT NULL,
  `cRY` float NOT NULL,
  `cRZ` float NOT NULL,
  `oX` float NOT NULL,
  `oY` float NOT NULL,
  `oZ` float NOT NULL,
  `oRX` float NOT NULL,
  `oRY` float NOT NULL,
  `oRZ` float NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `gates`
--

INSERT INTO `gates` (`ID`, `model`, `password`, `admin`, `vip`, `faction`, `family`, `speed`, `cX`, `cY`, `cZ`, `cRX`, `cRY`, `cRZ`, `oX`, `oY`, `oZ`, `oRX`, `oRY`, `oRZ`) VALUES
(0, 980, '', 0, 0, 0, -1, 2, 1539.41, -1627.56, 15.0128, 0, 0, 90.2, 1539.41, -1627.56, 9.51278, 0, 0, 90.2),
(1, 986, '', 0, 0, 4, -1, 2, 777.918, -1385.11, 13.6232, 0, 0, 0, 769.928, -1385.11, 13.6232, 0, 0, 0),
(3, 989, '', 0, 0, 0, -1, 2, 2227.56, -2209.11, 14.2969, 0, 0, 61.7, 2232.11, -2213.03, 14.2969, 0, 0, 61.7),
(4, 989, '', 0, 0, 0, -1, 2, 2240.78, -2221.81, 14.3369, 0, 0, 61.1, 2236.69, -2217.7, 14.3369, 0, 0, 61.1),
(7, 975, 'wawan', 0, 0, 0, -1, 2, 263.974, -1334.23, 53.9154, 0, 0, 35.1, 270.307, -1329.78, 53.9154, 0, 0, 35.1),
(9, 19912, '', 6, 0, 0, -1, 2, 1528.21, -49.3396, 1002.13, 0, 0, -91.5, 1528.21, -49.3396, 1002.13, 0, 0, -91.5),
(11, 19912, '', 6, 0, 0, -1, 2, 1519.98, -45.8958, 1002.13, 0, 0, 89.7, 1519.98, -45.8958, 1002.13, 0, 0, 89.7),
(10, 19912, '001', 0, 0, 0, -1, 2, 277.949, -1323.39, 55.578, 0, 0, -145.5, 277.949, -1323.39, 49.338, 0, 0, -145.5),
(13, 19912, '', 0, 0, 0, -1, 2, 452.799, -16.122, 1001.13, 0, 0, 0, 454.038, -16.0657, 1001.13, 0, 0, 88.1),
(17, 19912, '342', 0, 0, 0, -1, 2, 1286.68, -612.405, 102.32, 0, 0, 23.4, 1286.68, -612.405, 98.9898, 0, 0, 23.4),
(18, 975, '25', 0, 0, 0, -1, 2, 731.857, -581.396, 16.8459, 0, 0, 89.1, 731.987, -573.136, 16.8459, 0, 0, 89.1),
(19, 1609, '1', 0, 0, 0, -1, 2, 733.405, -590.698, 16.4453, 0, 0, 0, 733.405, -590.698, 16.4453, 0, 0, 0),
(20, 11313, '1234', 0, 0, 0, -1, 2, 1839.62, 777.146, 11.1424, 0, 0, -90.4, 1839.62, 777.146, 7.3324, 0, 0, -90.4),
(21, 11313, '1234', 0, 0, 0, -1, 2, 1848.58, 776.935, 11.1424, 0, 0, -90.7, 1848.58, 776.935, 7.5724, 0, 0, -90.7),
(22, 11313, '2', 0, 0, 0, -1, 2, 1830.55, 777.35, 11.0686, 0.300002, 0, -90.2, 1830.73, 777.34, 7.3124, 0, 0, -90.2),
(23, 11313, '1234', 0, 0, 0, -1, 2, 1821.74, 777.623, 11.0894, 0, -0.000001, -91.8, 1821.74, 777.623, 7.30137, 0, -0.000001, -91.8),
(2, 11474, '', 0, 0, 0, -1, 2, 2376.13, -1723.37, 13.2845, -0.2, 2.8, 7.3, 2376.08, -1723.33, 9.87259, -0.3, 3.2, 7.3),
(25, 11313, 'revolusi', 0, 0, 0, -1, 2, -443.783, 1442.45, 22.0773, 0, 0, -25.6, -443.709, 1442.6, 17.7873, 0, 0, -25.6),
(26, 11313, '', 0, 0, 0, 3, 2, -396.012, 1243.7, 7.08954, 0, 0, 91.4, -396.012, 1243.7, 2.81954, 0, 0, 91.4),
(27, 19912, 'wer', 5, 0, 0, 3, 2, -2596.6, 333.013, 2.47804, 0, 0, 89.9, -2596.6, 333.013, 0.538038, 0, 0, 89.9),
(28, 19912, '', 0, 0, 0, 3, 2, -2548.95, 314.849, 17.746, 0, 0, -89.5, -2548.95, 314.849, 15.266, 0, 0, -89.5),
(12, 19912, '2006', 0, 0, 0, -1, 2, 688.236, 304.042, 21.8306, 0, 0, 5.2, 688.236, 304.042, 15.2506, 0, 0, 5.2),
(8, 975, 'rizu', 0, 0, 0, -1, 2, 948.858, 2283, 10.1603, 0, 0, 0, 948.858, 2283, 7.4203, 0, 0, 0),
(6, 975, '', 0, 0, 0, -1, 2, 1002.93, -643.562, 122.215, 0, 1.4, 24, 1002.8, -643.619, 116.437, 0, 1.4, 24),
(35, 11313, '2006', 0, 0, 0, -1, 2, -2022.22, 1144.35, 18.0688, 0, 0, 0, -2022.22, 1144.35, 18.0688, 0, 0, 0),
(14, 19912, '25', 0, 0, 0, -1, 2, 204.066, -1382.87, 48.96, 0, -4, 46.5, 204.318, -1382.6, 43.7128, 0, -4, 46.5),
(15, 971, '2006', 0, 0, 0, -1, 2, 901.302, -631.911, 117.003, 0, -1.4, -137, 896.352, -636.527, 117.168, 0, -1.4, -137),
(41, 975, 'PVR', 0, 0, 0, -1, 2, 617.336, -1501.3, 15.492, 0, 0, -88.8, 617.481, -1508.24, 15.492, 0, 0, -88.8),
(42, 989, 'PVR', 0, 0, 0, -1, 2, 612.239, -1507.49, 15.3408, 0, 0, -73, 612.239, -1507.49, 11.8308, 0, 0, -73),
(43, 989, 'PVR', 0, 0, 0, -1, 2, 603.347, -1507.54, 15.33, 0, 0, -73.5, 603.347, -1507.54, 10.75, 0, 0, -73.5),
(5, 975, '001', 0, 0, 0, -1, 3, 1022.11, -926.465, 43.5583, 0, 0, 96.5, 1021.05, -917.145, 43.5583, 0, 0, 96.5),
(24, 975, 'voska', 0, 0, 0, -1, 2, 1378.67, -1752.55, 14.1869, 0, 0, -90.4, 1378.6, -1761.4, 14.1869, 0, 0, -90.4),
(29, 975, 'axort', 0, 0, 0, -1, 2, 1927.22, -1796.92, 14.0628, 0, 0, 0, 1936.28, -1796.92, 14.0628, 0, 0, 0),
(31, 980, '', 0, 0, 1, -1, 2, 1534.54, -1451.51, 14.7228, 0, 0, 0, 1534.54, -1451.51, 9.50281, 0, 0, 0),
(30, 980, 't120ss88', 0, 0, 0, -1, 2, -57.5755, -1591.69, 4.58051, 0, 1.4, -130.3, -57.48, -1591.57, -1.45769, 0, 1.4, -130.3),
(32, 971, '1234', 0, 0, 0, -1, 2, 261.717, -1231.51, 73.4571, 0, -5.3, 35, 262.319, -1231.09, 65.5312, 0, -5.3, 35),
(34, 971, '2006', 0, 0, 0, -1, 2, -152.783, -1864.32, 3.36125, 0, 0, 109.5, -152.783, -1864.32, -2.42875, 0, 0, 109.5),
(33, 971, '2006', 0, 0, 0, -1, 2, -155.832, -1856.14, 3.48125, 0, 0, 110.7, -155.832, -1856.14, -2.65875, 0, 0, 110.7),
(36, 971, '', 0, 0, 0, -1, 2, -158.624, -1848.85, 3.80125, 0, 0, -70.3, -158.624, -1848.85, -3.40875, 0, 0, -70.3),
(37, 971, '2006', 0, 0, 0, -1, 2, -149.806, -1872.89, 3.28125, 0, 0, 109.9, -149.806, -1872.89, -2.26875, 0, 0, 109.9),
(38, 980, '2006', 0, 0, 0, -1, 2, -135.054, -1786.04, 5.16125, 0, 0, 19.5, -135.054, -1786.04, -0.688747, 0, 0, 19.5),
(16, 971, '', 0, 0, 3, -1, 2, 1145.52, -1291.38, 12.4022, 0, 0, 0, 1139.25, -1291.38, 12.4022, 0, 0, 0),
(40, 980, 'glumet123', 0, 0, 0, -1, 4, 2105.55, 1156.07, 13.1466, 0, 0, 62.3, 2105.55, 1156.07, 5.97658, 0, 0, 62.3),
(39, 19912, 'glumet123', 0, 0, 0, -1, 3, 2162.81, 1102.27, 13.6977, 0, 0, -27.5, 2162.81, 1102.27, 8.1077, 0, 0, -27.5),
(44, 19912, 'misba', 0, 0, 0, -1, 2, 2068.68, 2437.51, 11.6703, 0, 0, 0, 2068.68, 2437.51, 6.79031, 0, 0, 0),
(45, 19912, '', 0, 0, 0, -1, 2, 1188.33, -2324.81, 16.4883, 0, 1.1, -148.6, 1179.59, -2330.15, 16.2917, 0, 1.1, -148.6),
(46, 988, '', 0, 0, 0, -1, 2, 1278.5, -2282.41, 13.3634, 0, -0.6, 123.8, 1275.49, -2277.91, 13.4202, 0, -0.6, 123.8),
(48, 976, '', 0, 0, 0, 3, 2, 2361.07, -1268.75, 23.1487, 0, 0, -90.0001, 2361.07, -1275.18, 23.1487, 0, 0, -90.0001),
(47, 976, '', 0, 0, 0, 3, 2, 2313.38, -1221.77, 23.305, 0, 0, 90.5, 2313.32, -1215.26, 23.305, 0, 0, 90.5);

-- --------------------------------------------------------

--
-- Table structure for table `gstations`
--

CREATE TABLE `gstations` (
  `id` int(11) NOT NULL DEFAULT 0,
  `stock` int(11) NOT NULL DEFAULT 10000,
  `posx` float DEFAULT 0,
  `posy` float DEFAULT 0,
  `posz` float DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `gstations`
--

INSERT INTO `gstations` (`id`, `stock`, `posx`, `posy`, `posz`) VALUES
(0, 7490, 1937.56, -1772.77, 13.3828),
(1, 7920, 1944.66, -1772.42, 13.3906),
(2, 7625, -89.1587, -1163.73, 2.26514),
(3, 7930, -93.6488, -1174.95, 2.26908),
(4, 4932, 1004.67, -940.464, 42.1797),
(5, 7950, 1004.12, -933.524, 42.1797),
(6, 7493, 658.251, -559.73, 16.3359),
(7, 7940, 1380.87, 456.826, 19.91),
(8, 7663, 2114.91, 920.07, 10.8203),
(10, 7770, -2405.13, 978.62, 45.2969),
(11, 8410, 612.262, 1694.97, 6.99219),
(12, 8270, 605.164, 1705.05, 6.77943),
(13, 8700, 608.571, 1699.78, 6.78187),
(14, 9100, -1328.63, 2682.89, 49.824),
(15, 8840, 2109.35, 927.987, 10.5814),
(16, 7623, 2450.45, -1639.24, 13.4294),
(18, 7690, 658.264, -568.912, 16.3359),
(25, 7567, 70.5413, 1218.87, 18.8139),
(26, 7490, -1609.37, -2718.64, 48.5391),
(27, 7990, -1605.86, -2714.16, 48.5391),
(28, 9090, -1602.64, -2709.72, 48.5391),
(29, 7200, 76.1461, 1216.89, 18.8324),
(30, 7500, 2193.23, 2476.11, 10.5409),
(31, 7151, 2202.02, 2475.1, 10.5417),
(32, 7928, 2210.87, 2474.58, 10.5409),
(33, 9840, -1671, 417.987, 7.17969),
(34, 9680, 1594.85, 2198.79, 10.3609),
(9, 9450, -1680.61, 409.027, 7.17969),
(19, 7117, -2029.71, 156.696, 28.8359);

-- --------------------------------------------------------

--
-- Table structure for table `hotels`
--

CREATE TABLE `hotels` (
  `ID` int(11) NOT NULL,
  `owner` varchar(50) NOT NULL DEFAULT '-',
  `address` varchar(50) DEFAULT 'None',
  `price` int(11) NOT NULL DEFAULT 500000,
  `type` int(11) NOT NULL DEFAULT 1,
  `locked` int(11) NOT NULL DEFAULT 1,
  `money` int(11) NOT NULL DEFAULT 0,
  `hotelint` int(11) NOT NULL DEFAULT 0,
  `extposx` float NOT NULL DEFAULT 0,
  `extposy` float NOT NULL DEFAULT 0,
  `extposz` float NOT NULL DEFAULT 0,
  `extposa` float NOT NULL DEFAULT 0,
  `intposx` float NOT NULL DEFAULT 0,
  `intposy` float NOT NULL DEFAULT 0,
  `intposz` float NOT NULL DEFAULT 0,
  `intposa` float NOT NULL DEFAULT 0,
  `visit` bigint(16) DEFAULT 0,
  `hotelWeapon1` int(12) DEFAULT 0,
  `hotelAmmo1` int(12) DEFAULT 0,
  `hotelWeapon2` int(12) DEFAULT 0,
  `hotelAmmo2` int(12) DEFAULT 0,
  `hotelWeapon3` int(12) DEFAULT 0,
  `hotelAmmo3` int(12) DEFAULT 0,
  `hotelWeapon4` int(12) DEFAULT 0,
  `hotelAmmo4` int(12) DEFAULT 0,
  `hotelWeapon5` int(12) DEFAULT 0,
  `hotelAmmo5` int(12) DEFAULT 0,
  `hotelWeapon6` int(12) DEFAULT 0,
  `hotelAmmo6` int(12) DEFAULT 0,
  `hotelWeapon7` int(12) DEFAULT 0,
  `hotelAmmo7` int(12) DEFAULT 0,
  `hotelWeapon8` int(12) DEFAULT 0,
  `hotelAmmo8` int(12) DEFAULT 0,
  `hotelWeapon9` int(12) DEFAULT 0,
  `hotelAmmo9` int(12) DEFAULT 0,
  `hotelWeapon10` int(12) DEFAULT 0,
  `hotelAmmo10` int(12) DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `houses`
--

CREATE TABLE `houses` (
  `ID` int(11) NOT NULL,
  `owner` varchar(50) NOT NULL DEFAULT '-',
  `address` varchar(50) DEFAULT 'None',
  `price` int(11) NOT NULL DEFAULT 500000,
  `type` int(11) NOT NULL DEFAULT 1,
  `locked` int(11) NOT NULL DEFAULT 1,
  `money` int(11) NOT NULL DEFAULT 0,
  `houseint` int(11) NOT NULL DEFAULT 0,
  `extposx` float NOT NULL DEFAULT 0,
  `extposy` float NOT NULL DEFAULT 0,
  `extposz` float NOT NULL DEFAULT 0,
  `extposa` float NOT NULL DEFAULT 0,
  `intposx` float NOT NULL DEFAULT 0,
  `intposy` float NOT NULL DEFAULT 0,
  `intposz` float NOT NULL DEFAULT 0,
  `intposa` float NOT NULL DEFAULT 0,
  `visit` bigint(16) DEFAULT 0,
  `houseWeapon1` int(12) DEFAULT 0,
  `houseAmmo1` int(12) DEFAULT 0,
  `houseWeapon2` int(12) DEFAULT 0,
  `houseAmmo2` int(12) DEFAULT 0,
  `houseWeapon3` int(12) DEFAULT 0,
  `houseAmmo3` int(12) DEFAULT 0,
  `houseWeapon4` int(12) DEFAULT 0,
  `houseAmmo4` int(12) DEFAULT 0,
  `houseWeapon5` int(12) DEFAULT 0,
  `houseAmmo5` int(12) DEFAULT 0,
  `houseWeapon6` int(12) DEFAULT 0,
  `houseAmmo6` int(12) DEFAULT 0,
  `houseWeapon7` int(12) DEFAULT 0,
  `houseAmmo7` int(12) DEFAULT 0,
  `houseWeapon8` int(12) DEFAULT 0,
  `houseAmmo8` int(12) DEFAULT 0,
  `houseWeapon9` int(12) DEFAULT 0,
  `houseAmmo9` int(12) DEFAULT 0,
  `houseWeapon10` int(12) DEFAULT 0,
  `houseAmmo10` int(12) DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `iplogger`
--

CREATE TABLE `iplogger` (
  `Name` varchar(24) NOT NULL,
  `IP` int(10) UNSIGNED NOT NULL,
  `Connected` datetime NOT NULL,
  `Disconnected` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `lockers`
--

CREATE TABLE `lockers` (
  `id` int(11) NOT NULL,
  `type` int(11) NOT NULL DEFAULT 0,
  `posx` float NOT NULL DEFAULT 0,
  `posy` float NOT NULL DEFAULT 0,
  `posz` float NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lockers`
--

INSERT INTO `lockers` (`id`, `type`, `posx`, `posy`, `posz`, `interior`) VALUES
(0, 1, 1554.93, -1688.94, 2113.03, 0),
(1, 6, -4121.17, 867.087, 10.0237, 1),
(2, 2, 705.758, 405.129, 1023.58, 0),
(5, 3, 1975.33, 1171.69, -5.2087, 0),
(6, 4, 2465.13, 2251.67, 91.6868, 1),
(4, 6, 248.818, 303.935, 999.148, 1),
(15, 1, 255.061, 73.6973, 1003.64, 6),
(7, 1, 327.231, 307.197, 999.148, 5),
(8, 1, 256.669, 65.4893, 1003.64, 6),
(9, 6, 1274.49, -800.499, 1089.94, 5),
(11, 5, 1381.95, -1887.8, 17.4745, 0),
(12, 6, 1283.74, -601.322, 1004.28, 1),
(13, 5, 2308.88, -2.30453, 26.7422, 0),
(10, 6, 1283.66, -619.73, 1004.28, 1),
(14, 6, 1272.92, -738.884, 1096.52, 1),
(3, 3, 1269.95, -1308.71, 1061.14, 0),
(16, 6, 1257.66, -725.205, 1089.76, 1),
(17, 2, 376.247, 187.696, 1008.38, 3),
(18, 7, 959.615, -1352.86, 17.8554, 0),
(19, 2, 2111.41, 754.083, 97.2449, 20),
(20, 6, 1290, -799.131, 1089.94, 5),
(21, 6, 1873.7, -1724.09, 1720.07, 1);

-- --------------------------------------------------------

--
-- Table structure for table `loglogin`
--

CREATE TABLE `loglogin` (
  `no` int(11) NOT NULL,
  `username` varchar(40) NOT NULL DEFAULT 'None',
  `reg_id` int(11) NOT NULL DEFAULT 0,
  `password` varchar(40) NOT NULL DEFAULT 'None',
  `time` varchar(40) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `loglogin`
--

INSERT INTO `loglogin` (`no`, `username`, `reg_id`, `password`, `time`) VALUES
(1, 'Phillip_Bouhler', 1, '123456', '2023-02-13 22:35:46'),
(2, 'Phillip_Bouhler', 1, '123456', '2023-02-13 23:32:09'),
(3, 'Phillip_Bouhler', 1, '123456', '2023-02-13 23:40:52'),
(4, 'Phillip_Bouhler', 1, '123456', '2023-02-13 23:43:27'),
(5, 'Phillip_Bouhler', 1, '123456', '2023-02-14 08:04:53'),
(6, 'Phillip_Bouhle', 2, '123456', '2023-02-14 08:05:12'),
(7, 'Phillip_Bouhler', 1, '123456', '2023-02-14 08:05:54'),
(8, 'Phillip_Bouhler', 1, '123456', '2023-02-14 08:12:11'),
(9, 'Phillip_Bouhle', 2, '123456', '2023-02-14 08:13:22'),
(10, 'Phillip_Bouhle', 2, '123456', '2023-02-14 14:39:05'),
(11, 'Phillip_Bouhler', 1, '123456', '2023-02-14 14:40:00'),
(12, 'Phillip_Bouhler', 1, '123456', '2023-02-14 14:50:15'),
(13, 'Phillip_Bouhle', 2, '123456', '2023-02-14 14:50:52'),
(14, 'Phillip_Bouhle', 2, '123456', '2023-02-14 14:58:23'),
(15, 'Phillip_Bouhler', 1, '123456', '2023-02-14 14:59:05'),
(16, 'Phillip_Bouhler', 1, '123456', '2023-02-14 14:59:08'),
(17, 'Phillip_Bouhler', 1, '123456', '2023-02-14 15:04:49'),
(18, 'Phillip_Bouhler', 1, '123456', '2023-02-14 16:05:54'),
(19, 'Phillip_Bouhler', 1, '123456', '2023-02-14 18:59:21'),
(20, 'Phillip_Bouhler', 1, '123456', '2023-02-14 20:03:22'),
(21, 'Phillip_Bouhler', 1, '123456', '2023-02-15 05:53:11'),
(22, 'Phillip_Bouhler', 1, '123456', '2023-02-15 21:30:26'),
(23, 'Phillip_Bouhler', 1, '123456', '2023-02-15 21:58:01'),
(24, 'Phillip_Bouhler', 1, '123456', '2023-02-15 21:54:06'),
(25, 'Phillip_Bouhler', 1, '123456', '2023-02-15 21:59:57'),
(26, 'Phillip_Bouhler', 1, '123456', '2023-02-15 23:15:33'),
(27, 'Phillip_Bouhler', 1, '123456', '2023-02-16 06:11:10'),
(28, 'Phillip_Bouhler', 1, '123456', '2023-02-16 17:30:07'),
(29, 'Phillip_Bouhler', 1, '123456', '2023-02-16 17:42:52'),
(30, 'Phillip_Bouhler', 1, '123456', '2023-02-16 19:15:45'),
(31, 'Phillip_Bouhler', 1, '123456', '2023-02-16 19:29:35'),
(32, 'Phillip_Bouhler', 1, '123456', '2023-02-17 06:02:57'),
(33, 'Phillip_Bouhler', 1, '123456', '2023-02-17 06:17:04'),
(34, 'Phillip_Bouhler', 1, '123456', '2023-02-17 18:45:40'),
(35, 'Phillip_Bouhler', 1, '123456', '2023-02-17 18:55:07'),
(36, 'Phillip_Bouhler', 1, '123456', '2023-02-17 19:08:09'),
(37, 'Phillip_Bouhler', 1, '123456', '2023-02-17 20:18:43'),
(38, 'Phillip_Bouhler', 1, '123456', '2023-02-17 20:34:24'),
(39, 'Phillip_Bouhler', 1, '123456', '2023-02-17 20:46:24'),
(40, 'Phillip_Bouhler', 1, '123456', '2023-02-17 20:51:52'),
(41, 'Phillip_Bouhler', 1, '123456', '2023-02-17 21:13:59'),
(42, 'Phillip_Bouhler', 1, '123456', '2023-02-17 21:25:14'),
(43, 'Phillip_Bouhler', 1, '123456', '2023-02-17 21:36:55'),
(44, 'Phillip_Bouhler', 1, '123456', '2023-02-17 21:44:15');

-- --------------------------------------------------------

--
-- Table structure for table `logpay`
--

CREATE TABLE `logpay` (
  `player` varchar(40) NOT NULL DEFAULT 'None',
  `playerid` int(11) NOT NULL DEFAULT 0,
  `toplayer` varchar(40) NOT NULL DEFAULT 'None',
  `toplayerid` int(11) NOT NULL DEFAULT 0,
  `ammount` int(11) NOT NULL DEFAULT 0,
  `time` bigint(15) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `logstaff`
--

CREATE TABLE `logstaff` (
  `command` varchar(50) NOT NULL,
  `admin` varchar(50) NOT NULL,
  `adminid` int(11) NOT NULL,
  `player` varchar(50) NOT NULL DEFAULT '*',
  `playerid` int(11) NOT NULL DEFAULT -1,
  `str` varchar(50) NOT NULL DEFAULT '*',
  `time` bigint(15) UNSIGNED NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `logstaff`
--

INSERT INTO `logstaff` (`command`, `admin`, `adminid`, `player`, `playerid`, `str`, `time`) VALUES
('SETCOMPONENT', 'Phillip_Bouhler(None)', 1, 'Phillip_Bouhler', 1, '1000000000', 1676302753),
('SETMONEY', 'Phillip_Bouhler(meki)', 1, 'Phillip_Bouhler', 1, '999999', 1676543465),
('SETMONEY', 'Phillip_Bouhler(meki)', 1, 'Phillip_Bouhler', 1, '10', 1676543474),
('SETMONEY', 'Phillip_Bouhler(meki)', 1, 'Phillip_Bouhler', 1, '0', 1676588747),
('SETMONEY', 'Phillip_Bouhler(meki)', 1, 'Phillip_Bouhler', 1, '10000', 1676642094);

-- --------------------------------------------------------

--
-- Table structure for table `ores`
--

CREATE TABLE `ores` (
  `id` int(11) NOT NULL,
  `type` int(11) NOT NULL DEFAULT 0,
  `posx` float DEFAULT 0,
  `posy` float DEFAULT 0,
  `posz` float DEFAULT 0,
  `posrx` float DEFAULT 0,
  `posry` float DEFAULT 0,
  `posrz` float DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ores`
--

INSERT INTO `ores` (`id`, `type`, `posx`, `posy`, `posz`, `posrx`, `posry`, `posrz`) VALUES
(0, 0, 464.381, 866.534, -28.387, 0, 0, 0),
(1, 1, 555.939, 928.367, -43.5709, 0, 0, 0),
(2, 0, 613.141, 865.3, -43.5509, 0, 0, 0),
(3, 1, 637.747, 831.97, -43.6309, 0, 0, 0),
(4, 0, 671.772, 927.05, -41.4543, 0, 0, 0),
(5, 0, 652.36, 738.067, -11.904, 0, 0, 0),
(6, 1, 640.83, 731.161, -2.64683, 0, 0, 0),
(7, 1, 500.121, 781.126, -21.9991, 0, 0, 0),
(8, 0, 488.845, 785.109, -22.3256, 0, 0, 0),
(9, 1, 685.946, 820.716, -28.3049, 0, 0, 0),
(10, 0, 562.108, 982.26, -7.96277, 0, 0, 0),
(11, 0, 535.467, 909.043, -43.4109, 0, 0, 0),
(12, 0, 539.144, 882.115, -36.6565, 0, 0, 0),
(13, 1, 461.884, 884.778, -28.8179, 0, 0, 0),
(14, 1, 698.502, 841.609, -28.2711, 0, 0, 0),
(15, 1, 487.904, 800.007, -22.22, 0, 0, 0),
(16, 0, 546.501, 824.598, -29.9684, 0, 0, 0),
(17, 1, 576.64, 805.685, -29.4404, 0, 0, 0),
(18, 1, 554.326, 786.207, -19.1056, 0, 0, 0),
(19, 1, 709.745, 921.678, -19.4611, 0, 0, 0),
(20, 0, 714.078, 913.618, -19.2864, 0, 0, 0),
(21, 1, 744.818, 776.606, -8.06283, 0, 0, 0),
(22, 0, 600.437, 932.102, -41.5237, 0, 0, 0),
(23, 0, 597.532, 829.781, -43.959, 0, 0, 0),
(24, 1, 540.974, 842.47, -42.1793, 0, 0, 0),
(25, 0, 706.007, 873.741, -29.7255, 0, 0, 0),
(26, 0, 617.181, 828.375, -43.9534, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `parks`
--

CREATE TABLE `parks` (
  `id` int(11) NOT NULL,
  `posx` float NOT NULL,
  `posy` float NOT NULL,
  `posz` float NOT NULL,
  `interior` int(11) NOT NULL,
  `world` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `plants`
--

CREATE TABLE `plants` (
  `id` int(11) NOT NULL,
  `type` int(11) NOT NULL DEFAULT 0,
  `time` int(11) NOT NULL DEFAULT 0,
  `posx` float NOT NULL DEFAULT 0,
  `posy` float NOT NULL DEFAULT 0,
  `posz` float NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE `players` (
  `reg_id` int(11) UNSIGNED NOT NULL,
  `username` varchar(24) NOT NULL DEFAULT '',
  `adminname` varchar(24) NOT NULL DEFAULT 'None',
  `ip` varchar(24) NOT NULL DEFAULT '',
  `password` char(64) NOT NULL DEFAULT '',
  `password2` varchar(24) NOT NULL DEFAULT '',
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `aktif_email` enum('1','0') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `aktif_token` enum('1','0') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `online` enum('1','0') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `online_id` int(20) NOT NULL,
  `salt` char(16) NOT NULL DEFAULT '',
  `email` varchar(40) NOT NULL DEFAULT 'None',
  `admin` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `helper` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `level` int(11) UNSIGNED NOT NULL DEFAULT 1,
  `levelup` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `vip` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `vip_time` bigint(16) UNSIGNED NOT NULL DEFAULT 0,
  `gold` int(11) NOT NULL DEFAULT 0,
  `reg_date` varchar(30) NOT NULL DEFAULT '',
  `last_login` varchar(30) NOT NULL DEFAULT '',
  `money` int(11) NOT NULL DEFAULT 0,
  `bmoney` int(11) NOT NULL DEFAULT 0,
  `brek` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `phone` mediumint(8) UNSIGNED NOT NULL,
  `phoneoff` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `phonecredit` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `phonebook` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `wt` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `hours` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `minutes` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `seconds` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `paycheck` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `skin` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `facskin` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `gender` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `age` varchar(30) NOT NULL DEFAULT '',
  `indoor` mediumint(8) NOT NULL DEFAULT -1,
  `inbiz` mediumint(8) NOT NULL DEFAULT -1,
  `inflat` mediumint(8) NOT NULL DEFAULT -1,
  `inhouse` mediumint(8) NOT NULL DEFAULT -1,
  `inhotel` mediumint(8) NOT NULL DEFAULT -1,
  `posx` float NOT NULL DEFAULT 0,
  `posy` float NOT NULL DEFAULT 0,
  `posz` float NOT NULL DEFAULT 0,
  `posa` float NOT NULL DEFAULT 0,
  `interior` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `world` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `health` float NOT NULL DEFAULT 100,
  `armour` float NOT NULL DEFAULT 0,
  `hunger` smallint(5) NOT NULL DEFAULT 100,
  `energy` smallint(5) NOT NULL DEFAULT 100,
  `sick` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `hospital` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `injured` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `duty` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `dutytime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `faction` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `factionrank` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `divisi` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `factionlead` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `farm` tinyint(3) NOT NULL DEFAULT -1,
  `farmrank` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `family` tinyint(3) NOT NULL DEFAULT -1,
  `familyrank` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `pegawai` tinyint(3) NOT NULL DEFAULT -1,
  `jail` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `jail_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `arrest` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `arrest_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `warn` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `job` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `job2` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `sweepertime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `bustime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `pizzatime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `forklifttime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `jobtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `sidejobtime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `exitjob` bigint(16) UNSIGNED NOT NULL DEFAULT 0,
  `taxitime` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `medicine` mediumint(8) NOT NULL DEFAULT 0,
  `paracetamol` mediumint(8) NOT NULL DEFAULT 0,
  `amoxicilin` mediumint(8) NOT NULL DEFAULT 0,
  `antasida` mediumint(8) NOT NULL DEFAULT 0,
  `medkit` mediumint(8) NOT NULL DEFAULT 0,
  `mask` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `maskid` mediumint(8) UNSIGNED NOT NULL,
  `fstyle` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `gvip` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `helmet` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `snack` mediumint(8) NOT NULL DEFAULT 0,
  `sprunk` mediumint(8) NOT NULL DEFAULT 0,
  `gas` mediumint(8) NOT NULL DEFAULT 0,
  `bandage` mediumint(8) NOT NULL DEFAULT 0,
  `gps` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `material` mediumint(8) NOT NULL DEFAULT 0,
  `component` mediumint(8) NOT NULL DEFAULT 0,
  `food` mediumint(8) NOT NULL DEFAULT 0,
  `seed` mediumint(8) NOT NULL DEFAULT 0,
  `potato` mediumint(8) NOT NULL DEFAULT 0,
  `wheat` mediumint(8) NOT NULL DEFAULT 0,
  `orange` mediumint(8) NOT NULL DEFAULT 0,
  `price1` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `price2` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `price3` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `price4` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `marijuana` mediumint(8) NOT NULL DEFAULT 0,
  `plant` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `plant_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `fishtool` tinyint(3) NOT NULL DEFAULT 0,
  `fish` mediumint(8) NOT NULL DEFAULT 0,
  `worm` mediumint(8) NOT NULL DEFAULT 0,
  `fmax` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `ftime` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `idcard` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `idcard_time` bigint(16) UNSIGNED NOT NULL DEFAULT 0,
  `skck` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `skck_time` bigint(16) UNSIGNED NOT NULL DEFAULT 0,
  `penebang` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `penebang_time` bigint(16) UNSIGNED NOT NULL DEFAULT 0,
  `bpjs` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `bpjs_time` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `starter` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `drivelic` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `drivelic_time` bigint(16) UNSIGNED NOT NULL DEFAULT 0,
  `truckerlic` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `truckerlic_time` bigint(16) UNSIGNED NOT NULL DEFAULT 0,
  `boombox` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `hbemode` tinyint(3) UNSIGNED NOT NULL DEFAULT 2,
  `tdmode` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `togtweet` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `tnames` varchar(24) NOT NULL DEFAULT '',
  `akuntw` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `togpm` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `toglog` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `togads` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `togwt` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `togreports` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `togdamage` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `Gun1` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Gun2` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Gun3` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Gun4` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Gun5` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Gun6` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Gun7` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Gun8` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Gun9` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Gun10` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Gun11` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Gun12` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Gun13` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo1` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo2` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo3` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo4` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo5` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo6` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo7` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo8` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo9` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo10` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo11` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo12` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo13` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `WhiteList` int(11) NOT NULL DEFAULT 0,
  `trash` mediumint(8) NOT NULL DEFAULT 0,
  `berry` mediumint(8) NOT NULL DEFAULT 0,
  `frozenpizza` mediumint(8) NOT NULL DEFAULT 0,
  `licbiz` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `licbiz_time` bigint(16) UNSIGNED NOT NULL DEFAULT 0,
  `borax` int(11) NOT NULL DEFAULT 0,
  `paketborax` int(11) NOT NULL DEFAULT 0,
  `redmoney` int(11) NOT NULL DEFAULT 0,
  `ayamhidup` int(11) NOT NULL DEFAULT 0,
  `ayampotong` int(11) NOT NULL DEFAULT 0,
  `ayamfillet` int(11) NOT NULL DEFAULT 0,
  `nugget` mediumint(8) NOT NULL DEFAULT 0,
  `burger` mediumint(8) NOT NULL DEFAULT 0,
  `teh` mediumint(8) NOT NULL DEFAULT 0,
  `bodycondition0` float NOT NULL DEFAULT 100,
  `bodycondition1` float NOT NULL DEFAULT 100,
  `bodycondition2` float NOT NULL DEFAULT 100,
  `bodycondition3` float NOT NULL DEFAULT 100,
  `bodycondition4` float NOT NULL DEFAULT 100,
  `bodycondition5` float NOT NULL DEFAULT 100,
  `truckskill` int(11) NOT NULL DEFAULT 0,
  `mechskill` int(11) NOT NULL DEFAULT 0,
  `smuggskill` int(11) NOT NULL DEFAULT 0,
  `sparepart` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `players`
--

INSERT INTO `players` (`reg_id`, `username`, `adminname`, `ip`, `password`, `password2`, `token`, `aktif_email`, `aktif_token`, `online`, `online_id`, `salt`, `email`, `admin`, `helper`, `level`, `levelup`, `vip`, `vip_time`, `gold`, `reg_date`, `last_login`, `money`, `bmoney`, `brek`, `phone`, `phoneoff`, `phonecredit`, `phonebook`, `wt`, `hours`, `minutes`, `seconds`, `paycheck`, `skin`, `facskin`, `gender`, `age`, `indoor`, `inbiz`, `inflat`, `inhouse`, `inhotel`, `posx`, `posy`, `posz`, `posa`, `interior`, `world`, `health`, `armour`, `hunger`, `energy`, `sick`, `hospital`, `injured`, `duty`, `dutytime`, `faction`, `factionrank`, `divisi`, `factionlead`, `farm`, `farmrank`, `family`, `familyrank`, `pegawai`, `jail`, `jail_time`, `arrest`, `arrest_time`, `warn`, `job`, `job2`, `sweepertime`, `bustime`, `pizzatime`, `forklifttime`, `jobtime`, `sidejobtime`, `exitjob`, `taxitime`, `medicine`, `paracetamol`, `amoxicilin`, `antasida`, `medkit`, `mask`, `maskid`, `fstyle`, `gvip`, `helmet`, `snack`, `sprunk`, `gas`, `bandage`, `gps`, `material`, `component`, `food`, `seed`, `potato`, `wheat`, `orange`, `price1`, `price2`, `price3`, `price4`, `marijuana`, `plant`, `plant_time`, `fishtool`, `fish`, `worm`, `fmax`, `ftime`, `idcard`, `idcard_time`, `skck`, `skck_time`, `penebang`, `penebang_time`, `bpjs`, `bpjs_time`, `starter`, `drivelic`, `drivelic_time`, `truckerlic`, `truckerlic_time`, `boombox`, `hbemode`, `tdmode`, `togtweet`, `tnames`, `akuntw`, `togpm`, `toglog`, `togads`, `togwt`, `togreports`, `togdamage`, `Gun1`, `Gun2`, `Gun3`, `Gun4`, `Gun5`, `Gun6`, `Gun7`, `Gun8`, `Gun9`, `Gun10`, `Gun11`, `Gun12`, `Gun13`, `Ammo1`, `Ammo2`, `Ammo3`, `Ammo4`, `Ammo5`, `Ammo6`, `Ammo7`, `Ammo8`, `Ammo9`, `Ammo10`, `Ammo11`, `Ammo12`, `Ammo13`, `WhiteList`, `trash`, `berry`, `frozenpizza`, `licbiz`, `licbiz_time`, `borax`, `paketborax`, `redmoney`, `ayamhidup`, `ayampotong`, `ayamfillet`, `nugget`, `burger`, `teh`, `bodycondition0`, `bodycondition1`, `bodycondition2`, `bodycondition3`, `bodycondition4`, `bodycondition5`, `truckskill`, `mechskill`, `smuggskill`, `sparepart`) VALUES
(1, 'Phillip_Bouhler', 'meki', '255.255.255.255', '8FC35D3B19CF22F620204E678FE29F0B3EB774A422216D4E91002128C71547B4', '', NULL, NULL, NULL, NULL, 0, '-?(?te=h>6\"?,Z~^', 'None', 6, 0, 1, 5, 0, 0, 0, '2023-02-13 22:32:39', '2023-02-17 21:45:09', 0, 5000, 262814, 0, 0, 0, 0, 0, 5, 11, 3, 18663, 0, 0, 1, '09/09/2000', -1, -1, -1, -1, -1, 810.489, -597.294, 16.4875, 107.489, 0, 0, 85, 0, 75, 67, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8388607, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 106, 0, 0),
(2, 'Phillip_Bouhle', 'None', '255.255.255.255', '15E3CBA57B8DBDB45ED13D03DC28224DAE1E096F5F2929B28038A01417DD5724', '', NULL, NULL, NULL, NULL, 0, 'l\"F\\lGKA!SfD3G\\N', 'None', 0, 0, 1, 0, 0, 0, 0, '2023-02-14 07:53:56', '2023-02-14 14:29:08', 5000, 5000, 871915, 0, 0, 0, 0, 0, 0, 17, 4, 1024, 98, 0, 1, '09/09/2000', -1, -1, -1, -1, -1, 1186.4, -1324.98, 13.8594, 256.826, 0, 0, 159, 0, 50, 50, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `salary`
--

CREATE TABLE `salary` (
  `id` bigint(20) NOT NULL,
  `owner` int(11) DEFAULT 0,
  `info` varchar(46) DEFAULT '',
  `money` int(11) NOT NULL DEFAULT 0,
  `date` varchar(36) DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `server`
--

CREATE TABLE `server` (
  `id` int(11) NOT NULL DEFAULT 0,
  `servermoney` int(11) NOT NULL DEFAULT 0,
  `material` int(11) NOT NULL DEFAULT 500,
  `materialprice` int(11) NOT NULL DEFAULT 10,
  `lumberprice` int(11) NOT NULL DEFAULT 800,
  `component` int(11) NOT NULL DEFAULT 500,
  `componentprice` int(11) NOT NULL DEFAULT 10,
  `metalprice` int(11) NOT NULL DEFAULT 500,
  `gasoil` int(11) NOT NULL DEFAULT 1000,
  `gasoilprice` int(11) NOT NULL DEFAULT 10,
  `coalprice` int(11) NOT NULL DEFAULT 500,
  `product` int(11) NOT NULL DEFAULT 500,
  `productprice` int(11) NOT NULL DEFAULT 20,
  `apotek` int(11) NOT NULL DEFAULT 500,
  `medicineprice` int(11) NOT NULL DEFAULT 300,
  `medkitprice` int(11) NOT NULL DEFAULT 500,
  `food` int(11) NOT NULL DEFAULT 500,
  `foodprice` int(11) NOT NULL DEFAULT 100,
  `seedprice` int(11) NOT NULL DEFAULT 10,
  `potatoprice` int(11) NOT NULL DEFAULT 10,
  `wheatprice` int(11) NOT NULL DEFAULT 10,
  `orangeprice` int(11) NOT NULL DEFAULT 10,
  `meat` int(11) NOT NULL DEFAULT 500,
  `marijuana` int(11) NOT NULL DEFAULT 500,
  `marijuanaprice` int(11) NOT NULL DEFAULT 10,
  `fishprice` int(11) NOT NULL DEFAULT 100,
  `gstationprice` int(11) NOT NULL DEFAULT 100,
  `cargomeat` int(11) NOT NULL DEFAULT 500,
  `cargoseed` int(11) NOT NULL DEFAULT 500
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `server`
--

INSERT INTO `server` (`id`, `servermoney`, `material`, `materialprice`, `lumberprice`, `component`, `componentprice`, `metalprice`, `gasoil`, `gasoilprice`, `coalprice`, `product`, `productprice`, `apotek`, `medicineprice`, `medkitprice`, `food`, `foodprice`, `seedprice`, `potatoprice`, `wheatprice`, `orangeprice`, `meat`, `marijuana`, `marijuanaprice`, `fishprice`, `gstationprice`, `cargomeat`, `cargoseed`) VALUES
(0, -122803202, 7417, 500, 10000, 4548, 100, 10000, 6055, 150, 7000, 7417, 10000, 5000, 50, 300, 7417, 100, 5, 10, 50, 30, 479, 91880, 50000, 1500, 50, 6055, 5118);

-- --------------------------------------------------------

--
-- Table structure for table `song`
--

CREATE TABLE `song` (
  `id` int(11) NOT NULL DEFAULT 0,
  `serversong` varchar(70) CHARACTER SET latin1 NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `song`
--

INSERT INTO `song` (`id`, `serversong`) VALUES
(0, 'http://www.mboxdrive.com/raiin1.mp3\r\n');

-- --------------------------------------------------------

--
-- Table structure for table `speedcam`
--

CREATE TABLE `speedcam` (
  `ID` int(11) NOT NULL,
  `camx` float DEFAULT 0,
  `camy` float DEFAULT 0,
  `camz` float DEFAULT 0,
  `camrx` float DEFAULT 0,
  `camry` float DEFAULT 0,
  `camrz` float DEFAULT 0,
  `camworld` int(11) NOT NULL DEFAULT 10,
  `camint` int(11) NOT NULL DEFAULT 10,
  `camspeed` int(11) NOT NULL DEFAULT 10
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `toys`
--

CREATE TABLE `toys` (
  `Id` int(10) NOT NULL,
  `Owner` varchar(40) NOT NULL DEFAULT '',
  `Slot0_Model` int(8) NOT NULL DEFAULT 0,
  `Slot0_Bone` int(8) NOT NULL DEFAULT 0,
  `Slot0_XPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot0_YPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot0_ZPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot0_XRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot0_YRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot0_ZRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot0_XScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot0_YScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot0_ZScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot1_Model` int(8) NOT NULL DEFAULT 0,
  `Slot1_Bone` int(8) NOT NULL DEFAULT 0,
  `Slot1_XPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot1_YPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot1_ZPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot1_XRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot1_YRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot1_ZRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot1_XScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot1_YScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot1_ZScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_Model` int(8) NOT NULL DEFAULT 0,
  `Slot2_Bone` int(8) NOT NULL DEFAULT 0,
  `Slot2_XPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_YPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_ZPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_XRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_YRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_ZRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_XScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_YScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_ZScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot3_Model` int(8) NOT NULL DEFAULT 0,
  `Slot3_Bone` int(8) NOT NULL DEFAULT 0,
  `Slot3_XPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot3_YPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot3_ZPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot3_XRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot3_YRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot3_ZRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot3_XScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot3_YScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot3_ZScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot4_Model` int(8) NOT NULL DEFAULT 0,
  `Slot4_Bone` int(8) NOT NULL DEFAULT 0,
  `Slot4_XPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot4_YPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot4_ZPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot4_XRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot4_YRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot4_ZRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot4_XScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot4_YScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot4_ZScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot5_Model` int(8) NOT NULL DEFAULT 0,
  `Slot5_Bone` int(8) NOT NULL DEFAULT 0,
  `Slot5_XPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot5_YPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot5_ZPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot5_XRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot5_YRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot5_ZRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot5_XScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot5_YScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot5_ZScale` float(20,3) NOT NULL DEFAULT 0.000
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `trees`
--

CREATE TABLE `trees` (
  `id` int(11) NOT NULL,
  `posx` float DEFAULT NULL,
  `posy` float DEFAULT NULL,
  `posz` float DEFAULT NULL,
  `posrx` float DEFAULT NULL,
  `posry` float DEFAULT NULL,
  `posrz` float DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `trees`
--

INSERT INTO `trees` (`id`, `posx`, `posy`, `posz`, `posrx`, `posry`, `posrz`) VALUES
(0, -523.63, -2247.73, 34.5218, 0, 0, 0),
(1, -623.954, -2261.36, 23.9413, 0, 0, 0),
(2, -628.714, -2394, 29.5843, 0, 0, 0),
(3, -735.625, -2254.4, 27.5423, 0, 0, 0),
(4, -657.756, -2140.98, 24.2563, 0, 0, 0),
(5, -654.44, -2074.7, 25.9842, 0, 0, 0),
(6, -546.637, -1999.71, 48.0892, 0, 0, 0),
(7, -731.541, -2189.38, 34.526, 0, 0, 0),
(8, -732.679, -2200.2, 34.5699, 0, 0, 0),
(9, -739.308, -2193.72, 34.6548, 0, 0, 0),
(10, -865.874, -2199.14, 29.0169, 0, 0, 0),
(11, -814.336, -2247.82, 37.77, 0, 0, 0),
(12, -878.67, -2367.51, 68.2969, 0, 0, 0),
(13, -861.714, -2381.68, 69.0388, 0, 0, 0),
(14, -972.936, -2322.47, 62.7628, 0, 0, 0),
(15, -1043.86, -2303.47, 55.4699, 0, 0, 0),
(16, -979.795, -2391.9, 70.2428, 0, 0, 0),
(17, -928.635, -2531.78, 114.824, 0, 0, 0),
(18, -928.943, -2555.48, 114.897, 0, 0, 0),
(19, -889.914, -2502.48, 110.088, 0, 0, 0),
(20, -874.672, -2612.06, 95.074, 0, 0, 0),
(21, -622.4, -2263.39, 23.9615, 0, 0, 0),
(22, -552.445, -2272.94, 28.3696, 0, 0, 0),
(23, -1065.08, -2548.24, 68.1407, 0, 0, 0),
(24, -744.504, -2441.61, 65.1923, 0, 0, 0),
(25, -818.597, -2657.71, 91.0869, 0, 0, 0),
(26, -734.419, -2690.28, 86.7166, 0, 0, 0),
(27, -686.676, -2630.36, 82.9661, 0, 0, 0),
(28, -707.708, -2695.28, 91.3966, 0, 0, 0),
(29, -757.89, -2538.72, 90.0414, 0, 0, 0),
(30, -748.443, -2509.77, 81.1096, 0, 0, 0),
(31, -574.876, -2265.34, 25.6459, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `trunk`
--

CREATE TABLE `trunk` (
  `ID` int(10) NOT NULL,
  `Owner` int(11) NOT NULL DEFAULT 0,
  `money` int(11) DEFAULT 0,
  `component` int(11) NOT NULL DEFAULT 0,
  `material` int(11) NOT NULL DEFAULT 0,
  `weapon1` int(12) DEFAULT 0,
  `ammo1` int(12) DEFAULT 0,
  `weapon2` int(12) DEFAULT 0,
  `ammo2` int(12) DEFAULT 0,
  `weapon3` int(12) DEFAULT 0,
  `ammo3` int(12) DEFAULT 0,
  `weapon4` int(12) DEFAULT 0,
  `ammo4` int(12) DEFAULT 0,
  `weapon5` int(12) DEFAULT 0,
  `ammo5` int(12) DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `vehicle`
--

CREATE TABLE `vehicle` (
  `id` int(11) UNSIGNED NOT NULL,
  `owner` int(11) NOT NULL,
  `model` int(11) NOT NULL DEFAULT 0,
  `color1` int(11) NOT NULL DEFAULT 0,
  `color2` int(11) NOT NULL DEFAULT 0,
  `paintjob` int(11) NOT NULL DEFAULT -1,
  `neon` int(11) NOT NULL DEFAULT 0,
  `locked` int(11) NOT NULL DEFAULT 0,
  `insu` int(11) NOT NULL DEFAULT 1,
  `claim` int(11) NOT NULL DEFAULT 0,
  `claim_time` bigint(15) NOT NULL DEFAULT 0,
  `impound` int(11) NOT NULL DEFAULT 0,
  `impound_time` bigint(15) NOT NULL DEFAULT 0,
  `plate` varchar(50) NOT NULL DEFAULT 'None',
  `plate_time` bigint(16) NOT NULL DEFAULT 0,
  `ticket` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `price` int(11) NOT NULL DEFAULT 200000,
  `health` float NOT NULL DEFAULT 1000,
  `fuel` int(11) NOT NULL DEFAULT 1000,
  `x` float NOT NULL DEFAULT 0,
  `y` float NOT NULL DEFAULT 0,
  `z` float NOT NULL DEFAULT 0,
  `a` float NOT NULL DEFAULT 0,
  `int` int(11) NOT NULL DEFAULT 0,
  `vw` int(11) NOT NULL DEFAULT 0,
  `damage0` int(11) NOT NULL DEFAULT 0,
  `damage1` int(11) NOT NULL DEFAULT 0,
  `damage2` int(11) NOT NULL DEFAULT 0,
  `damage3` int(11) NOT NULL DEFAULT 0,
  `mod0` int(11) NOT NULL DEFAULT 0,
  `mod1` int(11) NOT NULL DEFAULT 0,
  `mod2` int(11) NOT NULL DEFAULT 0,
  `mod3` int(11) NOT NULL DEFAULT 0,
  `mod4` int(11) NOT NULL DEFAULT 0,
  `mod5` int(11) NOT NULL DEFAULT 0,
  `mod6` int(11) NOT NULL DEFAULT 0,
  `mod7` int(11) NOT NULL DEFAULT 0,
  `mod8` int(11) NOT NULL DEFAULT 0,
  `mod9` int(11) NOT NULL DEFAULT 0,
  `mod10` int(11) NOT NULL DEFAULT 0,
  `mod11` int(11) NOT NULL DEFAULT 0,
  `mod12` int(11) NOT NULL DEFAULT 0,
  `mod13` int(11) NOT NULL DEFAULT 0,
  `mod14` int(11) NOT NULL DEFAULT 0,
  `mod15` int(11) NOT NULL DEFAULT 0,
  `mod16` int(11) NOT NULL DEFAULT 0,
  `lumber` int(11) NOT NULL DEFAULT -1,
  `metal` int(11) NOT NULL DEFAULT 0,
  `coal` int(11) NOT NULL DEFAULT 0,
  `product` int(11) NOT NULL DEFAULT 0,
  `gasoil` int(11) NOT NULL DEFAULT 0,
  `money` int(11) DEFAULT 0,
  `weapon1` int(12) DEFAULT 0,
  `ammo1` int(12) DEFAULT 0,
  `weapon2` int(12) DEFAULT 0,
  `ammo2` int(12) DEFAULT 0,
  `weapon3` int(12) DEFAULT 0,
  `ammo3` int(12) DEFAULT 0,
  `weapon4` int(12) DEFAULT 0,
  `ammo4` int(12) DEFAULT 0,
  `weapon5` int(12) DEFAULT 0,
  `ammo5` int(12) DEFAULT 0,
  `weapon6` int(12) DEFAULT 0,
  `ammo6` int(12) DEFAULT 0,
  `weapon7` int(12) DEFAULT 0,
  `ammo7` int(12) DEFAULT 0,
  `weapon8` int(12) DEFAULT 0,
  `ammo8` int(12) DEFAULT 0,
  `weapon9` int(12) DEFAULT 0,
  `ammo9` int(12) DEFAULT 0,
  `weapon10` int(12) DEFAULT 0,
  `ammo10` int(12) DEFAULT 0,
  `park` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `mesin` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `body` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `rental` bigint(16) NOT NULL DEFAULT 0,
  `broken` int(11) NOT NULL DEFAULT 0,
  `component` int(11) NOT NULL DEFAULT 0,
  `material` int(11) NOT NULL DEFAULT 0,
  `fish` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `vehicle`
--

INSERT INTO `vehicle` (`id`, `owner`, `model`, `color1`, `color2`, `paintjob`, `neon`, `locked`, `insu`, `claim`, `claim_time`, `impound`, `impound_time`, `plate`, `plate_time`, `ticket`, `price`, `health`, `fuel`, `x`, `y`, `z`, `a`, `int`, `vw`, `damage0`, `damage1`, `damage2`, `damage3`, `mod0`, `mod1`, `mod2`, `mod3`, `mod4`, `mod5`, `mod6`, `mod7`, `mod8`, `mod9`, `mod10`, `mod11`, `mod12`, `mod13`, `mod14`, `mod15`, `mod16`, `lumber`, `metal`, `coal`, `product`, `gasoil`, `money`, `weapon1`, `ammo1`, `weapon2`, `ammo2`, `weapon3`, `ammo3`, `weapon4`, `ammo4`, `weapon5`, `ammo5`, `weapon6`, `ammo6`, `weapon7`, `ammo7`, `weapon8`, `ammo8`, `weapon9`, `ammo9`, `weapon10`, `ammo10`, `park`, `mesin`, `body`, `rental`, `broken`, `component`, `material`, `fish`) VALUES
(1, 1, 560, 1, 1, -1, 0, 0, 1, 1, 0, 0, 0, 'JAVA', 0, 0, 620000, 656.618, 0, -535.46, -502.969, 27.2238, 177.898, 0, 0, 2097168, 33554432, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 1, 498, 1, 1, -1, 0, 0, 2, 0, 0, 0, 0, 'JAVA', 0, 0, 158000, 960.107, 325, 799.009, -603.975, 16.4501, 173.651, 0, 0, 2097168, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_object`
--

CREATE TABLE `vehicle_object` (
  `id` int(10) UNSIGNED NOT NULL,
  `model` int(10) UNSIGNED DEFAULT NULL,
  `vehicle` int(10) UNSIGNED DEFAULT NULL,
  `color` int(24) DEFAULT NULL,
  `type` tinyint(2) UNSIGNED DEFAULT NULL,
  `x` float DEFAULT NULL,
  `y` float DEFAULT NULL,
  `z` float DEFAULT NULL,
  `rx` float DEFAULT NULL,
  `ry` float DEFAULT NULL,
  `rz` float DEFAULT NULL,
  `text` varchar(32) DEFAULT 'Text',
  `font` varchar(24) DEFAULT NULL,
  `fontcolor` int(10) UNSIGNED DEFAULT NULL,
  `fontsize` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `vehicle_object`
--

INSERT INTO `vehicle_object` (`id`, `model`, `vehicle`, `color`, `type`, `x`, `y`, `z`, `rx`, `ry`, `rz`, `text`, `font`, `fontcolor`, `fontsize`) VALUES
(1, 18661, 1, 0, 1, -1.08951, -0.045532, 0.015662, 0, -1.1, -1079.86, 'PoltekNegeriBermuda', 'Verdana', 6, 50),
(2, 18661, 1, 0, 1, 0, 0, 0, 0, 0, 0, 'TEXT', 'Arial', 1, 24),
(3, 18661, 1, 0, 1, 0, 0, 0, 0, 0, 0, 'TEXT', 'Arial', 1, 24);

-- --------------------------------------------------------

--
-- Table structure for table `vending`
--

CREATE TABLE `vending` (
  `ID` int(11) NOT NULL,
  `owner` varchar(40) CHARACTER SET latin1 NOT NULL DEFAULT '-',
  `name` varchar(64) CHARACTER SET latin1 NOT NULL DEFAULT 'Vending Machine',
  `price` int(11) NOT NULL DEFAULT 1,
  `type` int(11) NOT NULL DEFAULT 2,
  `locked` int(11) NOT NULL DEFAULT 0,
  `money` int(11) NOT NULL DEFAULT 0,
  `stock` int(11) NOT NULL DEFAULT 100,
  `posx` float NOT NULL DEFAULT 0,
  `posy` float NOT NULL DEFAULT 0,
  `posz` float NOT NULL DEFAULT 0,
  `posa` float NOT NULL DEFAULT 0,
  `posrx` float NOT NULL DEFAULT 0,
  `posry` float NOT NULL DEFAULT 0,
  `posrz` float NOT NULL DEFAULT 0,
  `restock` tinyint(2) NOT NULL DEFAULT 0,
  `vprice0` int(111) NOT NULL DEFAULT 0,
  `vprice1` int(11) NOT NULL DEFAULT 0,
  `vprice2` int(11) NOT NULL DEFAULT 0,
  `vprice3` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `vouchers`
--

CREATE TABLE `vouchers` (
  `id` int(11) NOT NULL,
  `code` int(11) NOT NULL DEFAULT 0,
  `vip` int(11) NOT NULL DEFAULT 0,
  `vip_time` int(11) NOT NULL DEFAULT 0,
  `gold` int(11) NOT NULL DEFAULT 0,
  `admin` varchar(16) NOT NULL DEFAULT 'None',
  `donature` varchar(16) NOT NULL DEFAULT 'None',
  `claim` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `vtoys`
--

CREATE TABLE `vtoys` (
  `id` int(10) NOT NULL,
  `Owner` int(11) NOT NULL DEFAULT 0,
  `Slot0_Modelid` int(8) NOT NULL DEFAULT 0,
  `Slot0_XPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot0_YPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot0_ZPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot0_XRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot0_YRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot0_ZRot` float(20,3) NOT NULL,
  `Slot1_Modelid` int(8) NOT NULL DEFAULT 0,
  `Slot1_XPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot1_YPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot1_ZPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot1_XRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot1_YRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot1_ZRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_Modelid` int(8) NOT NULL DEFAULT 0,
  `Slot2_XPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_YPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_ZPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_XRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_YRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_ZRot` float(20,3) NOT NULL,
  `Slot3_Modelid` int(8) NOT NULL DEFAULT 0,
  `Slot3_XPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot3_YPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot3_ZPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot3_XRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot3_YRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot3_ZRot` float(20,3) NOT NULL DEFAULT 0.000
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `weaponsettings`
--

CREATE TABLE `weaponsettings` (
  `Owner` int(11) NOT NULL,
  `WeaponID` tinyint(4) NOT NULL,
  `PosX` float DEFAULT -0.116,
  `PosY` float DEFAULT 0.189,
  `PosZ` float DEFAULT 0.088,
  `RotX` float DEFAULT 0,
  `RotY` float DEFAULT 44.5,
  `RotZ` float DEFAULT 0,
  `Bone` tinyint(4) NOT NULL DEFAULT 1,
  `Hidden` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `workshop`
--

CREATE TABLE `workshop` (
  `ID` int(11) NOT NULL,
  `owner` varchar(21) NOT NULL,
  `name` varchar(128) NOT NULL,
  `price` int(11) NOT NULL,
  `locked` int(11) NOT NULL,
  `xpos` float DEFAULT 0,
  `ypos` float DEFAULT 0,
  `zpos` float DEFAULT 0,
  `repx` float NOT NULL DEFAULT 0,
  `repy` float NOT NULL DEFAULT 0,
  `repz` float NOT NULL DEFAULT 0,
  `money` int(11) NOT NULL,
  `component` int(11) NOT NULL,
  `segel` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `workshop`
--

INSERT INTO `workshop` (`ID`, `owner`, `name`, `price`, `locked`, `xpos`, `ypos`, `zpos`, `repx`, `repy`, `repz`, `money`, `component`, `segel`) VALUES
(0, 'Phillip_Bouhler', 'kont', 10, 0, 166.248, -1735.8, 4.49248, 166.426, -1735.91, 4.48554, 0, 0, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `atms`
--
ALTER TABLE `atms`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `banneds`
--
ALTER TABLE `banneds`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `berry`
--
ALTER TABLE `berry`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bisnis`
--
ALTER TABLE `bisnis`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `cargo`
--
ALTER TABLE `cargo`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`contactID`);

--
-- Indexes for table `doors`
--
ALTER TABLE `doors`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `familys`
--
ALTER TABLE `familys`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `flats`
--
ALTER TABLE `flats`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `furniture`
--
ALTER TABLE `furniture`
  ADD PRIMARY KEY (`furnitureID`);

--
-- Indexes for table `gates`
--
ALTER TABLE `gates`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `gstations`
--
ALTER TABLE `gstations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hotels`
--
ALTER TABLE `hotels`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `houses`
--
ALTER TABLE `houses`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `iplogger`
--
ALTER TABLE `iplogger`
  ADD PRIMARY KEY (`Name`,`Connected`);

--
-- Indexes for table `lockers`
--
ALTER TABLE `lockers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `loglogin`
--
ALTER TABLE `loglogin`
  ADD PRIMARY KEY (`no`);

--
-- Indexes for table `ores`
--
ALTER TABLE `ores`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `plants`
--
ALTER TABLE `plants`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`reg_id`);

--
-- Indexes for table `salary`
--
ALTER TABLE `salary`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `server`
--
ALTER TABLE `server`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `speedcam`
--
ALTER TABLE `speedcam`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `toys`
--
ALTER TABLE `toys`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `id` (`Owner`);

--
-- Indexes for table `trees`
--
ALTER TABLE `trees`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trunk`
--
ALTER TABLE `trunk`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `vehicle`
--
ALTER TABLE `vehicle`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vehicle_object`
--
ALTER TABLE `vehicle_object`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vending`
--
ALTER TABLE `vending`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `vouchers`
--
ALTER TABLE `vouchers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vtoys`
--
ALTER TABLE `vtoys`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `weaponsettings`
--
ALTER TABLE `weaponsettings`
  ADD PRIMARY KEY (`Owner`,`WeaponID`),
  ADD UNIQUE KEY `Owner` (`Owner`,`WeaponID`);

--
-- Indexes for table `workshop`
--
ALTER TABLE `workshop`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `banneds`
--
ALTER TABLE `banneds`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cargo`
--
ALTER TABLE `cargo`
  MODIFY `ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `contacts`
--
ALTER TABLE `contacts`
  MODIFY `contactID` int(12) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `furniture`
--
ALTER TABLE `furniture`
  MODIFY `furnitureID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=151;

--
-- AUTO_INCREMENT for table `loglogin`
--
ALTER TABLE `loglogin`
  MODIFY `no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `players`
--
ALTER TABLE `players`
  MODIFY `reg_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `salary`
--
ALTER TABLE `salary`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `toys`
--
ALTER TABLE `toys`
  MODIFY `Id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trunk`
--
ALTER TABLE `trunk`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `vehicle`
--
ALTER TABLE `vehicle`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `vehicle_object`
--
ALTER TABLE `vehicle_object`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `vtoys`
--
ALTER TABLE `vtoys`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
