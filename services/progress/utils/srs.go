package utils

import (
	"math"
	"time"
)

// ================================================================
// SPACED REPETITION SYSTEM (SRS) ALGORITHM
// ================================================================
// Based on SM-2 Algorithm (SuperMemo 2)
// Used for optimizing vocabulary review schedules
// ================================================================

const (
	// Initial easiness factor (2.5 is standard for SM-2)
	InitialEasinessFactor = 2.5

	// Minimum easiness factor
	MinEasinessFactor = 1.3

	// Maximum easiness factor
	MaxEasinessFactor = 3.5

	// Mastery levels
	MasteryLevelNew       = 0 // New word
	MasteryLevelLearning  = 1 // Learning
	MasteryLevelReviewing = 2 // Reviewing
	MasteryLevelMastered  = 3 // Mastered
)

// SRSResult represents the result of SRS calculation
type SRSResult struct {
	MasteryLevel    int       `json:"mastery_level"`
	EasinessFactor  float64   `json:"easiness_factor"`
	IntervalDays    int       `json:"interval_days"`
	RepetitionCount int       `json:"repetition_count"`
	NextReviewAt    time.Time `json:"next_review_at"`
}

// CalculateNextReview calculates the next review schedule using SM-2 algorithm
// quality: 0-5 (0=complete blackout, 5=perfect response)
// - 0: Complete blackout, couldn't remember
// - 1: Incorrect, but felt familiar
// - 2: Incorrect, but remembered with difficulty
// - 3: Correct, but with difficulty
// - 4: Correct, with some hesitation
// - 5: Perfect, instant recall
func CalculateNextReview(
	quality int,
	currentEasiness float64,
	currentInterval int,
	currentRepetitions int,
	currentMastery int,
) SRSResult {
	// Validate quality (0-5)
	if quality < 0 {
		quality = 0
	}
	if quality > 5 {
		quality = 5
	}

	// Initialize if first review
	if currentEasiness == 0 {
		currentEasiness = InitialEasinessFactor
	}

	// Calculate new easiness factor
	// EF' = EF + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
	newEasiness := currentEasiness + (0.1 - float64(5-quality)*(0.08+float64(5-quality)*0.02))

	// Constrain easiness factor
	if newEasiness < MinEasinessFactor {
		newEasiness = MinEasinessFactor
	}
	if newEasiness > MaxEasinessFactor {
		newEasiness = MaxEasinessFactor
	}

	var newInterval int
	var newRepetitions int
	var newMastery int

	// If quality < 3, reset repetitions and use short intervals
	if quality < 3 {
		// Failed review - reset
		newRepetitions = 0
		newInterval = 1 // Review again tomorrow
		newMastery = MasteryLevelLearning

	} else {
		// Successful review
		newRepetitions = currentRepetitions + 1

		// Calculate interval based on repetition count
		switch newRepetitions {
		case 1:
			// First successful review: 1 day
			newInterval = 1
			newMastery = MasteryLevelLearning

		case 2:
			// Second successful review: 6 days
			newInterval = 6
			newMastery = MasteryLevelReviewing

		default:
			// Subsequent reviews: multiply by easiness factor
			newInterval = int(math.Round(float64(currentInterval) * newEasiness))

			// Determine mastery level based on interval
			if newInterval >= 30 {
				newMastery = MasteryLevelMastered
			} else {
				newMastery = MasteryLevelReviewing
			}
		}
	}

	// Calculate next review date
	nextReviewAt := time.Now().Add(time.Duration(newInterval) * 24 * time.Hour)

	return SRSResult{
		MasteryLevel:    newMastery,
		EasinessFactor:  newEasiness,
		IntervalDays:    newInterval,
		RepetitionCount: newRepetitions,
		NextReviewAt:    nextReviewAt,
	}
}

