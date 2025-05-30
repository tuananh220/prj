<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8" />
<title>Đăng nhập – AnhNT</title>
<style>
  /* ===== RESET & FONT ===== */
  html, body {
    margin: 0; padding: 0; height: 100%; overflow: hidden;
    font-family: 'Segoe UI', Tahoma, Verdana, sans-serif;
    background: #000;
  }

  /* ===== CANVAS THREE.JS ===== */
  #bg {
    position: fixed; top: 0; left: 0;
    width: 100vw; height: 100vh;
    z-index: 0;
  }

  /* ===== BOX LOGIN ===== */
  .login-box {
    width: 380px;
    background: rgba(30,30,30,0.3);
    border-radius: 20px;
    padding: 40px 30px;
    box-shadow: 0 15px 30px rgba(0,0,0,0.9), inset 0 0 40px #00aaff33;
    position: relative;
    z-index: 10;
    margin: auto;
    top: 50%;
    transform: translateY(-50%);
    overflow: hidden;
    user-select: none;
  }
  .login-box h2 {
    color: #00aaff;
    font-size: 28px;
    margin-bottom: 30px;
    text-align: center;
  }
  label {
    color: #aaa;
    font-weight: 600;
    font-size: 14px;
    margin-bottom: 8px;
    display: block;
  }
  input[type=text], input[type=password] {
    width: 100%;
    padding: 14px 18px;
    margin-bottom: 20px;
    border-radius: 12px;
    border: none;
    background: #222;
    color: #eee;
    font-size: 16px;
    box-shadow: inset 0 0 6px #00aaff55;
    outline: none;
    transition: background-color 0.3s, box-shadow 0.3s;
  }
  input[type=text]:focus, input[type=password]:focus {
    box-shadow: 0 0 12px #00aaffcc;
    background: #111;
    color: #fff;
  }
  button {
    width: 100%;
    padding: 16px 0;
    border: none;
    border-radius: 14px;
    cursor: pointer;
    background: linear-gradient(90deg, #00aaff, #005f99);
    color: #e0f7ff;
    font-size: 18px;
    font-weight: 700;
    transition: transform 0.15s ease, box-shadow 0.15s ease;
  }
  button:hover {
    transform: scale(1.03);
    box-shadow: 0 0 20px #00ccff, 0 8px 20px #0077cc;
  }
  button:active {
    transform: scale(0.97);
  }
  .remember {
    color: #888;
    font-size: 14px;
    margin-bottom: 18px;
    display: flex;
    align-items: center;
  }
  .remember input {
    margin-right: 8px;
    cursor: pointer;
  }
  .error {
    color: #ff5555;
    font-weight: 700;
    font-size: 14px;
    margin-top: 10px;
    text-align: center;
  }

  /* ===== LIGHT SCAN (ánh sáng quét) ===== */
  .light-scan {
    position: absolute;
    top: 0; left: -80%;
    width: 60%; height: 100%;
    background: linear-gradient(120deg, transparent 0%, rgba(255,255,255,0.25) 50%, transparent 100%);
    transform: skewX(-25deg);
    filter: blur(8px);
    animation: scan 2.5s linear infinite;
    pointer-events: none;
    z-index: 25;
    opacity: 0.7;
  }
  @keyframes scan {
    0% { left: -80%; }
    100% { left: 130%; }
  }

  /* ===== NÚT NHẠC ===== */
  #musicBtn {
    position: fixed;
    bottom: 20px; right: 20px;
    z-index: 30;
    border: none;
    border-radius: 50%;
    width: 48px; height: 48px;
    background: #00aaffaa;
    color: #fff;
    font-size: 22px;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    backdrop-filter: blur(4px);
    transition: background-color 0.3s ease;
  }
  #musicBtn:hover {
    background: #00ccff;
  }
</style>
</head>
<body>
<canvas id="bg"></canvas>

<div class="login-box">
  <div class="light-scan"></div>

  <h2>Đăng nhập</h2>
  <form action="login" method="post" onsubmit="saveIfRemember()">
    <label for="username">Tên đăng nhập:</label>
    <input type="text" id="username" name="username" required />
    <label for="password">Mật khẩu:</label>
    <input type="password" id="password" name="password" required />
    <div class="remember">
      <input type="checkbox" id="rememberMe" />
      <label for="rememberMe" style="display:inline">Nhớ tài khoản</label>
    </div>
    <button type="submit">Đăng nhập</button>
  </form>

  <% String error = (String)request.getAttribute("errorMessage");
     if(error != null) { %>
    <div class="error"><%= error %></div>
  <% } %>
</div>

<!-- Nút nhạc & audio -->
<button id="musicBtn" aria-label="Toggle music">►</button>
<audio id="bgMusic" loop preload="auto">
  <source src="https://zingmp3.vn/embed/song/Z7U7IFEW?start=false" type="audio/mpeg" />
</audio>

<!-- THREE.JS & SCENE -->
<script type="module">
import * as THREE from 'https://cdn.skypack.dev/three@0.150.0';

const canvas = document.getElementById('bg');
const renderer = new THREE.WebGLRenderer({ canvas, alpha: true });
renderer.setSize(window.innerWidth, window.innerHeight);
renderer.setPixelRatio(window.devicePixelRatio);

