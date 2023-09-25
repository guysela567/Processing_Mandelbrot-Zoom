// Made a little vector class bc Processing's one sucks (transitioned from floats to doubles)
static class Vector {
  double x; double y;

  Vector(double x, double y) {
    this.x = x;
    this.y = y;
  }

  Vector() {
    this.x = 0;
    this.y = 0;
  }

  void div(double num) {
    this.x /= num;
    this.y /= num;
  }

  void mult(double num) {
    this.x *= num;
    this.y *= num;
  }

  String toString() {
    return "[" + this.x + ", " + this.y + "]";
  }

  static Vector add(Vector v1, Vector v2) {
    return new Vector(v1.x + v2.x, v1.y + v2.y);
  }
}
