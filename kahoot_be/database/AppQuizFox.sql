/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE IF NOT EXISTS `AppQuizFox`;

USE `AppQuizFox`;

CREATE TABLE `GameSessions` (
  `session_id` int NOT NULL AUTO_INCREMENT,
  `quiz_id` int NOT NULL,
  `pin` varchar(10) NOT NULL,
  `status` enum('active','playing','inactive') DEFAULT 'active',
  `start_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `end_time` timestamp NULL DEFAULT NULL,
  `host` varchar(100) NOT NULL,
  PRIMARY KEY (`session_id`),
  UNIQUE KEY `pin` (`pin`),
  KEY `quiz_id` (`quiz_id`),
  CONSTRAINT `GameSessions_ibfk_1` FOREIGN KEY (`quiz_id`) REFERENCES `Quizzes` (`quiz_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Options` (
  `option_id` int NOT NULL AUTO_INCREMENT,
  `question_id` int NOT NULL,
  `option_text` text NOT NULL,
  `is_correct` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`option_id`),
  KEY `question_id` (`question_id`),
  CONSTRAINT `Options_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `Questions` (`question_id`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Questions` (
  `question_id` int NOT NULL AUTO_INCREMENT,
  `quiz_id` int NOT NULL,
  `question_text` text NOT NULL,
  `question_type` enum('multiple_choice','true_false','open_ended','puzzle','poll') NOT NULL,
  `media_url` text,
  `time_limit` int DEFAULT '30',
  `points` int DEFAULT '0',
  PRIMARY KEY (`question_id`),
  KEY `quiz_id` (`quiz_id`),
  CONSTRAINT `Questions_ibfk_1` FOREIGN KEY (`quiz_id`) REFERENCES `Quizzes` (`quiz_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `QuizSnapshots` (
  `snapshot_id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `quiz_id` int NOT NULL,
  `user_id` int NOT NULL,
  `quiz_data` json NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`snapshot_id`),
  KEY `session_id` (`session_id`),
  KEY `quiz_id` (`quiz_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `QuizSnapshots_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `GameSessions` (`session_id`),
  CONSTRAINT `QuizSnapshots_ibfk_2` FOREIGN KEY (`quiz_id`) REFERENCES `Quizzes` (`quiz_id`),
  CONSTRAINT `QuizSnapshots_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Quizzes` (
  `quiz_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `creator` varchar(100) NOT NULL,
  `cover_image` text,
  `visibility` enum('public','private') DEFAULT 'public',
  `category` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`quiz_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `SessionAnswers` (
  `answer_id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `user_id` int NOT NULL,
  `answers_json` json DEFAULT NULL,
  `answered_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`answer_id`),
  KEY `session_id` (`session_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `SessionAnswers_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `GameSessions` (`session_id`),
  CONSTRAINT `SessionAnswers_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `SessionPlayers` (
  `session_player_id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `user_id` int NOT NULL,
  `nickname` varchar(50) NOT NULL,
  `score` int DEFAULT '0',
  `join_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`session_player_id`),
  KEY `session_id` (`session_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `SessionPlayers_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `GameSessions` (`session_id`),
  CONSTRAINT `SessionPlayers_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Groups` (
    `group_id` INT AUTO_INCREMENT PRIMARY KEY,
    `group_name` VARCHAR(100) NOT NULL,
    `created_by` INT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`created_by`) REFERENCES `Users`(`user_id`)
);

CREATE TABLE `GroupMembers` (
    `member_id` INT AUTO_INCREMENT PRIMARY KEY,
    `group_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `joined_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`group_id`) REFERENCES `Groups`(`group_id`),
    FOREIGN KEY (`user_id`) REFERENCES `Users`(`user_id`)
);

CREATE TABLE `GroupMessages` (
    `message_id` INT AUTO_INCREMENT PRIMARY KEY,
    `group_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `message` TEXT NOT NULL,
    `sent_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`group_id`) REFERENCES `Groups`(`group_id`),
    FOREIGN KEY (`user_id`) REFERENCES `Users`(`user_id`)
);

INSERT INTO `GameSessions` (`session_id`, `quiz_id`, `pin`, `status`, `start_time`, `end_time`, `host`) VALUES
(1, 1, '885718', 'active', '2025-02-12 06:12:19', NULL, '1');
INSERT INTO `GameSessions` (`session_id`, `quiz_id`, `pin`, `status`, `start_time`, `end_time`, `host`) VALUES
(2, 2, '564692', 'active', '2025-02-12 06:21:17', NULL, '1');
INSERT INTO `GameSessions` (`session_id`, `quiz_id`, `pin`, `status`, `start_time`, `end_time`, `host`) VALUES
(4, 4, '959625', 'active', '2025-02-12 06:55:03', NULL, '2');
INSERT INTO `GameSessions` (`session_id`, `quiz_id`, `pin`, `status`, `start_time`, `end_time`, `host`) VALUES
(5, 5, '917327', 'active', '2025-02-12 07:00:50', NULL, '2'),
(6, 6, '429890', 'active', '2025-02-12 07:11:53', NULL, '3'),
(7, 6, '711295', 'active', '2025-02-12 07:12:00', NULL, '3'),
(8, 3, '907490', 'inactive', '2025-02-12 08:44:10', NULL, '2'),
(9, 3, '872501', 'inactive', '2025-02-12 09:10:52', NULL, '2'),
(13, 7, '035093', 'inactive', '2025-02-12 16:54:08', NULL, '2');

INSERT INTO `Options` (`option_id`, `question_id`, `option_text`, `is_correct`) VALUES
(1, 1, 'Hyperlink and Text Markup Language', 0);
INSERT INTO `Options` (`option_id`, `question_id`, `option_text`, `is_correct`) VALUES
(2, 1, 'Hyper Transfer Markup Language', 0);
INSERT INTO `Options` (`option_id`, `question_id`, `option_text`, `is_correct`) VALUES
(3, 1, 'Hyper Text Markup Language', 1);
INSERT INTO `Options` (`option_id`, `question_id`, `option_text`, `is_correct`) VALUES
(4, 1, 'High Tech Markup Language', 0),
(5, 2, '<ul>', 1),
(6, 2, '<ol>', 0),
(7, 2, '<li>', 0),
(8, 2, '<list>', 0),
(9, 3, 'href', 0),
(10, 3, 'src', 1),
(11, 3, 'alt', 0),
(12, 3, 'link', 0),
(13, 4, '<td>', 0),
(14, 4, '<tr>', 1),
(15, 4, '<th>', 0),
(16, 4, '<table>', 0),
(17, 5, '<br>', 1),
(18, 5, '<lb>', 0),
(19, 5, '<break>', 0),
(20, 5, '<newline>', 0),
(21, 6, 'Creative Style Sheets', 0),
(22, 6, 'Cascading Style Sheets', 1),
(23, 6, 'Computer Style Sheets', 0),
(24, 6, 'Colorful Style Sheets', 0),
(25, 7, 'font-color', 0),
(26, 7, 'text-color', 0),
(27, 7, 'color', 1),
(28, 7, 'text-style', 0),
(29, 8, '.', 0),
(30, 8, '#', 1),
(31, 8, '@', 0),
(32, 8, '*', 0),
(33, 9, 'font-weight: bold', 1),
(34, 9, 'text-bold: true', 0),
(35, 9, 'bold: yes', 0),
(36, 9, 'style: bold', 0),
(37, 10, '6', 0),
(38, 10, '7', 0),
(39, 10, '8', 1),
(40, 10, '9', 0),
(41, 11, '5', 0),
(42, 11, '6', 1),
(43, 11, '7', 0),
(44, 11, '8', 0),
(45, 12, '10', 0),
(46, 12, '11', 0),
(47, 12, '12', 1),
(48, 12, '13', 0),
(49, 13, '2', 0),
(50, 13, '3', 0),
(51, 13, '4', 1),
(52, 13, '5', 0),
(53, 14, '7', 0),
(54, 14, '8', 1),
(55, 14, '9', 0),
(56, 14, '10', 0),
(57, 15, 'Berlin', 0),
(58, 15, 'Madrid', 0),
(59, 15, 'Paris', 1),
(60, 15, 'Rome', 0),
(61, 16, '5', 0),
(62, 16, '6', 0),
(63, 16, '7', 1),
(64, 16, '8', 0),
(65, 17, 'Atlantic Ocean', 0),
(66, 17, 'Indian Ocean', 0),
(67, 17, 'Arctic Ocean', 0),
(68, 17, 'Pacific Ocean', 1),
(69, 18, 'Amazon River', 0),
(70, 18, 'Nile River', 1),
(71, 18, 'Yangtze River', 0),
(72, 18, 'Mississippi River', 0),
(73, 19, 'Japan', 0),
(74, 19, 'China', 1),
(75, 19, 'India', 0),
(76, 19, 'Korea', 0),
(77, 21, 'China', 0),
(78, 21, 'Thailand', 0),
(79, 21, 'Japan', 0),
(80, 21, 'Vietnam', 1),
(81, 22, 'Monaco', 0),
(82, 22, 'Liechtenstein', 0),
(83, 22, 'Vatican City', 1),
(84, 22, 'San Marino', 0),
(85, 23, 'Sahara Desert', 0),
(86, 23, 'Gobi Desert', 0),
(87, 23, 'Antarctic Desert', 1),
(88, 23, 'Arabian Desert', 0),
(89, 24, 'var myVar = 10', 1),
(90, 24, 'variable myVar = 10', 0),
(91, 24, 'let myVar == 10', 0),
(92, 24, 'const myVar : 10', 0),
(93, 25, 'let', 0),
(94, 25, 'const', 1),
(95, 25, 'var', 0),
(96, 25, 'static', 0),
(97, 26, '\"number\"', 1),
(98, 26, '\"string\"', 0),
(99, 26, '\"integer\"', 0),
(100, 26, '\"undefined\"', 0),
(101, 27, '#', 0),
(102, 27, '//', 1),
(103, 27, '<!-- -->', 0),
(104, 27, '/* */', 0),
(105, 28, '7', 0),
(106, 28, '12', 1),
(107, 28, '9', 0),
(108, 28, '15', 0),
(109, 29, '3', 0),
(110, 29, '5', 0),
(111, 29, '4', 1),
(112, 29, '6', 0),
(113, 30, '3', 0),
(114, 30, '4', 0),
(115, 30, '6', 0),
(116, 30, '5', 1);

INSERT INTO `Questions` (`question_id`, `quiz_id`, `question_text`, `question_type`, `media_url`, `time_limit`, `points`) VALUES
(1, 1, 'What does HTML stand for?', 'multiple_choice', '', 20, 10);
INSERT INTO `Questions` (`question_id`, `quiz_id`, `question_text`, `question_type`, `media_url`, `time_limit`, `points`) VALUES
(2, 1, 'Which HTML tag is used to define an unordered list?', 'multiple_choice', '', 20, 10);
INSERT INTO `Questions` (`question_id`, `quiz_id`, `question_text`, `question_type`, `media_url`, `time_limit`, `points`) VALUES
(3, 1, 'Which attribute is used to specify an image in an <img> tag?', 'multiple_choice', '', 20, 10);
INSERT INTO `Questions` (`question_id`, `quiz_id`, `question_text`, `question_type`, `media_url`, `time_limit`, `points`) VALUES
(4, 1, ' Which HTML tag is used to define a table row?', 'multiple_choice', '', 20, 10),
(5, 1, 'Which HTML tag is used to create a line break?', 'multiple_choice', '', 20, 10),
(6, 2, 'What does CSS stand for?', 'multiple_choice', '', 20, 10),
(7, 2, 'Which property is used to change text color?', 'multiple_choice', '', 20, 10),
(8, 2, 'Which symbol is used for an ID selector?', 'multiple_choice', '', 20, 10),
(9, 2, 'How do you make text bold in CSS?', 'multiple_choice', '', 20, 10),
(10, 3, 'What is 5 + 3?', 'multiple_choice', '', 20, 10),
(11, 3, 'What is 10 − 4?', 'multiple_choice', '', 20, 10),
(12, 3, 'What is 3 × 4?', 'multiple_choice', '', 20, 10),
(13, 3, 'What is 16 ÷ 4?', 'multiple_choice', '', 20, 10),
(14, 3, 'What is the next number in the sequence: 2, 4, 6, __?', 'multiple_choice', '', 20, 10),
(15, 4, 'What is the capital of France?', 'multiple_choice', '', 20, 10),
(16, 4, 'How many continents are there on Earth?', 'multiple_choice', '', 20, 10),
(17, 4, 'Which ocean is the largest?', 'multiple_choice', '', 20, 10),
(18, 4, 'What is the longest river in the world?', 'multiple_choice', '', 20, 10),
(19, 4, 'Which country is famous for the Great Wall?', 'multiple_choice', '', 20, 10),
(21, 5, 'This flag belongs to which country ?', 'multiple_choice', 'https://res.cloudinary.com/dlrd3ngz5/image/upload/v1739343756/appquizfox/j4e9btufogljlipwdc9y.png', 20, 10),
(22, 5, 'What is the smallest country in the world by land area?', 'multiple_choice', '', 20, 10),
(23, 5, 'Which desert is the largest in the world?', 'multiple_choice', '', 20, 10),
(24, 6, 'How do you declare a variable in JavaScript?', 'multiple_choice', '', 20, 10),
(25, 6, 'Which keyword is used to define a constant variable?', 'multiple_choice', '', 20, 10),
(26, 6, ' What is the output of console.log(typeof 42);?', 'multiple_choice', '', 20, 10),
(27, 6, 'Which symbol is used for single-line comments in JavaScript?', 'multiple_choice', '', 20, 10),
(28, 7, 'Which number is an even number?', 'multiple_choice', '', 20, 10),
(29, 7, 'If a triangle has three sides, how many sides does a square have?', 'multiple_choice', '', 20, 10),
(30, 7, 'What is 15 ÷ 3?', 'multiple_choice', '', 20, 10);

INSERT INTO `QuizSnapshots` (`snapshot_id`, `session_id`, `quiz_id`, `user_id`, `quiz_data`, `created_at`) VALUES
(1, 2, 2, 1, '{\"questions\": [{\"options\": [{\"option_id\": 21, \"is_correct\": false, \"option_text\": \"Creative Style Sheets\"}, {\"option_id\": 22, \"is_correct\": true, \"option_text\": \"Cascading Style Sheets\"}, {\"option_id\": 23, \"is_correct\": false, \"option_text\": \"Computer Style Sheets\"}, {\"option_id\": 24, \"is_correct\": false, \"option_text\": \"Colorful Style Sheets\"}], \"question_id\": 6, \"question_text\": \"What does CSS stand for?\"}, {\"options\": [{\"option_id\": 25, \"is_correct\": false, \"option_text\": \"font-color\"}, {\"option_id\": 26, \"is_correct\": false, \"option_text\": \"text-color\"}, {\"option_id\": 27, \"is_correct\": true, \"option_text\": \"color\"}, {\"option_id\": 28, \"is_correct\": false, \"option_text\": \"text-style\"}], \"question_id\": 7, \"question_text\": \"Which property is used to change text color?\"}, {\"options\": [{\"option_id\": 29, \"is_correct\": false, \"option_text\": \".\"}, {\"option_id\": 30, \"is_correct\": true, \"option_text\": \"#\"}, {\"option_id\": 31, \"is_correct\": false, \"option_text\": \"@\"}, {\"option_id\": 32, \"is_correct\": false, \"option_text\": \"*\"}], \"question_id\": 8, \"question_text\": \"Which symbol is used for an ID selector?\"}, {\"options\": [{\"option_id\": 33, \"is_correct\": true, \"option_text\": \"font-weight: bold\"}, {\"option_id\": 34, \"is_correct\": false, \"option_text\": \"text-bold: true\"}, {\"option_id\": 35, \"is_correct\": false, \"option_text\": \"bold: yes\"}, {\"option_id\": 36, \"is_correct\": false, \"option_text\": \"style: bold\"}], \"question_id\": 9, \"question_text\": \"How do you make text bold in CSS?\"}], \"quizTitle\": \"CSS review\"}', '2025-02-12 06:42:25');
INSERT INTO `QuizSnapshots` (`snapshot_id`, `session_id`, `quiz_id`, `user_id`, `quiz_data`, `created_at`) VALUES
(3, 4, 4, 3, '{\"questions\": [{\"options\": [{\"option_id\": 57, \"is_correct\": false, \"option_text\": \"Berlin\"}, {\"option_id\": 58, \"is_correct\": false, \"option_text\": \"Madrid\"}, {\"option_id\": 59, \"is_correct\": true, \"option_text\": \"Paris\"}, {\"option_id\": 60, \"is_correct\": false, \"option_text\": \"Rome\"}], \"question_id\": 15, \"question_text\": \"What is the capital of France?\"}, {\"options\": [{\"option_id\": 61, \"is_correct\": false, \"option_text\": \"5\"}, {\"option_id\": 62, \"is_correct\": false, \"option_text\": \"6\"}, {\"option_id\": 63, \"is_correct\": true, \"option_text\": \"7\"}, {\"option_id\": 64, \"is_correct\": false, \"option_text\": \"8\"}], \"question_id\": 16, \"question_text\": \"How many continents are there on Earth?\"}, {\"options\": [{\"option_id\": 65, \"is_correct\": false, \"option_text\": \"Atlantic Ocean\"}, {\"option_id\": 66, \"is_correct\": false, \"option_text\": \"Indian Ocean\"}, {\"option_id\": 67, \"is_correct\": false, \"option_text\": \"Arctic Ocean\"}, {\"option_id\": 68, \"is_correct\": true, \"option_text\": \"Pacific Ocean\"}], \"question_id\": 17, \"question_text\": \"Which ocean is the largest?\"}, {\"options\": [{\"option_id\": 69, \"is_correct\": false, \"option_text\": \"Amazon River\"}, {\"option_id\": 70, \"is_correct\": true, \"option_text\": \"Nile River\"}, {\"option_id\": 71, \"is_correct\": false, \"option_text\": \"Yangtze River\"}, {\"option_id\": 72, \"is_correct\": false, \"option_text\": \"Mississippi River\"}], \"question_id\": 18, \"question_text\": \"What is the longest river in the world?\"}, {\"options\": [{\"option_id\": 73, \"is_correct\": false, \"option_text\": \"Japan\"}, {\"option_id\": 74, \"is_correct\": true, \"option_text\": \"China\"}, {\"option_id\": 75, \"is_correct\": false, \"option_text\": \"India\"}, {\"option_id\": 76, \"is_correct\": false, \"option_text\": \"Korea\"}], \"question_id\": 19, \"question_text\": \"Which country is famous for the Great Wall?\"}], \"quizTitle\": \"Geography basic quiz\"}', '2025-02-12 07:29:04');
INSERT INTO `QuizSnapshots` (`snapshot_id`, `session_id`, `quiz_id`, `user_id`, `quiz_data`, `created_at`) VALUES
(4, 2, 2, 5, '{\"questions\": [{\"options\": [{\"option_id\": 21, \"is_correct\": false, \"option_text\": \"Creative Style Sheets\"}, {\"option_id\": 22, \"is_correct\": true, \"option_text\": \"Cascading Style Sheets\"}, {\"option_id\": 23, \"is_correct\": false, \"option_text\": \"Computer Style Sheets\"}, {\"option_id\": 24, \"is_correct\": false, \"option_text\": \"Colorful Style Sheets\"}], \"question_id\": 6, \"question_text\": \"What does CSS stand for?\"}, {\"options\": [{\"option_id\": 25, \"is_correct\": false, \"option_text\": \"font-color\"}, {\"option_id\": 26, \"is_correct\": false, \"option_text\": \"text-color\"}, {\"option_id\": 27, \"is_correct\": true, \"option_text\": \"color\"}, {\"option_id\": 28, \"is_correct\": false, \"option_text\": \"text-style\"}], \"question_id\": 7, \"question_text\": \"Which property is used to change text color?\"}, {\"options\": [{\"option_id\": 29, \"is_correct\": false, \"option_text\": \".\"}, {\"option_id\": 30, \"is_correct\": true, \"option_text\": \"#\"}, {\"option_id\": 31, \"is_correct\": false, \"option_text\": \"@\"}, {\"option_id\": 32, \"is_correct\": false, \"option_text\": \"*\"}], \"question_id\": 8, \"question_text\": \"Which symbol is used for an ID selector?\"}, {\"options\": [{\"option_id\": 33, \"is_correct\": true, \"option_text\": \"font-weight: bold\"}, {\"option_id\": 34, \"is_correct\": false, \"option_text\": \"text-bold: true\"}, {\"option_id\": 35, \"is_correct\": false, \"option_text\": \"bold: yes\"}, {\"option_id\": 36, \"is_correct\": false, \"option_text\": \"style: bold\"}], \"question_id\": 9, \"question_text\": \"How do you make text bold in CSS?\"}], \"quizTitle\": \"CSS review\"}', '2025-02-12 07:32:22');
INSERT INTO `QuizSnapshots` (`snapshot_id`, `session_id`, `quiz_id`, `user_id`, `quiz_data`, `created_at`) VALUES
(5, 4, 4, 4, '{\"questions\": [{\"options\": [{\"option_id\": 57, \"is_correct\": false, \"option_text\": \"Berlin\"}, {\"option_id\": 58, \"is_correct\": false, \"option_text\": \"Madrid\"}, {\"option_id\": 59, \"is_correct\": true, \"option_text\": \"Paris\"}, {\"option_id\": 60, \"is_correct\": false, \"option_text\": \"Rome\"}], \"question_id\": 15, \"question_text\": \"What is the capital of France?\"}, {\"options\": [{\"option_id\": 61, \"is_correct\": false, \"option_text\": \"5\"}, {\"option_id\": 62, \"is_correct\": false, \"option_text\": \"6\"}, {\"option_id\": 63, \"is_correct\": true, \"option_text\": \"7\"}, {\"option_id\": 64, \"is_correct\": false, \"option_text\": \"8\"}], \"question_id\": 16, \"question_text\": \"How many continents are there on Earth?\"}, {\"options\": [{\"option_id\": 65, \"is_correct\": false, \"option_text\": \"Atlantic Ocean\"}, {\"option_id\": 66, \"is_correct\": false, \"option_text\": \"Indian Ocean\"}, {\"option_id\": 67, \"is_correct\": false, \"option_text\": \"Arctic Ocean\"}, {\"option_id\": 68, \"is_correct\": true, \"option_text\": \"Pacific Ocean\"}], \"question_id\": 17, \"question_text\": \"Which ocean is the largest?\"}, {\"options\": [{\"option_id\": 69, \"is_correct\": false, \"option_text\": \"Amazon River\"}, {\"option_id\": 70, \"is_correct\": true, \"option_text\": \"Nile River\"}, {\"option_id\": 71, \"is_correct\": false, \"option_text\": \"Yangtze River\"}, {\"option_id\": 72, \"is_correct\": false, \"option_text\": \"Mississippi River\"}], \"question_id\": 18, \"question_text\": \"What is the longest river in the world?\"}, {\"options\": [{\"option_id\": 73, \"is_correct\": false, \"option_text\": \"Japan\"}, {\"option_id\": 74, \"is_correct\": true, \"option_text\": \"China\"}, {\"option_id\": 75, \"is_correct\": false, \"option_text\": \"India\"}, {\"option_id\": 76, \"is_correct\": false, \"option_text\": \"Korea\"}], \"question_id\": 19, \"question_text\": \"Which country is famous for the Great Wall?\"}], \"quizTitle\": \"Geography basic quiz\"}', '2025-02-12 07:36:58'),
(9, 9, 3, 2, '{\"questions\": [{\"options\": [{\"option_id\": 37, \"is_correct\": false, \"option_text\": \"6\"}, {\"option_id\": 38, \"is_correct\": false, \"option_text\": \"7\"}, {\"option_id\": 39, \"is_correct\": true, \"option_text\": \"8\"}, {\"option_id\": 40, \"is_correct\": false, \"option_text\": \"9\"}], \"question_id\": 10, \"question_text\": \"What is 5 + 3?\"}, {\"options\": [{\"option_id\": 41, \"is_correct\": false, \"option_text\": \"5\"}, {\"option_id\": 42, \"is_correct\": true, \"option_text\": \"6\"}, {\"option_id\": 43, \"is_correct\": false, \"option_text\": \"7\"}, {\"option_id\": 44, \"is_correct\": false, \"option_text\": \"8\"}], \"question_id\": 11, \"question_text\": \"What is 10 − 4?\"}, {\"options\": [{\"option_id\": 45, \"is_correct\": false, \"option_text\": \"10\"}, {\"option_id\": 46, \"is_correct\": false, \"option_text\": \"11\"}, {\"option_id\": 47, \"is_correct\": true, \"option_text\": \"12\"}, {\"option_id\": 48, \"is_correct\": false, \"option_text\": \"13\"}], \"question_id\": 12, \"question_text\": \"What is 3 × 4?\"}, {\"options\": [{\"option_id\": 49, \"is_correct\": false, \"option_text\": \"2\"}, {\"option_id\": 50, \"is_correct\": false, \"option_text\": \"3\"}, {\"option_id\": 51, \"is_correct\": true, \"option_text\": \"4\"}, {\"option_id\": 52, \"is_correct\": false, \"option_text\": \"5\"}], \"question_id\": 13, \"question_text\": \"What is 16 ÷ 4?\"}, {\"options\": [{\"option_id\": 53, \"is_correct\": false, \"option_text\": \"7\"}, {\"option_id\": 54, \"is_correct\": true, \"option_text\": \"8\"}, {\"option_id\": 55, \"is_correct\": false, \"option_text\": \"9\"}, {\"option_id\": 56, \"is_correct\": false, \"option_text\": \"10\"}], \"question_id\": 14, \"question_text\": \"What is the next number in the sequence: 2, 4, 6, __?\"}], \"quizTitle\": \"Math basic quiz\"}', '2025-02-12 09:10:53'),
(10, 9, 3, 4, '{\"questions\": [{\"options\": [{\"option_id\": 37, \"is_correct\": false, \"option_text\": \"6\"}, {\"option_id\": 38, \"is_correct\": false, \"option_text\": \"7\"}, {\"option_id\": 39, \"is_correct\": true, \"option_text\": \"8\"}, {\"option_id\": 40, \"is_correct\": false, \"option_text\": \"9\"}], \"question_id\": 10, \"question_text\": \"What is 5 + 3?\"}, {\"options\": [{\"option_id\": 41, \"is_correct\": false, \"option_text\": \"5\"}, {\"option_id\": 42, \"is_correct\": true, \"option_text\": \"6\"}, {\"option_id\": 43, \"is_correct\": false, \"option_text\": \"7\"}, {\"option_id\": 44, \"is_correct\": false, \"option_text\": \"8\"}], \"question_id\": 11, \"question_text\": \"What is 10 − 4?\"}, {\"options\": [{\"option_id\": 45, \"is_correct\": false, \"option_text\": \"10\"}, {\"option_id\": 46, \"is_correct\": false, \"option_text\": \"11\"}, {\"option_id\": 47, \"is_correct\": true, \"option_text\": \"12\"}, {\"option_id\": 48, \"is_correct\": false, \"option_text\": \"13\"}], \"question_id\": 12, \"question_text\": \"What is 3 × 4?\"}, {\"options\": [{\"option_id\": 49, \"is_correct\": false, \"option_text\": \"2\"}, {\"option_id\": 50, \"is_correct\": false, \"option_text\": \"3\"}, {\"option_id\": 51, \"is_correct\": true, \"option_text\": \"4\"}, {\"option_id\": 52, \"is_correct\": false, \"option_text\": \"5\"}], \"question_id\": 13, \"question_text\": \"What is 16 ÷ 4?\"}, {\"options\": [{\"option_id\": 53, \"is_correct\": false, \"option_text\": \"7\"}, {\"option_id\": 54, \"is_correct\": true, \"option_text\": \"8\"}, {\"option_id\": 55, \"is_correct\": false, \"option_text\": \"9\"}, {\"option_id\": 56, \"is_correct\": false, \"option_text\": \"10\"}], \"question_id\": 14, \"question_text\": \"What is the next number in the sequence: 2, 4, 6, __?\"}], \"quizTitle\": \"Math basic quiz\"}', '2025-02-12 09:11:02'),
(11, 9, 3, 3, '{\"questions\": [{\"options\": [{\"option_id\": 37, \"is_correct\": false, \"option_text\": \"6\"}, {\"option_id\": 38, \"is_correct\": false, \"option_text\": \"7\"}, {\"option_id\": 39, \"is_correct\": true, \"option_text\": \"8\"}, {\"option_id\": 40, \"is_correct\": false, \"option_text\": \"9\"}], \"question_id\": 10, \"question_text\": \"What is 5 + 3?\"}, {\"options\": [{\"option_id\": 41, \"is_correct\": false, \"option_text\": \"5\"}, {\"option_id\": 42, \"is_correct\": true, \"option_text\": \"6\"}, {\"option_id\": 43, \"is_correct\": false, \"option_text\": \"7\"}, {\"option_id\": 44, \"is_correct\": false, \"option_text\": \"8\"}], \"question_id\": 11, \"question_text\": \"What is 10 − 4?\"}, {\"options\": [{\"option_id\": 45, \"is_correct\": false, \"option_text\": \"10\"}, {\"option_id\": 46, \"is_correct\": false, \"option_text\": \"11\"}, {\"option_id\": 47, \"is_correct\": true, \"option_text\": \"12\"}, {\"option_id\": 48, \"is_correct\": false, \"option_text\": \"13\"}], \"question_id\": 12, \"question_text\": \"What is 3 × 4?\"}, {\"options\": [{\"option_id\": 49, \"is_correct\": false, \"option_text\": \"2\"}, {\"option_id\": 50, \"is_correct\": false, \"option_text\": \"3\"}, {\"option_id\": 51, \"is_correct\": true, \"option_text\": \"4\"}, {\"option_id\": 52, \"is_correct\": false, \"option_text\": \"5\"}], \"question_id\": 13, \"question_text\": \"What is 16 ÷ 4?\"}, {\"options\": [{\"option_id\": 53, \"is_correct\": false, \"option_text\": \"7\"}, {\"option_id\": 54, \"is_correct\": true, \"option_text\": \"8\"}, {\"option_id\": 55, \"is_correct\": false, \"option_text\": \"9\"}, {\"option_id\": 56, \"is_correct\": false, \"option_text\": \"10\"}], \"question_id\": 14, \"question_text\": \"What is the next number in the sequence: 2, 4, 6, __?\"}], \"quizTitle\": \"Math basic quiz\"}', '2025-02-12 09:11:31'),
(12, 7, 6, 1, '{\"questions\": [{\"options\": [{\"option_id\": 89, \"is_correct\": true, \"option_text\": \"var myVar = 10\"}, {\"option_id\": 90, \"is_correct\": false, \"option_text\": \"variable myVar = 10\"}, {\"option_id\": 91, \"is_correct\": false, \"option_text\": \"let myVar == 10\"}, {\"option_id\": 92, \"is_correct\": false, \"option_text\": \"const myVar : 10\"}], \"question_id\": 24, \"question_text\": \"How do you declare a variable in JavaScript?\"}, {\"options\": [{\"option_id\": 93, \"is_correct\": false, \"option_text\": \"let\"}, {\"option_id\": 94, \"is_correct\": true, \"option_text\": \"const\"}, {\"option_id\": 95, \"is_correct\": false, \"option_text\": \"var\"}, {\"option_id\": 96, \"is_correct\": false, \"option_text\": \"static\"}], \"question_id\": 25, \"question_text\": \"Which keyword is used to define a constant variable?\"}, {\"options\": [{\"option_id\": 97, \"is_correct\": true, \"option_text\": \"\\\"number\\\"\"}, {\"option_id\": 98, \"is_correct\": false, \"option_text\": \"\\\"string\\\"\"}, {\"option_id\": 99, \"is_correct\": false, \"option_text\": \"\\\"integer\\\"\"}, {\"option_id\": 100, \"is_correct\": false, \"option_text\": \"\\\"undefined\\\"\"}], \"question_id\": 26, \"question_text\": \" What is the output of console.log(typeof 42);?\"}, {\"options\": [{\"option_id\": 101, \"is_correct\": false, \"option_text\": \"#\"}, {\"option_id\": 102, \"is_correct\": true, \"option_text\": \"//\"}, {\"option_id\": 103, \"is_correct\": false, \"option_text\": \"<!-- -->\"}, {\"option_id\": 104, \"is_correct\": false, \"option_text\": \"/* */\"}], \"question_id\": 27, \"question_text\": \"Which symbol is used for single-line comments in JavaScript?\"}], \"quizTitle\": \"JavaScript final test\"}', '2025-02-12 09:15:00'),
(13, 7, 6, 3, '{\"questions\": [{\"options\": [{\"option_id\": 89, \"is_correct\": true, \"option_text\": \"var myVar = 10\"}, {\"option_id\": 90, \"is_correct\": false, \"option_text\": \"variable myVar = 10\"}, {\"option_id\": 91, \"is_correct\": false, \"option_text\": \"let myVar == 10\"}, {\"option_id\": 92, \"is_correct\": false, \"option_text\": \"const myVar : 10\"}], \"question_id\": 24, \"question_text\": \"How do you declare a variable in JavaScript?\"}, {\"options\": [{\"option_id\": 93, \"is_correct\": false, \"option_text\": \"let\"}, {\"option_id\": 94, \"is_correct\": true, \"option_text\": \"const\"}, {\"option_id\": 95, \"is_correct\": false, \"option_text\": \"var\"}, {\"option_id\": 96, \"is_correct\": false, \"option_text\": \"static\"}], \"question_id\": 25, \"question_text\": \"Which keyword is used to define a constant variable?\"}, {\"options\": [{\"option_id\": 97, \"is_correct\": true, \"option_text\": \"\\\"number\\\"\"}, {\"option_id\": 98, \"is_correct\": false, \"option_text\": \"\\\"string\\\"\"}, {\"option_id\": 99, \"is_correct\": false, \"option_text\": \"\\\"integer\\\"\"}, {\"option_id\": 100, \"is_correct\": false, \"option_text\": \"\\\"undefined\\\"\"}], \"question_id\": 26, \"question_text\": \" What is the output of console.log(typeof 42);?\"}, {\"options\": [{\"option_id\": 101, \"is_correct\": false, \"option_text\": \"#\"}, {\"option_id\": 102, \"is_correct\": true, \"option_text\": \"//\"}, {\"option_id\": 103, \"is_correct\": false, \"option_text\": \"<!-- -->\"}, {\"option_id\": 104, \"is_correct\": false, \"option_text\": \"/* */\"}], \"question_id\": 27, \"question_text\": \"Which symbol is used for single-line comments in JavaScript?\"}], \"quizTitle\": \"JavaScript final test\"}', '2025-02-12 09:17:01'),
(14, 2, 2, 3, '{\"questions\": [{\"options\": [{\"option_id\": 21, \"is_correct\": false, \"option_text\": \"Creative Style Sheets\"}, {\"option_id\": 22, \"is_correct\": true, \"option_text\": \"Cascading Style Sheets\"}, {\"option_id\": 23, \"is_correct\": false, \"option_text\": \"Computer Style Sheets\"}, {\"option_id\": 24, \"is_correct\": false, \"option_text\": \"Colorful Style Sheets\"}], \"question_id\": 6, \"question_text\": \"What does CSS stand for?\"}, {\"options\": [{\"option_id\": 25, \"is_correct\": false, \"option_text\": \"font-color\"}, {\"option_id\": 26, \"is_correct\": false, \"option_text\": \"text-color\"}, {\"option_id\": 27, \"is_correct\": true, \"option_text\": \"color\"}, {\"option_id\": 28, \"is_correct\": false, \"option_text\": \"text-style\"}], \"question_id\": 7, \"question_text\": \"Which property is used to change text color?\"}, {\"options\": [{\"option_id\": 29, \"is_correct\": false, \"option_text\": \".\"}, {\"option_id\": 30, \"is_correct\": true, \"option_text\": \"#\"}, {\"option_id\": 31, \"is_correct\": false, \"option_text\": \"@\"}, {\"option_id\": 32, \"is_correct\": false, \"option_text\": \"*\"}], \"question_id\": 8, \"question_text\": \"Which symbol is used for an ID selector?\"}, {\"options\": [{\"option_id\": 33, \"is_correct\": true, \"option_text\": \"font-weight: bold\"}, {\"option_id\": 34, \"is_correct\": false, \"option_text\": \"text-bold: true\"}, {\"option_id\": 35, \"is_correct\": false, \"option_text\": \"bold: yes\"}, {\"option_id\": 36, \"is_correct\": false, \"option_text\": \"style: bold\"}], \"question_id\": 9, \"question_text\": \"How do you make text bold in CSS?\"}], \"quizTitle\": \"CSS review\"}', '2025-02-12 09:17:18'),
(15, 5, 5, 3, '{\"questions\": [{\"options\": [{\"option_id\": 77, \"is_correct\": false, \"option_text\": \"China\"}, {\"option_id\": 78, \"is_correct\": false, \"option_text\": \"Thailand\"}, {\"option_id\": 79, \"is_correct\": false, \"option_text\": \"Japan\"}, {\"option_id\": 80, \"is_correct\": true, \"option_text\": \"Vietnam\"}], \"question_id\": 21, \"question_text\": \"This flag belongs to which country ?\"}, {\"options\": [{\"option_id\": 81, \"is_correct\": false, \"option_text\": \"Monaco\"}, {\"option_id\": 82, \"is_correct\": false, \"option_text\": \"Liechtenstein\"}, {\"option_id\": 83, \"is_correct\": true, \"option_text\": \"Vatican City\"}, {\"option_id\": 84, \"is_correct\": false, \"option_text\": \"San Marino\"}], \"question_id\": 22, \"question_text\": \"What is the smallest country in the world by land area?\"}, {\"options\": [{\"option_id\": 85, \"is_correct\": false, \"option_text\": \"Sahara Desert\"}, {\"option_id\": 86, \"is_correct\": false, \"option_text\": \"Gobi Desert\"}, {\"option_id\": 87, \"is_correct\": true, \"option_text\": \"Antarctic Desert\"}, {\"option_id\": 88, \"is_correct\": false, \"option_text\": \"Arabian Desert\"}], \"question_id\": 23, \"question_text\": \"Which desert is the largest in the world?\"}], \"quizTitle\": \"Geography 2\"}', '2025-02-12 10:09:05'),
(16, 5, 5, 1, '{\"questions\": [{\"options\": [{\"option_id\": 77, \"is_correct\": false, \"option_text\": \"China\"}, {\"option_id\": 78, \"is_correct\": false, \"option_text\": \"Thailand\"}, {\"option_id\": 79, \"is_correct\": false, \"option_text\": \"Japan\"}, {\"option_id\": 80, \"is_correct\": true, \"option_text\": \"Vietnam\"}], \"question_id\": 21, \"question_text\": \"This flag belongs to which country ?\"}, {\"options\": [{\"option_id\": 81, \"is_correct\": false, \"option_text\": \"Monaco\"}, {\"option_id\": 82, \"is_correct\": false, \"option_text\": \"Liechtenstein\"}, {\"option_id\": 83, \"is_correct\": true, \"option_text\": \"Vatican City\"}, {\"option_id\": 84, \"is_correct\": false, \"option_text\": \"San Marino\"}], \"question_id\": 22, \"question_text\": \"What is the smallest country in the world by land area?\"}, {\"options\": [{\"option_id\": 85, \"is_correct\": false, \"option_text\": \"Sahara Desert\"}, {\"option_id\": 86, \"is_correct\": false, \"option_text\": \"Gobi Desert\"}, {\"option_id\": 87, \"is_correct\": true, \"option_text\": \"Antarctic Desert\"}, {\"option_id\": 88, \"is_correct\": false, \"option_text\": \"Arabian Desert\"}], \"question_id\": 23, \"question_text\": \"Which desert is the largest in the world?\"}], \"quizTitle\": \"Geography 2\"}', '2025-02-12 10:11:45'),
(17, 4, 4, 2, '{\"questions\": [{\"options\": [{\"option_id\": 57, \"is_correct\": false, \"option_text\": \"Berlin\"}, {\"option_id\": 58, \"is_correct\": false, \"option_text\": \"Madrid\"}, {\"option_id\": 59, \"is_correct\": true, \"option_text\": \"Paris\"}, {\"option_id\": 60, \"is_correct\": false, \"option_text\": \"Rome\"}], \"question_id\": 15, \"question_text\": \"What is the capital of France?\"}, {\"options\": [{\"option_id\": 61, \"is_correct\": false, \"option_text\": \"5\"}, {\"option_id\": 62, \"is_correct\": false, \"option_text\": \"6\"}, {\"option_id\": 63, \"is_correct\": true, \"option_text\": \"7\"}, {\"option_id\": 64, \"is_correct\": false, \"option_text\": \"8\"}], \"question_id\": 16, \"question_text\": \"How many continents are there on Earth?\"}, {\"options\": [{\"option_id\": 65, \"is_correct\": false, \"option_text\": \"Atlantic Ocean\"}, {\"option_id\": 66, \"is_correct\": false, \"option_text\": \"Indian Ocean\"}, {\"option_id\": 67, \"is_correct\": false, \"option_text\": \"Arctic Ocean\"}, {\"option_id\": 68, \"is_correct\": true, \"option_text\": \"Pacific Ocean\"}], \"question_id\": 17, \"question_text\": \"Which ocean is the largest?\"}, {\"options\": [{\"option_id\": 69, \"is_correct\": false, \"option_text\": \"Amazon River\"}, {\"option_id\": 70, \"is_correct\": true, \"option_text\": \"Nile River\"}, {\"option_id\": 71, \"is_correct\": false, \"option_text\": \"Yangtze River\"}, {\"option_id\": 72, \"is_correct\": false, \"option_text\": \"Mississippi River\"}], \"question_id\": 18, \"question_text\": \"What is the longest river in the world?\"}, {\"options\": [{\"option_id\": 73, \"is_correct\": false, \"option_text\": \"Japan\"}, {\"option_id\": 74, \"is_correct\": true, \"option_text\": \"China\"}, {\"option_id\": 75, \"is_correct\": false, \"option_text\": \"India\"}, {\"option_id\": 76, \"is_correct\": false, \"option_text\": \"Korea\"}], \"question_id\": 19, \"question_text\": \"Which country is famous for the Great Wall?\"}], \"quizTitle\": \"Geography basic quiz\"}', '2025-02-12 15:43:25'),
(22, 13, 7, 2, '{\"questions\": [{\"options\": [{\"option_id\": 105, \"is_correct\": false, \"option_text\": \"7\"}, {\"option_id\": 106, \"is_correct\": true, \"option_text\": \"12\"}, {\"option_id\": 107, \"is_correct\": false, \"option_text\": \"9\"}, {\"option_id\": 108, \"is_correct\": false, \"option_text\": \"15\"}], \"question_id\": 28, \"question_text\": \"Which number is an even number?\"}, {\"options\": [{\"option_id\": 109, \"is_correct\": false, \"option_text\": \"3\"}, {\"option_id\": 110, \"is_correct\": false, \"option_text\": \"5\"}, {\"option_id\": 111, \"is_correct\": true, \"option_text\": \"4\"}, {\"option_id\": 112, \"is_correct\": false, \"option_text\": \"6\"}], \"question_id\": 29, \"question_text\": \"If a triangle has three sides, how many sides does a square have?\"}, {\"options\": [{\"option_id\": 113, \"is_correct\": false, \"option_text\": \"3\"}, {\"option_id\": 114, \"is_correct\": false, \"option_text\": \"4\"}, {\"option_id\": 115, \"is_correct\": false, \"option_text\": \"6\"}, {\"option_id\": 116, \"is_correct\": true, \"option_text\": \"5\"}], \"question_id\": 30, \"question_text\": \"What is 15 ÷ 3?\"}], \"quizTitle\": \"Math 2\"}', '2025-02-12 16:54:09'),
(23, 13, 7, 1, '{\"questions\": [{\"options\": [{\"option_id\": 105, \"is_correct\": false, \"option_text\": \"7\"}, {\"option_id\": 106, \"is_correct\": true, \"option_text\": \"12\"}, {\"option_id\": 107, \"is_correct\": false, \"option_text\": \"9\"}, {\"option_id\": 108, \"is_correct\": false, \"option_text\": \"15\"}], \"question_id\": 28, \"question_text\": \"Which number is an even number?\"}, {\"options\": [{\"option_id\": 109, \"is_correct\": false, \"option_text\": \"3\"}, {\"option_id\": 110, \"is_correct\": false, \"option_text\": \"5\"}, {\"option_id\": 111, \"is_correct\": true, \"option_text\": \"4\"}, {\"option_id\": 112, \"is_correct\": false, \"option_text\": \"6\"}], \"question_id\": 29, \"question_text\": \"If a triangle has three sides, how many sides does a square have?\"}, {\"options\": [{\"option_id\": 113, \"is_correct\": false, \"option_text\": \"3\"}, {\"option_id\": 114, \"is_correct\": false, \"option_text\": \"4\"}, {\"option_id\": 115, \"is_correct\": false, \"option_text\": \"6\"}, {\"option_id\": 116, \"is_correct\": true, \"option_text\": \"5\"}], \"question_id\": 30, \"question_text\": \"What is 15 ÷ 3?\"}], \"quizTitle\": \"Math 2\"}', '2025-02-12 16:54:17'),
(24, 13, 7, 4, '{\"questions\": [{\"options\": [{\"option_id\": 105, \"is_correct\": false, \"option_text\": \"7\"}, {\"option_id\": 106, \"is_correct\": true, \"option_text\": \"12\"}, {\"option_id\": 107, \"is_correct\": false, \"option_text\": \"9\"}, {\"option_id\": 108, \"is_correct\": false, \"option_text\": \"15\"}], \"question_id\": 28, \"question_text\": \"Which number is an even number?\"}, {\"options\": [{\"option_id\": 109, \"is_correct\": false, \"option_text\": \"3\"}, {\"option_id\": 110, \"is_correct\": false, \"option_text\": \"5\"}, {\"option_id\": 111, \"is_correct\": true, \"option_text\": \"4\"}, {\"option_id\": 112, \"is_correct\": false, \"option_text\": \"6\"}], \"question_id\": 29, \"question_text\": \"If a triangle has three sides, how many sides does a square have?\"}, {\"options\": [{\"option_id\": 113, \"is_correct\": false, \"option_text\": \"3\"}, {\"option_id\": 114, \"is_correct\": false, \"option_text\": \"4\"}, {\"option_id\": 115, \"is_correct\": false, \"option_text\": \"6\"}, {\"option_id\": 116, \"is_correct\": true, \"option_text\": \"5\"}], \"question_id\": 30, \"question_text\": \"What is 15 ÷ 3?\"}], \"quizTitle\": \"Math 2\"}', '2025-02-12 16:54:38'),
(25, 2, 2, 2, '{\"questions\": [{\"options\": [{\"option_id\": 21, \"is_correct\": false, \"option_text\": \"Creative Style Sheets\"}, {\"option_id\": 22, \"is_correct\": true, \"option_text\": \"Cascading Style Sheets\"}, {\"option_id\": 23, \"is_correct\": false, \"option_text\": \"Computer Style Sheets\"}, {\"option_id\": 24, \"is_correct\": false, \"option_text\": \"Colorful Style Sheets\"}], \"question_id\": 6, \"question_text\": \"What does CSS stand for?\"}, {\"options\": [{\"option_id\": 25, \"is_correct\": false, \"option_text\": \"font-color\"}, {\"option_id\": 26, \"is_correct\": false, \"option_text\": \"text-color\"}, {\"option_id\": 27, \"is_correct\": true, \"option_text\": \"color\"}, {\"option_id\": 28, \"is_correct\": false, \"option_text\": \"text-style\"}], \"question_id\": 7, \"question_text\": \"Which property is used to change text color?\"}, {\"options\": [{\"option_id\": 29, \"is_correct\": false, \"option_text\": \".\"}, {\"option_id\": 30, \"is_correct\": true, \"option_text\": \"#\"}, {\"option_id\": 31, \"is_correct\": false, \"option_text\": \"@\"}, {\"option_id\": 32, \"is_correct\": false, \"option_text\": \"*\"}], \"question_id\": 8, \"question_text\": \"Which symbol is used for an ID selector?\"}, {\"options\": [{\"option_id\": 33, \"is_correct\": true, \"option_text\": \"font-weight: bold\"}, {\"option_id\": 34, \"is_correct\": false, \"option_text\": \"text-bold: true\"}, {\"option_id\": 35, \"is_correct\": false, \"option_text\": \"bold: yes\"}, {\"option_id\": 36, \"is_correct\": false, \"option_text\": \"style: bold\"}], \"question_id\": 9, \"question_text\": \"How do you make text bold in CSS?\"}], \"quizTitle\": \"CSS review\"}', '2025-02-12 17:02:38');

INSERT INTO `Quizzes` (`quiz_id`, `title`, `description`, `creator`, `cover_image`, `visibility`, `category`, `created_at`, `updated_at`) VALUES
(1, 'HTML review', 'review HTML for dev', '1', 'https://res.cloudinary.com/dlrd3ngz5/image/upload/v1739340737/appquizfox/pokth6sxrtwlr7kbt2zi.webp', 'private', 'IT', '2025-02-12 06:12:19', '2025-02-12 06:12:19');
INSERT INTO `Quizzes` (`quiz_id`, `title`, `description`, `creator`, `cover_image`, `visibility`, `category`, `created_at`, `updated_at`) VALUES
(2, 'CSS review', 'review CSS help practice', '1', 'https://res.cloudinary.com/dlrd3ngz5/image/upload/v1739341275/appquizfox/ihzm9hjvtgeyck6jecj8.png', 'public', 'IT', '2025-02-12 06:21:17', '2025-02-12 06:21:17');
INSERT INTO `Quizzes` (`quiz_id`, `title`, `description`, `creator`, `cover_image`, `visibility`, `category`, `created_at`, `updated_at`) VALUES
(3, 'Math basic quiz', 'Test your basic math skills', '2', 'https://res.cloudinary.com/dlrd3ngz5/image/upload/v1739342851/appquizfox/wp8gqtg6n155coetfbha.jpg', 'private', 'Math', '2025-02-12 06:47:34', '2025-02-12 06:47:34');
INSERT INTO `Quizzes` (`quiz_id`, `title`, `description`, `creator`, `cover_image`, `visibility`, `category`, `created_at`, `updated_at`) VALUES
(4, 'Geography basic quiz', 'simple question', '2', 'https://res.cloudinary.com/dlrd3ngz5/image/upload/v1739343300/appquizfox/xtx3hdcca9z3ssqr7zwp.jpg', 'public', 'Geography', '2025-02-12 06:55:03', '2025-02-12 06:55:03'),
(5, 'Geography 2', 'small quiz', '2', 'https://res.cloudinary.com/dlrd3ngz5/image/upload/v1739343648/appquizfox/klqwmpucbntdnvrqavi5.jpg', 'public', 'Geography', '2025-02-12 07:00:50', '2025-02-12 07:00:50'),
(6, 'JavaScript final test', 'final test', '3', 'https://res.cloudinary.com/dlrd3ngz5/image/upload/v1739344311/appquizfox/viwgsxl8zgsonikqcbrb.jpg', 'public', 'IT', '2025-02-12 07:11:53', '2025-02-12 07:11:53'),
(7, 'Math 2', 'math quiz', '2', 'https://res.cloudinary.com/dlrd3ngz5/image/upload/v1739377876/appquizfox/gknijipts3t0idfqlhkl.jpg', 'private', 'Math', '2025-02-12 16:31:20', '2025-02-12 16:31:20');

INSERT INTO `SessionAnswers` (`answer_id`, `session_id`, `user_id`, `answers_json`, `answered_at`) VALUES
(1, 4, 3, '{\"0\": 59, \"1\": 63, \"2\": 68, \"3\": 70, \"4\": 74}', '2025-02-12 07:30:58');
INSERT INTO `SessionAnswers` (`answer_id`, `session_id`, `user_id`, `answers_json`, `answered_at`) VALUES
(2, 2, 5, '{\"0\": 22, \"1\": 27, \"2\": 30, \"3\": 33}', '2025-02-12 07:34:01');
INSERT INTO `SessionAnswers` (`answer_id`, `session_id`, `user_id`, `answers_json`, `answered_at`) VALUES
(3, 4, 4, '{\"0\": 57, \"1\": 63, \"2\": 68, \"3\": 72, \"4\": 74}', '2025-02-12 07:38:52');
INSERT INTO `SessionAnswers` (`answer_id`, `session_id`, `user_id`, `answers_json`, `answered_at`) VALUES
(4, 8, 3, '{\"0\": 39, \"1\": 42, \"2\": 47, \"3\": 51, \"4\": 54}', '2025-02-12 08:46:52'),
(5, 8, 4, '{\"0\": 39, \"1\": 44, \"2\": 47, \"3\": 52, \"4\": 54}', '2025-02-12 08:46:52'),
(6, 9, 4, '{\"0\": 39, \"1\": 44, \"2\": 48, \"3\": 52, \"4\": 54}', '2025-02-12 09:13:37'),
(7, 9, 3, '{\"0\": 39, \"1\": 42, \"2\": 47, \"3\": 52, \"4\": 54}', '2025-02-12 09:13:38'),
(8, 7, 1, '{\"0\": 89, \"1\": 94, \"2\": 97, \"3\": 102}', '2025-02-12 09:16:33'),
(9, 2, 3, '{\"0\": 22, \"1\": 25, \"2\": 30, \"3\": 33}', '2025-02-12 09:18:52'),
(10, 5, 3, '{\"0\": 80, \"1\": 83, \"2\": 87}', '2025-02-12 10:10:17'),
(11, 5, 1, '{\"0\": 80, \"1\": 82, \"2\": 86}', '2025-02-12 10:12:57'),
(14, 13, 4, '{\"0\": 106, \"1\": 112, \"2\": 114}', '2025-02-12 16:56:06'),
(15, 13, 1, '{\"0\": 106, \"1\": 110, \"2\": 116}', '2025-02-12 16:56:06'),
(16, 2, 2, '{\"0\": 22, \"1\": 26, \"2\": 29, \"3\": 33}', '2025-02-12 17:04:11');

INSERT INTO `SessionPlayers` (`session_player_id`, `session_id`, `user_id`, `nickname`, `score`, `join_time`) VALUES
(2, 4, 3, 'phuongnga', 870, '2025-02-12 07:29:03');
INSERT INTO `SessionPlayers` (`session_player_id`, `session_id`, `user_id`, `nickname`, `score`, `join_time`) VALUES
(3, 2, 5, 'minhphat', 620, '2025-02-12 07:32:21');
INSERT INTO `SessionPlayers` (`session_player_id`, `session_id`, `user_id`, `nickname`, `score`, `join_time`) VALUES
(4, 4, 4, 'dpnguyen', 470, '2025-02-12 07:36:58');
INSERT INTO `SessionPlayers` (`session_player_id`, `session_id`, `user_id`, `nickname`, `score`, `join_time`) VALUES
(8, 9, 4, 'nguoiandanh', 340, '2025-02-12 09:11:02'),
(9, 9, 3, 'ngane', 670, '2025-02-12 09:11:31'),
(10, 7, 1, 'nnhgiang_s', 660, '2025-02-12 09:15:00'),
(11, 7, 3, 'phuongnga', 0, '2025-02-12 09:17:01'),
(12, 2, 3, 'phuongnga', 510, '2025-02-12 09:17:18'),
(13, 5, 3, 'phuongnga', 360, '2025-02-12 10:09:05'),
(14, 5, 1, 'nnhgiang_s', 180, '2025-02-12 10:11:45'),
(15, 4, 2, 'anthanh', 0, '2025-02-12 15:43:25'),
(18, 13, 1, 'huonggiang', 330, '2025-02-12 16:54:17'),
(19, 13, 4, 'phucnguyen', 170, '2025-02-12 16:54:38'),
(20, 2, 2, 'anthanh', 360, '2025-02-12 17:02:38');

INSERT INTO `Users` (`user_id`, `username`, `email`, `password`, `full_name`, `phone`, `avatar`, `created_at`) VALUES
(1, 'nnhgiang_s', 'huonggiang@gmail.com', '$2b$10$VK4LuzfHgK2uNCveyiMTlOF3TtlRXLXtHqWVLLpM5wzpitzZFFGda', 'Giang', '0123456789', 'https://res.cloudinary.com/dlrd3ngz5/image/upload/v1739340499/appquizfox/e3o7ixrkmc02emlctpra.jpg', '2025-02-12 05:55:46');
INSERT INTO `Users` (`user_id`, `username`, `email`, `password`, `full_name`, `phone`, `avatar`, `created_at`) VALUES
(2, 'anthanh', 'anthanh@gmail.com', '$2b$10$.Daw8FZZDekMD62mrSt2M.824WC4f7a53bytCmRU5KGg2UNXBFH1C', 'AnThanh', NULL, 'https://res.cloudinary.com/dlrd3ngz5/image/upload/v1738950300/kahoot_clone/bgu71soejmd8aniapnmy.jpg', '2025-02-12 06:43:36');
INSERT INTO `Users` (`user_id`, `username`, `email`, `password`, `full_name`, `phone`, `avatar`, `created_at`) VALUES
(3, 'phuongnga', 'phuongnga@gmail.com', '$2b$10$qcoyHo3RjirjpuZev2yfxOsN.5c0sR.3uK/qmGDq2gdzDiafV3f7e', 'Nga', NULL, 'https://res.cloudinary.com/dlrd3ngz5/image/upload/v1739344481/appquizfox/nvohwmnsfiiuchkjrv23.jpg', '2025-02-12 07:08:42');
INSERT INTO `Users` (`user_id`, `username`, `email`, `password`, `full_name`, `phone`, `avatar`, `created_at`) VALUES
(4, 'dpnguyen', 'dpnguyen@gmail.com', '$2b$10$7sznXUq1rPllUCfd7uxHpuRiuVLViBqrmw/zez/jnkn8z8NqqDw2a', 'dinh phuc nguyen', NULL, 'https://res.cloudinary.com/dlrd3ngz5/image/upload/v1738950300/kahoot_clone/bgu71soejmd8aniapnmy.jpg', '2025-02-12 07:27:03'),
(5, 'minhphat', 'minhphat@gmail.com', '$2b$10$lwcXSaw1wX/HCCFFu0KMJew5ucQSTklSssVQEPAUs9gMZcUKbyODG', 'minhphat', NULL, 'https://res.cloudinary.com/dlrd3ngz5/image/upload/v1738950300/kahoot_clone/bgu71soejmd8aniapnmy.jpg', '2025-02-12 07:32:03');


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;