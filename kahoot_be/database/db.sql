CREATE DATABASE IF NOT EXISTS `QuizApp`;

USE `QuizApp`;

CREATE TABLE `Users` (
    `user_id` INT AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(50) NOT NULL,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `full_name` VARCHAR(100),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE `Quizzes` (
    `quiz_id` INT AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(255) NOT NULL,
    `description` TEXT,
    `creator` VARCHAR(100) NOT NULL,
    `cover_image` TEXT,
    `visibility` ENUM('public', 'private') DEFAULT 'public',
    `category` VARCHAR(50),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE `Questions` (
    `question_id` INT AUTO_INCREMENT PRIMARY KEY,
    `quiz_id` INT NOT NULL,
    `question_text` TEXT NOT NULL,
    `question_type` ENUM('multiple_choice', 'true_false', 'open_ended', 'puzzle', 'poll') NOT NULL,
    `media_url` TEXT,
    `time_limit` INT DEFAULT 30,
    `points` INT DEFAULT 0,
    FOREIGN KEY (`quiz_id`) REFERENCES `Quizzes`(`quiz_id`)
);

CREATE TABLE `Options` (
    `option_id` INT AUTO_INCREMENT PRIMARY KEY,
    `question_id` INT NOT NULL,
    `option_text` TEXT NOT NULL,
    `is_correct` BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (`question_id`) REFERENCES `Questions`(`question_id`)
);

CREATE TABLE `GameSessions` (
    `session_id` INT AUTO_INCREMENT PRIMARY KEY,
    `quiz_id` INT NOT NULL,
    `pin` VARCHAR(10) UNIQUE NOT NULL,
    `status` ENUM('active', 'completed') DEFAULT 'active',
    `start_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `end_time` TIMESTAMP,
    `host` VARCHAR(100) NOT NULL,
    FOREIGN KEY (`quiz_id`) REFERENCES `Quizzes`(`quiz_id`)
);

CREATE TABLE `SessionPlayers` (
    `session_player_id` INT AUTO_INCREMENT PRIMARY KEY,
    `session_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `nickname` VARCHAR(50) NOT NULL,
    `score` INT DEFAULT 0,
    `join_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`session_id`) REFERENCES `GameSessions`(`session_id`),
    FOREIGN KEY (`user_id`) REFERENCES `Users`(`user_id`)
);

CREATE TABLE `SessionAnswers` (
    `answer_id` INT AUTO_INCREMENT PRIMARY KEY,
    `session_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `question_id` INT NOT NULL,
    `selected_option` INT,
    `is_correct` BOOLEAN,
    `answered_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`session_id`) REFERENCES `GameSessions`(`session_id`),
    FOREIGN KEY (`user_id`) REFERENCES `Users`(`user_id`),
    FOREIGN KEY (`question_id`) REFERENCES `Questions`(`question_id`)
);

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

CREATE TABLE `Subscriptions` (
    `subscription_id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `description` TEXT,
    `price` DECIMAL(10, 2) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE `Payments` (
    `payment_id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `subscription_id` INT NOT NULL,
    `payment_method` VARCHAR(50) NOT NULL,
    `status` ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    `amount` DECIMAL(10, 2) NOT NULL,
    `payment_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `Users`(`user_id`),
    FOREIGN KEY (`subscription_id`) REFERENCES `Subscriptions`(`subscription_id`)
);

INSERT INTO `Quizzes` (`title`, `description`, `creator`, `cover_image`, `visibility`, `category`)
VALUES
('General Knowledge Quiz', 'A quiz to test your general knowledge on various topics.', 'John Doe', 'image1.jpg', 'public', 'General Knowledge'),
('Math Quiz', 'A quiz focused on mathematics problems and theories.', 'Jane Smith', 'image2.jpg', 'private', 'Mathematics'),
('Science Quiz', 'A challenging quiz to test your science knowledge.', 'Mike Johnson', 'image3.jpg', 'public', 'Science');
