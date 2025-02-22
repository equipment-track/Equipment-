import { initializeApp } from "https://www.gstatic.com/firebasejs/10.8.1/firebase-app.js";
import { getAuth, signInWithEmailAndPassword, onAuthStateChanged, signOut } from "https://www.gstatic.com/firebasejs/10.8.1/firebase-auth.js";
import { getFirestore, doc, getDoc } from "https://www.gstatic.com/firebasejs/10.8.1/firebase-firestore.js";

const firebaseConfig = {
    apiKey: "AIzaSyBtuhLluv-z5jGcHq_HL03Xt38q8U6zYsI",
    authDomain: "equipment-trackin.firebaseapp.com",
    projectId: "equipment-trackin",
    storageBucket: "equipment-trackin.firebasestorage.app",
    messagingSenderId: "1050154806013",
    appId: "1:1050154806013:web:72a52bbbe62744abea6c94",
    measurementId: "G-VX9LKVG6ZD"
};

const app = initializeApp(firebaseConfig);
const auth = getAuth();
const db = getFirestore();

const loginPage = document.getElementById("login-page");
const adminPage = document.getElementById("admin-page");
const userPage = document.getElementById("user-page");
const loader = document.getElementById("loader");

function showPage(page) {
    document.querySelectorAll(".page").forEach(p => p.classList.remove("active"));
    document.getElementById(page).classList.add("active");
}

// Login Function
document.getElementById("login-btn").addEventListener("click", async () => {
    const email = document.getElementById("email").value;
    const password = document.getElementById("password").value;
    try {
        loader.style.display = "block";
        const userCredential = await signInWithEmailAndPassword(auth, email, password);
        const user = userCredential.user;

        const userDoc = await getDoc(doc(db, "users", user.uid));
        if (userDoc.exists()) {
            const role = userDoc.data().role;
            localStorage.setItem("role", role);
            role === "admin" ? showPage("admin-page") : showPage("user-page");
        } else {
            document.getElementById("login-error").innerText = "User not found.";
        }
    } catch (error) {
        document.getElementById("login-error").innerText = "Invalid email or password.";
    } finally {
        loader.style.display = "none";
    }
});

// Authentication State Listener
onAuthStateChanged(auth, async (user) => {
    if (user) {
        loader.style.display = "block";
        const userDoc = await getDoc(doc(db, "users", user.uid));
        if (userDoc.exists()) {
            const role = userDoc.data().role;
            showPage(role === "admin" ? "admin-page" : "user-page");
        }
        loader.style.display = "none";
    } else {
        showPage("login-page");
    }
});

// Logout Function
document.getElementById("logout-btn").addEventListener("click", async () => {
    await signOut(auth);
    localStorage.removeItem("role");
    showPage("login-page");
});