web: gunicorn stalwart-keval.wsgi --log-file -
web: gunicorn stalwart-keval:app
web: sh setup.sh && stalwart-keval run app.py
