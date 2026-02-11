-- ================================================================
-- 013: Character Customization & My Room System
-- ================================================================
-- Adds character item catalog, user characters (equipped items),
-- user inventory (owned items), and room furniture placement.
-- Extends lemon_transactions to support 'purchase' type.
-- ================================================================

BEGIN;

-- ================================================================
-- character_items - item catalog (managed by admin)
-- ================================================================
CREATE TABLE IF NOT EXISTS character_items (
    id SERIAL PRIMARY KEY,
    category VARCHAR(30) NOT NULL CHECK (category IN (
        'body', 'skin_color', 'hair', 'eyes', 'eyebrows', 'nose', 'mouth',
        'top', 'bottom', 'shoes', 'hat', 'accessory',
        'pet', 'wallpaper', 'floor', 'furniture'
    )),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    asset_key VARCHAR(200) NOT NULL,
    asset_type VARCHAR(10) DEFAULT 'svg' CHECK (asset_type IN ('svg', 'png')),
    is_bundled BOOLEAN DEFAULT false,
    render_order INTEGER DEFAULT 0,
    price INTEGER DEFAULT 0,
    rarity VARCHAR(20) DEFAULT 'common' CHECK (rarity IN ('common', 'rare', 'epic', 'legendary')),
    is_default BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_character_items_category ON character_items(category);
CREATE INDEX IF NOT EXISTS idx_character_items_active ON character_items(is_active) WHERE is_active = true;

-- ================================================================
-- user_characters - equipped items per user
-- ================================================================
CREATE TABLE IF NOT EXISTS user_characters (
    user_id INTEGER PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    body_item_id INTEGER REFERENCES character_items(id),
    skin_color VARCHAR(7) DEFAULT '#FFDBB4',
    hair_item_id INTEGER REFERENCES character_items(id),
    eyes_item_id INTEGER REFERENCES character_items(id),
    eyebrows_item_id INTEGER REFERENCES character_items(id),
    nose_item_id INTEGER REFERENCES character_items(id),
    mouth_item_id INTEGER REFERENCES character_items(id),
    top_item_id INTEGER REFERENCES character_items(id),
    bottom_item_id INTEGER REFERENCES character_items(id),
    shoes_item_id INTEGER REFERENCES character_items(id),
    hat_item_id INTEGER REFERENCES character_items(id),
    accessory_item_id INTEGER REFERENCES character_items(id),
    pet_item_id INTEGER REFERENCES character_items(id),
    wallpaper_item_id INTEGER REFERENCES character_items(id),
    floor_item_id INTEGER REFERENCES character_items(id),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ================================================================
-- user_inventory - owned items
-- ================================================================
CREATE TABLE IF NOT EXISTS user_inventory (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    item_id INTEGER NOT NULL REFERENCES character_items(id) ON DELETE CASCADE,
    acquired_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, item_id)
);

CREATE INDEX IF NOT EXISTS idx_user_inventory_user ON user_inventory(user_id);

-- ================================================================
-- user_room_furniture - furniture placement in my room
-- ================================================================
CREATE TABLE IF NOT EXISTS user_room_furniture (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    item_id INTEGER NOT NULL REFERENCES character_items(id) ON DELETE CASCADE,
    position_x REAL DEFAULT 0.5,
    position_y REAL DEFAULT 0.5,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_user_room_furniture_user ON user_room_furniture(user_id);

-- ================================================================
-- Extend lemon_transactions type to include 'purchase'
-- ================================================================
ALTER TABLE lemon_transactions DROP CONSTRAINT IF EXISTS lemon_transactions_type_check;
ALTER TABLE lemon_transactions ADD CONSTRAINT lemon_transactions_type_check
    CHECK (type IN ('lesson', 'boss', 'harvest', 'bonus', 'purchase'));

-- ================================================================
-- Seed default items (bundled, free, equipped by default)
-- ================================================================

-- Body
INSERT INTO character_items (category, name, asset_key, is_bundled, render_order, price, is_default)
VALUES
    ('body', 'Default Body', 'assets/character/body/body_default.svg', true, 0, 0, true);

-- Hair
INSERT INTO character_items (category, name, asset_key, is_bundled, render_order, price, is_default)
VALUES
    ('hair', 'Short Hair', 'assets/character/hair/hair_short.svg', true, 40, 0, true),
    ('hair', 'Long Hair', 'assets/character/hair/hair_long.svg', true, 40, 0, false),
    ('hair', 'Curly Hair', 'assets/character/hair/hair_curly.svg', true, 40, 0, false);

-- Eyes
INSERT INTO character_items (category, name, asset_key, is_bundled, render_order, price, is_default)
VALUES
    ('eyes', 'Round Eyes', 'assets/character/eyes/eyes_round.svg', true, 20, 0, true),
    ('eyes', 'Almond Eyes', 'assets/character/eyes/eyes_almond.svg', true, 20, 0, false),
    ('eyes', 'Happy Eyes', 'assets/character/eyes/eyes_happy.svg', true, 20, 0, false);

-- Eyebrows
INSERT INTO character_items (category, name, asset_key, is_bundled, render_order, price, is_default)
VALUES
    ('eyebrows', 'Natural Brows', 'assets/character/eyebrows/eyebrows_natural.svg', true, 25, 0, true),
    ('eyebrows', 'Thick Brows', 'assets/character/eyebrows/eyebrows_thick.svg', true, 25, 0, false);

-- Nose
INSERT INTO character_items (category, name, asset_key, is_bundled, render_order, price, is_default)
VALUES
    ('nose', 'Button Nose', 'assets/character/nose/nose_button.svg', true, 30, 0, true),
    ('nose', 'Small Nose', 'assets/character/nose/nose_small.svg', true, 30, 0, false);

-- Mouth
INSERT INTO character_items (category, name, asset_key, is_bundled, render_order, price, is_default)
VALUES
    ('mouth', 'Smile', 'assets/character/mouth/mouth_smile.svg', true, 35, 0, true),
    ('mouth', 'Grin', 'assets/character/mouth/mouth_grin.svg', true, 35, 0, false);

-- Top (clothing)
INSERT INTO character_items (category, name, asset_key, is_bundled, render_order, price, is_default)
VALUES
    ('top', 'Basic T-Shirt', 'assets/character/top/top_tshirt.svg', true, 50, 0, true),
    ('top', 'Hoodie', 'assets/character/top/top_hoodie.svg', true, 50, 10, false);

-- Bottom (clothing)
INSERT INTO character_items (category, name, asset_key, is_bundled, render_order, price, is_default)
VALUES
    ('bottom', 'Jeans', 'assets/character/bottom/bottom_jeans.svg', true, 55, 0, true),
    ('bottom', 'Shorts', 'assets/character/bottom/bottom_shorts.svg', true, 55, 10, false);

-- Wallpaper
INSERT INTO character_items (category, name, asset_key, is_bundled, render_order, price, is_default)
VALUES
    ('wallpaper', 'Light Blue Wall', 'assets/character/wallpaper/wall_light_blue.svg', true, 0, 0, true),
    ('wallpaper', 'Warm Yellow Wall', 'assets/character/wallpaper/wall_warm_yellow.svg', true, 0, 15, false);

-- Floor
INSERT INTO character_items (category, name, asset_key, is_bundled, render_order, price, is_default)
VALUES
    ('floor', 'Wooden Floor', 'assets/character/floor/floor_wood.svg', true, 0, 0, true),
    ('floor', 'Tile Floor', 'assets/character/floor/floor_tile.svg', true, 0, 15, false);

COMMIT;
