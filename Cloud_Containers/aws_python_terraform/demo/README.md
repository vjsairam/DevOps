## First build your image with docker 
docker build -t <your username>/myweatherapp .

## To run
docker run -p 8080:3000 -e APIKEY=1234 -d <your username>/myweatherapp


