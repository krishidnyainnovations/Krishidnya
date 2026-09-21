@echo off
cd /d C:\Users\Krishidnya\Desktop\Krishidnya\BackendKrishidnya
docker-compose up -d
echo Backend server started successfully!
echo Backend API: http://localhost:8000
echo Adminer: http://localhost:8080
echo Starting ngrok tunnel in new window...
start "" cmd /k "ngrok http 8000"
echo Services started! Keep this window open to manage containers.
echo Press Ctrl+C to stop Docker containers.
docker-compose logs -f
