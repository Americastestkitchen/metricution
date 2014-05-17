char *ssid;

// State
// 0 = Available
// 1 = Occupied
// 2 = Unknown
int state      = 2;
int last_state = 2;

void setup() {
  pinMode(D7, OUTPUT);
  pinMode(D0, INPUT_PULLDOWN);

  ssid = Network.SSID();
  Spark.variable("ssid", ssid, STRING);
  Spark.variable("state", &state, INT);
}

void loop() {
  state = digitalRead(D0);

  if (state != last_state) {
    digitalWrite(D7, state);
    Spark.publish("door", (state ? "closed" : "opened"), 60, PRIVATE);
  }

  last_state = state;
}
