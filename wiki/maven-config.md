# Cấu hình Maven của dự án

## Cấu trúc Maven

Dự án sử dụng cấu trúc multi-module Maven với:

-   Parent POM (pom.xml gốc)
-   EJB module (ejb/pom.xml)
-   Web module (web/pom.xml)

## POM cha (Parent POM)

File: cart/pom.xml

### Thông tin cơ bản

```xml
<groupId>com.ptithcm</groupId>
<artifactId>shopmypham</artifactId>
<version>1.0</version>
<packaging>pom</packaging>
```

### Các module con

```xml
<modules>
    <module>ejb</module>
    <module>web</module>
</modules>
```

### Properties

```xml
<properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <maven.compiler.source>1.8</maven.compiler.source>
    <maven.compiler.target>1.8</maven.compiler.target>
</properties>
```

### Dependencies chung

```xml
<dependencies>
    <!-- Java EE 7 API -->
    <dependency>
        <groupId>javax</groupId>
        <artifactId>javaee-api</artifactId>
        <version>7.0</version>
        <scope>provided</scope>
    </dependency>
</dependencies>
```

### Cấu hình build

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <version>3.8.1</version>
            <configuration>
                <source>${maven.compiler.source}</source>
                <target>${maven.compiler.target}</target>
            </configuration>
        </plugin>
    </plugins>
</build>
```

## Điểm đáng chú ý

1. Java EE 7:

    - Sử dụng Java EE 7 API với scope="provided" vì GlassFish server đã cung cấp
    - Phiên bản 7.0 tương thích với JDK 8

2. Compiler Settings:

    - Source/Target compatibility: Java 8
    - Encoding: UTF-8 cho đa ngôn ngữ

3. Module Structure:

    - ejb: Chứa business logic và persistence
    - web: Chứa giao diện người dùng và controllers

4. Build Process:
    1. Build EJB module trước: `cd ejb && mvn clean install`
    2. Build Web module sau: `cd ../web && mvn clean package`
    3. Deploy file WAR: `cart/web/target/shopmypham-web-1.0.war`

## Lệnh Maven thường dùng

```bash
# Clean và build toàn bộ dự án
mvn clean install

# Build module cụ thể
mvn -pl ejb clean install     # Build EJB module
mvn -pl web clean package     # Build Web module

# Skip tests
mvn clean install -DskipTests

# Update dependencies
mvn versions:display-dependency-updates
```
