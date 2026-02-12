package handlers

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"strconv"

	"lemonkorean/progress/repository"

	"github.com/gin-gonic/gin"
)

// CharacterHandler handles character customization endpoints
type CharacterHandler struct {
	repo *repository.ProgressRepository
}

// NewCharacterHandler creates a new character handler
func NewCharacterHandler(repo *repository.ProgressRepository) *CharacterHandler {
	return &CharacterHandler{repo: repo}
}

// EquipRequest is the request body for equipping items
type EquipRequest struct {
	Category string `json:"category" binding:"required"`
	ItemID   int    `json:"item_id" binding:"required"`
}

// SkinColorRequest is the request body for changing skin color
type SkinColorRequest struct {
	SkinColor string `json:"skin_color" binding:"required"`
}

// PurchaseRequest is the request body for purchasing items
type PurchaseRequest struct {
	ItemID int `json:"item_id" binding:"required"`
}

// FurnitureItem represents a single furniture placement
type FurnitureItem struct {
	ItemID    int     `json:"item_id" binding:"required"`
	PositionX float32 `json:"position_x"`
	PositionY float32 `json:"position_y"`
}

// RoomFurnitureRequest is the request body for updating room furniture
type RoomFurnitureRequest struct {
	Furniture []FurnitureItem `json:"furniture" binding:"required"`
}

// getUserID safely extracts the user ID from the gin context
func getUserID(c *gin.Context) (int64, bool) {
	userID, exists := c.Get("userId")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return 0, false
	}
	uidFloat, ok := userID.(float64)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid user ID"})
		return 0, false
	}
	return int64(uidFloat), true
}

// GetCharacter retrieves a user's equipped character items
func (h *CharacterHandler) GetCharacter(c *gin.Context) {
	userIDStr := c.Param("userId")
	userID, err := strconv.ParseInt(userIDStr, 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid user ID"})
		return
	}

	query := `
		SELECT uc.body_item_id, uc.skin_color, uc.hair_item_id, uc.eyes_item_id,
		       uc.eyebrows_item_id, uc.nose_item_id, uc.mouth_item_id,
		       uc.top_item_id, uc.bottom_item_id, uc.shoes_item_id,
		       uc.hat_item_id, uc.accessory_item_id, uc.pet_item_id,
		       uc.wallpaper_item_id, uc.floor_item_id
		FROM user_characters uc
		WHERE uc.user_id = $1
	`

	var body, hair, eyes, eyebrows, nose, mouth, top, bottom, shoes, hat, accessory, pet, wallpaper, floor sql.NullInt64
	var skinColor string

	err = h.repo.GetDB().QueryRowContext(c.Request.Context(), query, userID).Scan(
		&body, &skinColor, &hair, &eyes, &eyebrows, &nose, &mouth,
		&top, &bottom, &shoes, &hat, &accessory, &pet, &wallpaper, &floor,
	)

	if err == sql.ErrNoRows {
		// Return defaults
		c.JSON(http.StatusOK, gin.H{
			"equipped":   gin.H{},
			"skin_color": "#FFDBB4",
		})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to get character"})
		return
	}

	equipped := gin.H{}
	if body.Valid {
		equipped["body"] = body.Int64
	}
	if hair.Valid {
		equipped["hair"] = hair.Int64
	}
	if eyes.Valid {
		equipped["eyes"] = eyes.Int64
	}
	if eyebrows.Valid {
		equipped["eyebrows"] = eyebrows.Int64
	}
	if nose.Valid {
		equipped["nose"] = nose.Int64
	}
	if mouth.Valid {
		equipped["mouth"] = mouth.Int64
	}
	if top.Valid {
		equipped["top"] = top.Int64
	}
	if bottom.Valid {
		equipped["bottom"] = bottom.Int64
	}
	if shoes.Valid {
		equipped["shoes"] = shoes.Int64
	}
	if hat.Valid {
		equipped["hat"] = hat.Int64
	}
	if accessory.Valid {
		equipped["accessory"] = accessory.Int64
	}
	if pet.Valid {
		equipped["pet"] = pet.Int64
	}
	if wallpaper.Valid {
		equipped["wallpaper"] = wallpaper.Int64
	}
	if floor.Valid {
		equipped["floor"] = floor.Int64
	}

	c.JSON(http.StatusOK, gin.H{
		"equipped":   equipped,
		"skin_color": skinColor,
	})
}

