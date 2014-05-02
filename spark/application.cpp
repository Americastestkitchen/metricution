#include "application.h"

char *ssid;
int last_state = -1;

void setup() {
  pinMode(D7, OUTPUT);
  pinMode(D0, INPUT_PULLDOWN);

  ssid = Network.SSID();
  Spark.variable("ssid", ssid, STRING);
}

void loop() {
  int state = digitalRead(D0);

  if (state != last_state) {
    digitalWrite(D7, state);
    Spark.publish("door", (state ? "closed" : "opened"), 60, PRIVATE);
  }

  last_state = state;
}
