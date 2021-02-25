web: node index.js
web: gunicorn stalwart-keval:app --log-file=-
web: sh setup.sh && streamlit run app.py
