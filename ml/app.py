import os
from flask import Flask, jsonify
from flask_cors import CORS

from routes.recommend import recommend_bp
from routes.playstyle import playstyle_bp
from routes.chatbot import chatbot_bp

app = Flask(__name__)
ALLOWED_ORIGINS = [
    origin.strip() for origin in os.environ.get('ALLOWED_ORIGINS', '').split(',')
    if origin.strip()
] or [
    'https://stu196396.webhosting.arden.ac.uk',
]
CORS(app, resources={r'/api/*': {'origins': ALLOWED_ORIGINS}})

app.register_blueprint(recommend_bp)
app.register_blueprint(playstyle_bp)
app.register_blueprint(chatbot_bp)


@app.route('/')
def index():
    return jsonify({
        'service': 'Maze Escape ML',
        'status': 'running',
        'endpoints': [
            '/api/health',
            '/api/recommend',
            '/api/playstyle',
            '/api/chatbot',
        ],
    })


@app.route('/api/health')
def health():
    return jsonify({
        'status': 'ok',
        'chatbot_configured': bool(os.environ.get('GROQ_API_KEY')),
    })


if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
