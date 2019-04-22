# nodejs-weather-app
Sample application using nodejs to search local weather
For more information check out the blog post
[http://taswar.zeytinsoft.com/creating-a-nodejs-application-with-vscode/](http://taswar.zeytinsoft.com/creating-a-nodejs-application-with-vscode/)

## First build your image with docker 
docker build -t <your username>/myweatherapp .

## To run
docker run -p 8080:3000 -e APIKEY=1234 -d <your username>/myweatherapp

Note: You need your openweather APIKEY above
Get it from https://openweathermap.org/
