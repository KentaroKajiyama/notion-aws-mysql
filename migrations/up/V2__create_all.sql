DROP TABLE IF EXISTS `rests`;
DROP TABLE IF EXISTS `student_subfield_traces`;
DROP TABLE IF EXISTS `trackers`;
DROP TABLE IF EXISTS `student_subject_information`;
DROP TABLE IF EXISTS `problem_options`;
DROP TABLE IF EXISTS `student_problems`;
DROP TABLE IF EXISTS `problems`;
DROP TABLE IF EXISTS `actual_blocks`;
DROP TABLE IF EXISTS `default_blocks`;
DROP TABLE IF EXISTS `subfields`;
DROP TABLE IF EXISTS `subjects`;
DROP TABLE IF EXISTS `students`;
DROP TABLE IF EXISTS `property_options`;
DROP TABLE IF EXISTS `notion_db_properties`;

CREATE TABLE `notion_db_properties` (
  `program_name` varchar(50) NOT NULL,
  `notion_db_property_id` int unsigned NOT NULL AUTO_INCREMENT,
  `db_name` varchar(50) NOT NULL,
  `property_name` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `property_type` enum('title','rich_text','number','select','multi_select','date','formula','relation','rollup','people','files','checkbox','url','email','phone_number','created_time','created_by','last_edited_time','last_edited_by','status','unique_id','verification') NOT NULL,
  PRIMARY KEY (`notion_db_property_id`),
  UNIQUE KEY `property_name` (`property_name`,`db_name`)
) ENGINE=InnoDB;



CREATE TABLE `property_options` (
  `notion_db_property_id` int unsigned NOT NULL,
  `option_value` varchar(50) NOT NULL,
  `option_key` varchar(50) NOT NULL,
  `property_option_id` int unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`property_option_id`),
  KEY `notion_db_property_id` (`notion_db_property_id`),
  CONSTRAINT `property_options_ibfk_1` FOREIGN KEY (`notion_db_property_id`) REFERENCES `notion_db_properties` (`notion_db_property_id`)
) ENGINE=InnoDB;



CREATE TABLE `students` (
  `student_id` int unsigned NOT NULL AUTO_INCREMENT,
  `student_notion_user_id` varchar(50) DEFAULT NULL,
  `student_name` varchar(50) NOT NULL,
  `parent_name` varchar(50) DEFAULT NULL,
  `exam_date` date DEFAULT NULL,
  `parent_phone_number` varchar(10) DEFAULT NULL,
  `student_only_page_id` varchar(50) DEFAULT NULL,
  `student_overview_page_id` varchar(50) DEFAULT NULL,
  `todo_db_id` varchar(50) DEFAULT NULL,
  `wrong_db_id` varchar(50) DEFAULT NULL,
  `is_difficult_db_id` varchar(50) DEFAULT NULL,
  `remaining_db_id` varchar(50) DEFAULT NULL,
  `student_schedule_db_id` varchar(50) DEFAULT NULL,
  `necessary_study_time_db_id` varchar(50) DEFAULT NULL,
  `todo_counter_db_id` varchar(50) DEFAULT NULL,
  `coach_plan_db_id` varchar(50) DEFAULT NULL,
  `student_detail_info_db_id` varchar(50) DEFAULT NULL,
  `coach_irregular_db_id` varchar(50) DEFAULT NULL,
  `coach_rest_db_id` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `goal_description` varchar(50) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `parent_email` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`student_id`)
) ENGINE=InnoDB;


CREATE TABLE `subjects` (
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `subject_name` ENUM('国語','数学','英語','物理','化学','生物','日本史','世界史','地理') NOT NULL,
  `subject_id` int unsigned NOT NULL AUTO_INCREMENT,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`subject_id`),
  UNIQUE KEY `subject_name` (`subject_name`)
) ENGINE=InnoDB;


