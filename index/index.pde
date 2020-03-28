FlappyBird engine;
void setup() {
  size(800, 600);
  engine=new FlappyBird();
  engine.RECORD="user-input-data";
  frameRate(60);
}
void keyPressed() {
  engine.keyPress();
}
void keyReleased() {
  engine.keyRelease();
}
void draw() {
  background(0);
  engine.draw();
}
