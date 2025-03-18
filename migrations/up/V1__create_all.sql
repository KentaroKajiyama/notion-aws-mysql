CREATE TABLE `notion_db_properties` (
  `program_name` VARCHAR(50) NOT NULL,
  `notion_db_property_id` INT UNSIGNED AUTO_INCREMENT,
  `db_name` VARCHAR(50) NOT NULL,
  `property_name` VARCHAR(50) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `property_type` ENUM('UNKNOWN') NOT NULL,
  PRIMARY KEY (`notion_db_property_id`),
  UNIQUE (`property_type`),
  UNIQUE (`'property_name'`, `'db_name'`),
  UNIQUE (`'property_name'`, `'db_name'`)
) ENGINE=InnoDB;

CREATE TABLE `property_options` (
  `notion_db_property_id` INT UNSIGNED NOT NULL,
  `option_value` VARCHAR(50) NOT NULL,
  `option_key` VARCHAR(50) NOT NULL,
  `property_option_id` INT UNSIGNED AUTO_INCREMENT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`property_option_id`),
  FOREIGN KEY (`notion_db_property_id`) REFERENCES `notion_db_properties`(`notion_db_property_id`)
) ENGINE=InnoDB;

CREATE TABLE `students` (
  `student_id` INT UNSIGNED AUTO_INCREMENT,
  `student_notion_user_id` VARCHAR(50),
  `student_name` VARCHAR(50) NOT NULL,
  `parent_name` VARCHAR(50),
  `exam_date` DATE,
  `parent_phone_number` VARCHAR(10),
  `student_only_page_id` VARCHAR(50),
  `student_overview_page_id` VARCHAR(50),
  `todo_db_id` VARCHAR(50),
  `wrong_db_id` VARCHAR(50),
  `is_difficult_db_id` VARCHAR(50),
  `remaining_db_id` VARCHAR(50),
  `student_only_plan_db_id` VARCHAR(50),
  `coach_page_id` VARCHAR(50),
  `student_progress_db_id` VARCHAR(50),
  `coach_plan_db_id` VARCHAR(50),
  `student_detail_info_db_id` VARCHAR(50),
  `coach_irregular_db_id` VARCHAR(50),
  `coach_record_db_id` VARCHAR(50),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `goal_description` VARCHAR(50),
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`student_id`)
) ENGINE=InnoDB;

CREATE TABLE `subjects` (
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `subject_name` ENUM('国語','数学','英語','物理','化学','生物','日本史','世界史','地理') NOT NULL,
  `subject_id` INT UNSIGNED AUTO_INCREMENT,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`subject_id`),
  UNIQUE (`subject_name`)
) ENGINE=InnoDB;

CREATE TABLE `subfields` (
  `subfield_name` ENUM('現代文','古文','漢文','数学','Reading','Listening&Speaking','Writing','物理','化学','生物','日本史','世界史','地理') NOT NULL,
  `subfield_id` INT UNSIGNED AUTO_INCREMENT,
  `subject_id` INT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`subfield_id`),
  FOREIGN KEY (`subject_id`) REFERENCES `subjects`(`subject_id`),
  UNIQUE (`subfield_name`)
) ENGINE=InnoDB;

CREATE TABLE `default_blocks` (
  `subfield_id` INT UNSIGNED NOT NULL,
  `default_block_id` INT UNSIGNED AUTO_INCREMENT,
  `block_name` VARCHAR(50) NOT NULL,
  `space` INT UNSIGNED NOT NULL,
  `notion_page_id` VARCHAR(50),
  `lap` INT UNSIGNED NOT NULL,
  `is_tail` TINYINT NOT NULL,
  `block_order` INT UNSIGNED NOT NULL,
  `speed` INT UNSIGNED NOT NULL,
  `average_expected_time` INT UNSIGNED ,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `block_size` INT UNSIGNED NOT NULL,
  `problem_level` ENUM('基礎１','基礎２','基礎３') NOT NULL,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`default_block_id`),
  FOREIGN KEY (`subfield_id`) REFERENCES `subfields`(`subfield_id`)
) ENGINE=InnoDB;

