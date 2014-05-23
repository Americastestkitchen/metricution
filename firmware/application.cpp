char *ssid;

// State
// 0 = Available
// 1 = Occupied
int state;
int last_state = state;

void setup() {
  pinMode(D7, OUTPUT);
  pinMode(D0, INPUT_PULLDOWN);

  ssid = Network.SSID();
  Spark.variable("ssid", ssid, STRING);

  state = digitalRead(D0);
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
