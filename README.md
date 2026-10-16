# Maze Escape

Maze Escape is a browser game with eight maze levels, saved scores, achievements,
player messaging and a gameplay chatbot.

## How it runs

The website and database run on Arden University's PHP/MySQL web hosting through cPanel.
The machine learning service and chatbot run on Render.

## Project structure

- `admin` - Administration pages for users and achievements.
- `auth` - Login, registration and logout processing.
- `core` - Database connection, shared functions, header and footer.
- `css` - Website styles.
- `game` - Game data, scores and messaging endpoints.
- `js` - Game and messaging scripts.
- `ml` - Python machine learning service and chatbot.
- `pages` - Website pages.
- `sql` - Database schema and the eight game levels.
- `index.php` - Website entry point.

## Website setup on the web host

1. Upload the project files into the `COM6011` hosting folder using cPanel and extract them.
2. In phpMyAdmin, create a database and import `sql/schema.sql`, then `sql/levels.sql`.
3. Put your own database name, user and password at the top of `core/db.php`. The real values
   used on the Arden web hosting are not in this repository. The ML service address is set there too.

The website works from a subfolder, and its links adjust automatically.

## Machine learning service on Render

Create a **New Web Service** from the GitHub repository with these settings:

- Root directory: `ml`
- Language: Python 3
- Build command: `pip install -r requirements.txt`
- Start command: `gunicorn app:app`
- Instance: Free
- Environment variables: `GROQ_API_KEY` (your Groq key), `GROQ_MODEL`
  (`openai/gpt-oss-20b`) and `ALLOWED_ORIGINS`
  (`https://stu196396.webhosting.arden.ac.uk`, the website address).
- Health check path: `/api/health`

## Game accounts and saved data

This repository has no player accounts or saved games, so select Register to create an account.
To open the admin panel with it, set `is_admin` to 1 for that account in phpMyAdmin.

## Chatbot settings

The Groq key and model are Render environment variables, `GROQ_API_KEY` and `GROQ_MODEL`.
Groq retires models, so if the chatbot stops working because its model is retired,
change `GROQ_MODEL` on Render to a supported model. No code change is needed.

## Troubleshooting

The free Render service sleeps after 15 minutes idle, so the first chatbot reply
can take about a minute. If the ML service is unavailable, the site still works;
only the profile recommendation hides and the chatbot does not reply.
