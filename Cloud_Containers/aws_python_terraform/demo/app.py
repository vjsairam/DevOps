import urllib, json
import random
from flask import Flask

app = Flask(__name__)
@app.route("/")
def hello():
    url = "<Include the URL here to be worked upon>"
    response = urllib.urlopen(url)
    data = json.loads(response.read())
    list2=[]
    for d in data:
        foo = d.get('message')
        list2.append(foo)
    return random.choice(list2)
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int("3000"), debug=True)
    

    
