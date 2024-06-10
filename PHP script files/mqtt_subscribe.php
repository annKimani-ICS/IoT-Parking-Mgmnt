// This is the php script file to be run on the server to subscribe to the MQTT broker and update the database with the parking sensor data.

<?php

require 'vendor/autoload.php';

use PhpMqtt\Client\MqttClient;
use PhpMqtt\Client\ConnectionSettings;
use PhpMqtt\Client\Exceptions\ConfigurationInvalidException;
use PhpMqtt\Client\Exceptions\DataTransferException;

// MQTT configuration
$clientId = 'mqttx_' . uniqid();
$server   = 'localhost';
$port     = 1883;
$clean_session = true;
$keepAlive = 60; // 60 seconds

// Database configuration
$dbConfig = [
    'servername' => 'localhost',
    'username' => 'root',
    'password' => '',
    'dbname' => 'parkingdetails'
];

function handleDatabaseUpdate($sensorId, $status, $latitude, $longitude, $dbConfig) {
    // Create connection
    $conn = new mysqli($dbConfig['servername'], $dbConfig['username'], $dbConfig['password'], $dbConfig['dbname']);

    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
    
    // Check if the sensor_id already exists
    $checkSql = $conn->prepare("SELECT * FROM parking_spaces WHERE sensor_id = ?");
    $checkSql->bind_param("s", $sensorId);
    $checkSql->execute();
    $result = $checkSql->get_result();

    if ($result->num_rows > 0) {
        // Update existing record
        $sql = $conn->prepare("UPDATE parking_spaces SET status = ?, timestamp = CURRENT_TIMESTAMP WHERE sensor_id = ?");
        $sql->bind_param("ss", $status, $sensorId);
    } else {
        // Insert new record with latitude and longitude
        $sql = $conn->prepare("INSERT INTO parking_spaces (sensor_id, status, latitude, longitude) VALUES (?, ?, ?, ?)");
        $sql->bind_param("ssdd", $sensorId, $status, $latitude, $longitude);
    }

    if ($sql->execute() === TRUE) {
        echo "Database operation successful\n";
    } else {
        echo "Error: " . $sql->error;
    }

    $sql->close();
    $conn->close();
}

try {
    $connectionSettings = (new ConnectionSettings)
                            ->setUseTls(false)
                            ->setKeepAliveInterval($keepAlive)
                            ->setConnectTimeout(10); // 10 seconds

    $mqtt = new MqttClient($server, $port, $clientId);

    $mqtt->connect($connectionSettings, $clean_session);
    echo "Connected to MQTT broker\n";

    $mqtt->subscribe('esp32/us', function ($topic, $message) use ($dbConfig) {
        echo "Message received: $message\n";

        // Decode JSON message
        $decodedMessage = json_decode($message, true);

        // Check if the message is valid and contains the required keys
        if (json_last_error() === JSON_ERROR_NONE && isset($decodedMessage['sensor_id']) && isset($decodedMessage['status'])) {
            $sensorId = $decodedMessage['sensor_id'];
            $status = strtoupper($decodedMessage['status']);
            $latitude = isset($decodedMessage['latitude']) ? $decodedMessage['latitude'] : null;
            $longitude = isset($decodedMessage['longitude']) ? $decodedMessage['longitude'] : null;

            if ($status === 'VACANT' || $status === 'OCCUPIED') {
                echo "Valid message: Sensor ID = $sensorId, Status = $status\n";
                handleDatabaseUpdate($sensorId, $status, $latitude, $longitude, $dbConfig);
            } else {
                echo "Invalid status: $status\n";
            }
        } else {
            echo "Invalid message format: $message\n";
        }
    }, 0);

    $mqtt->loop(true);
    $mqtt->disconnect();
    echo "Disconnected from MQTT broker\n";

} catch (ConfigurationInvalidException $e) {
    echo "Configuration error: " . $e->getMessage();
} catch (DataTransferException $e) {
    echo "Data transfer error: " . $e->getMessage();
} catch (Exception $e) {
    echo "General error: " . $e->getMessage();
}
?>
