from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/contact', methods=['GET', 'POST'])
def contact():
    if request.method == 'POST':
        name = request.form.get('name')
        email = request.form.get('email')
        message = request.form.get('message')
        print(f"📩 New message from {name} ({email}): {message}")
        return render_template('contact.html', success=True)
    return render_template('contact.html', success=False)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
