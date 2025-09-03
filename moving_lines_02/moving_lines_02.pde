// ARTPIECE INSPIRED ON: https://www.youtube.com/watch?v=LaarVR1AOvs

static final int BASE_LINES = 20;  // minimum lines
PGraphics pg;
float t;

// for gradient background
float bgShift = 0;

// store history of smoothed mouse positions
int historySize = 600; 
ArrayList<PVector> mouseHistory = new ArrayList<PVector>();

// smoothed mouse
float smoothX, smoothY;

void setup() {
  size(1920, 1080, P2D);
  pg = createGraphics(width, height, P2D);

  smoothX = width/2;
  smoothY = height/2;
}

void draw() {
  // gradient background (red - black)
  noStroke();
  for (int y = 0; y < height; y++) {
    float inter = map(y, 0, height, 0, 1);

    float redVal = 150 + 100 * sin(bgShift * 0.01); // animated red
    int c1 = color(redVal, 0, 0);  // deep red
    int c2 = color(0, 0, 0);       // black

    stroke(lerpColor(c1, c2, inter));
    line(0, y, width, y);
  }
  bgShift += 1;

  // smoother mouse tracking
  smoothX = lerp(smoothX, mouseX - width/2, 0.2);
  smoothY = lerp(smoothY, mouseY - height/2, 0.2);

  // record smoothed mouse into history
  mouseHistory.add(new PVector(smoothX, smoothY));
  if (mouseHistory.size() > historySize) {
    mouseHistory.remove(0);
  }

  // generative line system
  pg.beginDraw();
  pg.clear();
  pg.translate(width / 2, height / 2);

  // number of lines stays constant (no flicker)
  int numLines = 150;

  // use mouseY to control line spacing (higher = wider fan of lines)
  float spacingRange = map(mouseY, 0, height, 10, 200);

  int lineCol = color(255); 

  for (int i = 0; i < numLines; i++) {
    float offset = t + i * 0.5;

    float scale = 0.5 * (1 + 0.15 * sin(offset * 0.07 + t * 0.01));

    int historyIndex = int(map(i, 0, numLines-1, 0, mouseHistory.size()-1));
    PVector pos = mouseHistory.get(historyIndex);

    // spacing now depends on mouseY
    float spacing = map(i, 0, numLines, -spacingRange, spacingRange);

    // compute endpoints
    float x1f = (x1(offset) + pos.x + spacing) * scale;
    float y1f = (y1(offset) + pos.y) * scale;
    float x2f = (x2(offset) + pos.x + spacing) * scale;
    float y2f = (y2(offset) + pos.y) * scale;

    // constrain to canvas edges
    x1f = constrain(x1f, -width/2, width/2);
    y1f = constrain(y1f, -height/2, height/2);
    x2f = constrain(x2f, -width/2, width/2);
    y2f = constrain(y2f, -height/2, height/2);

    pg.stroke(lineCol, 220);
    pg.strokeWeight(2);
    pg.line(x1f, y1f, x2f, y2f);
  }

  pg.endDraw();

  t += 0.5;
  image(pg, 0, 0);
}

// endpoint functions
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
