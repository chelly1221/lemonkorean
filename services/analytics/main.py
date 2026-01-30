from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional, Dict, Any
from datetime import datetime, timedelta
import os
from dotenv import load_dotenv
import pymongo
import psycopg2
from psycopg2.extras import RealDictCursor
import redis
import logging
from collections import defaultdict

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize FastAPI app
app = FastAPI(
    title="Lemon Korean Analytics Service",
    description="Analytics and event tracking service",
    version="1.0.0"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Database connections
def get_postgres_conn():
    try:
        conn = psycopg2.connect(
            host=os.getenv('DB_HOST', 'postgres'),
            port=os.getenv('DB_PORT', '5432'),
            database=os.getenv('DB_NAME', 'lemon_korean'),
            user=os.getenv('DB_USER', '3chan'),
            password=os.getenv('DB_PASSWORD'),
            cursor_factory=RealDictCursor
        )
        return conn
    except Exception as e:
        logger.error(f"PostgreSQL connection error: {e}")
        raise HTTPException(status_code=500, detail="Database connection failed")

def get_mongodb_client():
    try:
        mongodb_uri = os.getenv('MONGODB_URI', 'mongodb://3chan:password@mongodb:27017/lemon_korean')
        client = pymongo.MongoClient(mongodb_uri)
        return client['lemon_korean']
    except Exception as e:
        logger.error(f"MongoDB connection error: {e}")
        raise HTTPException(status_code=500, detail="MongoDB connection failed")

def get_redis_client():
    try:
        redis_client = redis.Redis(
            host=os.getenv('REDIS_HOST', 'redis'),
            port=int(os.getenv('REDIS_PORT', 6379)),
            password=os.getenv('REDIS_PASSWORD'),
            decode_responses=True
        )
        return redis_client
    except Exception as e:
        logger.error(f"Redis connection error: {e}")
        return None

# Pydantic models
class EventLog(BaseModel):
    user_id: int
    event_type: str
    event_data: Dict[str, Any]
    timestamp: Optional[datetime] = None

class UserActivity(BaseModel):
    user_id: int
    date: str
    lesson_count: int
    study_time: int
    quiz_score: float

# Health check
@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "service": "analytics",
        "timestamp": datetime.now().isoformat()
    }

# Log event
@app.post("/api/analytics/events")
def log_event(event: EventLog):
    """Log user event to MongoDB"""
    try:
        db = get_mongodb_client()

        event_doc = {
            "user_id": event.user_id,
            "event_type": event.event_type,
            "event_data": event.event_data,
            "timestamp": event.timestamp or datetime.now()
        }

        result = db.events.insert_one(event_doc)

        return {
            "success": True,
            "event_id": str(result.inserted_id),
            "message": "Event logged successfully"
        }
    except Exception as e:
        logger.error(f"Error logging event: {e}")
        raise HTTPException(status_code=500, detail=str(e))

# Get user activity stats
@app.get("/api/analytics/users/{user_id}/activity")
def get_user_activity(user_id: int, days: int = 7):
    """Get user activity statistics for the last N days"""
    try:
        conn = get_postgres_conn()
        cur = conn.cursor()

        # Get lesson completion stats
        cur.execute("""
            SELECT
                DATE(completed_at) as date,
                COUNT(*) as lessons_completed,
                SUM(time_spent) as total_time,
                AVG(quiz_score) as avg_quiz_score
            FROM user_progress
            WHERE user_id = %s
                AND completed_at >= NOW() - INTERVAL '%s days'
                AND status = 'completed'
            GROUP BY DATE(completed_at)
            ORDER BY date DESC
        """, (user_id, days))

        activity = cur.fetchall()

        cur.close()
        conn.close()

        return {
            "user_id": user_id,
            "period_days": days,
            "activity": [dict(row) for row in activity]
        }
    except Exception as e:
        logger.error(f"Error getting user activity: {e}")
        raise HTTPException(status_code=500, detail=str(e))

# Get learning patterns
@app.get("/api/analytics/users/{user_id}/patterns")
def get_learning_patterns(user_id: int):
    """Analyze user learning patterns"""
    try:
        db = get_mongodb_client()

        # Get events from last 30 days
        start_date = datetime.now() - timedelta(days=30)

        events = list(db.events.find({
            "user_id": user_id,
            "timestamp": {"$gte": start_date}
        }).sort("timestamp", -1))

        # Analyze patterns
        event_types = defaultdict(int)
        hourly_activity = defaultdict(int)

        for event in events:
            event_types[event['event_type']] += 1
            hour = event['timestamp'].hour
            hourly_activity[hour] += 1

        # Find peak learning hours
        peak_hours = sorted(hourly_activity.items(), key=lambda x: x[1], reverse=True)[:3]

        return {
            "user_id": user_id,
            "total_events": len(events),
            "event_type_distribution": dict(event_types),
            "peak_learning_hours": [{"hour": h, "count": c} for h, c in peak_hours],
            "most_active_day": None  # TODO: implement
        }
    except Exception as e:
        logger.error(f"Error analyzing patterns: {e}")
        raise HTTPException(status_code=500, detail=str(e))

