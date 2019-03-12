from flask import Flask, jsonify
app = Flask(__name__)


@app.route('/')
def hello():
    return "Welcome to demo-api!"

@app.route('/all/')
def get_all():
    tasks = [
        {
            'id':1,
            'task':'this is first task'
        },
        {
            'id':2,
            'task':'this is another task'
        }
    ]
    return jsonify({'tasks':tasks})

@app.route('/info/<name>')
def hello_name(name):
    return jsonify({'info':format(name)})

if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0', port=8090)