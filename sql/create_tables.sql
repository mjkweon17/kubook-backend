CREATE TABLE `user` (
	`id`    INT	NOT NULL    AUTO_INCREMENT,
	`auth_id`	VARCHAR(50)	NOT NULL,
	`user_name`	VARCHAR(45)	NOT NULL,
	`is_active`	BOOLEAN NOT NULL	DEFAULT TRUE,
	`email`	VARCHAR(100)	NOT NULL,
	`created_at`	DATETIME	NOT NULL	DEFAULT CURRENT_TIMESTAMP,
	`updated_at`	DATETIME	NOT NULL	DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`is_valid`	BOOLEAN	NOT NULL	DEFAULT FALSE,
    PRIMARY KEY (`id`),
    UNIQUE KEY `auth_id` (`auth_id`),
    UNIQUE KEY `email` (`email`)
);

CREATE TABLE `requested_book` (
	`id`	INT	NOT NULL    AUTO_INCREMENT,
	`user_id`	INT	NOT NULL,
	`book_title`	VARCHAR(255)	NOT NULL,
	`author`	VARCHAR(255)	NULL,
	`publication_year`	YEAR	NULL,
	`publisher`	VARCHAR(255)	NULL,
	`request_link`	VARCHAR(100)	NOT NULL,
	`reason`	TEXT	NOT NULL,
	`processing_status`	TINYINT	NOT NULL	DEFAULT 0,
	`request_date`	DATE	NOT NULL,
	`created_at`	DATETIME	NOT NULL	DEFAULT CURRENT_TIMESTAMP,
	`updated_at`	DATETIME	NOT NULL	DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`is_valid`	BOOLEAN	NOT NULL	DEFAULT FALSE,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`)
);

CREATE TABLE `admin` (
	`id`	INT	NOT NULL    AUTO_INCREMENT,
	`user_id`	INT	NOT NULL,
	`admin_status`	BOOLEAN	NOT NULL	DEFAULT FALSE,
	`created_at`	DATETIME	NOT NULL	DEFAULT CURRENT_TIMESTAMP,
	`updated_at`	DATETIME	NOT NULL	DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `is_valid`	BOOLEAN	NOT NULL	DEFAULT FALSE,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`)
);

CREATE TABLE `notice` (
	`id`	INT	NOT NULL    AUTO_INCREMENT,
	`admin_id`	INT	NOT NULL,
	`user_id`	INT	NULL,
	`title`	VARCHAR(255)	NOT NULL,
	`notice_content`	TEXT	NOT NULL,
	`created_at`	DATETIME	NOT NULL	DEFAULT CURRENT_TIMESTAMP,
	`updated_at`	DATETIME	NOT NULL	DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`is_valid`	BOOLEAN	NOT NULL	DEFAULT FALSE,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`admin_id`) REFERENCES `admin`(`id`)
);

