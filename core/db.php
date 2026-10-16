<?php
if (session_status() === PHP_SESSION_NONE) {
    ini_set('session.use_strict_mode', '1');
    session_name('COM6011_APP_SESSION');
    session_set_cookie_params([
        'httponly' => true,
        'samesite' => 'Lax',
        'secure' => !empty($_SERVER['HTTPS']),
    ]);
    session_start();
}

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

function db_fail_response(int $statusCode, string $publicMessage): void
{
    if (!headers_sent()) {
        http_response_code($statusCode);
        header('Retry-After: 30');
    }

    $isAjax = strpos($_SERVER['SCRIPT_NAME'] ?? '', '/game/') !== false;

    if ($isAjax) {
        if (!headers_sent()) {
            header('Content-Type: application/json; charset=UTF-8');
        }
        echo json_encode(['success' => false, 'error' => $publicMessage]);
    } else {
        if (!headers_sent()) {
            header('Content-Type: text/html; charset=UTF-8');
        }
        echo '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8">'
            . '<meta name="viewport" content="width=device-width, initial-scale=1.0">'
            . '<title>Maze Escape - temporarily unavailable</title></head>'
            . '<body style="font-family:Arial,Helvetica,sans-serif;background:#1a0033;color:#fff;text-align:center;padding-top:15vh;">'
            . '<h1>Maze Escape is taking a short break</h1>'
            . '<p>' . htmlspecialchars($publicMessage, ENT_QUOTES, 'UTF-8') . '</p>'
            . '<p><a href="javascript:location.reload()" style="color:#00ffff;">Try again</a></p>'
            . '</body></html>';
    }

    exit;
}

set_exception_handler(function (Throwable $e) {
    error_log(sprintf(
        'Unhandled %s: %s in %s:%d',
        get_class($e),
        $e->getMessage(),
        $e->getFile(),
        $e->getLine()
    ));
    db_fail_response(500, 'Something went wrong on our side. Please try again in a moment.');
});

$host     = 'localhost';
$dbname   = 'your_database_name';
$username = 'your_database_user';
$password = 'your_database_password';
$port     = 3306;

putenv('ML_API_URL=https://maze-escape-ml.onrender.com');
putenv('ML_PUBLIC_URL=https://maze-escape-ml.onrender.com');

$conn = null;
$maxAttempts = 5;
$delayMs = 250;

for ($attempt = 1; $attempt <= $maxAttempts; $attempt++) {
    try {
        $conn = mysqli_init();
        mysqli_options($conn, MYSQLI_OPT_CONNECT_TIMEOUT, 4);
        mysqli_real_connect($conn, $host, $username, $password, $dbname, $port);
        mysqli_set_charset($conn, 'utf8mb4');
        break;
    } catch (mysqli_sql_exception $e) {
        $conn = null;
        error_log(sprintf(
            'db.php: MySQL connect attempt %d/%d to %s:%d (db: %s) failed: %s',
            $attempt,
            $maxAttempts,
            $host,
            $port,
            $dbname,
            $e->getMessage()
        ));

        if ($attempt < $maxAttempts) {
            usleep($delayMs * 1000);
            $delayMs *= 2;
        }
    }
}

if ($conn === null) {
    db_fail_response(503, 'The database is temporarily unavailable. Please refresh in a few seconds.');
}
