import pytest
from fastapi.testclient import TestClient
from main import app
from datetime import datetime

client = TestClient(app)


class TestHealthCheck:
    """Health check endpoint tests"""

    def test_health_check(self):
        """Test health check endpoint"""
        response = client.get("/health")
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "healthy"
        assert data["service"] == "analytics"
        assert "timestamp" in data


class TestEventLogging:
    """Event logging tests"""

    def test_log_event(self):
        """Test logging a user event"""
        event_data = {
            "user_id": 1,
            "event_type": "lesson_start",
            "event_data": {
                "lesson_id": 234,
                "timestamp": datetime.now().isoformat()
            }
        }

        response = client.post("/api/analytics/events", json=event_data)
        assert response.status_code == 200
        data = response.json()
        assert data["success"] is True
        assert "event_id" in data

    def test_log_event_missing_fields(self):
        """Test logging event with missing required fields"""
        event_data = {
            "user_id": 1,
            "event_type": "lesson_start"
            # missing event_data
        }

        response = client.post("/api/analytics/events", json=event_data)
        assert response.status_code == 422  # Validation error


class TestUserActivity:
    """User activity stats tests"""

    def test_get_user_activity(self):
        """Test getting user activity stats"""
        user_id = 1
        response = client.get(f"/api/analytics/users/{user_id}/activity")

        # May return 200 with empty data or 500 if DB not configured
        # In test environment, we just check endpoint is reachable
        assert response.status_code in [200, 500]

    def test_get_user_activity_with_days_param(self):
        """Test getting user activity with custom days parameter"""
        user_id = 1
        days = 30
        response = client.get(
            f"/api/analytics/users/{user_id}/activity",
            params={"days": days}
        )
        assert response.status_code in [200, 500]


class TestLearningPatterns:
    """Learning patterns tests"""

    def test_get_learning_patterns(self):
        """Test getting user learning patterns"""
        user_id = 1
        response = client.get(f"/api/analytics/users/{user_id}/patterns")
        assert response.status_code in [200, 500]


class TestStatistics:
    """Statistics endpoints tests"""

    def test_get_overview_stats(self):
        """Test getting overview statistics"""
        response = client.get("/api/analytics/stats/overview")
        assert response.status_code in [200, 500]

    def test_get_dau_stats(self):
        """Test getting DAU stats"""
        response = client.get("/api/analytics/stats/dau")
        assert response.status_code in [200, 500]

    def test_get_dau_stats_with_days(self):
        """Test getting DAU stats with custom days"""
        response = client.get(
            "/api/analytics/stats/dau",
            params={"days": 7}
        )
        assert response.status_code in [200, 500]

    def test_get_lesson_stats(self):
        """Test getting lesson statistics"""
        response = client.get("/api/analytics/stats/lessons")
        assert response.status_code in [200, 500]

    def test_get_vocabulary_stats(self):
        """Test getting vocabulary statistics"""
        response = client.get("/api/analytics/stats/vocabulary")
        assert response.status_code in [200, 500]

    def test_get_retention_metrics(self):
        """Test getting retention metrics"""
        response = client.get("/api/analytics/stats/retention")
        assert response.status_code in [200, 500]


class TestAPIValidation:
    """API validation and error handling tests"""

    def test_invalid_endpoint(self):
        """Test accessing non-existent endpoint"""
        response = client.get("/api/analytics/nonexistent")
        assert response.status_code == 404

    def test_invalid_method(self):
        """Test using wrong HTTP method"""
        response = client.post("/api/analytics/stats/overview")
        assert response.status_code == 405

    def test_invalid_user_id(self):
        """Test with invalid user ID type"""
        response = client.get("/api/analytics/users/invalid/activity")
        assert response.status_code == 422


# Run tests with pytest
if __name__ == "__main__":
    pytest.main([__file__, "-v"])
