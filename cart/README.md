# Shop Mỹ Phẩm - EJB Cosmetics Store

## Cấu hình và triển khai

### 1. Chuẩn bị môi trường
- JDK 8
- GlassFish 5
- MySQL 8.0
- Maven 3.8+

### 2. Cấu hình cơ sở dữ liệu
1. Đăng nhập vào MySQL:
```bash
mysql -u root -p
```

2. Thực thi script tạo CSDL (đảm bảo UTF-8):
```bash
source setup.sql
```

### 3. Cấu hình GlassFish JDBC (Quan trọng!)

1. Copy MySQL Driver vào GlassFish:
```bash
# Download MySQL Connector/J nếu chưa có
mvn dependency:get -Dartifact=mysql:mysql-connector-java:8.0.27

# Copy vào thư mục lib của GlassFish
cp ~/.m2/repository/mysql/mysql-connector-java/8.0.27/mysql-connector-java-8.0.27.jar \
   [GLASSFISH_HOME]/glassfish/domains/domain1/lib/
```
*If using Community Server Connector, GLASSFISH_HOME must be `C:\Users\<ussername>\.rsp\redhat-community-server-connector\runtimes\installations\glassfish-5.0.1\glassfish5`*
2. Khởi động GlassFish:
```bash
./asadmin start-domain
```

3. Tạo JDBC Connection Pool:
- Common Pool Settings:
  - Pool Name: CosmeticsPool
  - Resource Type: javax.sql.DataSource
  - Database Driver Vendor: MySQL
  
- Additional Properties:
  - serverName: localhost
  - portNumber: 3306
  - databaseName: cosmetics
  - user: root
  - password: [mật khẩu MySQL]
  - URL: jdbc:mysql://localhost:3306/cosmetics?useSSL=false&useUnicode=true&characterEncoding=UTF-8
  - useUnicode: true
  - characterEncoding: UTF-8
  - characterSetResults: UTF-8

QUAN TRỌNG: Sử dụng class name mới:
```
DataSource Classname: com.mysql.cj.jdbc.MysqlDataSource
```

4. Tạo JDBC Resource:
- JNDI Name: jdbc/cosmetics
- Pool Name: CosmeticsPool

Hoặc sử dụng lệnh asadmin:
```bash
./asadmin create-jdbc-connection-pool \
    --datasourceclassname com.mysql.cj.jdbc.MysqlDataSource \
    --restype javax.sql.DataSource \
    --property "user=root:password=yourpassword:databaseName=cosmetics:serverName=localhost:portNumber=3306:useUnicode=true:characterEncoding=UTF-8" \
    CosmeticsPool

./asadmin create-jdbc-resource --connectionpoolid CosmeticsPool jdbc/cosmetics
```

5. Kiểm tra kết nối:
- Vào Admin Console > Resources > JDBC > Connection Pools
- Chọn CosmeticsPool
- Click "Ping" để test kết nối

### 4. Build và Deploy
1. Build project:
```bash
# Build EJB module first
cd ejb
mvn clean install

# Build web module (includes EJB JAR)
cd ../web
mvn clean package
```

2. Deploy WAR file:
- Vào Admin Console > Applications
- Deploy file: cart/web/target/shopmypham-web-1.0.war

### 5. Kiểm tra cài đặt
1. Truy cập ứng dụng: http://localhost:8080/shopmypham-web-1.0

2. Đăng nhập admin:
- Username: admin
- Password: admin123

### Xử lý lỗi thường gặp

1. Lỗi "Class name is wrong or classpath is not set":
- Kiểm tra MySQL driver đã copy vào thư mục lib của GlassFish chưa
- Đảm bảo dùng đúng class name: com.mysql.cj.jdbc.MysqlDataSource
- Restart GlassFish sau khi copy driver

2. Lỗi JNDI lookup failed:
- Kiểm tra JDBC Resource đã tạo đúng chưa
- Test connection pool bằng nút "Ping"
- Xem server.log để biết chi tiết lỗi

3. Lỗi kết nối MySQL:
- Kiểm tra MySQL service đang chạy
- Verify thông tin kết nối (user, password, database)
- Kiểm tra firewall có chặn port 3306 không

4. Lỗi hiển thị tiếng Việt:
- Kiểm tra các thuộc tính Unicode trong connection pool
- Verify database và tables dùng UTF-8
- Đảm bảo các file JSP có khai báo UTF-8

## Cấu trúc project
```
cart/
├── ejb/                    # EJB module
│   ├── src/main/java/     # Entity & EJB classes
│   └── pom.xml
├── web/                    # Web module
│   ├── src/main/java/     # Servlets & Filters
│   ├── src/main/webapp/   # JSP & resources
│   └── pom.xml
├── pom.xml                # Parent POM
├── setup.sql              # Database setup
└── README.md             # This file
