# Cloud App Backend

This directory contains the backend application code for the Cloud-Native-DevOps-Platform.

## Structure
- **app.py**: Main Flask application.
- **wsgi.py**: WSGI entrypoint for Gunicorn.
- **requirements.txt**: Python dependencies.

## Usage
1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
2. Run the app locally:
   ```bash
   python app.py
   ```
3. For production, use Gunicorn:
   ```bash
   gunicorn --bind 0.0.0.0:8080 wsgi:app
   ```

## Testing
Run unit tests (if present) with pytest:
```bash
pytest
```

## License
MIT
