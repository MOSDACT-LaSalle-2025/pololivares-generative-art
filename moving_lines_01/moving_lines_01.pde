static final int NUM_LINES = 15;
PGraphics pg;

float t;

void setup() {
  size(1920, 1080,P2D  );
  halfh = height / 2;
  w = float(width);
  rndclrs();
  background(0xffffffff);
  pg = createGraphics(width, height, P2D);
  initGradiant();
}

void draw() {
  // background(250);

  //background(0xffffffff);


  pg.beginDraw();
  //pg.background(0, 0, 0, 0);
  pg.clear();
  pg.stroke(250);
  pg.strokeWeight(2);

  pg.translate(width/2, height/2);

  for (int i = 0; i < NUM_LINES; i++) {
    float offset = t + i;
    pg.line(x1(offset), y1(offset), x2(offset), y2(offset));
  }
  pg.endDraw();
  t += 0.5;  // Increment once per frame
  image(pg, 0, 0);
}

// Define functions outside draw()
float x1(float t) {
  return sin(t / 10) * 100 + sin(t / 15) * 20;
}

float y1(float t) {
  return cos(t / 10) * 200 + sin(t / 105) * 30;
}

float x2(float t) {
  return sin(t / 10) * 500 + sin(t) * 2;
}

float y2(float t) {
  return cos(t / 20) * 170 + cos(t / 12) * 60;
}