// CalculateNextReviewSimple is a simplified version for boolean correct/incorrect
func CalculateNextReviewSimple(
	isCorrect bool,
	currentEasiness float64,
	currentInterval int,
	currentRepetitions int,
	currentMastery int,
) SRSResult {
	// Map boolean to quality score
	// Incorrect: quality 2 (remembered with difficulty but got it wrong)
	// Correct: quality 4 (correct with some hesitation)
	quality := 2
	if isCorrect {
		quality = 4
	}

	return CalculateNextReview(quality, currentEasiness, currentInterval, currentRepetitions, currentMastery)
}

// GetInitialSRSData returns initial SRS data for a new vocabulary item
func GetInitialSRSData() SRSResult {
	return SRSResult{
		MasteryLevel:    MasteryLevelNew,
		EasinessFactor:  InitialEasinessFactor,
		IntervalDays:    0,
		RepetitionCount: 0,
		NextReviewAt:    time.Now(), // Review immediately
	}
}

// CalculateQualityFromResponseTime estimates quality from response time
// This is a heuristic: faster responses indicate better retention
// responseTimeMs: response time in milliseconds
// Returns quality score 0-5
func CalculateQualityFromResponseTime(isCorrect bool, responseTimeMs int) int {
	if !isCorrect {
		// If incorrect, quality is low regardless of time
		if responseTimeMs < 2000 {
			return 1 // Quick but wrong - guessed
		}
		return 0 // Slow and wrong - don't know
	}

	// Correct response - quality depends on response time
	switch {
	case responseTimeMs < 1000:
		return 5 // Perfect - instant recall
	case responseTimeMs < 2000:
		return 4 // Good - quick recall
	case responseTimeMs < 4000:
		return 3 // OK - recalled with some effort
	case responseTimeMs < 8000:
		return 2 // Difficult - took time to recall
	default:
		return 1 // Very difficult - barely remembered
	}
}

// GetMasteryDescription returns a human-readable description of mastery level
func GetMasteryDescription(masteryLevel int) string {
	switch masteryLevel {
	case MasteryLevelNew:
		return "New"
	case MasteryLevelLearning:
		return "Learning"
	case MasteryLevelReviewing:
		return "Reviewing"
	case MasteryLevelMastered:
		return "Mastered"
	default:
		return "Unknown"
	}
}

// CalculateRetentionRate calculates retention rate from correct/incorrect counts
func CalculateRetentionRate(correctCount, incorrectCount int) float64 {
	total := correctCount + incorrectCount
	if total == 0 {
		return 0.0
	}
	return float64(correctCount) / float64(total) * 100
}

// GetRecommendedDailyReviews returns recommended number of reviews per day
// based on user's current progress
func GetRecommendedDailyReviews(totalVocabulary, masteredVocabulary int) int {
	learning := totalVocabulary - masteredVocabulary

	switch {
	case learning < 20:
		return 10 // Beginner
	case learning < 100:
		return 20 // Intermediate
	case learning < 500:
		return 30 // Advanced
	default:
		return 50 // Expert
	}
}

// ================================================================
// ALTERNATIVE SM-2 IMPLEMENTATION
// ================================================================
// This version matches the classic SM-2 signature more closely
// ================================================================

