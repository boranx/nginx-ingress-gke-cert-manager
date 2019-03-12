from flask import Flask, jsonify
app = Flask(__name__)


@app.route('/')
def hello():
    return "Welcome to test-api!"

@app.route('/all/')
def get_all():
    results = [
        {
            "rec_create_date": "12 Jun 2016",
            "rec_dietary_info": "nothing",
            "rec_dob": "01 Apr 1988",
            "rec_first_name": "New",
            "rec_last_name": "Guy",
        },
        {
            "rec_create_date": "1 Apr 2016",
            "rec_dietary_info": "Nut allergy",
            "rec_dob": "01 Feb 1988",
            "rec_first_name": "Old",
            "rec_last_name": "Guy",
        },
    ]
    return jsonify({'employee':results})

@app.route('/info/<name>')
def hello_name(name):
    return jsonify({'info':format(name)})

if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0', port=8091)