<h1>hello</h1>
<?php
$dsn = sprintf('mysql:host=%s;dbname=%s;charset=utf8mb4', getenv('DB_HOST'), getenv('DB_NAME'));
$user = getenv('DB_USER');
$pass = getenv('DB_PASSWORD');

try {
    $pdo = new PDO($dsn, $user, $pass, [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
    $rows = $pdo->query('SELECT NOW() AS server_time')->fetchAll();
    echo "<h1>Apache + PHP-FPM + MariaDB (Docker)</h1>";
    echo "<p>DB 연결 OK. 서버시각입니다: <b>{$rows[0]['server_time']}</b></p>";
} catch (Throwable $e) {
    http_response_code(500);
    echo "<h1>DB 연결 실패</h1><pre>{$e->getMessage()}</pre>";
}