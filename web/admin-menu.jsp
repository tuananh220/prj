<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    } else if (!"admin".equals(user.getRole())) {
        out.println("<h3 style='color:red; text-align:center;'>Access denied. Bạn không có quyền truy cập trang này.</h3>");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Admin Menu</title>
    <link rel="icon" href="favicon.ico" />
    <meta name="description" content="Trang quản lý dành cho Admin, quản lý món ăn, đơn hàng, người dùng và báo cáo doanh thu." />
    
    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet" />
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <!-- Three.js -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
    <!-- GSAP -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>

    <style>
        /* Reset */
        *, *::before, *::after {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #0f0f23, #1a1a2e);
            color: #fff;
            min-height: 100vh;
            overflow-x: hidden;
            position: relative;
        }

        /* Three.js Canvas Background */
        #three-canvas {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            opacity: 0.7;
        }

        /* Main Container */
        .page-wrapper {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            justify-content: center;
            align-items: center;
            padding: 2rem 1rem;
            position: relative;
            z-index: 1;
        }

        main.container {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            max-width: 480px;
            width: 100%;
            border-radius: 20px;
            padding: 3rem 2.5rem;
            box-shadow: 
                0 20px 40px rgba(0,0,0,0.3),
                inset 0 1px 0 rgba(255,255,255,0.1);
            text-align: center;
            position: relative;
            opacity: 0;
            transform: translateY(50px) scale(0.95);
        }

        /* Glassmorphism effect */
        main.container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, 
                rgba(255,255,255,0.1) 0%, 
                rgba(255,255,255,0.05) 50%, 
                rgba(255,255,255,0.02) 100%);
            border-radius: 20px;
            pointer-events: none;
        }

        h2 {
            font-weight: 700;
            font-size: 2.2rem;
            margin-bottom: 2.5rem;
            letter-spacing: 0.02em;
            color: #fff;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
            position: relative;
        }

        h2::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 60px;
            height: 3px;
            background: linear-gradient(90deg, #6366f1, #8b5cf6);
            border-radius: 2px;
        }

        ul {
            list-style: none;
            padding: 0;
            margin: 0 0 2.5rem 0;
        }

        li {
            margin-bottom: 1.5rem;
            opacity: 0;
            transform: translateX(-30px);
        }

        a.menu-link {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 18px 24px;
            border-radius: 16px;
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.15);
            color: #e2e8f0;
            font-weight: 600;
            font-size: 1.1rem;
            text-decoration: none;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            user-select: none;
            position: relative;
            overflow: hidden;
        }

        a.menu-link::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, 
                transparent, 
                rgba(255,255,255,0.1), 
                transparent);
            transition: left 0.6s ease;
        }

        a.menu-link:hover::before {
            left: 100%;
        }

        a.menu-link:hover, a.menu-link:focus {
            background: rgba(99, 102, 241, 0.2);
            border-color: rgba(99, 102, 241, 0.4);
            color: #fff;
            transform: translateY(-4px) scale(1.02);
            box-shadow: 
                0 10px 30px rgba(99, 102, 241, 0.3),
                0 0 20px rgba(99, 102, 241, 0.1);
            outline: none;
        }

        a.menu-link i {
            font-size: 1.4rem;
            flex-shrink: 0;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        form.logout-form {
            margin-top: 0;
            opacity: 0;
            transform: translateY(20px);
        }

        button.logout-btn {
            background: rgba(239, 68, 68, 0.1);
            border: 2px solid rgba(239, 68, 68, 0.3);
            color: #fca5a5;
            font-weight: 600;
            padding: 16px 28px;
            border-radius: 16px;
            font-size: 1.05rem;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 12px;
            user-select: none;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            backdrop-filter: blur(10px);
        }

        button.logout-btn:hover, button.logout-btn:focus {
            background: rgba(239, 68, 68, 0.2);
            border-color: rgba(239, 68, 68, 0.5);
            color: #fff;
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 8px 25px rgba(239, 68, 68, 0.3);
            outline: none;
        }

        button.logout-btn i {
            font-size: 1.3rem;
        }

        footer {
            background: rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(10px);
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: #cbd5e1;
            padding: 25px 0;
            text-align: center;
            font-size: 14px;
            margin-top: 60px;
            width: 100%;
            position: relative;
            z-index: 1;
        }

        footer .container {
            max-width: 480px;
            margin: 0 auto;
            padding: 0 1rem;
        }

        footer a {
            color: #94a3b8;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        footer a:hover, footer a:focus {
            color: #6366f1;
            text-decoration: underline;
            outline: none;
        }

        /* Floating particles */
        .particle {
            position: absolute;
            background: rgba(99, 102, 241, 0.6);
            border-radius: 50%;
            pointer-events: none;
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }

        /* Loading overlay */
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: #0f0f23;
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1000;
            transition: opacity 0.5s ease;
        }

        .loading-spinner {
            width: 50px;
            height: 50px;
            border: 3px solid rgba(99, 102, 241, 0.3);
            border-top: 3px solid #6366f1;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        @media (max-width: 480px) {
            main.container {
                padding: 2.5rem 2rem;
                max-width: 90%;
            }
            
            h2 {
                font-size: 1.8rem;
            }
            
            a.menu-link {
                font-size: 1rem;
                padding: 16px 20px;
                gap: 12px;
            }
            
            button.logout-btn {
                width: 100%;
                padding: 18px 0;
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner"></div>
    </div>

    <!-- Three.js Canvas -->
    <canvas id="three-canvas"></canvas>

    <div class="page-wrapper">
        <main class="container" id="mainContainer" role="main" aria-label="Menu quản lý dành cho Admin">
            <h2 id="mainTitle">Menu quản lý dành cho Admin</h2>
            <ul id="menuList">
                <li><a href="food-list" class="menu-link"><i class="fa-solid fa-utensils"></i> Quản lý món ăn</a></li>
                <li><a href="order-list" class="menu-link"><i class="fa-solid fa-receipt"></i> Quản lý đơn hàng</a></li>
                <li><a href="user-list" class="menu-link"><i class="fa-solid fa-users"></i> Quản lý người dùng</a></li>
                <li><a href="revenue-report" class="menu-link"><i class="fa-solid fa-chart-line"></i> Báo cáo doanh thu</a></li>
                <li><a href="menu" class="menu-link"><i class="fa-solid fa-house"></i> Xem giao diện người dùng</a></li>
            </ul>

            <form action="logout" method="get" class="logout-form" id="logoutForm" aria-label="Đăng xuất">
                <button type="submit" class="logout-btn"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</button>
            </form>
        </main>

        <footer>
            <div class="container">
                <p>&copy; 2025 AnhNT. All rights reserved.</p>
                <p><a href="${pageContext.request.contextPath}/support">Hỗ trợ</a> | 
                   Liên hệ: 0923894829 | Địa chỉ: Hoà Lạc – Thạch Thất – Hà Nội</p>
                <p style="font-style:italic">Thiết kế bởi AnhNT</p>
            </div>
        </footer>
    </div>

    <script>
        // Three.js Scene Setup
        let scene, camera, renderer, particles = [];
        let mouseX = 0, mouseY = 0;

        function initThreeJS() {
            scene = new THREE.Scene();
            camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
            renderer = new THREE.WebGLRenderer({ 
                canvas: document.getElementById('three-canvas'), 
                alpha: true,
                antialias: true 
            });
            
            renderer.setSize(window.innerWidth, window.innerHeight);
            renderer.setClearColor(0x000000, 0);

            // Create floating particles
            const particleGeometry = new THREE.SphereGeometry(0.5, 8, 8);
            const particleMaterial = new THREE.MeshBasicMaterial({ 
                color: 0x6366f1,
                transparent: true,
                opacity: 0.6
            });

            for (let i = 0; i < 50; i++) {
                const particle = new THREE.Mesh(particleGeometry, particleMaterial);
                particle.position.x = (Math.random() - 0.5) * 100;
                particle.position.y = (Math.random() - 0.5) * 100;
                particle.position.z = (Math.random() - 0.5) * 100;
                particle.userData = {
                    originalY: particle.position.y,
                    speed: Math.random() * 0.02 + 0.01
                };
                scene.add(particle);
                particles.push(particle);
            }

            // Create wireframe torus
            const torusGeometry = new THREE.TorusGeometry(10, 3, 16, 100);
            const torusMaterial = new THREE.MeshBasicMaterial({ 
                color: 0x8b5cf6,
                wireframe: true,
                transparent: true,
                opacity: 0.3
            });
            const torus = new THREE.Mesh(torusGeometry, torusMaterial);
            torus.position.z = -30;
            scene.add(torus);

            camera.position.z = 30;

            // Animation loop
            function animate() {
                requestAnimationFrame(animate);

                // Rotate torus
                torus.rotation.x += 0.005;
                torus.rotation.y += 0.01;

                // Animate particles
                particles.forEach((particle, index) => {
                    particle.position.y = particle.userData.originalY + Math.sin(Date.now() * particle.userData.speed + index) * 5;
                    particle.rotation.x += 0.01;
                    particle.rotation.y += 0.01;
                });

                // Mouse interaction
                camera.position.x += (mouseX - camera.position.x) * 0.05;
                camera.position.y += (-mouseY - camera.position.y) * 0.05;
                camera.lookAt(scene.position);

                renderer.render(scene, camera);
            }

            animate();
        }

        // Mouse movement
        document.addEventListener('mousemove', (event) => {
            mouseX = (event.clientX / window.innerWidth) * 2 - 1;
            mouseY = (event.clientY / window.innerHeight) * 2 - 1;
        });

        // Window resize
        window.addEventListener('resize', () => {
            camera.aspect = window.innerWidth / window.innerHeight;
            camera.updateProjectionMatrix();
            renderer.setSize(window.innerWidth, window.innerHeight);
        });

        // GSAP Animations
        function initAnimations() {
            // Hide loading overlay
            gsap.to("#loadingOverlay", {
                opacity: 0,
                duration: 0.5,
                onComplete: () => {
                    document.getElementById('loadingOverlay').style.display = 'none';
                }
            });

            // Main container entrance
            gsap.to("#mainContainer", {
                opacity: 1,
                y: 0,
                scale: 1,
                duration: 1,
                ease: "back.out(1.7)",
                delay: 0.3
            });

            // Title animation
            gsap.from("#mainTitle", {
                y: -30,
                opacity: 0,
                duration: 0.8,
                ease: "power2.out",
                delay: 0.5
            });

            // Menu items stagger animation
            gsap.to("#menuList li", {
                opacity: 1,
                x: 0,
                duration: 0.6,
                stagger: 0.1,
                ease: "power2.out",
                delay: 0.7
            });

            // Logout form animation
            gsap.to("#logoutForm", {
                opacity: 1,
                y: 0,
                duration: 0.6,
                ease: "power2.out",
                delay: 1.2
            });

            // Add hover animations for menu links
            document.querySelectorAll('.menu-link').forEach(link => {
                link.addEventListener('mouseenter', () => {
                    gsap.to(link, {
                        scale: 1.02,
                        duration: 0.3,
                        ease: "power2.out"
                    });
                });

                link.addEventListener('mouseleave', () => {
                    gsap.to(link, {
                        scale: 1,
                        duration: 0.3,
                        ease: "power2.out"
                    });
                });
            });

            // Floating animation for container
            gsap.to("#mainContainer", {
                y: -10,
                duration: 3,
                ease: "power1.inOut",
                yoyo: true,
                repeat: -1
            });
        }

        // Create floating HTML particles
        function createFloatingParticles() {
            for (let i = 0; i < 5; i++) {
                const particle = document.createElement('div');
                particle.className = 'particle';
                particle.style.width = Math.random() * 4 + 2 + 'px';
                particle.style.height = particle.style.width;
                particle.style.left = Math.random() * 100 + '%';
                particle.style.top = Math.random() * 100 + '%';
                particle.style.animationDelay = Math.random() * 3 + 's';
                document.body.appendChild(particle);

                // Remove particle after animation
                setTimeout(() => {
                    if (particle.parentNode) {
                        particle.parentNode.removeChild(particle);
                    }
                }, 6000);
            }
        }

        // Initialize everything
        window.addEventListener('load', () => {
            initThreeJS();
            initAnimations();
            
            // Create floating particles periodically
            setInterval(createFloatingParticles, 2000);
        });

        // Add click ripple effect
        document.addEventListener('click', (e) => {
            const ripple = document.createElement('div');
            ripple.style.position = 'fixed';
            ripple.style.left = e.clientX - 10 + 'px';
            ripple.style.top = e.clientY - 10 + 'px';
            ripple.style.width = '20px';
            ripple.style.height = '20px';
            ripple.style.borderRadius = '50%';
            ripple.style.background = 'rgba(99, 102, 241, 0.6)';
            ripple.style.pointerEvents = 'none';
            ripple.style.zIndex = '9999';
            document.body.appendChild(ripple);

            gsap.to(ripple, {
                scale: 4,
                opacity: 0,
                duration: 0.6,
                ease: "power2.out",
                onComplete: () => {
                    if (ripple.parentNode) {
                        ripple.parentNode.removeChild(ripple);
                    }
                }
            });
        });
    </script>
</body>
</html>