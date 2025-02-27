CREATE TABLE `students` (
  `student_id` UNSIGNED INT,
  `student_name` VARCHAR(50),
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
  `created_at` TIMESTAMP,
  `updated_at` TIMESTAMP,
  PRIMARY KEY (`student_id`)
);

CREATE TABLE `subfields` (
  `subfield_id` UNSIGNED INT,
  `subfield_name` VARCHAR(50),
  `subject_id` UNSIGNED INT,
  `subject_name` VARCHAR(50),
  `created_at` TIMESTAMP,
  `updated_at` TIMESTAMP,
  PRIMARY KEY (`subfield_id`),
  KEY `UNIQUE` (`subject_id`)
);

CREATE TABLE `default_blocks` (
  `default_block_id` UNSIGNED INT,
  `subfield_id` UNSIGNED INT,
  `block_name` VARCHAR(50),
  `block_order` UNSIGNED INT,
  `space` INT,
  `speed` UNSIGNED INT,
  `size` UNSIGNED INT,
  `average_expected_time` UNSIGNED INT,
  `created_at` TIMESTAMP,
  `updated_at` TIMESTAMP,
  PRIMARY KEY (`default_block_id`),
  FOREIGN KEY (`subfield_id`) REFERENCES `subfields`(`subfield_id`)
);

CREATE TABLE `actual_blocks` (
  `actual_block_id` UNSIGNED INT,
  `student_id` UNSIGNED INT,
  `subfield_id` UNSIGNED INT,
  `default_block_id` UNSIGNED INT,
  `actual_block_name` VARCHAR(50),
  `space` INT,
  `speed` UNSIGNED INT,
  `number_of_repeats` UNSIGNED INT,
  `head_order` UNSIGNED INT,
  `tail_order` UNSIGNED INT,
  `start_day` DATE,
  `end_day` DATE,
  `created_at` TIMESTAMP,
  `updated_at` TIMESTAMP,
  PRIMARY KEY (`actual_block_id`),
  FOREIGN KEY (`default_block_id`) REFERENCES `default_blocks`(`default_block_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`),
  FOREIGN KEY (`subfield_id`) REFERENCES `subfields`(`subfield_id`)
);

CREATE TABLE `problems` (
  `problem_id` UNSIGNED INT,
  `subfield_id` UNSIGNED INT,
  `default_block_id` UNSIGNED INT,
  `student_id` UNSIGNED INT,
  `problem_name` VARCHAR(50),
  `answer` VARCHAR(510),
  `area` VARCHAR(50),
  `section` VARCHAR(50),
  `subsection` VARCHAR(50),
  `reference` VARCHAR(50),
  `problem_level` UNSIGNED INT,
  `option1` VARCHAR(50),
  `option2` VARCHAR(50),
  `option3` VARCHAR(50),
  `option4` VARCHAR(50),
  `created_at` TIMESTAMP,
  `updated_at` TIMESTAMP,
  PRIMARY KEY (`problem_id`),
  FOREIGN KEY (`subfield_id`) REFERENCES `subfields`(`subfield_id`),
  FOREIGN KEY (`default_block_id`) REFERENCES `default_blocks`(`default_block_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`)
);

CREATE TABLE `student_problems` (
  `student_problem_id` UNSIGNED INT,
  `student_id` UNSIGNED INT,
  `problem_id` UNSIGNED INT,
  `actual_block_id` UNSIGNED INT,
  `answer_status` INT,
  `is_difficult` BOOLEAN,
  `understanding_level` INT,
  `try_count` INT,
  `difficult_count` INT,
  `wrong_count` INT,
  `review_level` INT,
  `review_count_down` INT,
  `created_at` TIMESTAMP,
  `updated_at` TIMESTAMP,
  PRIMARY KEY (`student_problem_id`),
  FOREIGN KEY (`problem_id`) REFERENCES `problems`(`problem_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`),
  FOREIGN KEY (`actual_block_id`) REFERENCES `actual_blocks`(`actual_block_id`)
);

CREATE TABLE `trackers` (
  `tracker_id` UNSIGNED INT,
  `student_id` UNSIGNED INT,
  `subfield_id` UNSIGNED INT,
  `actual_block_id` UNSIGNED INT,
  `student_problem_id` UNSIGNED INT,
  `order` UNSIGNED INT,
  `remaining_space` INT,
  `is_rest` boolean,
  `lap` INT,
  `create_at` TIMESTAMP,
  `updated_at` TIMESTAMP,
  PRIMARY KEY (`tracker_id`),
  FOREIGN KEY (`subfield_id`) REFERENCES `subfields`(`subfield_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`),
  FOREIGN KEY (`actual_block_id`) REFERENCES `actual_blocks`(`actual_block_id`),
  FOREIGN KEY (`student_problem_id`) REFERENCES `student_problems`(`student_problem_id`)
);

CREATE TABLE `remainings` (
  `remaining_id` UNSIGNED INT,
  `student_id` UNSIGNED INT,
  `subfield_id` UNSIGNED INT,
  `target_day` DATE,
  `exam_day` DATE,
  `created_at` TIMESTAMP,
  `updated_at` TIMESTAMP,
  PRIMARY KEY (`remaining_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`),
  FOREIGN KEY (`subfield_id`) REFERENCES `subfields`(`subfield_id`)
);

CREATE TABLE `students_subfields` (
  `student_id` UNSIGNED INT,
  `subfield_id` UNSIGNED INT,
  `created_at` TIMESTAMP,
  `updated_at` TIMESTAMP,
  PRIMARY KEY (`student_id`, `subfield_id`),
  FOREIGN KEY (`subfield_id`) REFERENCES `subfields`(`subfield_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`)
);

CREATE TABLE `todo_counters` (
  `todo_counters_id` UNSIGNED INT,
  `student_id` UNSIGNED INT,
  `subfield_id` UNSIGNED INT,
  `count` INT,
  `created_at` TIMESTAMP,
  `updated_at` TIMESTAMP,
  PRIMARY KEY (`todo_counters_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`),
  FOREIGN KEY (`subfield_id`) REFERENCES `subfields`(`subfield_id`)
);

CREATE TABLE `student_subject_information` (
  `student_subject_information_id` UNSIGNED INT,
  `student_id` UNSIGNED INT,
  `subject_id` UNSIGNED INT,
  `subject_level` VARCHAR(50),
  `goal_description` VARCHAR(50),
  `goal_level` VARCHAR(50),
  `review_size` INT,
  `review_space` INT,
  `created_at` TIMESTAMP,
  `updated_at` TIMESTAMP,
  PRIMARY KEY (`student_subject_information_id`),
  FOREIGN KEY (`subject_id`) REFERENCES `subfields`(`subject_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`)
);

CREATE TABLE `Rests` (
  `rest_id` UNSIGNED INT,
  `student_id` UNSIGNED INT,
  `subfield_id` UNSIGNED INT,
  `start_date` DATE,
  `end_date` DATE,
  `created_at` TIMESTAMP,
  `updated_at` TIMESTAMP,
  PRIMARY KEY (`rest_id`),
  FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`),
  FOREIGN KEY (`subfield_id`) REFERENCES `subfields`(`subfield_id`)
);