// CalculateNextReviewClassic implements the classic SM-2 algorithm
// with the traditional function signature
//
// Parameters:
//   - lastReview: The last time this item was reviewed
//   - quality: Response quality (0-5)
//     0 = Complete blackout
//     1 = Incorrect response
//     2 = Incorrect but remembered with difficulty
//     3 = Correct with difficulty
//     4 = Correct with hesitation
//     5 = Perfect response
//   - repetitions: Number of consecutive successful reviews
//   - easeFactor: Current easiness factor (typically starts at 2.5)
//   - interval: Current interval in days
//
// Returns:
//   - nextReview: When to review this item next
//   - newEF: Updated easiness factor
//   - newInterval: New interval in days
//   - newReps: Updated repetition count
func CalculateNextReviewClassic(
	lastReview time.Time,
	quality int,
	repetitions int,
	easeFactor float64,
	interval int,
) (nextReview time.Time, newEF float64, newInterval int, newReps int) {

	// ================================================================
	// STEP 1: Validate and normalize inputs
	// ================================================================

	// Validate quality (must be 0-5)
	if quality < 0 {
		quality = 0
	}
	if quality > 5 {
		quality = 5
	}

	// Initialize easiness factor if not set
	if easeFactor <= 0 {
		easeFactor = InitialEasinessFactor
	}

	// ================================================================
	// STEP 2: Calculate new Easiness Factor (EF)
	// ================================================================
	// Formula: EF' = EF + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
	// This adjusts EF based on how well the user remembered

	newEF = easeFactor + (0.1 - float64(5-quality)*(0.08+float64(5-quality)*0.02))

	// Constrain EF to valid range [1.3, 3.5]
	if newEF < MinEasinessFactor {
		newEF = MinEasinessFactor
	}
	if newEF > MaxEasinessFactor {
		newEF = MaxEasinessFactor
	}

	// ================================================================
	// STEP 3: Calculate interval and repetitions
	// ================================================================

	if quality < 3 {
		// ============================================================
		// FAILED REVIEW (quality < 3)
		// ============================================================
		// Reset the learning process
		// The item will be shown again soon (tomorrow)

		newReps = 0
		newInterval = 1 // Review again in 1 day

	} else {
		// ============================================================
		// SUCCESSFUL REVIEW (quality >= 3)
		// ============================================================
		// Increase repetition count
		newReps = repetitions + 1

		// Calculate new interval based on repetition number
		switch newReps {
		case 1:
			// First successful repetition: 1 day
			newInterval = 1

		case 2:
			// Second successful repetition: 6 days
			newInterval = 6

		default:
			// Third and subsequent repetitions:
			// Multiply previous interval by the easiness factor
			// Formula: I(n) = I(n-1) * EF
			newInterval = int(math.Round(float64(interval) * newEF))

			// Ensure minimum interval of 1 day
			if newInterval < 1 {
				newInterval = 1
			}
		}
	}

	// ================================================================
	// STEP 4: Calculate next review date
	// ================================================================
	// Add the interval (in days) to the last review date

	if lastReview.IsZero() {
		// If no last review time provided, use current time
		lastReview = time.Now()
	}

	nextReview = lastReview.Add(time.Duration(newInterval) * 24 * time.Hour)

	return nextReview, newEF, newInterval, newReps
}

// CalculateNextReviewWithMastery extends the classic SM-2 algorithm
// with mastery level tracking
//
// This is a convenience wrapper that combines the classic algorithm
// with additional mastery level tracking
func CalculateNextReviewWithMastery(
	lastReview time.Time,
	quality int,
	repetitions int,
	easeFactor float64,
	interval int,
) (nextReview time.Time, newEF float64, newInterval int, newReps int, masteryLevel int) {

	// Call the classic algorithm
	nextReview, newEF, newInterval, newReps = CalculateNextReviewClassic(
		lastReview, quality, repetitions, easeFactor, interval,
	)

	// Determine mastery level based on interval and repetitions
	masteryLevel = DetermineMasteryLevel(newInterval, newReps, quality)

	return
}

// DetermineMasteryLevel determines the mastery level based on interval and repetitions
func DetermineMasteryLevel(interval, repetitions, lastQuality int) int {
	// Failed review (quality < 3) or no repetitions
	if lastQuality < 3 || repetitions == 0 {
		return MasteryLevelLearning
	}

	// Determine by interval length
	switch {
	case interval >= 30:
		// Reviews 30+ days apart = Mastered
		return MasteryLevelMastered

	case interval >= 6:
		// Reviews 6-29 days apart = Reviewing
		return MasteryLevelReviewing

	case repetitions >= 1:
		// Short intervals but has successful reviews = Learning
		return MasteryLevelLearning

	default:
		// New item
		return MasteryLevelNew
	}
}

