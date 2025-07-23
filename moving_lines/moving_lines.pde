static final int NUM_LINES = 15;

float t;

void setup() {
  size(500, 500);
  background(20);
}

void draw() {
  background(20);
  stroke(255);
  strokeWeight(2);

  translate(width/2, height/2);

  for (int i = 0; i < NUM_LINES; i++) {
    float offset = t + i;
    line(x1(offset), y1(offset), x2(offset), y2(offset));
  }

  t += 0.5;  // Increment once per frame
}

// Define functions outside draw()
float x1(float t) {
  return sin(t / 10) * 100 + sin(t / 15) * 20;
}

float y1(float t) {
  return cos(t / 10) * 200 + sin(t / 105) * 30;
}

float x2(float t) {
  return sin(t / 10) * 200 + sin(t) * 2;
}

float y2(float t) {
  return cos(t / 20) * 100 + cos(t / 12) * 60;
}