CREATE TABLE `actual_blocks` (
  `actual_block_id` INT UNSIGNED AUTO_INCREMENT,
  `default_block_id` INT UNSIGNED,
  `student_id` INT UNSIGNED NOT NULL,
  `subfield_id` INT UNSIGNED NOT NULL,
  `student_schedule_notion_page_id` VARCHAR(50),
  `coach_plan_notion_page_id` VARCHAR(50),
  `student_actual_block_db_notion_page_id` VARCHAR(50),
  `problem_level` ENUM('基礎１','基礎２','基礎３') NOT NULL,
  `actual_block_size` INT UNSIGNED NOT NULL,
  `block_order` INT UNSIGNED NOT NULL,
  `end_date` DATE,
  `is_tail` TINYINT NOT NULL,
  `lap` INT UNSIGNED NOT NULL,
  `speed` INT UNSIGNED NOT NULL,
  `start_date` DATE,
  `space` INT UNSIGNED NOT NULL,
  `actual_block_name` VARCHAR(50) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`actual_block_id`),
  FOREIGN KEY (`default_block_id`) REFERENCES `default_blocks`(`default_block_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`),
  FOREIGN KEY (`subfield_id`) REFERENCES `subfields`(`subfield_id`),
  UNIQUE (`student_schedule_notion_page_id`),
  UNIQUE (`coach_plan_notion_page_id`),
  UNIQUE (`student_actual_block_db_notion_page_id`)
) ENGINE=InnoDB;

CREATE TABLE `problems` (
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `problem_level` ENUM('基礎１','基礎２','基礎３') NOT NULL,
  `answer` VARCHAR(510) NOT NULL DEFAULT "",
  `problem_name` VARCHAR(50) NOT NULL DEFAULT "",
  `default_block_id` INT UNSIGNED,
  `problem_id` INT UNSIGNED AUTO_INCREMENT,
  `subfield_id` INT UNSIGNED,
  `notion_page_id` VARCHAR(50),
  PRIMARY KEY (`problem_id`),
  FOREIGN KEY (`default_block_id`) REFERENCES `default_blocks`(`default_block_id`),
  FOREIGN KEY (`subfield_id`) REFERENCES `subfields`(`subfield_id`)
) ENGINE=InnoDB;

CREATE TABLE `student_problems` (
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_answered_date` DATE,
  `problem_in_block_order` INT UNSIGNED NOT NULL,
  `problem_overall_order` INT UNSIGNED NOT NULL,
  `review_available_date` DATE,
  `difficult_count` INT UNSIGNED DEFAULT 0,
  `review_count_down` INT UNSIGNED,
  `review_level` ENUM('初学','レベル１','レベル２','レベル３','レベル４') NOT NULL,
  `try_count` INT UNSIGNED DEFAULT 0,
  `wrong_count` INT UNSIGNED DEFAULT 0,
  `notion_page_id` VARCHAR(50),
  `is_difficult` TINYINT DEFAULT 0,
  `answer_status` ENUM('未回答','不正解','正解') NOT NULL,
  `actual_block_id` INT UNSIGNED NOT NULL,
  `student_problem_id` INT UNSIGNED AUTO_INCREMENT,
  `problem_id` INT UNSIGNED NOT NULL,
  `student_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`student_problem_id`),
  FOREIGN KEY (`actual_block_id`) REFERENCES `actual_blocks`(`actual_block_id`),
  FOREIGN KEY (`problem_id`) REFERENCES `problems`(`problem_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`),
  UNIQUE (`actual_block_id`, `problem_in_block_order`)
) ENGINE=InnoDB;

