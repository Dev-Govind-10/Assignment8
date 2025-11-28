from flask import Flask, request, jsonify
from business import get_data, set_data

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'

@app.route('/submit', methods=['POST'])
def submit():
    try:
        data = request.json
        if not data:
            return jsonify({"error": "No data provided"}), 400

        # Required fields
        required_fields = ["name", "email", "password", "confirm_password"]

        # Check for missing fields
        missing_fields = [field for field in required_fields if not data.get(field)]
        if missing_fields:
            return jsonify({"error": f"Missing fields: {', '.join(missing_fields)}"}), 400

        set_data(data)
        return jsonify({"message": "Data submitted successfully"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/view')
def view():
    data = get_data()
    # data = list(data)
    # data = { "data" : data }
    return data

if __name__ == '__main__':
    app.run(host= '0.0.0.0', port=8000, debug=True)