// EquipItem equips an item on the user's character
func (h *CharacterHandler) EquipItem(c *gin.Context) {
	uid, ok := getUserID(c)
	if !ok {
		return
	}

	var req EquipRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Verify user owns the item
	var count int
	err := h.repo.GetDB().QueryRowContext(c.Request.Context(),
		`SELECT COUNT(*) FROM user_inventory WHERE user_id = $1 AND item_id = $2`,
		uid, req.ItemID,
	).Scan(&count)
	if err != nil || count == 0 {
		c.JSON(http.StatusForbidden, gin.H{"error": "item not owned"})
		return
	}

	// Map category to column name
	columnMap := map[string]string{
		"body":      "body_item_id",
		"hair":      "hair_item_id",
		"eyes":      "eyes_item_id",
		"eyebrows":  "eyebrows_item_id",
		"nose":      "nose_item_id",
		"mouth":     "mouth_item_id",
		"top":       "top_item_id",
		"bottom":    "bottom_item_id",
		"shoes":     "shoes_item_id",
		"hat":       "hat_item_id",
		"accessory": "accessory_item_id",
		"pet":       "pet_item_id",
		"wallpaper": "wallpaper_item_id",
		"floor":     "floor_item_id",
	}

	column, ok := columnMap[req.Category]
	if !ok {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid category"})
		return
	}

	// Upsert user_characters
	query := `
		INSERT INTO user_characters (user_id, ` + column + `, updated_at)
		VALUES ($1, $2, NOW())
		ON CONFLICT (user_id) DO UPDATE
		SET ` + column + ` = $2, updated_at = NOW()
	`

	_, err = h.repo.GetDB().ExecContext(c.Request.Context(), query, uid, req.ItemID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to equip item"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success":  true,
		"category": req.Category,
		"item_id":  req.ItemID,
	})
}

// UpdateSkinColor changes the user's skin color
func (h *CharacterHandler) UpdateSkinColor(c *gin.Context) {
	uid, ok := getUserID(c)
	if !ok {
		return
	}

	var req SkinColorRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	query := `
		INSERT INTO user_characters (user_id, skin_color, updated_at)
		VALUES ($1, $2, NOW())
		ON CONFLICT (user_id) DO UPDATE
		SET skin_color = $2, updated_at = NOW()
	`

	_, err := h.repo.GetDB().ExecContext(c.Request.Context(), query, uid, req.SkinColor)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to update skin color"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success":    true,
		"skin_color": req.SkinColor,
	})
}

// GetInventory retrieves a user's owned items
func (h *CharacterHandler) GetInventory(c *gin.Context) {
	userIDStr := c.Param("userId")
	userID, err := strconv.ParseInt(userIDStr, 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid user ID"})
		return
	}

	query := `
		SELECT ci.id, ci.category, ci.name, ci.asset_key, ci.asset_type,
		       ci.is_bundled, ci.render_order, ci.price, ci.rarity,
		       ci.is_default, ci.metadata, ui.acquired_at
		FROM user_inventory ui
		JOIN character_items ci ON ci.id = ui.item_id
		WHERE ui.user_id = $1 AND ci.is_active = true
		ORDER BY ci.category, ci.render_order
	`

	rows, err := h.repo.GetDB().QueryContext(c.Request.Context(), query, userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to get inventory"})
		return
	}
	defer rows.Close()

	items := []gin.H{}
	for rows.Next() {
		var id, renderOrder, price int
		var category, name, assetKey, assetType, rarity string
		var isBundled, isDefault bool
		var metadata []byte
		var acquiredAt string

		if err := rows.Scan(&id, &category, &name, &assetKey, &assetType,
			&isBundled, &renderOrder, &price, &rarity,
			&isDefault, &metadata, &acquiredAt); err != nil {
			continue
		}

		var metaMap interface{}
		if len(metadata) > 0 {
			json.Unmarshal(metadata, &metaMap)
		}
		if metaMap == nil {
			metaMap = map[string]interface{}{}
		}

		items = append(items, gin.H{
			"id":           id,
			"category":     category,
			"name":         name,
			"asset_key":    assetKey,
			"asset_type":   assetType,
			"is_bundled":   isBundled,
			"render_order": renderOrder,
			"price":        price,
			"rarity":       rarity,
			"is_default":   isDefault,
			"acquired_at":  acquiredAt,
			"metadata":     metaMap,
		})
	}

	c.JSON(http.StatusOK, gin.H{
		"items": items,
	})
}