CREATE TABLE `subfields` (
  `subfield_name` ENUM('現代文','古文','漢文','数学','Reading','Listening&Speaking','Writing','物理','化学','生物','日本史','世界史','地理') NOT NULL,
  `subfield_id` int unsigned NOT NULL AUTO_INCREMENT,
  `subject_id` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`subfield_id`),
  UNIQUE KEY `subfield_name` (`subfield_name`),
  KEY `subject_id` (`subject_id`),
  CONSTRAINT `subfields_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`subject_id`)
) ENGINE=InnoDB;


CREATE TABLE `default_blocks` (
  `subfield_id` int unsigned NOT NULL,
  `default_block_id` int unsigned NOT NULL AUTO_INCREMENT,
  `block_name` varchar(50) NOT NULL,
  `space` int unsigned NOT NULL,
  `notion_page_id` varchar(50) DEFAULT NULL,
  `lap` int unsigned NOT NULL,
  `is_tail` tinyint NOT NULL,
  `block_order` int unsigned NOT NULL,
  `speed` int unsigned NOT NULL,
  `average_expected_time` int unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `block_size` int unsigned NOT NULL,
  `problem_level` ENUM('基礎１','基礎２','基礎３')  NOT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`default_block_id`),
  KEY `subfield_id` (`subfield_id`),
  CONSTRAINT `default_blocks_ibfk_1` FOREIGN KEY (`subfield_id`) REFERENCES `subfields` (`subfield_id`)
) ENGINE=InnoDB;


CREATE TABLE `actual_blocks` (
  `actual_block_id` int unsigned NOT NULL AUTO_INCREMENT,
  `default_block_id` int unsigned DEFAULT NULL,
  `student_id` int unsigned NOT NULL,
  `subfield_id` int unsigned NOT NULL,
  `student_schedule_notion_page_id` varchar(50) DEFAULT NULL,
  `coach_plan_notion_page_id` varchar(50) DEFAULT NULL,
  `student_actual_block_db_notion_page_id` varchar(50) DEFAULT NULL,
  `problem_level` ENUM('基礎１','基礎２','基礎３') NOT NULL,
  `actual_block_size` int unsigned NOT NULL,
  `block_order` int unsigned NOT NULL,
  `end_date` date DEFAULT NULL,
  `is_tail` tinyint NOT NULL,
  `lap` int unsigned NOT NULL,
  `speed` int unsigned NOT NULL,
  `start_date` date DEFAULT NULL,
  `space` int unsigned NOT NULL,
  `actual_block_name` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`actual_block_id`),
  UNIQUE KEY `student_schedule_notion_page_id` (`student_schedule_notion_page_id`),
  UNIQUE KEY `coach_plan_notion_page_id` (`coach_plan_notion_page_id`),
  UNIQUE KEY `student_actual_block_db_notion_page_id` (`student_actual_block_db_notion_page_id`),
  KEY `default_block_id` (`default_block_id`),
  KEY `student_id` (`student_id`),
  KEY `subfield_id` (`subfield_id`),
  CONSTRAINT `actual_blocks_ibfk_1` FOREIGN KEY (`default_block_id`) REFERENCES `default_blocks` (`default_block_id`),
  CONSTRAINT `actual_blocks_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`),
  CONSTRAINT `actual_blocks_ibfk_3` FOREIGN KEY (`subfield_id`) REFERENCES `subfields` (`subfield_id`)
) ENGINE=InnoDB;


CREATE TABLE `problems` (
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `problem_level` ENUM('基礎１','基礎２','基礎３') NOT NULL,
  `answer` varchar(510) NOT NULL DEFAULT '',
  `problem_name` varchar(50) NOT NULL DEFAULT '',
  `default_block_id` int unsigned DEFAULT NULL,
  `problem_id` int unsigned NOT NULL AUTO_INCREMENT,
  `subfield_id` int unsigned DEFAULT NULL,
  `notion_page_id` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`problem_id`),
  KEY `default_block_id` (`default_block_id`),
  KEY `subfield_id` (`subfield_id`),
  CONSTRAINT `problems_ibfk_1` FOREIGN KEY (`default_block_id`) REFERENCES `default_blocks` (`default_block_id`),
  CONSTRAINT `problems_ibfk_2` FOREIGN KEY (`subfield_id`) REFERENCES `subfields` (`subfield_id`)
) ENGINE=InnoDB;


CREATE TABLE `student_problems` (
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_answered_date` date DEFAULT NULL,
  `problem_in_block_order` int unsigned NOT NULL,
  `problem_overall_order` int unsigned NOT NULL,
  `review_available_date` date DEFAULT NULL,
  `difficult_count` int unsigned DEFAULT '0',
  `review_count_down` int unsigned DEFAULT NULL,
  `review_level` ENUM('初学','レベル１','レベル２','レベル３','レベル４') NOT NULL,
  `try_count` int unsigned DEFAULT '0',
  `wrong_count` int unsigned DEFAULT '0',
  `notion_page_id` varchar(50) DEFAULT NULL,
  `is_difficult` tinyint DEFAULT '0',
  `answer_status` ENUM('未回答','不正解','正解') NOT NULL,
  `actual_block_id` int unsigned NOT NULL,
  `student_problem_id` int unsigned NOT NULL AUTO_INCREMENT,
  `problem_id` int unsigned NOT NULL,
  `student_id` int unsigned NOT NULL,
  PRIMARY KEY (`student_problem_id`),
  UNIQUE KEY `actual_block_id` (`actual_block_id`,`problem_in_block_order`),
  KEY `problem_id` (`problem_id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `student_problems_ibfk_1` FOREIGN KEY (`actual_block_id`) REFERENCES `actual_blocks` (`actual_block_id`),
  CONSTRAINT `student_problems_ibfk_2` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`problem_id`),
  CONSTRAINT `student_problems_ibfk_3` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`)
) ENGINE=InnoDB;


