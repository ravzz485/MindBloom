from flask import Flask, request, jsonify
from flask_cors import CORS
import nltk
import re

nltk.download('stopwords')
nltk.download('punkt')

from nltk.corpus import stopwords

app = Flask(__name__)
CORS(app)

# ─── Clean Text ──────────────────────────────────
def clean_text(text):
    text = re.sub(r'[^a-zA-Z\s]', '', text)
    text = text.lower()
    stop_words = set(stopwords.words('english'))
    words = text.split()
    words = [w for w in words if w not in stop_words]
    return ' '.join(words)

# ─── Keywords ────────────────────────────────────
depression_keywords = [
    "hopeless", "worthless", "empty", "sad",
    "depressed", "crying", "lonely", "miserable",
    "failure", "guilty", "helpless", "numb",
    "meaningless", "exhausted"
]

anxiety_keywords = [
    "panic", "anxious", "worried", "fear",
    "nervous", "stress", "overwhelmed", "tense",
    "restless", "dread", "scared", "uneasy",
    "trembling", "racing"
]

sleep_keywords = [
    "sleep", "insomnia", "tired", "exhausted",
    "fatigue", "nightmare", "awake", "restless"
]

stress_keywords = [
    "stress", "pressure", "burden", "overloaded",
    "overwhelmed", "tense", "irritable",
    "frustrated", "angry", "burnout"
]

# ─── Extract Keywords ─────────────────────────────
def extract_keywords(text):
    text_lower = text.lower()
    found = []

    for word in depression_keywords:
        if word in text_lower:
            found.append({
                "keyword": word,
                "category": "depression"
            })

    for word in anxiety_keywords:
        if word in text_lower:
            found.append({
                "keyword": word,
                "category": "anxiety"
            })

    for word in sleep_keywords:
        if word in text_lower:
            found.append({
                "keyword": word,
                "category": "sleep"
            })

    for word in stress_keywords:
        if word in text_lower:
            found.append({
                "keyword": word,
                "category": "stress"
            })

    return found

# ─── Detect Issue ─────────────────────────────────
def detect_issue(keywords):
    counts = {
        "depression": 0,
        "anxiety": 0,
        "sleep": 0,
        "stress": 0
    }

    for k in keywords:
        counts[k["category"]] += 1

    if all(v == 0 for v in counts.values()):
        return "general"

    return max(counts, key=counts.get)

# ─── Calculate Risk ───────────────────────────────
def calculate_risk(keywords):
    count = len(keywords)
    if count >= 5:
        return "high"
    elif count >= 3:
        return "moderate"
    elif count >= 1:
        return "mild"
    return "low"

# ─── PHQ9 Scoring ────────────────────────────────
def phq9_risk(score):
    if score <= 4:
        return {"level": "minimal", "color": "green", "message": "Minimal depression"}
    elif score <= 9:
        return {"level": "mild", "color": "yellow", "message": "Mild depression"}
    elif score <= 14:
        return {"level": "moderate", "color": "orange", "message": "Moderate depression"}
    return {"level": "severe", "color": "red", "message": "Severe depression"}

# ─── GAD7 Scoring ────────────────────────────────
def gad7_risk(score):
    if score <= 4:
        return {"level": "minimal", "color": "green", "message": "Minimal anxiety"}
    elif score <= 9:
        return {"level": "mild", "color": "yellow", "message": "Mild anxiety"}
    elif score <= 14:
        return {"level": "moderate", "color": "orange", "message": "Moderate anxiety"}
    return {"level": "severe", "color": "red", "message": "Severe anxiety"}

# ─── ROUTES ──────────────────────────────────────

# 1. Test route
@app.route('/', methods=['GET'])
def home():
    return jsonify({
        "message": "🌱 MindBloom ML API running!"
    })

# 2. Analyze symptoms
@app.route('/ml/analyze', methods=['POST'])
def analyze():
    try:
        data = request.json
        text = data.get('text', '')

        if not text:
            return jsonify({
                "error": "No text provided"
            }), 400

        keywords = extract_keywords(text)
        detected_issue = detect_issue(keywords)
        risk_level = calculate_risk(keywords)
        cleaned = clean_text(text)

        return jsonify({
            "success": True,
            "text": text,
            "cleanedText": cleaned,
            "keywords": keywords,
            "detectedIssue": detected_issue,
            "riskLevel": risk_level,
            "keywordCount": len(keywords),
            "disclaimer": "This is not a medical diagnosis."
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# 3. PHQ9 scoring
@app.route('/ml/phq9', methods=['POST'])
def phq9():
    try:
        data = request.json
        answers = data.get('answers', [])
        score = sum(answers)
        risk = phq9_risk(score)

        return jsonify({
            "success": True,
            "score": score,
            "maxScore": 27,
            "riskLevel": risk["level"],
            "color": risk["color"],
            "message": risk["message"],
            "disclaimer": "This is not a medical diagnosis."
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# 4. GAD7 scoring
@app.route('/ml/gad7', methods=['POST'])
def gad7():
    try:
        data = request.json
        answers = data.get('answers', [])
        score = sum(answers)
        risk = gad7_risk(score)

        return jsonify({
            "success": True,
            "score": score,
            "maxScore": 21,
            "riskLevel": risk["level"],
            "color": risk["color"],
            "message": risk["message"],
            "disclaimer": "This is not a medical diagnosis."
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# 5. Trend analysis
@app.route('/ml/trend', methods=['POST'])
def trend():
    try:
        data = request.json
        stress_levels = data.get('stressLevels', [])

        if len(stress_levels) < 2:
            return jsonify({
                "trend": "stable",
                "message": "Not enough data yet!"
            })

        recent = stress_levels[-3:]
        avg_recent = sum(recent) / len(recent)
        avg_all = sum(stress_levels) / len(stress_levels)

        if avg_recent > avg_all + 1:
            trend_result = "worsening"
            message = "⚠️ Your stress has been increasing!"
        elif avg_recent < avg_all - 1:
            trend_result = "improving"
            message = "✅ Your stress is improving!"
        else:
            trend_result = "stable"
            message = "😊 Your stress is stable."

        return jsonify({
            "success": True,
            "trend": trend_result,
            "message": message,
            "averageStress": round(avg_all, 1),
            "recentAverage": round(avg_recent, 1)
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# 6. Sentiment analysis
@app.route('/ml/sentiment', methods=['POST'])
def sentiment():
    try:
        data = request.json
        text = data.get('text', '')

        text_lower = text.lower()

        positive_words = [
            "happy", "great", "good", "amazing",
            "wonderful", "excited", "joy", "love",
            "peaceful", "calm", "better", "hopeful"
        ]

        negative_words = [
            "sad", "depressed", "hopeless", "terrible",
            "awful", "hate", "miserable", "worthless",
            "anxious", "stressed", "panic", "crying"
        ]

        positive_count = sum(
            1 for word in positive_words
            if word in text_lower
        )
        negative_count = sum(
            1 for word in negative_words
            if word in text_lower
        )

        if positive_count > negative_count:
            sentiment_result = "positive"
            score = positive_count
        elif negative_count > positive_count:
            sentiment_result = "negative"
            score = negative_count
        else:
            sentiment_result = "neutral"
            score = 0

        return jsonify({
            "success": True,
            "sentiment": sentiment_result,
            "positiveCount": positive_count,
            "negativeCount": negative_count,
            "score": score
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(port=5001, debug=True)