CREATE TABLE `problem_options` (
  `problem_option_id` INT UNSIGNED,
  `problem_id` INT UNSIGNED NOT NULL,
  `notion_db_property_id` INT UNSIGNED NOT NULL,
  `option_value` VARCHAR(50),
  `created_at` TIMESTAMP,
  `updated_at` TIMESTAMP,
  PRIMARY KEY (`problem_option_id`),
  FOREIGN KEY (`problem_id`) REFERENCES `problems`(`problem_id`),
  FOREIGN KEY (`notion_db_property_id`) REFERENCES `notion_db_properties`(`notion_db_property_id`)
) ENGINE=InnoDB;

CREATE TABLE `student_subject_information` (
  `student_subject_information_id` INT UNSIGNED AUTO_INCREMENT,
  `subject_level` ENUM('基礎１','基礎２','基礎３') NOT NULL,
  `student_id` INT UNSIGNED NOT NULL,
  `subject_id` INT UNSIGNED NOT NULL,
  `goal_level` VARCHAR(50),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `goal_description` VARCHAR(50),
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`student_subject_information_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`),
  FOREIGN KEY (`subject_id`) REFERENCES `subjects`(`subject_id`)
) ENGINE=InnoDB;

CREATE TABLE `trackers` (
  `subfield_id` INT UNSIGNED NOT NULL,
  `student_id` INT UNSIGNED NOT NULL,
  `tracker_id` INT UNSIGNED AUTO_INCREMENT,
  `student_problem_id` INT UNSIGNED NOT NULL,
  `actual_block_id` INT UNSIGNED NOT NULL,
  `remaining_space` INT UNSIGNED NOT NULL DEFAULT 0 NOT NULL,
  `is_enabled` TINYINT NOT NULL DEFAULT 0 NOT NULL,
  `current_lap` INT UNSIGNED NOT NULL DEFAULT 0 NOT NULL,
  `is_rest` TINYINT NOT NULL DEFAULT 0 NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`tracker_id`),
  FOREIGN KEY (`subfield_id`) REFERENCES `subfields`(`subfield_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`),
  FOREIGN KEY (`student_problem_id`) REFERENCES `student_problems`(`student_problem_id`),
  FOREIGN KEY (`actual_block_id`) REFERENCES `actual_blocks`(`actual_block_id`)
) ENGINE=InnoDB;

CREATE TABLE `student_subfield_traces` (
  `subfield_id` INT UNSIGNED NOT NULL,
  `trace_id` INT UNSIGNED AUTO_INCREMENT,
  `student_id` INT UNSIGNED NOT NULL,
  `todo_remaining_counter_notion_page_id` VARCHAR(50),
  `todo_remaining_counter` INT UNSIGNED,
  `remaining_day` INT UNSIGNED,
  `target_date` DATE,
  `remaining_day_notion_page_id` VARCHAR(50),
  `actual_end_date` DATE,
  `notion_problems_db_id` VARCHAR(50),
  `delay` INT NOT NULL DEFAULT 0,
  `exam_date` DATE,
  `review_speed` INT UNSIGNED NOT NULL DEFAULT 0,
  `review_space` INT UNSIGNED NOT NULL DEFAULT 0,
  `review_remaining_space` INT UNSIGNED NOT NULL DEFAULT 0,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `review_alert` INT UNSIGNED NOT NULL DEFAULT 50,
  PRIMARY KEY (`trace_id`),
  FOREIGN KEY (`subfield_id`) REFERENCES `subfields`(`subfield_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`),
  UNIQUE (`studen_id`, `subfield_id`),
  UNIQUE (`student_id`, `subfield_id`)
) ENGINE=InnoDB;

CREATE TABLE `rests` (
  `notion_page_id` VARCHAR(50) NOT NULL,
  `subfield_id` INT UNSIGNED NOT NULL,
  `student_id` INT UNSIGNED NOT NULL,
  `rest_id` INT UNSIGNED AUTO_INCREMENT,
  `rest_name` VARCHAR(50) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `end_date` DATE NOT NULL,
  `start_date` DATE NOT NULL,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`rest_id`),
  FOREIGN KEY (`subfield_id`) REFERENCES `subfields`(`subfield_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`)
) ENGINE=InnoDB;
