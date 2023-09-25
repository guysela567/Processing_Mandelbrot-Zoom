final int CANVAS_SIZE = 1200;

// ZOOM POINT (real and imaginary coefficients) - used in video capture
final double POINT_RE = 0.360240443437614363236125244449545308482607807958585750488375814740195346059218100311752936722773426396233731729724987737320035372683285317664532401218521579554288661726564324134702299962817029213329980895208036363104546639698106204384566555001322985619004717862781192694046362748742863016467354574422779443226982622356594130430232458472420816652623492974891730419252651127672782407292315574480207005828774566475024380960675386215814315654794021855269375824443853463117354448779647099224311848192893972572398662626725254769950976527431277402440752868498588785436705371093442460696090720654908973712759963732914849861213100695402602927267843779747314419332179148608587129105289166676461292845685734536033692577618496925170576714796693411776794742904333484665301628662532967079174729170714156810530598764525260869731233845987202037712637770582084286587072766838497865108477149114659838883818795374195150936369987302574377608649625020864292915913378927790344097552591919409137354459097560040374880346637533711271919419723135538377394364882968994646845930838049998854075817859391340445151448381853615103761584177161812057928;
final double POINT_IM = -0.6413130610648031748603750151793020665794949522823052595561775430644485741727536902556370230689681162370740565537072149790106973211105273740851993394803287437606238596262287731075999483940467161288840614581091294325709988992269165007394305732683208318834672366947550710920088501655704252385244481168836426277052232593412981472237968353661477793530336607247738951625817755401065045362273039788332245567345061665756708689359294516668271440525273653083717877701237756144214394870245598590883973716531691124286669552803640414068523325276808909040317617092683826521501539932397262012011082098721944643118695001226048977430038509470101715555439047884752058334804891389685530946112621573416582482926221804767466258346014417934356149837352092608891639072745930639364693513216719114523328990690069588676087923656657656023794484324797546024248328156586471662631008741349069961493817600100133439721557969263221185095951241491408756751582471307537382827924073746760884081704887902040036056611401378785952452105099242499241003208013460878442953408648178692353788153787229940221611731034405203519945313911627314900851851072122990492499999999999999999991;

final double THREASHOLD = 1000000; // Assume the series diverges if it's value goes above the threshold
final int MAX_ITERATIONS = 1000; // Amount of iterations until the series is assumed to be convergent

final float ZOOM_FACTOR = 1.05;
final int TOTAL_FRAMES = 1500;
// final Vector ZOOM_CENTER = new Vector(123.95869446392783, 255.63310241595218);
final Vector ZOOM_CENTER = complexToCanvasCoords(POINT_RE, POINT_IM, CANVAS_SIZE);
final String OUT_DIR_NAME = "out";

// These variables enclose the viewport the user can see, and are updated on each zoom
Vector viewPos = new Vector(0, 0);
Vector viewPort = new Vector(CANVAS_SIZE, CANVAS_SIZE);

void setup() {
  size(1200, 1200); // Must be magic numbers unfortunately
  colorMode(HSB, 360, 100, 100);

  drawSet(); // Initial draw, next time will be on user click
}

void saveToFolder(String dirname, int totalFrames, Vector zoomCenter) {
  for (int i = 0; i < totalFrames; i++) {
    saveFrame(dirname + "/frame-" + nf(i + 1, 4) + ".png");
    zoomIntoPosition(zoomCenter);
  }
}

// Draws the Mandelbrot set in all its glory
void drawSet() {
  loadPixels();
  for (int x = 0; x < width; x += 1) {
    for (int y = 0; y < height; y += 1) {
      // Map the coordinates to match viewport and view position
      Vector mapped = toRelativeViewPoint(x, y, viewPos, viewPort);
      // Map the coordinates to the center of the screen
      // and normalize them to a smaller range (-2 to 2)
      Vector c = canvasCoordsToComplex(mapped.x, mapped.y);
      Vector z = new Vector(); // Starting value is 0

      // Now count the number of iterations until the value of Z surpasses the threshold
      int iterCount = 0;
      while (iterCount < MAX_ITERATIONS && isInRange(z, THREASHOLD)) {
        z = nextInSeries(z, c);
        iterCount++;
      }

      // We are plotting each point, including the ones that are not in the set
      plotPixel(x, y, iterCount, MAX_ITERATIONS);
    }
  }

  updatePixels();
}

// Zooms into a given point using the zoom factor constant
void zoomIntoPosition(Vector zoomCenter) {
  // Magnify by fixed amount
  viewPort.div(ZOOM_FACTOR);

  // Center towards the center point
  viewPos.x = zoomCenter.x - viewPort.x / 2;
  viewPos.y = zoomCenter.y - viewPort.y / 2;

  drawSet();
}

// Zooms into the clicked point on screen
void mousePressed() {
  // Find the real coordiantes of mouse cursor's poisition
  Vector zoomCenter = toRelativeViewPoint(mouseX, mouseY, viewPos, viewPort);
  println("Zooming into:", zoomCenter);
  zoomIntoPosition(zoomCenter);
}

// Returns whether the given vector is inside the threashold, aka convergent
boolean isInRange(Vector z, double threashold) {
  return Math.abs(z.x + z.y) < threashold;
}

// Calculates the next value in the Z series, given the previous one
Vector nextInSeries(Vector z, Vector c) {
  return Vector.add(squareComplex(z), c);
}

// Updates the color using the pixel array on a given coordinate
void plotPixel(int x, int y, int iter, int maxIter) {
  // Mapping x, y to flat array --> index = x + y * cols
  pixels[y * width + x] = getColor(iter, maxIter);
}

// Really not a complex one, but it does the trick for me
color getColor(int iter, int maxIter) {
  // Map the time needed for the given point to "escape" the threshold
  double h = iter == maxIter ? 0 : dmap(iter, 1, maxIter * 0.6, 0, 360);
  int b = iter == maxIter ? 0 : 100; // pitch black for center area, else fully lit
  return color(Math.round((h * 10)) % 360, b, b);
}
