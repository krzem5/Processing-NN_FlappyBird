class Bird{
	float y_vel;
	float gravity;
	PVector pos;
	boolean end;
	int w,h;
	int score;
	int aniamation_step;
	boolean restart;
	boolean jumping;
	Engine e;



	Bird(Engine e){
		this.e=e;
		this.y_vel=0;
		this.pos=new PVector(200,height/2);
		this.gravity=0;
		this.end=false;
		this.w=25;
		this.h=20;
		this.score=0;
		this.aniamation_step=-1;
		this.restart=false;
		this.jumping=false;
	}



	void jump(){
		this.gravity=0.115;
		this.y_vel-=3;
		this.y_vel=constrain(this.y_vel,-4,4);
	}



	void update(){
		if (this.aniamation_step==0){
			this.y_vel=-3;
			this.gravity=0.2;
		}
		if (this.end==false){
			this.pos.y+=this.y_vel;
			this.y_vel+=this.gravity;
			if (this.pos.y<10){
				this.pos.y=10;
				this.y_vel=0;
			}
			if (this.pos.y>=height-10){
				this.end=true;
			}
			for (Pipe p : this.e.pipes){
				if (p.collision(this)){
					this.end=true;
				}
			}
		}
		if (this.end==true){
			this.pos.y+=this.y_vel;
			this.y_vel+=this.gravity;
			this.aniamation_step++;
		}
		if (this.pos.y-this.w/2>=height){
			this.restart=true;
		}
	}



	void draw(){
		noStroke();
		fill(#FAD728);
		ellipseMode(CENTER);
		translate(this.pos.x,this.pos.y);
		if (this.aniamation_step>0&&this.aniamation_step<20){
			rotate(map(this.aniamation_step,0,20,0,PI/2));
		}
		if (this.aniamation_step>=20){
			rotate(PI/2);
		}
		ellipse(0,0,this.w,this.h);
	}
}