CREATE TABLE `problem_options` (
  `problem_option_id` int unsigned NOT NULL AUTO_INCREMENT,
  `problem_id` int unsigned NOT NULL,
  `notion_db_property_id` int unsigned NOT NULL,
  `option_value` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`problem_option_id`),
  KEY `problem_id` (`problem_id`),
  KEY `notion_db_property_id` (`notion_db_property_id`),
  CONSTRAINT `problem_options_ibfk_1` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`problem_id`),
  CONSTRAINT `problem_options_ibfk_2` FOREIGN KEY (`notion_db_property_id`) REFERENCES `notion_db_properties` (`notion_db_property_id`)
) ENGINE=InnoDB;


CREATE TABLE `student_subject_information` (
  `student_subject_information_id` int unsigned NOT NULL AUTO_INCREMENT,
  `subject_level` ENUM('基礎１','基礎２','基礎３') NOT NULL,
  `student_id` int unsigned NOT NULL,
  `subject_id` int unsigned NOT NULL,
  `goal_level` decimal(3,1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `goal_description` varchar(50) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`student_subject_information_id`),
  KEY `student_id` (`student_id`),
  KEY `subject_id` (`subject_id`),
  CONSTRAINT `student_subject_information_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`),
  CONSTRAINT `student_subject_information_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`subject_id`)
) ENGINE=InnoDB;


CREATE TABLE `trackers` (
  `subfield_id` int unsigned NOT NULL,
  `student_id` int unsigned NOT NULL,
  `tracker_id` int unsigned NOT NULL AUTO_INCREMENT,
  `student_problem_id` int unsigned NOT NULL,
  `actual_block_id` int unsigned NOT NULL,
  `remaining_space` int unsigned NOT NULL DEFAULT '0',
  `is_enabled` tinyint NOT NULL DEFAULT '0',
  `current_lap` int unsigned NOT NULL DEFAULT '0',
  `is_rest` tinyint NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`tracker_id`),
  KEY `subfield_id` (`subfield_id`),
  KEY `student_id` (`student_id`),
  KEY `student_problem_id` (`student_problem_id`),
  KEY `actual_block_id` (`actual_block_id`),
  CONSTRAINT `trackers_ibfk_1` FOREIGN KEY (`subfield_id`) REFERENCES `subfields` (`subfield_id`),
  CONSTRAINT `trackers_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`),
  CONSTRAINT `trackers_ibfk_3` FOREIGN KEY (`student_problem_id`) REFERENCES `student_problems` (`student_problem_id`),
  CONSTRAINT `trackers_ibfk_4` FOREIGN KEY (`actual_block_id`) REFERENCES `actual_blocks` (`actual_block_id`)
) ENGINE=InnoDB;


CREATE TABLE `student_subfield_traces` (
  `subfield_id` int unsigned NOT NULL,
  `trace_id` int unsigned NOT NULL AUTO_INCREMENT,
  `student_id` int unsigned NOT NULL,
  `todo_counter_notion_page_id` varchar(50) DEFAULT NULL,
  `todo_counter` int unsigned DEFAULT NULL,
  `remaining_day` int unsigned DEFAULT NULL,
  `target_date` date DEFAULT NULL,
  `remaining_day_notion_page_id` varchar(50) DEFAULT NULL,
  `actual_end_date` date DEFAULT NULL,
  `notion_problems_db_id` varchar(50) DEFAULT NULL,
  `delay` int NOT NULL DEFAULT '0',
  `exam_date` date DEFAULT NULL,
  `review_speed` int unsigned NOT NULL DEFAULT '0',
  `review_space` int unsigned NOT NULL DEFAULT '0',
  `review_remaining_space` int unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `review_alert` int unsigned NOT NULL DEFAULT '50',
  PRIMARY KEY (`trace_id`),
  UNIQUE KEY `student_id` (`student_id`,`subfield_id`),
  KEY `subfield_id` (`subfield_id`),
  CONSTRAINT `student_subfield_traces_ibfk_1` FOREIGN KEY (`subfield_id`) REFERENCES `subfields` (`subfield_id`),
  CONSTRAINT `student_subfield_traces_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`)
) ENGINE=InnoDB;


CREATE TABLE `rests` (
  `notion_page_id` varchar(50) NOT NULL,
  `subfield_id` int unsigned NOT NULL,
  `student_id` int unsigned NOT NULL,
  `rest_id` int unsigned NOT NULL AUTO_INCREMENT,
  `rest_name` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `end_date` date NOT NULL,
  `start_date` date NOT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`rest_id`),
  KEY `subfield_id` (`subfield_id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `rests_ibfk_1` FOREIGN KEY (`subfield_id`) REFERENCES `subfields` (`subfield_id`),
  CONSTRAINT `rests_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`)
) ENGINE=InnoDB;



