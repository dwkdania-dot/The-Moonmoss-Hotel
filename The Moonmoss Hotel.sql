-- Create Database
CREATE DATABASE IF NOT EXISTS moonmoss_hotel;
USE moonmoss_hotel;

-- Users Table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    fairy_type ENUM('bloom', 'glimmer', 'tinker', 'frost', 'whisper', 'hearth', 'lumen') NOT NULL,
    gender ENUM('male', 'female', 'other') NOT NULL,
    origin VARCHAR(100),
    coins INT DEFAULT 100,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_login DATETIME,
    profile_image VARCHAR(255) DEFAULT 'default_fairy.png',
    is_admin BOOLEAN DEFAULT FALSE
);

-- User Sessions Table
CREATE TABLE user_sessions (
    session_id VARCHAR(128) PRIMARY KEY,
    user_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    expires_at DATETIME NOT NULL,
    ip_address VARCHAR(45),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Inventory Items Table
CREATE TABLE inventory_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    description TEXT,
    category ENUM('top', 'bottom', 'wings', 'shoes', 'accessory', 'special') NOT NULL,
    price INT NOT NULL,
    rarity ENUM('common', 'uncommon', 'rare', 'epic', 'legendary') DEFAULT 'common',
    image_path VARCHAR(255) NOT NULL,
    is_seasonal BOOLEAN DEFAULT FALSE
);

-- User Inventory Table
CREATE TABLE user_inventory (
    user_item_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    item_id INT NOT NULL,
    acquired_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_equipped BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES inventory_items(item_id)
);

-- Forum Categories Table
CREATE TABLE forum_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    display_order INT NOT NULL
);

-- Forum Threads Table
CREATE TABLE forum_threads (
    thread_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_pinned BOOLEAN DEFAULT FALSE,
    is_locked BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (category_id) REFERENCES forum_categories(category_id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Forum Posts Table
CREATE TABLE forum_posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    thread_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    posted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    edited_at DATETIME,
    FOREIGN KEY (thread_id) REFERENCES forum_threads(thread_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Clans Table
CREATE TABLE clans (
    clan_id INT AUTO_INCREMENT PRIMARY KEY,
    clan_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    leader_id INT NOT NULL,
    icon VARCHAR(10) DEFAULT '👥',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    member_count INT DEFAULT 1,
    FOREIGN KEY (leader_id) REFERENCES users(id)
);

-- Clan Members Table
CREATE TABLE clan_members (
    clan_member_id INT AUTO_INCREMENT PRIMARY KEY,
    clan_id INT NOT NULL,
    user_id INT NOT NULL,
    role ENUM('leader', 'admin', 'member') DEFAULT 'member',
    joined_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (clan_id) REFERENCES clans(clan_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_clan_member (clan_id, user_id)
);

-- Clan Announcements Table
CREATE TABLE clan_announcements (
    announcement_id INT AUTO_INCREMENT PRIMARY KEY,
    clan_id INT NOT NULL,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    posted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (clan_id) REFERENCES clans(clan_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Insert Default Forum Categories
INSERT INTO forum_categories (category_name, description, display_order) VALUES
('Announcements', 'Official announcements from the Moonmoss staff', 1),
('Fairy Discussions', 'Talk about anything fairy-related!', 2),
('Games & Activities', 'Discuss and share tips for our mini-games', 3),
('Fashion & Style', 'Show off your fairy outfits and accessories', 4),
('Clan Discussions', 'Talk about clan activities and events', 5);

-- Insert Some Default Items
INSERT INTO inventory_items (item_name, description, category, price, rarity, image_path) VALUES
('Petal Top', 'A beautiful top made of flower petals', 'top', 200, 'uncommon', 'images/items/petal_top.png'),
('Mossy Cape', 'A cape woven from forest moss', 'accessory', 350, 'rare', 'images/items/mossy_cape.png'),
('Crystal Wings', 'Shimmering wings made of pure crystal', 'wings', 500, 'epic', 'images/items/crystal_wings.png'),
('Mushroom Hat', 'A cute hat shaped like a red mushroom', 'accessory', 150, 'common', 'images/items/mushroom_hat.png'),
('Dewdrop Sandals', 'Sandals adorned with morning dew drops', 'shoes', 250, 'uncommon', 'images/items/dewdrop_sandals.png');