// PurchaseItem purchases an item from the shop
func (h *CharacterHandler) PurchaseItem(c *gin.Context) {
	uid, ok := getUserID(c)
	if !ok {
		return
	}

	var req PurchaseRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// All checks and mutations inside a single transaction to prevent race conditions
	tx, err := h.repo.GetDB().BeginTx(c.Request.Context(), nil)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to start transaction"})
		return
	}
	defer tx.Rollback()

	// Check if already owned
	var ownedCount int
	err = tx.QueryRowContext(c.Request.Context(),
		`SELECT COUNT(*) FROM user_inventory WHERE user_id = $1 AND item_id = $2`,
		uid, req.ItemID,
	).Scan(&ownedCount)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to check ownership"})
		return
	}
	if ownedCount > 0 {
		c.JSON(http.StatusConflict, gin.H{"error": "item already owned"})
		return
	}

	// Get item price
	var price int
	var isActive bool
	err = tx.QueryRowContext(c.Request.Context(),
		`SELECT price, is_active FROM character_items WHERE id = $1`,
		req.ItemID,
	).Scan(&price, &isActive)
	if err == sql.ErrNoRows {
		c.JSON(http.StatusNotFound, gin.H{"error": "item not found"})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to get item"})
		return
	}
	if !isActive {
		c.JSON(http.StatusBadRequest, gin.H{"error": "item not available"})
		return
	}

	// Check lemon balance with row lock to prevent race condition
	var totalLemons int
	err = tx.QueryRowContext(c.Request.Context(),
		`SELECT total_lemons FROM lemon_currency WHERE user_id = $1 FOR UPDATE`,
		uid,
	).Scan(&totalLemons)
	if err == sql.ErrNoRows {
		totalLemons = 0
	} else if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to check balance"})
		return
	}

	if totalLemons < price {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":        "insufficient lemons",
			"total_lemons": totalLemons,
			"required":     price,
		})
		return
	}

	// Deduct lemons
	if price > 0 {
		_, err = tx.ExecContext(c.Request.Context(),
			`UPDATE lemon_currency SET total_lemons = total_lemons - $1, updated_at = NOW() WHERE user_id = $2`,
			price, uid,
		)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to deduct lemons"})
			return
		}

		// Record transaction
		_, err = tx.ExecContext(c.Request.Context(),
			`INSERT INTO lemon_transactions (user_id, amount, type, source_id) VALUES ($1, $2, 'purchase', $3)`,
			uid, -price, req.ItemID,
		)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to record transaction"})
			return
		}
	}

	// Add to inventory
	_, err = tx.ExecContext(c.Request.Context(),
		`INSERT INTO user_inventory (user_id, item_id) VALUES ($1, $2)`,
		uid, req.ItemID,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to add to inventory"})
		return
	}

	if err := tx.Commit(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to complete purchase"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success":          true,
		"item_id":          req.ItemID,
		"price":            price,
		"remaining_lemons": totalLemons - price,
	})
}

