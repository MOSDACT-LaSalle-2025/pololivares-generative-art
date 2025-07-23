int halfh;
color startc, stopc;
float w, step0, step1, stepc;
float[] startf, stopf, current = new float[4];
String fmt = "%s\tX %.2f\tY %.2f\tZ %.2f\tW %.2f";

void initGradiant() {
  step1 = abs(cos(frameCount * .01));
  for (int i = 0; i < width; ++i) {
    step0 = i / w;
    stepc = step0 * step1;



    // Draw custom gradient.
    smootherStepRgb(startf, stopf, stepc, current);
    stroke(composeclr(current));
    line(i, 0, i, height);
  }
}
void rndclrs() {

  // Create random RGB values.
  startf = new float[] { random(1.0), random(1.0), random(1.0), 1.0 };
  stopf = new float[] { random(1.0), random(1.0), random(1.0), 1.0 };

  // Convert to colors for Processing gradient.
  startc = composeclr(startf);
  stopc = composeclr(stopf);

  // Print color values.
  println(String.format(fmt,
    hex(startc), startf[0], startf[1], startf[2], startf[3]));
  println(String.format(fmt,
    hex(stopc), stopf[0], stopf[1], stopf[2], stopf[3]));
}



float smootherStep(float st) {
  return st * st * st * (st * (st * 6.0 - 15.0) + 10.0);
}

float[] smootherStepRgb(float[] a, float[] b, float st, float[] out) {
  float eval = smootherStep(st);
  out[0] = a[0] + eval * (b[0] - a[0]);
  out[1] = a[1] + eval * (b[1] - a[1]);
  out[2] = a[2] + eval * (b[2] - a[2]);
  out[3] = a[3] + eval * (b[3] - a[3]);
  return out;
}
int composeclr(float[] in) {
  return composeclr(in[0], in[1], in[2], in[3]);
}
// Assumes that RGBA are in range 0 .. 1.
int composeclr(float red, float green, float blue, float alpha) {
  return round(alpha * 255.0) << 24
    | round(red * 255.0) << 16
    | round(green * 255.0) << 8
    | round(blue * 255.0);
}

float[] decomposeclr(int clr) {
  return decomposeclr(clr, new float[] { 0.0, 0.0, 0.0, 1.0 });
}

// Assumes that out has 4 elements.
// 1.0 / 255.0 = 0.003921569
float[] decomposeclr(int clr, float[] out) {
  out[3] = (clr >> 24 & 0xff) * 0.003921569;
  out[0] = (clr >> 16 & 0xff) * 0.003921569;
  out[1] = (clr >> 8 & 0xff) * 0.003921569;
  out[2] = (clr & 0xff) * 0.003921569;
  return out;
}
