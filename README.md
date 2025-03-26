# Shop Mỹ Phẩm - EJB Cosmetics Store

## Tổng quan

Hệ thống quản lý bán hàng mỹ phẩm sử dụng công nghệ EJB (Enterprise JavaBeans), được triển khai trên GlassFish Server và sử dụng MySQL làm cơ sở dữ liệu.

## Cấu hình và triển khai

<details>
<summary>1. Chuẩn bị môi trường (Bên ngoài)</summary>

### Yêu cầu hệ thống

-   JDK 8 (jdk1.8.0_202)
-   GlassFish 5
-   MySQL 8.0
-   Maven 3.8+
-   Visual Studio Code (tùy chọn)

### Cài đặt GlassFish 5 với VS Code Community Server Connector

1. Cài đặt các extension cho Visual Studio Code:

    - Community Server Connectors
    - Maven for Java

2. Trong VS Code, mở tab `EXPLORER`, tìm tab `SERVERS` ở cuối, nhấn chuột phải và chọn `Create new Server...`
   ![alt text](setup/image/addserver.png)

3. Chọn `Yes` khi được hỏi về việc tải server, tìm kiếm `glassfish 5.x.x` và cài đặt
   ![alt text](setup/image/downloadserver1.png)
   ![alt text](setup/image/downloadserver2.png)

4. Cấu hình server:

    - Nhấn chuột phải vào glassfish5, chọn `Edit server`
    - Domain: domain1 (mặc định)
    - Port: 8080 (mặc định)
    - Admin Port: 4848 (mặc định)
    - Thêm dòng: `"vm.install.path": "C:\\Program Files\\Java\\jdk1.8.0_202",` (thay đổi đường dẫn tới JDK 1.8 của bạn)

    ![Edit server](setup/image/editserver.png)

5. Kiểm tra cài đặt:
    - Khởi động server từ tab SERVERS
    - Truy cập: `http://localhost:4848` để vào Admin Console
        </details>

<details>
<summary>2. Cấu hình cơ sở dữ liệu</summary>

1. Đăng nhập vào MySQL:

```bash
mysql -u root -p
```

2. Thực thi script tạo CSDL (đảm bảo UTF-8):

```bash
source setup.sql
```

</details>

<details>
<summary>3. Cấu hình JDBC trên GlassFish</summary>

1. Copy MySQL Driver vào GlassFish:

```bash
# Download MySQL Connector/J nếu chưa có
mvn dependency:get -Dartifact=mysql:mysql-connector-java:8.0.27

# Copy vào thư mục lib của GlassFish
cp ~/.m2/repository/mysql/mysql-connector-java/8.0.27/mysql-connector-java-8.0.27.jar \
   [GLASSFISH_HOME]/glassfish/domains/domain1/lib/
```

_Lưu ý: Nếu sử dụng Community Server Connector, GLASSFISH_HOME sẽ là `C:\Users\<username>\.rsp\redhat-community-server-connector\runtimes\installations\glassfish-5.0.1\glassfish5`_

2. Tạo JDBC Connection Pool:

-   Common Pool Settings:
    -   Pool Name: CosmeticsPool
    -   Resource Type: javax.sql.DataSource
    -   Database Driver Vendor: MySQL
-   Additional Properties:
    -   serverName: localhost
    -   portNumber: 3306
    -   databaseName: cosmetics
    -   user: root
    -   password: [mật khẩu MySQL]
    -   URL: jdbc:mysql://localhost:3306/cosmetics?useSSL=false&useUnicode=true&characterEncoding=UTF-8
    -   useUnicode: true
    -   characterEncoding: UTF-8
    -   characterSetResults: UTF-8

QUAN TRỌNG: Sử dụng class name mới:

```
DataSource Classname: com.mysql.cj.jdbc.MysqlDataSource
```

3. Tạo JDBC Resource:

-   JNDI Name: jdbc/cosmetics
-   Pool Name: CosmeticsPool

Hoặc sử dụng lệnh asadmin _(chú ý username và password phù hợp)_:

```bash
cd glassfish-4.1.1\glassfish4\glassfish\bin
./asadmin create-jdbc-connection-pool --datasourceclassname com.mysql.cj.jdbc.MysqlDataSource --restype javax.sql.DataSource --property "user=root:password=admin:databaseName=cosmetics:serverName=localhost:portNumber=3306:useUnicode=true:characterEncoding=UTF-8" CosmeticsPool
./asadmin create-jdbc-resource --connectionpoolid CosmeticsPool jdbc/cosmetics
```

4. Kiểm tra kết nối:

-   Vào Admin Console > Resources > JDBC > Connection Pools
-   Chọn CosmeticsPool
-   Click "Ping" để test kết nối
</details>

<details>
<summary>4. Build và triển khai dự án</summary>

### Build bằng Maven

1. Build project:

```bash
# Build EJB module first
cd ejb
mvn clean install

# Build web module (includes EJB JAR)
cd ../web
mvn clean package
```

2.  Deploy WAR file:

    -   Tùy chọn 1: Sử dụng Admin Console

        -   Vào Admin Console > Applications
        -   Deploy file: cart/web/target/shopmypham-web-1.0.war

    -   Tùy chọn 2: Sử dụng VS Code

        -   Trong folder tree, chuột phải vào file `war` (trong thư mục `web/target`)
        -   Chọn "Run on Server" hoặc "Debug on server"

        ![alt text](setup/image/runwar.png)

    -   Tùy chọn 3: Sử dụng lệnh triển khai nhanh

        ````bash # Start
        .\pj start cart\web\target\shopmypham-web-1.0.war
             # Redeploy
             .\pj redeploy cart\web\target\shopmypham-web-1.0.war

             # Stop
             .\pj stop
             ```
             ***Nếu chạy bằng cmd, dùng `pjb` thay cho `pj`***
        </details>
        ````

<details>
<summary>5. Kiểm tra cài đặt</summary>

1. Truy cập ứng dụng: http://localhost:8080/shopmypham-web-1.0

2. Đăng nhập admin:

-   Username: admin
-   Password: admin123
</details>

<details>
<summary>6. Xử lý lỗi thường gặp</summary>

1. Lỗi "Class name is wrong or classpath is not set":

-   Kiểm tra MySQL driver đã copy vào thư mục lib của GlassFish chưa
-   Đảm bảo dùng đúng class name: com.mysql.cj.jdbc.MysqlDataSource
-   Restart GlassFish sau khi copy driver

2. Lỗi JNDI lookup failed:

-   Kiểm tra JDBC Resource đã tạo đúng chưa
-   Test connection pool bằng nút "Ping"
-   Xem server.log để biết chi tiết lỗi

3. Lỗi kết nối MySQL:

-   Kiểm tra MySQL service đang chạy
-   Verify thông tin kết nối (user, password, database)
-   Kiểm tra firewall có chặn port 3306 không

4. Lỗi hiển thị tiếng Việt:

-   Kiểm tra các thuộc tính Unicode trong connection pool
-   Verify database và tables dùng UTF-8
-   Đảm bảo các file JSP có khai báo UTF-8
</details>

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
```