// GetShopItems retrieves available items for purchase
func (h *CharacterHandler) GetShopItems(c *gin.Context) {
	category := c.Query("category")

	query := `
		SELECT id, category, name, description, asset_key, asset_type,
		       is_bundled, render_order, price, rarity, is_default, metadata
		FROM character_items
		WHERE is_active = true
	`
	args := []interface{}{}

	if category != "" {
		query += ` AND category = $1`
		args = append(args, category)
	}

	query += ` ORDER BY category, price, render_order`

	rows, err := h.repo.GetDB().QueryContext(c.Request.Context(), query, args...)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to get shop items"})
		return
	}
	defer rows.Close()

	items := []gin.H{}
	for rows.Next() {
		var id, renderOrder, price int
		var category, name, assetKey, assetType, rarity string
		var description sql.NullString
		var isBundled, isDefault bool
		var metadata []byte

		if err := rows.Scan(&id, &category, &name, &description, &assetKey, &assetType,
			&isBundled, &renderOrder, &price, &rarity, &isDefault, &metadata); err != nil {
			continue
		}

		var metaMap interface{}
		if len(metadata) > 0 {
			json.Unmarshal(metadata, &metaMap)
		}
		if metaMap == nil {
			metaMap = map[string]interface{}{}
		}

		item := gin.H{
			"id":           id,
			"category":     category,
			"name":         name,
			"asset_key":    assetKey,
			"asset_type":   assetType,
			"is_bundled":   isBundled,
			"render_order": renderOrder,
			"price":        price,
			"rarity":       rarity,
			"is_default":   isDefault,
			"metadata":     metaMap,
		}
		if description.Valid {
			item["description"] = description.String
		}

		items = append(items, item)
	}

	c.JSON(http.StatusOK, gin.H{
		"items": items,
	})
}

// GetRoom retrieves a user's room furniture layout
func (h *CharacterHandler) GetRoom(c *gin.Context) {
	userIDStr := c.Param("userId")
	userID, err := strconv.ParseInt(userIDStr, 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid user ID"})
		return
	}

	query := `
		SELECT urf.id, urf.item_id, ci.name, ci.asset_key, ci.asset_type,
		       urf.position_x, urf.position_y
		FROM user_room_furniture urf
		JOIN character_items ci ON ci.id = urf.item_id
		WHERE urf.user_id = $1
		ORDER BY urf.id
	`

	rows, err := h.repo.GetDB().QueryContext(c.Request.Context(), query, userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to get room"})
		return
	}
	defer rows.Close()

	furniture := []gin.H{}
	for rows.Next() {
		var id, itemID int
		var name, assetKey, assetType string
		var posX, posY float32

		if err := rows.Scan(&id, &itemID, &name, &assetKey, &assetType, &posX, &posY); err != nil {
			continue
		}

		furniture = append(furniture, gin.H{
			"id":         id,
			"item_id":    itemID,
			"name":       name,
			"asset_key":  assetKey,
			"asset_type": assetType,
			"position_x": posX,
			"position_y": posY,
		})
	}

	c.JSON(http.StatusOK, gin.H{
		"furniture": furniture,
	})
}

// UpdateRoomFurniture replaces all furniture in a user's room
func (h *CharacterHandler) UpdateRoomFurniture(c *gin.Context) {
	uid, ok := getUserID(c)
	if !ok {
		return
	}

	var req RoomFurnitureRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	tx, err := h.repo.GetDB().BeginTx(c.Request.Context(), nil)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to start transaction"})
		return
	}
	defer tx.Rollback()

	// Clear existing furniture
	_, err = tx.ExecContext(c.Request.Context(),
		`DELETE FROM user_room_furniture WHERE user_id = $1`, uid)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to clear furniture"})
		return
	}

	// Insert new furniture
	for _, f := range req.Furniture {
		_, err = tx.ExecContext(c.Request.Context(),
			`INSERT INTO user_room_furniture (user_id, item_id, position_x, position_y) VALUES ($1, $2, $3, $4)`,
			uid, f.ItemID, f.PositionX, f.PositionY,
		)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to place furniture"})
			return
		}
	}

	if err := tx.Commit(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to save room"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"count":   len(req.Furniture),
	})
}
