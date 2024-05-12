from flask import Flask, render_template
import sqlite3

app = Flask(__name__)

# Function to fetch data from the SQLite database
def fetch_data():
    conn = sqlite3.connect('/home/emli/mqtt_scripts/mqtt_logs.db')
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM mqtt_logs')
    data = cursor.fetchall()
    conn.close()
    return data

# Route to display data on the website
@app.route('/')
def index():
    data = fetch_data()
    return render_template('index.html', data=data)

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)
