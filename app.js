document.querySelector('.login-form').addEventListener('submit', function (e) {
    e.preventDefault();

    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;

    if (email && password) {
        // Add authentication logic here
        console.log('Logging in with', email, password);
        alert('Login successful!'); // Replace with actual logic
    } else {
        alert('Please fill in all fields.');
    }
});