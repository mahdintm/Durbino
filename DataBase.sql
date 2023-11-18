-- phpMyAdmin SQL Dump

-- version 4.9.5deb2

-- https://www.phpmyadmin.net/

--

-- Host: localhost:3306

-- Generation Time: Nov 18, 2023 at 11:06 PM

-- Server version: 8.0.34-0ubuntu0.20.04.1

-- PHP Version: 7.4.3-4ubuntu2.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";

SET AUTOCOMMIT = 0;

START TRANSACTION;

SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */

;

/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */

;

/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */

;

/*!40101 SET NAMES utf8mb4 */

;

--

-- Database: `Mahdi_test`

--

CREATE DATABASE
    IF NOT EXISTS `Durbino` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

USE `Mahdi_test`;

-- --------------------------------------------------------

--

-- Table structure for table `chats`

--

CREATE TABLE
    `chats` (
        `id` int NOT NULL,
        `is_Group` tinyint(1) NOT NULL DEFAULT '0',
        `Members` varchar(3000) NOT NULL DEFAULT '[]',
        `name_Group` varchar(100) NOT NULL DEFAULT 'گروه',
        `admins_Group` varchar(3000) NOT NULL DEFAULT '[]',
        `image` varchar(1000) DEFAULT NULL
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--

-- Table structure for table `GPS`

--

CREATE TABLE
    `GPS` (
        `id` int NOT NULL,
        `User` int NOT NULL,
        `latitude` double NOT NULL,
        `longitude` double NOT NULL,
        `timestamp` bigint NOT NULL
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--

-- Table structure for table `Logs`

--

CREATE TABLE
    `Logs` (
        `id` int NOT NULL,
        `EventName` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
        `Description` varchar(10000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
        `TimeStamp` bigint DEFAULT NULL
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--

-- Table structure for table `pms`

--

CREATE TABLE
    `pms` (
        `id` int NOT NULL,
        `from` int NOT NULL,
        `timestamp` varchar(1000) NOT NULL,
        `value` varchar(10000) NOT NULL,
        `chat_id` int NOT NULL,
        `status` tinyint(1) NOT NULL DEFAULT '0',
        `isMedia` tinyint(1) NOT NULL DEFAULT '0'
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--

-- Table structure for table `Users`

--

CREATE TABLE
    `Users` (
        `id` int NOT NULL,
        `username` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
        `password` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
        `acl` int NOT NULL DEFAULT '0',
        `lastLogin` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0',
        `image` varchar(1000) DEFAULT NULL,
        `name` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '{"firstName":null,"lastName":null}',
        `lastOnline` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '1000',
        `IsEnable` tinyint(1) NOT NULL DEFAULT '1'
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--

-- Dumping data for table `Users`

--

INSERT INTO
    `Users` (
        `id`,
        `username`,
        `password`,
        `acl`,
        `lastLogin`,
        `image`,
        `name`,
        `lastOnline`,
        `IsEnable`
    )
VALUES (
        1,
        'admin',
        'admin',
        1,
        '1691961505997',
        NULL,
        '{\"firstName\":null,\"lastName\":null}',
        '1691961540529',
        1
    );

--

-- Indexes for dumped tables

--

--

-- Indexes for table `chats`

--

ALTER TABLE `chats` ADD PRIMARY KEY (`id`);

--

-- Indexes for table `GPS`

--

ALTER TABLE `GPS` ADD PRIMARY KEY (`id`);

--

-- Indexes for table `Logs`

--

ALTER TABLE `Logs` ADD PRIMARY KEY (`id`);

--

-- Indexes for table `pms`

--

ALTER TABLE `pms` ADD PRIMARY KEY (`id`);

--

-- Indexes for table `Users`

--

ALTER TABLE `Users` ADD PRIMARY KEY (`id`);

--

-- AUTO_INCREMENT for dumped tables

--

--

-- AUTO_INCREMENT for table `chats`

--

ALTER TABLE
    `chats` MODIFY `id` int NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT = 5;

--

-- AUTO_INCREMENT for table `GPS`

--

ALTER TABLE
    `GPS` MODIFY `id` int NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT = 6043;

--

-- AUTO_INCREMENT for table `Logs`

--

ALTER TABLE
    `Logs` MODIFY `id` int NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT = 436;

--

-- AUTO_INCREMENT for table `pms`

--

ALTER TABLE
    `pms` MODIFY `id` int NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT = 8;

--

-- AUTO_INCREMENT for table `Users`

--

ALTER TABLE
    `Users` MODIFY `id` int NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT = 10;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */

;

/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */

;

/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */

;