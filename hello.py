from flask import Flask


app = Flask(__name__)


@app.route('/')
def hello_world():
    return "Please visit: https://github.com/votestakes"


if __name__ == '__main__':
    app.run()
