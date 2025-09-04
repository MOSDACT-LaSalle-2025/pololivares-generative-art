
// VIDEO TUTORIAL: https://www.youtube.com/watch?v=LaarVR1AOvs&t=6s


static final int BASE_LINES = 20;  // minimum lines
PGraphics pg;
float t;

// background
float bgShift = 0;

// history buffers
int historySize = 800;
ArrayList<PVector> mouseHistory = new ArrayList<PVector>();
IntList colorHistory = new IntList(); // store per-point colors (ints)

// smoothed mouse for stable trail
float smoothX, smoothY, prevSmoothX, prevSmoothY;

// hue cycle (HSB)
float hueValue = 0;
float hueStep = 2;           // how fast hue progresses when moving
float speedThreshold = 0.6;  // movement threshold to register 'moving'
int maxLines = 150;         // constant drawing count to avoid flicker

void setup() {
  size(1920, 1080, P2D);
  pg = createGraphics(width, height, P2D);

  // initial smoothed mouse in center
  smoothX = prevSmoothX = width/2;
  smoothY = prevSmoothY = height/2;

  // pre-fill history so there are always at least BASE_LINES entries
  for (int i = 0; i < BASE_LINES; i++) {
    mouseHistory.add(new PVector(smoothX - width/2, smoothY - height/2));
    colorHistory.append(color(255)); // white
  }
}

void draw() {
  //background (red -> black)
  //background (soft red -> black gradient) 
colorMode(RGB, 255);
noStroke();
for (int y = 0; y < height; y++) {
  float inter = map(y, 0, height, 0, 1);

  // use easing for smoother blend
  float eased = pow(inter, 1.8); // adjust exponent for softness

  float redVal = 120 + 60 * sin(bgShift * 0.005); // slower & softer red pulse
  int c1 = color(redVal, 20, 20); // darker red (not pure)
  int c2 = color(0, 0, 0);        // black

  stroke(lerpColor(c1, c2, eased));
  line(0, y, width, y);
}
bgShift += 1;

  //smooth mouse tracking 
  smoothX = lerp(smoothX, mouseX, 0.25); // note: keep in screen coords here
  smoothY = lerp(smoothY, mouseY, 0.25);

  // measure speed on smoothed mouse (less jitter)
  float dsx = smoothX - prevSmoothX;
  float dsy = smoothY - prevSmoothY;
  float speed = sqrt(dsx*dsx + dsy*dsy);
  prevSmoothX = smoothX;
  prevSmoothY = smoothY;

  // decide new color: if moving, advance hue (HSB), otherwise white
  int newColor = color(255); // default white
  if (speed > speedThreshold) {
    hueValue = (hueValue + hueStep) % 255;
    pushStyle();
    colorMode(HSB, 255);
    newColor = color(hueValue, 255, 255); // full saturation & brightness
    popStyle();
  }

  // store smoothed mouse (convert to centered coords) + color
  mouseHistory.add(new PVector(smoothX - width/2, smoothY - height/2));
  colorHistory.append(newColor);


  if (mouseHistory.size() > historySize) {
    mouseHistory.remove(0);
    colorHistory.remove(0);
  }

  // draw lines 
  pg.beginDraw();
  pg.clear();
  pg.translate(width/2, height/2);
  pg.colorMode(RGB, 255);

  int numLines = min(maxLines, mouseHistory.size()); // constant drawing count
  float spacingRange = map(mouseY, 0, height, 10, 200); // vertical controls spread

  for (int i = 0; i < numLines; i++) {
    float offset = t + i * 0.5;
    float scale = 0.5 * (1 + 0.15 * sin(offset * 0.07 + t * 0.01)); // 50% base

    int historyIndex = int(map(i, 0, numLines - 1, 0, mouseHistory.size() - 1));
    PVector pos = mouseHistory.get(historyIndex);

    float spacing = map(i, 0, numLines, -spacingRange, spacingRange);

    float x1f = (x1(offset) + pos.x + spacing) * scale;
    float y1f = (y1(offset) + pos.y) * scale;
    float x2f = (x2(offset) + pos.x + spacing) * scale;
    float y2f = (y2(offset) + pos.y) * scale;

    // keep inside canvas
    x1f = constrain(x1f, -width/2, width/2);
    y1f = constrain(y1f, -height/2, height/2);
    x2f = constrain(x2f, -width/2, width/2);
    y2f = constrain(y2f, -height/2, height/2);

   
    int c = colorHistory.get(historyIndex);
    int faded = lerpColor(c, color(255), 0.025); 
    colorHistory.set(historyIndex, faded);

    pg.stroke(faded, 220);
    pg.strokeWeight(2);
    pg.line(x1f, y1f, x2f, y2f);
  }

  pg.endDraw();

  t += 0.5;
  image(pg, 0, 0);
}

// endpoint functions
float x1(float t) { return sin(t / 10) * 100 + sin(t / 15) * 20; }
float y1(float t) { return cos(t / 10) * 200 + sin(t / 105) * 30; }
float x2(float t) { return sin(t / 10) * 500 + sin(t) * 2; }
float y2(float t) { return cos(t / 20) * 170 + cos(t / 12) * 60; }
