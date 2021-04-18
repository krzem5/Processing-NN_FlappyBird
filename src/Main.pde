Engine e;



void setup(){
	size(800,600);
	frameRate(60);
	e=new Engine();
	e.RECORD="user-input-data";
}



void keyPressed(){
	e.keyPress();
}



void keyReleased(){
	e.keyRelease();
}



void draw(){
	background(0);
	e.draw();
}
