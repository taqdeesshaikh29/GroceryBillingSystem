<%@ page import="java.sql.*,dao.DBConnection" %>
<%@ page session="true" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
    <title>Products</title>
    <style>
        body { font-family: Arial,sans-serif; background: #f5f5f5; margin:0; text-align:center; }
        h2 { color:#333; }

        /* Hamburger Menu */
        .menu-icon { font-size:26px; cursor:pointer; position:absolute; top:15px; left:15px; color:#333; }
        .sidenav { height:100%; width:0; position:fixed; z-index:1000; top:0; left:0;
            background-color:#111; overflow-x:hidden; transition:0.3s; padding-top:60px; }
        .sidenav a { padding:12px 24px; text-decoration:none; font-size:18px; color:#f1f1f1; display:block; transition:0.2s; }
        .sidenav a:hover { background-color:#575757; }
        .sidenav .closebtn { position:absolute; top:15px; right:20px; font-size:30px; color:#fff; }

        /* Products Grid */
        .products-container { display:grid; grid-template-columns:repeat(auto-fit,minmax(220px,1fr)); gap:20px; width:90%; margin:20px auto; }
        .product-card { position:relative; background:white; padding:15px; border-radius:10px; box-shadow:0 4px 8px rgba(0,0,0,0.1); transition:transform 0.2s; }
        .product-card:hover { transform:scale(1.05); }
        .product-card img { width:100%; height:150px; object-fit:cover; border-radius:8px; margin-bottom:10px; }
        .product-card h3 { margin:5px 0; font-size:18px; color:#444; }
        .product-card p { margin:5px 0; font-size:16px; color:#777; }
        .product-card button { background:#28a745; border:none; color:white; padding:8px 12px; border-radius:5px; cursor:pointer; }
        .product-card button:hover { background:#218838; }

        /* Quantity Counter */
        .qty-controls { display:flex; justify-content:center; align-items:center; gap:8px; margin-top:5px; }
        .qty-controls button { background:#28a745; border:none; color:white; padding:5px 10px; border-radius:5px; cursor:pointer; font-size:16px; }
        .qty-controls span { font-size:16px; font-weight:bold; }

        /* Unit Dropdown */
        .unit-select { margin-bottom:5px; padding:5px; font-size:16px; border-radius:5px; border:1px solid #ccc; }

        /* Filter */
        .filter-container { background:#fff; padding:15px 20px; width:90%; margin:0 auto 30px auto; border-radius:12px;
            box-shadow:0 4px 8px rgba(0,0,0,0.1); display:flex; justify-content:center; align-items:center; gap:10px; }
        .filter-container:hover { transform:scale(1.02); }
        .filter-container label { font-size:16px; color:#333; font-weight:500; }
        .filter-container select { padding:6px 12px; font-size:16px; }

        /* Discount Badge */
        .discount-badge { 
            position:absolute; 
            top:10px; 
            right:10px; 
            background:red; 
            color:white; 
            padding:2px 6px; 
            border-radius:5px; 
            font-size:12px; 
            font-weight:bold; 
            animation:flash 1s infinite alternate; 
            max-width:50px; 
            text-overflow:ellipsis; 
            overflow:hidden; 
            white-space:nowrap;
        }
        @keyframes flash { 0% { opacity:1; } 100% { opacity:0.5; } }

        /* Welcome Banner */
        .welcome-banner { background:linear-gradient(90deg,#ffecd2,#fcb69f); color:#333; padding:25px 20px; margin:30px auto 20px auto;
            width:90%; border-radius:15px; box-shadow:0 6px 12px rgba(0,0,0,0.15); text-align:center; transition:transform 0.3s; }
        .welcome-banner:hover { transform:scale(1.02); }
        .welcome-banner h2 { margin:0 0 10px 0; font-size:28px; }
        .welcome-banner p { margin:0; font-size:16px; color:#555; }

        /* Section Title */
        .section-title { width:90%; margin:20px auto 10px auto; text-align:center; }
        .section-title h3 { font-size:24px; color:#444; border-bottom:2px solid #28a745; display:inline-block; padding-bottom:5px; }

        /* Floating Cart Icon */
        .cart-icon { position:fixed; top:20px; right:20px; font-size:26px; text-decoration:none; color:white;
            background:#28a745; padding:14px 18px; border-radius:50%; box-shadow:0 6px 12px rgba(0,0,0,0.2); z-index:2000;
            transition:transform 0.2s, background 0.2s; }
        .cart-icon:hover { background:#218838; transform:scale(1.1); }
        #cart-count { position:absolute; top:8px; right:8px; background:red; color:white; font-size:14px;
            font-weight:bold; padding:2px 8px; border-radius:50%;min-width: 20px;     /* added */
    height: 20px;        /* added */
    line-height: 20px;   /* added */
    text-align: center;  /* added */
    display: inline-block; }
    </style>
</head>
<body>
    <!-- Hamburger Menu -->
    <span class="menu-icon" onclick="openNav()">&#9776;</span>
    <div id="mySidenav" class="sidenav">
        <a href="javascript:void(0)" class="closebtn" onclick="closeNav()">&times;</a>
        <a href="products.jsp">🏠 Home</a>
        <a href="feedback.jsp">Feedback</a>
        <a href="rateUs.jsp">Rate Us</a>
        <a href="previousOrders.jsp">Previous Orders</a>
        <a href="products.jsp?discounts=true">🎉 Discounts</a>
        <a href="logout.jsp">🚪 Logout</a>
    </div>

    <!-- Floating Cart Icon -->
    <a href="cart.jsp" class="cart-icon">
        🛒<span id="cart-count"><%= session.getAttribute("cartCount") != null ? session.getAttribute("cartCount") : 0 %></span>
    </a>

    <!-- Welcome Banner -->
    <div class="welcome-banner">
        <h2>👋 Welcome, <%= session.getAttribute("userName") %>!</h2>
        <p>Explore our fresh grocery items and get the best deals today!</p>
    </div>

    <!-- Section Title -->
    <div class="section-title"><h3>Available Grocery Items</h3></div>

    <!-- Filter Section -->
    <div class="filter-container">
        <form method="get" action="products.jsp">
            <label for="category">🔍 Filter by Category:</label>
            <select name="category" id="category" onchange="this.form.submit()">
                <option value="All" <%= "All".equals(request.getParameter("category")) || request.getParameter("category")==null?"selected":"" %>>All</option>
                <option value="Dairy & Bakery" <%= "Dairy & Bakery".equals(request.getParameter("category"))?"selected":"" %>>Dairy & Bakery</option>
                <option value="Grains & Pulses" <%= "Grains & Pulses".equals(request.getParameter("category"))?"selected":"" %>>Grains & Pulses</option>
                <option value="Oils & Essentials" <%= "Oils & Essentials".equals(request.getParameter("category"))?"selected":"" %>>Oils & Essentials</option>
                <option value="Packaged Foods" <%= "Packaged Foods".equals(request.getParameter("category"))?"selected":"" %>>Packaged Foods</option>
                <option value="Spices" <%= "Spices".equals(request.getParameter("category"))?"selected":"" %>>Spices</option>
            </select>
        </form>
    </div>

    <!-- Products Container -->
    <div class="products-container">
       <%
        String category = request.getParameter("category");
        String sql = "SELECT * FROM products";
        boolean hasFilter = (category != null && !"All".equals(category));
        if(hasFilter) sql += " WHERE category = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if(hasFilter) ps.setString(1, category);

            try (ResultSet rs = ps.executeQuery()) {
                boolean foundAny = false;
                while(rs.next()){
                    foundAny = true;
                    int productId = rs.getInt("id");
                    String name = rs.getString("name");
                    double price = rs.getDouble("price");
                    int stock = rs.getInt("stock");
                    String unitType = rs.getString("unit_type");
       %>
        <div class="product-card">
            <% if(rs.getString("discount")!=null && !rs.getString("discount").isEmpty()){ %>
                <div class="discount-badge"><%= rs.getString("discount") %></div>
            <% } %>
            <img src="images/<%= rs.getString("image") %>" alt="<%= name %>">
            <h3><%= name %></h3>
            <p>Price: &#8377;<%= price %></p>
            <p>Stock: <%= stock %></p>

            <div class="cart-action" 
                 data-id="<%=productId%>" 
                 data-name="<%=name%>" 
                 data-price="<%=price%>" 
                 data-stock="<%=stock%>">

                <select class="unit-select">
                    <% if("L".equalsIgnoreCase(unitType)){ %>
                        <option value="ml" data-qty="500">500 ml</option>
                        <option value="L" data-qty="1">1 L</option>
                    <% } else if("kg".equalsIgnoreCase(unitType) || "gm".equalsIgnoreCase(unitType)){ %>
                        <option value="gm" data-qty="500">500 gm</option>
                        <option value="kg" data-qty="1">1 kg</option>
                    <% } else { %>
                        <option value="unit" data-qty="1">1 unit</option>
                        <option value="unit" data-qty="2">2 units</option>
                    <% } %>
                </select>

                <button class="add-btn">Add to Cart</button>
            </div>
        </div>
       <%
                }
                if(!foundAny){
       %>
        <p style="width:100%;text-align:center;color:red;">⚠️ No products found for this category</p>
       <%
                }
            }
        } catch(Exception e){ e.printStackTrace(); }
       %>
    </div>

    <br>
    <a href="products.jsp" class="back-home">🏠 Back to Home</a>

    <script>
        function openNav(){ document.getElementById("mySidenav").style.width="250px"; }
        function closeNav(){ document.getElementById("mySidenav").style.width="0"; }

        // Cart button → Quantity Counter (Fixed: overlay gone)
        document.querySelectorAll(".cart-action").forEach(function(container){
            
            function bindAddButton(){
                let addBtn = container.querySelector(".add-btn");
                let select = container.querySelector(".unit-select");

                if(addBtn){
                    addBtn.addEventListener("click", function(){
                        let qty = 1;
                        let stock = parseInt(container.dataset.stock);
                        let productId = container.dataset.id;
                        let name = container.dataset.name;
                        let price = container.dataset.price;
                        let unitType = select.value;
                        let unitQuantity = select.options[select.selectedIndex].dataset.qty;

                        // Hide Add button, keep everything else
                        addBtn.style.display = "none";

                        // Only append qty-controls if not already there
                        if(!container.querySelector(".qty-controls")){
                            let qtyControls = document.createElement("div");
                            qtyControls.className = "qty-controls";
                            qtyControls.innerHTML = `<button class="dec">-</button>
                                                     <span class="qty">1</span>
                                                     <button class="inc">+</button>`;
                            container.appendChild(qtyControls);

                            function updateCart(delta){
                                var xhr = new XMLHttpRequest();
xhr.open("POST","CartServlet",true);
xhr.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");  // 👈 Add this line
xhr.onload = function(){
    if(xhr.status==200){
        document.getElementById("cart-count").innerText = xhr.responseText;
    }
};
xhr.send("action=add&productId="+productId+"&name="+encodeURIComponent(name)+"&price="+price+"&qty="+delta+"&unitType="+unitType+"&unitQuantity="+unitQuantity);

                            }

                            updateCart(1);

                            let decBtn = qtyControls.querySelector(".dec");
                            let incBtn = qtyControls.querySelector(".inc");
                            let qtyElem = qtyControls.querySelector(".qty");

                            incBtn.addEventListener("click", function(){
                                if(qty < stock){
                                    qty++;
                                    qtyElem.textContent = qty;
                                    updateCart(1);
                                }
                            });

                            decBtn.addEventListener("click", function(){
                                qty--;
                                if(qty > 0){
                                    qtyElem.textContent = qty;
                                    updateCart(-1);
                                } else {
                                    qtyControls.remove();
                                    addBtn.style.display = "inline-block";
                                }
                            });
                        }
                    });
                }
            }

            bindAddButton();
        });
    </script>

</body>
</html>
