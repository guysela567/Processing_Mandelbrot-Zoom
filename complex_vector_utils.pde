// Returns the squared value of a given complex vector
Vector squareComplex(Vector z) {
  // a^2 + 2abi - b^2 --> RE = a^2 - b^2, IM = 2ab
  return new Vector(Math.pow(z.x, 2) - Math.pow(z.y, 2), 2 * z.x * z.y);
}

// Converts a coordiante on viewport to fit the intire screen
Vector toRelativeViewPoint(double x, double y, Vector viewPos, Vector viewPort) {
  return new Vector(
    dmap(x, 0, width, viewPos.x, viewPos.x + viewPort.x),
    dmap(y, 0, height, viewPos.y, viewPos.y + viewPort.y)
  );
}

// Basically Processing's good ol' map but with doubles
double dmap(double val, double x1, double x2, double y1, double y2) {
  double perc = (val - x1) / (x2 - x1);
  return y1 + perc * (y2 - y1);
}

// Converts the range of -1 to 1 for complex coefficients to fit the intire screen
Vector complexToCanvasCoords(double x, double y, int canvasSize) {
  return new Vector(
    dmap(x, -2, 2, 0, canvasSize),
    dmap(y, -2, 2, 0, canvasSize)
  );
}

// Converts point on-screen to the range of -2 to 2
Vector canvasCoordsToComplex(double x, double y) {
  return new Vector(
    dmap(x, 0, width, -2, 2),
    dmap(y, 0, height, -2, 2)
  );
}