CREATE TABLE `notification_category` (
	`id`	INT	NOT NULL    AUTO_INCREMENT,
	`name`	VARCHAR(100)	NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `notification` (
	`id`	INT	NOT NULL    AUTO_INCREMENT,
	`user_id`	INT	NOT NULL,
	`notification_category_id`	INT	NOT NULL,
	`content`	TEXT	NOT NULL,
    `created_at`	DATETIME	NOT NULL	DEFAULT CURRENT_TIMESTAMP,
    `is_valid`	BOOLEAN	NOT NULL	DEFAULT FALSE,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`),
    FOREIGN KEY (`notification_category_id`) REFERENCES `notification_category`(`id`)
);

CREATE TABLE `book_category` (
	`id`	INT	NOT NULL    AUTO_INCREMENT,
	`code`	VARCHAR(5)	NOT NULL,
	`name`	VARCHAR(50)	NOT NULL,
	`is_valid`	BOOLEAN	NOT NULL	DEFAULT FALSE,
    PRIMARY KEY (`id`)
);

CREATE TABLE `book_info` (
	`id`	INT	NOT NULL    AUTO_INCREMENT,
	`title`	VARCHAR(255)	NOT NULL,
	`subtitle`	VARCHAR(255)	NULL,
	`author`	VARCHAR(100)	NOT NULL,
	`publisher`	VARCHAR(45)	NOT NULL,
	`publication_year`	YEAR	NOT NULL,
	`image_url`	VARCHAR(255)	NULL,
	`category_id`	INT	NOT NULL,
	`copied`	VARCHAR(100)	NULL,
	`version`	VARCHAR(45)	NULL,
	`major`	BOOLEAN	NULL	DEFAULT FALSE,
	`language`	VARCHAR(10)	NOT NULL	DEFAULT "한국어",
	`is_valid`	BOOLEAN	NOT NULL	DEFAULT 0,
	`created_at`	DATETIME	NOT NULL	DEFAULT CURRENT_TIMESTAMP,
	`updated_at`	DATETIME	NOT NULL	DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`category_id`) REFERENCES `book_category`(`id`)
);

CREATE TABLE `book_stat` (
	`id`	INT	NOT NULL    AUTO_INCREMENT,
	`book_info_id`	INT	NOT NULL,
	`average_rating`	DECIMAL(3,2)    NULL	DEFAULT NULL,
	`review_count`	INT	NOT NULL	DEFAULT 0,
	`loan_count`	INT	NOT NULL	DEFAULT 0,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`book_info_id`) REFERENCES `book_info`(`id`)
);

CREATE TABLE `book_review` (
	`id`	INT	NOT NULL    AUTO_INCREMENT,
	`user_id`	INT	NOT NULL,
	`book_info_id`	INT	NOT NULL,
	`review_content`    TEXT	NOT NULL,
	`rating`	INT	NOT NULL,
	`is_valid`	BOOLEAN	NOT NULL	DEFAULT FALSE,
	`created_at`	DATETIME	NOT NULL	DEFAULT CURRENT_TIMESTAMP,
	`updated_at`	DATETIME	NOT NULL	DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`),
    FOREIGN KEY (`book_info_id`) REFERENCES `book_info`(`id`)
);

CREATE TABLE `book` (
	`id`	INT	NOT NULL    AUTO_INCREMENT,
	`book_info_id`	INT	NOT NULL,
	`book_status`	BOOLEAN	NOT NULL    DEFAULT TRUE,
	`note`	VARCHAR(255)	NULL	DEFAULT NULL,
	`created_at`	DATETIME	NOT NULL	DEFAULT CURRENT_TIMESTAMP,
	`updated_at`	DATETIME	NOT NULL	DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`is_valid`	BOOLEAN	NOT NULL	DEFAULT FALSE,
	`donor_name`	VARCHAR(255)	NULL	DEFAULT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`book_info_id`) REFERENCES `book_info`(`id`)
);

CREATE TABLE `reservation` (
	`id`	INT	NOT NULL    AUTO_INCREMENT,
	`book_id`	INT	NOT NULL,
	`user_id`	INT	NOT NULL,
	`reservation_date`	DATETIME	NOT NULL	DEFAULT CURRENT_TIMESTAMP,
	`reservation_status`	TINYINT	NOT NULL,
	`created_at`	DATETIME	NOT NULL	DEFAULT CURRENT_TIMESTAMP,
	`updated_at`	DATETIME	NOT NULL	DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`book_id`) REFERENCES `book`(`id`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`)
);

CREATE TABLE `loan` (
	`id`	INT	NOT NULL    AUTO_INCREMENT,
	`book_id`	INT	NOT NULL,
	`user_id`	INT	NOT NULL,
	`loan_date`	DATE	NOT NULL,
	`extend_status`	BOOLEAN	NOT NULL	DEFAULT FALSE,
	`expected_return_date`	DATE	NOT NULL,
	`return_status`	BOOLEAN	NOT NULL	DEFAULT FALSE,
	`return_date`	DATE    NULL,
	`created_at`	DATETIME	NOT NULL	DEFAULT CURRENT_TIMESTAMP,
	`updated_at`	DATETIME	NOT NULL	DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`book_id`) REFERENCES `book`(`id`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`)
);

CREATE TABLE `service_setting` (
	`id`	INT	NOT NULL    AUTO_INCREMENT,
	`service_begin`	DATETIME	NOT NULL,
	`service_end`	DATETIME	NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `loan_setting` (
	`id`	INT	NOT NULL    AUTO_INCREMENT,
	`max_loan_count`	INT	NOT NULL,
	`loan_period`	INT	NOT NULL,
	`extend_period`	INT	NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `request_setting` (
	`id`	INT	NOT NULL    AUTO_INCREMENT,
	`max_request_count` INT	NOT NULL,
	`max_request_price`	INT	NOT NULL,
    PRIMARY KEY (`id`)
);