# Get overall statistics
@app.get("/api/analytics/stats/overview")
def get_overview_stats():
    """Get overall platform statistics"""
    try:
        conn = get_postgres_conn()
        cur = conn.cursor()

        # Total users
        cur.execute("SELECT COUNT(*) as total_users FROM users")
        total_users = cur.fetchone()['total_users']

        # Active users (last 7 days)
        cur.execute("""
            SELECT COUNT(DISTINCT user_id) as active_users
            FROM learning_sessions
            WHERE created_at >= NOW() - INTERVAL '7 days'
        """)
        active_users = cur.fetchone()['active_users']

        # Total lessons completed
        cur.execute("""
            SELECT COUNT(*) as completed_lessons
            FROM user_progress
            WHERE status = 'completed'
        """)
        completed_lessons = cur.fetchone()['completed_lessons']

        # Average quiz score
        cur.execute("""
            SELECT AVG(quiz_score) as avg_score
            FROM user_progress
            WHERE quiz_score IS NOT NULL
        """)
        avg_score = cur.fetchone()['avg_score']

        cur.close()
        conn.close()

        return {
            "total_users": total_users,
            "active_users_7d": active_users,
            "total_lessons_completed": completed_lessons,
            "average_quiz_score": float(avg_score) if avg_score else 0,
            "timestamp": datetime.now().isoformat()
        }
    except Exception as e:
        logger.error(f"Error getting overview stats: {e}")
        raise HTTPException(status_code=500, detail=str(e))

# Get daily active users
@app.get("/api/analytics/stats/dau")
def get_daily_active_users(days: int = 30):
    """Get daily active users for the last N days"""
    try:
        conn = get_postgres_conn()
        cur = conn.cursor()

        cur.execute("""
            SELECT * FROM daily_active_users
            WHERE activity_date >= NOW() - INTERVAL '%s days'
            ORDER BY activity_date DESC
        """, (days,))

        dau_data = cur.fetchall()

        cur.close()
        conn.close()

        return {
            "period_days": days,
            "data": [dict(row) for row in dau_data]
        }
    except Exception as e:
        logger.error(f"Error getting DAU: {e}")
        raise HTTPException(status_code=500, detail=str(e))

# Get lesson completion trends
@app.get("/api/analytics/stats/lessons")
def get_lesson_stats():
    """Get lesson completion statistics"""
    try:
        conn = get_postgres_conn()
        cur = conn.cursor()

        # Completion rate by lesson
        cur.execute("""
            SELECT
                l.id as lesson_id,
                l.title_ko,
                l.level,
                COUNT(DISTINCT up.user_id) as started_users,
                COUNT(DISTINCT CASE WHEN up.status = 'completed' THEN up.user_id END) as completed_users,
                ROUND(
                    COUNT(DISTINCT CASE WHEN up.status = 'completed' THEN up.user_id END)::numeric /
                    NULLIF(COUNT(DISTINCT up.user_id), 0) * 100,
                    2
                ) as completion_rate
            FROM lessons l
            LEFT JOIN user_progress up ON l.id = up.lesson_id
            GROUP BY l.id, l.title_ko, l.level
            ORDER BY l.level, l.id
        """)

        lesson_stats = cur.fetchall()

        cur.close()
        conn.close()

        return {
            "lessons": [dict(row) for row in lesson_stats]
        }
    except Exception as e:
        logger.error(f"Error getting lesson stats: {e}")
        raise HTTPException(status_code=500, detail=str(e))

# Get vocabulary learning stats
@app.get("/api/analytics/stats/vocabulary")
def get_vocabulary_stats():
    """Get vocabulary learning statistics"""
    try:
        conn = get_postgres_conn()
        cur = conn.cursor()

        # Vocabulary mastery distribution
        cur.execute("""
            SELECT
                mastery_level,
                COUNT(*) as word_count
            FROM vocabulary_progress
            GROUP BY mastery_level
            ORDER BY mastery_level
        """)

        mastery_dist = cur.fetchall()

        # Average ease factor
        cur.execute("""
            SELECT
                AVG(ease_factor) as avg_ease_factor,
                AVG(interval_days) as avg_interval
            FROM vocabulary_progress
        """)

        avg_stats = cur.fetchone()

        cur.close()
        conn.close()

        return {
            "mastery_distribution": [dict(row) for row in mastery_dist],
            "average_ease_factor": float(avg_stats['avg_ease_factor']) if avg_stats['avg_ease_factor'] else 0,
            "average_interval_days": float(avg_stats['avg_interval']) if avg_stats['avg_interval'] else 0
        }
    except Exception as e:
        logger.error(f"Error getting vocabulary stats: {e}")
        raise HTTPException(status_code=500, detail=str(e))

# Get retention metrics
@app.get("/api/analytics/stats/retention")
def get_retention_metrics():
    """Get user retention metrics"""
    try:
        conn = get_postgres_conn()
        cur = conn.cursor()

        # User retention by cohort (simplified version)
        cur.execute("""
            WITH cohorts AS (
                SELECT
                    user_id,
                    DATE_TRUNC('month', created_at) as cohort_month
                FROM users
            ),
            user_activity AS (
                SELECT
                    user_id,
                    DATE_TRUNC('month', created_at) as activity_month
                FROM learning_sessions
            )
            SELECT
                TO_CHAR(c.cohort_month, 'YYYY-MM') as cohort,
                COUNT(DISTINCT c.user_id) as cohort_size,
                COUNT(DISTINCT CASE
                    WHEN ua.activity_month >= c.cohort_month
                    THEN ua.user_id
                END) as retained_users
            FROM cohorts c
            LEFT JOIN user_activity ua ON c.user_id = ua.user_id
            GROUP BY c.cohort_month
            ORDER BY c.cohort_month DESC
            LIMIT 6
        """)

        retention_data = cur.fetchall()

        cur.close()
        conn.close()

        return {
            "retention_by_cohort": [dict(row) for row in retention_data]
        }
    except Exception as e:
        logger.error(f"Error getting retention metrics: {e}")
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    port = int(os.getenv('ANALYTICS_SERVICE_PORT', 3005))
    uvicorn.run(app, host="0.0.0.0", port=port)