// ================================================================
// BATCH REVIEW CALCULATIONS
// ================================================================

// ReviewItem represents a single item to be reviewed
type ReviewItem struct {
	ID             int64     `json:"id"`
	LastReview     time.Time `json:"last_review"`
	Quality        int       `json:"quality"`
	Repetitions    int       `json:"repetitions"`
	EaseFactor     float64   `json:"ease_factor"`
	Interval       int       `json:"interval"`
}

// ReviewResult contains the calculated result for a review item
type ReviewResult struct {
	ID             int64     `json:"id"`
	NextReview     time.Time `json:"next_review"`
	NewEF          float64   `json:"new_ef"`
	NewInterval    int       `json:"new_interval"`
	NewRepetitions int       `json:"new_repetitions"`
	MasteryLevel   int       `json:"mastery_level"`
}

// CalculateBatchReviews processes multiple review items at once
// This is useful for batch updating vocabulary progress
func CalculateBatchReviews(items []ReviewItem) []ReviewResult {
	results := make([]ReviewResult, len(items))

	for i, item := range items {
		nextReview, newEF, newInterval, newReps, masteryLevel := CalculateNextReviewWithMastery(
			item.LastReview,
			item.Quality,
			item.Repetitions,
			item.EaseFactor,
			item.Interval,
		)

		results[i] = ReviewResult{
			ID:             item.ID,
			NextReview:     nextReview,
			NewEF:          newEF,
			NewInterval:    newInterval,
			NewRepetitions: newReps,
			MasteryLevel:   masteryLevel,
		}
	}

	return results
}

// ================================================================
// SCHEDULING HELPERS
// ================================================================

// GetDueItems filters items that are due for review
func GetDueItems(items []ReviewItem, currentTime time.Time) []ReviewItem {
	var dueItems []ReviewItem

	for _, item := range items {
		nextReview := item.LastReview.Add(time.Duration(item.Interval) * 24 * time.Hour)
		if nextReview.Before(currentTime) || nextReview.Equal(currentTime) {
			dueItems = append(dueItems, item)
		}
	}

	return dueItems
}

// EstimateReviewTime estimates how long a review session will take
// Assumes average 3 seconds per item
func EstimateReviewTime(itemCount int) time.Duration {
	secondsPerItem := 3
	totalSeconds := itemCount * secondsPerItem
	return time.Duration(totalSeconds) * time.Second
}

// GetReviewLoadForDay calculates how many items are due on a specific day
func GetReviewLoadForDay(items []ReviewItem, targetDate time.Time) int {
	count := 0
	startOfDay := time.Date(targetDate.Year(), targetDate.Month(), targetDate.Day(), 0, 0, 0, 0, targetDate.Location())
	endOfDay := startOfDay.Add(24 * time.Hour)

	for _, item := range items {
		nextReview := item.LastReview.Add(time.Duration(item.Interval) * 24 * time.Hour)
		if (nextReview.After(startOfDay) || nextReview.Equal(startOfDay)) && nextReview.Before(endOfDay) {
			count++
		}
	}

	return count
}

// ================================================================
// PERFORMANCE METRICS
// ================================================================

// CalculateAverageEF calculates the average easiness factor across items
func CalculateAverageEF(items []ReviewItem) float64 {
	if len(items) == 0 {
		return 0
	}

	sum := 0.0
	for _, item := range items {
		sum += item.EaseFactor
	}

	return sum / float64(len(items))
}

// CalculateAverageInterval calculates the average interval across items
func CalculateAverageInterval(items []ReviewItem) float64 {
	if len(items) == 0 {
		return 0
	}

	sum := 0
	for _, item := range items {
		sum += item.Interval
	}

	return float64(sum) / float64(len(items))
}
