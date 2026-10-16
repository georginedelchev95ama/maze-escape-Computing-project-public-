
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    points INT NOT NULL DEFAULT 0,
    wins INT NOT NULL DEFAULT 0,
    games_played INT NOT NULL DEFAULT 0,
    best_level INT NOT NULL DEFAULT 1,
    title VARCHAR(100) NOT NULL DEFAULT 'New Player',
    is_admin TINYINT(1) NOT NULL DEFAULT 0,
    last_seen TIMESTAMP NULL DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS levels (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    difficulty INT NOT NULL,
    level_json LONGTEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS scores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    level_id INT NOT NULL,
    time_ms INT NOT NULL,
    moves INT NOT NULL,
    mode VARCHAR(20) NOT NULL DEFAULT 'custom',
    won TINYINT(1) NOT NULL DEFAULT 0,
    keys_collected INT NOT NULL DEFAULT 0,
    points_earned INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (level_id) REFERENCES levels(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS achievements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS user_achievements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    achievement_id INT NOT NULL,
    unlocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_unlock (user_id, achievement_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (achievement_id) REFERENCES achievements(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    body TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE
);

INSERT IGNORE INTO achievements (code, name, description) VALUES
('FIRST_ESCAPE', 'First Escape', 'Complete your first successful run.'),
('TEN_GAMES', 'Getting Started', 'Play 10 games in total.'),
('FIVE_WINS', 'Consistent Runner', 'Win 5 games.'),
('LEVEL_5', 'Deep Runner', 'Beat Level 5 or higher.'),
('POINTS_1000', 'Beginner Explorer', 'Reach 1000 total points.'),
('POINTS_2500', 'Maze Hunter', 'Reach 2500 total points.'),
('POINTS_7000', 'Escape Master', 'Reach 7000 total points.'),
('POINTS_15000', 'Shadow Sprinter', 'Reach 15000 total points.'),
('POINTS_20000', 'Maze Legend', 'Reach 20000 total points.'),
('KEY_COLLECTOR', 'Key Collector', 'Collect 25 keys across all runs.'),
('SPEED_40', 'Rapid Exit', 'Finish any level in under 40 seconds.'),
('HARD_CLEAR', 'No More Training Wheels', 'Beat Level 8.');