const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera(75, window.innerWidth/window.innerHeight, 0.1, 1000);
camera.position.z = 50;

// ----- PART 1: Background particles -----
const particleCount = 500;
const positionsBG = new Float32Array(particleCount * 3);

for (let i = 0; i < particleCount; i++) {
  positionsBG[i*3] = (Math.random() - 0.5) * 100;
  positionsBG[i*3 + 1] = (Math.random() - 0.5) * 100;
  positionsBG[i*3 + 2] = (Math.random() - 0.5) * 100;
}

const geometryBG = new THREE.BufferGeometry();
geometryBG.setAttribute('position', new THREE.Float32BufferAttribute(positionsBG, 3));

const materialBG = new THREE.PointsMaterial({
  color: 0x00aaff,
  size: 1.5,
  transparent: true,
  opacity: 0.7,
  blending: THREE.AdditiveBlending,
  depthWrite: false
});

const pointsBG = new THREE.Points(geometryBG, materialBG);
scene.add(pointsBG);

// ----- PART 2: Tạo chữ "AnhNT" từ canvas 2D thành điểm -----

const textCanvas = document.createElement('canvas');
const ctx = textCanvas.getContext('2d');
textCanvas.width = 256;
textCanvas.height = 64;

// Vẽ chữ lên canvas 2D
ctx.fillStyle = 'black';
ctx.fillRect(0, 0, textCanvas.width, textCanvas.height);
ctx.font = 'bold 48px Segoe UI, sans-serif';
ctx.fillStyle = 'white';
ctx.textBaseline = 'middle';
ctx.textAlign = 'center';
ctx.fillText('AnhNT', textCanvas.width / 2, textCanvas.height / 2);

// Lấy dữ liệu điểm ảnh
const imgData = ctx.getImageData(0, 0, textCanvas.width, textCanvas.height);
const data = imgData.data;

const positionsText = [];
const colorsText = [];
const sizesText = [];

const spacing = 0.7;

for(let y = 0; y < textCanvas.height; y += 2) {
  for(let x = 0; x < textCanvas.width; x += 2) {
    const i = (y * textCanvas.width + x) * 4;
    const r = data[i], g = data[i + 1], b = data[i + 2];
    if (r + g + b > 200) {  // pixel sáng => tạo điểm
      const px = (x - textCanvas.width / 2) * spacing;
      const py = -(y - textCanvas.height / 2) * spacing;
      const pz = (Math.random() - 0.5) * 5;

      positionsText.push(px, py, pz);
      colorsText.push(0.2, 0.8, 1);  // xanh dương
      sizesText.push(1 + Math.random() * 2);
    }
  }
}

const geometryText = new THREE.BufferGeometry();
geometryText.setAttribute('position', new THREE.Float32BufferAttribute(positionsText, 3));
geometryText.setAttribute('color', new THREE.Float32BufferAttribute(colorsText, 3));
geometryText.setAttribute('size', new THREE.Float32BufferAttribute(sizesText, 1));

const materialText = new THREE.PointsMaterial({
  size: 2,
  vertexColors: true,
  transparent: true,
  opacity: 1,
  blending: THREE.AdditiveBlending,
  depthWrite: false
});

const pointsText = new THREE.Points(geometryText, materialText);
scene.add(pointsText);


// ----- ANIMATION -----
function animate(t) {
  requestAnimationFrame(animate);
  const time = t * 0.001;

  // Quay background particles
  pointsBG.rotation.y = time * 0.1;
  pointsBG.rotation.x = time * 0.05;

  // Quay chữ "AnhNT" chậm hơn để nổi bật
  pointsText.rotation.y = time * 0.03;
  pointsText.rotation.x = time * 0.015;

  renderer.render(scene, camera);
}

animate();

window.addEventListener('resize', () => {
  renderer.setSize(window.innerWidth, window.innerHeight);
  camera.aspect = window.innerWidth/window.innerHeight;
  camera.updateProjectionMatrix();
});



</script>

<!-- REMEMBER ME JS -->
<script>
function saveIfRemember() {
  const usernameInput = document.getElementById('username');
  const passwordInput = document.getElementById('password');
  const rememberCheckbox = document.getElementById('rememberMe');

  if (rememberCheckbox.checked) {
    localStorage.setItem('remember_login', JSON.stringify({
      u: usernameInput.value,
      p: passwordInput.value
    }));
  } else {
    localStorage.removeItem('remember_login');
  }
}

window.onload = () => {
  const saved = localStorage.getItem('remember_login');
  if (saved) {
    try {
      const data = JSON.parse(saved);
      document.getElementById('username').value = data.u || '';
      document.getElementById('password').value = data.p || '';
      document.getElementById('rememberMe').checked = true;
    } catch(e) {
      // nếu dữ liệu sai định dạng JSON thì xóa đi
      localStorage.removeItem('remember_login');
    }
  }
};

// Nút bật/tắt nhạc
const musicBtn = document.getElementById('musicBtn');
const bgMusic = document.getElementById('bgMusic');
let isPlaying = false;

musicBtn.addEventListener('click', () => {
  if (isPlaying) {
    bgMusic.pause();
    musicBtn.textContent = '►';
  } else {
    bgMusic.play();
    musicBtn.textContent = '❚❚';
  }
  isPlaying = !isPlaying;
});
</script>
</body>
</html>
