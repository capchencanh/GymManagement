-- MySQL dump 10.13  Distrib 8.0.29, for Win64 (x86_64)
--
-- Host: localhost    Database: gymnetwork
-- ------------------------------------------------------
-- Server version	8.0.29

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `chat_messages`
--

DROP TABLE IF EXISTS `chat_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_messages` (
  `message_id` int NOT NULL AUTO_INCREMENT,
  `sender_id` int NOT NULL,
  `receiver_id` int NOT NULL,
  `message` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`message_id`),
  KEY `receiver_id` (`receiver_id`),
  KEY `idx_chat_time` (`sender_id`,`receiver_id`,`created_at`),
  CONSTRAINT `chat_messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `chat_messages_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_messages`
--

LOCK TABLES `chat_messages` WRITE;
/*!40000 ALTER TABLE `chat_messages` DISABLE KEYS */;
INSERT INTO `chat_messages` VALUES (1,2,3,'Hãy tập trung vào Squat hôm nay nhé!','2025-07-01 09:00:00'),(2,3,2,'Cảm ơn PT, tôi sẽ cố gắng!','2025-07-01 09:05:00');
/*!40000 ALTER TABLE `chat_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `class_enrollments`
--

DROP TABLE IF EXISTS `class_enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class_enrollments` (
  `enrollment_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `class_id` int NOT NULL,
  `joined_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `attendance` tinyint(1) DEFAULT '0',
  `check_in_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`enrollment_id`),
  KEY `class_id` (`class_id`),
  KEY `idx_user_class` (`user_id`,`class_id`),
  CONSTRAINT `class_enrollments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `class_enrollments_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `training_classes` (`class_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class_enrollments`
--

LOCK TABLES `class_enrollments` WRITE;
/*!40000 ALTER TABLE `class_enrollments` DISABLE KEYS */;
INSERT INTO `class_enrollments` VALUES (1,3,1,'2025-07-01 10:00:00',1,'2025-07-01 11:00:00'),(2,4,2,'2025-07-01 09:00:00',0,NULL);
/*!40000 ALTER TABLE `class_enrollments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `devices` (
  `device_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `type` varchar(100) DEFAULT NULL,
  `status` enum('AVAILABLE','IN_USE','BROKEN') DEFAULT 'AVAILABLE',
  `maintenance_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`device_id`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devices`
--

LOCK TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
INSERT INTO `devices` VALUES (1,'Máy chạy bộ','Cardio','AVAILABLE',NULL,'2025-07-17 16:20:36','2025-07-17 16:20:36'),(2,'Ghế tập tạ','Strength','BROKEN','2025-07-20','2025-07-17 16:20:36','2025-07-18 11:05:41');
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `diet_items`
--

DROP TABLE IF EXISTS `diet_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `diet_items` (
  `diet_item_id` int NOT NULL AUTO_INCREMENT,
  `diet_plan_id` int DEFAULT NULL,
  `meal_name` varchar(100) DEFAULT NULL,
  `calories` int DEFAULT NULL,
  `protein` int DEFAULT NULL,
  `carb` int DEFAULT NULL,
  `fat` int DEFAULT NULL,
  PRIMARY KEY (`diet_item_id`),
  KEY `diet_plan_id` (`diet_plan_id`),
  CONSTRAINT `diet_items_ibfk_1` FOREIGN KEY (`diet_plan_id`) REFERENCES `diet_plans` (`diet_plan_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diet_items`
--

LOCK TABLES `diet_items` WRITE;
/*!40000 ALTER TABLE `diet_items` DISABLE KEYS */;
INSERT INTO `diet_items` VALUES (1,1,'Gà nướng',500,40,10,20),(2,1,'Cơm trắng',200,5,45,1),(3,2,'Salad rau',150,3,10,5);
/*!40000 ALTER TABLE `diet_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `diet_plans`
--

DROP TABLE IF EXISTS `diet_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `diet_plans` (
  `diet_plan_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `calories_target` int DEFAULT NULL,
  `created_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`diet_plan_id`),
  KEY `created_by` (`created_by`),
  KEY `idx_user_date` (`user_id`,`created_at`),
  CONSTRAINT `diet_plans_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `diet_plans_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diet_plans`
--

LOCK TABLES `diet_plans` WRITE;
/*!40000 ALTER TABLE `diet_plans` DISABLE KEYS */;
INSERT INTO `diet_plans` VALUES (1,3,2500,2,'2025-07-01 05:00:00','2025-07-17 16:20:36'),(2,4,1800,2,'2025-07-02 05:00:00','2025-07-17 16:20:36');
/*!40000 ALTER TABLE `diet_plans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `membership_packages`
--

DROP TABLE IF EXISTS `membership_packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `membership_packages` (
  `package_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `duration_months` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`package_id`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `membership_packages`
--

LOCK TABLES `membership_packages` WRITE;
/*!40000 ALTER TABLE `membership_packages` DISABLE KEYS */;
INSERT INTO `membership_packages` VALUES (1,'Gói 1 tháng',1,500000.00,'Gói cơ bản 1 tháng','2025-07-17 16:20:36','2025-07-17 16:20:36'),(2,'Gói 3 tháng',3,1300000.00,'Gói tiết kiệm 3 tháng','2025-07-17 16:20:36','2025-07-17 16:20:36'),(3,'Gói VIP',12,4500000.00,'Gói VIP với hỗ trợ PT','2025-07-17 16:20:36','2025-07-17 16:20:36');
/*!40000 ALTER TABLE `membership_packages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `receiver_id` int NOT NULL,
  `sender_id` int DEFAULT NULL,
  `content` text,
  `type` enum('REMINDER','CHAT','SYSTEM') DEFAULT NULL,
  `status` enum('READ','UNREAD') DEFAULT 'UNREAD',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_id`),
  KEY `sender_id` (`sender_id`),
  KEY `idx_receiver_status` (`receiver_id`,`status`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,3,2,'Nhắc nhở lịch tập hôm nay','REMINDER','UNREAD','2025-07-01 08:00:00'),(2,4,2,'Đánh giá tiến trình','SYSTEM','READ','2025-07-02 07:00:00');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plan_details`
--

DROP TABLE IF EXISTS `plan_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plan_details` (
  `detail_id` int NOT NULL AUTO_INCREMENT,
  `plan_id` int NOT NULL,
  `day_of_week` int DEFAULT NULL,
  `exercise_name` varchar(100) DEFAULT NULL,
  `sets` int DEFAULT NULL,
  `reps` int DEFAULT NULL,
  `weight` decimal(6,2) DEFAULT NULL,
  PRIMARY KEY (`detail_id`),
  KEY `idx_plan_day` (`plan_id`,`day_of_week`),
  CONSTRAINT `plan_details_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `training_plans` (`plan_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plan_details`
--

LOCK TABLES `plan_details` WRITE;
/*!40000 ALTER TABLE `plan_details` DISABLE KEYS */;
INSERT INTO `plan_details` VALUES (1,1,2,'Squat',3,10,50.00),(2,1,4,'Bench Press',3,8,40.00),(3,2,3,'Yoga Pose',2,30,0.00);
/*!40000 ALTER TABLE `plan_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trainers`
--

DROP TABLE IF EXISTS `trainers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trainers` (
  `trainer_id` int NOT NULL,
  `specialization` varchar(100) DEFAULT NULL,
  `schedule` text,
  PRIMARY KEY (`trainer_id`),
  CONSTRAINT `trainers_ibfk_1` FOREIGN KEY (`trainer_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trainers`
--

LOCK TABLES `trainers` WRITE;
/*!40000 ALTER TABLE `trainers` DISABLE KEYS */;
INSERT INTO `trainers` VALUES (2,'Gym, Yoga','Thứ 2-6: 8:00-12:00, 14:00-18:00');
/*!40000 ALTER TABLE `trainers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `training_classes`
--

DROP TABLE IF EXISTS `training_classes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `training_classes` (
  `class_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  `trainer_id` int DEFAULT NULL,
  `schedule` text,
  `max_participants` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`class_id`),
  KEY `trainer_id` (`trainer_id`),
  KEY `idx_name` (`name`),
  CONSTRAINT `training_classes_ibfk_1` FOREIGN KEY (`trainer_id`) REFERENCES `trainers` (`trainer_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `training_classes`
--

LOCK TABLES `training_classes` WRITE;
/*!40000 ALTER TABLE `training_classes` DISABLE KEYS */;
INSERT INTO `training_classes` VALUES (1,'Lớp Gym','Tập luyện cơ bản',2,'Thứ 3,5: 18:00-19:30',20,'2025-07-17 16:20:36','2025-07-17 16:20:36'),(2,'Lớp Yoga','Tập luyện thư giãn',2,'Thứ 4,6: 17:00-18:30',15,'2025-07-17 16:20:36','2025-07-17 16:20:36');
/*!40000 ALTER TABLE `training_classes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `training_plans`
--

DROP TABLE IF EXISTS `training_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `training_plans` (
  `plan_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `created_by` int DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('ACTIVE','COMPLETED') DEFAULT 'ACTIVE',
  PRIMARY KEY (`plan_id`),
  KEY `created_by` (`created_by`),
  KEY `idx_user_date` (`user_id`,`start_date`),
  CONSTRAINT `training_plans_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `training_plans_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `training_plans`
--

LOCK TABLES `training_plans` WRITE;
/*!40000 ALTER TABLE `training_plans` DISABLE KEYS */;
INSERT INTO `training_plans` VALUES (1,3,2,'2025-07-01','2025-07-07','ACTIVE'),(2,4,2,'2025-07-01','2025-07-07','ACTIVE');
/*!40000 ALTER TABLE `training_plans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_memberships`
--

DROP TABLE IF EXISTS `user_memberships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_memberships` (
  `membership_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `package_id` int DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('ACTIVE','EXPIRED','CANCELLED') DEFAULT 'ACTIVE',
  PRIMARY KEY (`membership_id`),
  KEY `package_id` (`package_id`),
  KEY `idx_user_status` (`user_id`,`status`),
  CONSTRAINT `user_memberships_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `user_memberships_ibfk_2` FOREIGN KEY (`package_id`) REFERENCES `membership_packages` (`package_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_memberships`
--

LOCK TABLES `user_memberships` WRITE;
/*!40000 ALTER TABLE `user_memberships` DISABLE KEYS */;
INSERT INTO `user_memberships` VALUES (1,3,1,'2025-06-01','2025-06-30','ACTIVE'),(2,4,2,'2025-05-01','2025-07-31','ACTIVE');
/*!40000 ALTER TABLE `user_memberships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('ADMIN','PT','USER') NOT NULL,
  `name` varchar(100) NOT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `height` decimal(5,2) DEFAULT NULL,
  `weight` decimal(5,2) DEFAULT NULL,
  `fitness_goal` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone_number` (`phone_number`),
  KEY `idx_email` (`email`),
  KEY `idx_phone` (`phone_number`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin@example.com','0901234567','123','ADMIN','Nguyen Van A','Male','1985-05-15',NULL,NULL,NULL,'2025-07-17 16:20:36','2025-07-18 10:49:17'),(2,'pt1@example.com','0901234568','123','PT','Tran Thi B','Female','1990-08-20',NULL,NULL,NULL,'2025-07-17 16:20:36','2025-07-18 10:49:17'),(3,'user1@example.com','0901234569','123','USER','Le Van C','Male','1995-03-10',175.50,70.00,'Tăng cơ','2025-07-17 16:20:36','2025-07-18 10:49:17'),(4,'user2@example.com','0901234570','123','USER','Pham Thi D','Female','1998-11-25',160.00,55.00,'Giảm cân','2025-07-17 16:20:36','2025-07-18 10:49:17');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workout_logs`
--

DROP TABLE IF EXISTS `workout_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `workout_logs` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `exercise_name` varchar(100) DEFAULT NULL,
  `sets` int DEFAULT NULL,
  `reps` int DEFAULT NULL,
  `weight` decimal(6,2) DEFAULT NULL,
  `duration_min` int DEFAULT NULL,
  `calories_burned` decimal(6,2) DEFAULT NULL,
  `logged_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `idx_user_date` (`user_id`,`logged_at`),
  CONSTRAINT `workout_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workout_logs`
--

LOCK TABLES `workout_logs` WRITE;
/*!40000 ALTER TABLE `workout_logs` DISABLE KEYS */;
INSERT INTO `workout_logs` VALUES (1,3,'Squat',3,10,50.00,30,200.00,'2025-07-01 02:00:00'),(2,4,'Plank',2,60,0.00,10,50.00,'2025-07-02 03:00:00');
/*!40000 ALTER TABLE `workout_logs` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-20 13:32:27
