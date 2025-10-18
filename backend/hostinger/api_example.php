<?php
// Example Hostinger PHP API endpoint for creating a project.
// Assumes you have a `projects` table with columns matching the payload.

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit();
}

$method = $_SERVER['REQUEST_METHOD'];

$mysqli = new mysqli('localhost', 'db_user', 'db_password', 'todogoal');
if ($mysqli->connect_error) {
    http_response_code(500);
    echo json_encode(['error' => 'Database connection failed']);
    exit();
}

if ($method === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    $stmt = $mysqli->prepare('INSERT INTO projects (id, user_id, name, description, status, created_at) VALUES (?, ?, ?, ?, ?, ?)');
    $stmt->bind_param(
        'ssssss',
        $input['id'],
        $input['user_id'],
        $input['name'],
        $input['description'],
        $input['status'],
        $input['created_at']
    );

    if ($stmt->execute()) {
        http_response_code(201);
        echo json_encode($input);
    } else {
        http_response_code(400);
        echo json_encode(['error' => $stmt->error]);
    }

    $stmt->close();
} elseif ($method === 'GET') {
    $userId = $_GET['userId'] ?? '';
    $stmt = $mysqli->prepare('SELECT * FROM projects WHERE user_id = ? ORDER BY created_at DESC');
    $stmt->bind_param('s', $userId);
    $stmt->execute();
    $result = $stmt->get_result();

    $projects = [];
    while ($row = $result->fetch_assoc()) {
        $projects[] = $row;
    }

    echo json_encode($projects);
    $stmt->close();
} else {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
}

$mysqli->close();
