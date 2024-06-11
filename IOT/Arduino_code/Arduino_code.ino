const int trigPin = 33;
const int echoPin = 32;

// WiFi library for the esp32
#include <WiFi.h>
// Library used as client for all mqtt services
#include <PubSubClient.h>

//**** WiFi credentials *****
// SSID
const char* ssid = "Ann's iPhone";
// Password
const char* password = "Lewikimani";

// MQTT server information. Insert the IP address of your server
const char* mqtt_server = "";

// Create WiFi client 
WiFiClient espClient;
// Create PubSubClient
PubSubClient client(espClient);
// Variable for time elapsed
long lastMsg = 0;

// Sensor identifier
const char* sensorId = "A1"; // Example for parking lot A space 1

// Hard-coded coordinates
const float latitude = -1.2921; // Example latitude
const float longitude = 36.8219; // Example longitude

// setup()
void setup() {
  // Initialize serial communication at 115200 kB/s
  Serial.begin(115200);

  // Configure the trigPin as an output
  pinMode(trigPin, OUTPUT);

  // Configure the echoPin as an input
  pinMode(echoPin, INPUT);

  // Initialize WiFi and MQTT
  setup_wifi();
  // Initialize server at XXXXXXXX:1883
  client.setServer(mqtt_server, 1883);
}

void setup_wifi() {
  // Some serial prints
  delay(10);
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  // Connect to WiFi network
  WiFi.begin(ssid, password);

  // Test to see if connected
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  // Print the IP address of the esp32
  Serial.println(WiFi.localIP());
}

// Function to reconnect if disconnected from the server
void reconnect() {
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Random client ID, you can put whatever you want.
    if (client.connect("ESP32Client")) {
      Serial.println("connected");
    } else {
      Serial.print("failed, rc=");
      // If not connected, print the error code
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}

// loop()
void loop() {
  if (!client.connected()) {
    // Reconnect to MQTT broker if not connected
    reconnect();
  }
  client.loop();
  long now = millis();
  // Send message after 1s
  if (now - lastMsg > 1000) {
    lastMsg = now;
    
    // Clear the trigPin by setting it LOW
    digitalWrite(trigPin, LOW);
    delayMicroseconds(2);

    // Trigger the sensor by setting the trigPin high for 10 microseconds
    digitalWrite(trigPin, HIGH);
    delayMicroseconds(10);
    digitalWrite(trigPin, LOW);

    // Read the echoPin, pulseIn() returns the duration (length of the pulse) in microseconds
    long duration = pulseIn(echoPin, HIGH);

    // Calculate the distance
    // Speed of sound wave divided by 2 (round trip) and convert to cm
    float distance = duration * 0.034 / 2;

    // Print the distance on the serial monitor
    Serial.print("Distance: ");
    Serial.print(distance);
    Serial.println(" cm");

    // Determine the status based on distance
    String status;
    if (distance > 150) {
      status = "VACANT";
    } else {
      status = "OCCUPIED";
    }

    // Print the status on the serial monitor
    Serial.print("Status: ");
    Serial.println(status);

    // Construct JSON string
    String jsonString = "{\"sensor_id\": \"" + String(sensorId) + "\", \"status\": \"" + status + "\", \"latitude\": " + String(latitude, 6) + ", \"longitude\": " + String(longitude, 6) + "}";

    // Publish JSON string to MQTT topic named esp32/us
    client.publish("esp32/us", jsonString.c_str());
  }
}
