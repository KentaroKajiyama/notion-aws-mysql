CREATE TABLE `students` (
  `student_id` INT UNSIGNED,
  `student_name` VARCHAR(50) NOT NULL,
  `parent_name` VARCHAR(50),
  `parent_phone_number` VARCHAR(10),
  `exam_date` DATE,
  `student_page` VARCHAR(50),
  `todo_db` VARCHAR(50),
  `remaining_db` VARCHAR(50),
  `wrong_db` VARCHAR(50),
  `difficult_db` VARCHAR(50),
  `student_progress_db` VARCHAR(50),
  `student_only_plan_db` VARCHAR(50),
  `coach_page` VARCHAR(50),
  `coach_record_db` VARCHAR(50),
  `coach_plan_db` VARCHAR(50),
  `coach_student_db` VARCHAR(50),
  `goal_description` VARCHAR(50),
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`student_id`)
);

CREATE TABLE `subjects` (
  `subject_id` INT UNSIGNED,
  `subject_name` VARCHAR(50) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`subject_id`)
);

CREATE TABLE `subfields` (
  `subfield_id` INT UNSIGNED,
  `subject_id` INT UNSIGNED NOT NULL,
  `subfield_name` VARCHAR(50) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`subfield_id`),
  FOREIGN KEY (`subject_id`) REFERENCES `subjects`(`subject_id`)
);

CREATE TABLE `default_blocks` (
  `default_block_id` INT UNSIGNED,
  `subfield_id` INT UNSIGNED NOT NULL,
  `block_name` VARCHAR(50) NOT NULL,
  `block_order` INT UNSIGNED NOT NULL,
  `space` INT NOT NULL DEFAULT 0,
  `speed` INT UNSIGNED NOT NULL DEFAULT 1,
  `size` INT UNSIGNED NOT NULL,
  `average_expected_time` INT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`default_block_id`),
  FOREIGN KEY (`subfield_id`) REFERENCES `subfields`(`subfield_id`)
);

CREATE TABLE `actual_blocks` (
  `actual_block_id` INT UNSIGNED,
  `student_id` INT UNSIGNED NOT NULL,
  `subfield_id` INT UNSIGNED NOT NULL,
  `default_block_id` INT UNSIGNED NOT NULL,
  `actual_block_name` VARCHAR(50) NOT NULL,
  `space` INT NOT NULL DEFAULT 0,
  `speed` INT NOT NULL DEFAULT 0,
  `number_of_repeats` INT UNSIGNED NOT NULL DEFAULT 0,
  `head_order` INT UNSIGNED NOT NULL,
  `tail_order` INT UNSIGNED NOT NULL,
  `start_day` DATE NOT NULL,
  `end_day` DATE NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`actual_block_id`),
  FOREIGN KEY (`default_block_id`) REFERENCES `default_blocks`(`default_block_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`),
  FOREIGN KEY (`subfield_id`) REFERENCES `subfields`(`subfield_id`)
);

CREATE TABLE `problems` (
  `problem_id` INT UNSIGNED,
  `subfield_id` INT UNSIGNED NOT NULL,
  `default_block_id` INT UNSIGNED NOT NULL,
  `student_id` INT UNSIGNED NOT NULL,
  `problem_name` VARCHAR(50) NOT NULL,
  `answer` VARCHAR(510) NOT NULL,
  `area` VARCHAR(50) NOT NULL,
  `section` VARCHAR(50),
  `subsection` VARCHAR(50),
  `reference` VARCHAR(50),
  `problem_level` INT UNSIGNED NOT NULL,
  `option1` VARCHAR(50),
  `option2` VARCHAR(50),
  `option3` VARCHAR(50),
  `option4` VARCHAR(50),
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`problem_id`),
  FOREIGN KEY (`default_block_id`) REFERENCES `default_blocks`(`default_block_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`),
  FOREIGN KEY (`subfield_id`) REFERENCES `subfields`(`subfield_id`)
);

CREATE TABLE `student_problems` (
  `student_problem_id` INT UNSIGNED,
  `student_id` INT UNSIGNED NOT NULL,
  `problem_id` INT UNSIGNED NOT NULL,
  `actual_block_id` INT UNSIGNED NOT NULL,
  `answer_status` INT,
  `is_difficult` TINYINT(1) NOT NULL,
  `understanding_level` INT,
  `try_count` INT,
  `difficult_count` INT,
  `wrong_count` INT,
  `review_level` INT,
  `review_count_down` INT,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`student_problem_id`),
  FOREIGN KEY (`problem_id`) REFERENCES `problems`(`problem_id`),
  FOREIGN KEY (`actual_block_id`) REFERENCES `actual_blocks`(`actual_block_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`)
);

CREATE TABLE `trackers` (
  `tracker_id` INT UNSIGNED,
  `student_id` INT UNSIGNED NOT NULL,
  `subfield_id` INT UNSIGNED NOT NULL,
  `actual_block_id` INT UNSIGNED NOT NULL,
  `student_problem_id` INT UNSIGNED NOT NULL,
  `order` INT UNSIGNED,
  `remaining_space` INT,
  `is_rest` TINYINT(1) NOT NULL DEFAULT 0,
  `lap` INT,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`tracker_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`),
  FOREIGN KEY (`subfield_id`) REFERENCES `subfields`(`subfield_id`),
  FOREIGN KEY (`student_problem_id`) REFERENCES `student_problems`(`student_problem_id`),
  FOREIGN KEY (`actual_block_id`) REFERENCES `actual_blocks`(`actual_block_id`)
);

CREATE TABLE `remainings` (
  `remaining_id` INT UNSIGNED,
  `student_id` INT UNSIGNED NOT NULL,
  `subfield_id` INT UNSIGNED NOT NULL,
  `target_day` DATE,
  `exam_day` DATE,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`remaining_id`),
  FOREIGN KEY (`subfield_id`) REFERENCES `subfields`(`subfield_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`)
);

CREATE TABLE `todo_counters` (
  `todo_counters_id` INT UNSIGNED,
  `student_id` INT UNSIGNED NOT NULL,
  `subfield_id` INT UNSIGNED NOT NULL,
  `count` INT DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`todo_counters_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`),
  FOREIGN KEY (`subfield_id`) REFERENCES `subfields`(`subfield_id`)
);

CREATE TABLE `student_subject_information` (
  `student_subject_information_id` INT UNSIGNED,
  `student_id` INT UNSIGNED NOT NULL,
  `subject_id` INT UNSIGNED NOT NULL,
  `subject_level` VARCHAR(50),
  `goal_description` VARCHAR(50),
  `goal_level` VARCHAR(50),
  `review_size` INT,
  `review_space` INT DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`student_subject_information_id`),
  FOREIGN KEY (`subject_id`) REFERENCES `subjects`(`subject_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`)
);

CREATE TABLE `Rests` (
  `rest_id` INT UNSIGNED,
  `student_id` INT UNSIGNED NOT NULL,
  `subfield_id` INT UNSIGNED NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`rest_id`),
  FOREIGN KEY (`subfield_id`) REFERENCES `subfields`(`subfield_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`)
);

