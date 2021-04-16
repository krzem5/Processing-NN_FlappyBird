class FlappyBird {
  Bird bird;
  ArrayList<Pipe> pipes;
  float SPEED;
  int PIPE_GAP;
  int START_PIPE_GAP;
  boolean game_state;
  String RECORD;
  JSONArray record_data;
  FlappyBird() {
    this.RECORD="";
    this.SPEED=5;
    this.PIPE_GAP=500;
    this.START_PIPE_GAP=width;
    this.setup();
  }
  void setup() {
    this.record_data=new JSONArray();
    this.game_state=true;
    this.bird=new Bird(this);
    this.pipes=new ArrayList<Pipe>();
    for (int i=0; i<int(width/this.PIPE_GAP)+10; i++) {
      this.pipes.add(new Pipe(this));
    }
  }
  void keyPress() {
    if (keyCode==32&&game_state==true) {
      bird.jump();
      bird.jumping=true;
    }
    if (keyCode==27) {
      this.save_record();
    }
  }
  void keyRelease() {
    if (keyCode==32&&game_state==true) {
      bird.jumping=false;
    }
  }
  void save_record() {
    saveJSONArray(this.record_data, "./data/"+this.RECORD+".json");
  }
  void record_action() {
    for (Pipe p : this.pipes) {
      if (p.scoreState==0||p.scoreState==1) {
        if ((p.pos.x-p.pipe_width/2-this.bird.pos.x)/300>1) {
          return;
        }
        JSONObject json=new JSONObject();//Y pos,Y vel,Dist to nearest pipe,Y pos of the nearest pipe,Pipe gap,Pipe width
        json.setFloat("bird-pos", this.bird.pos.y/height);
        json.setFloat("bird-vel", this.bird.y_vel/4);
        json.setFloat("pipe-d", (p.pos.x-p.pipe_width/2-this.bird.pos.x)/300);
        json.setFloat("pipe-y", p.pos.y/height);
        json.setFloat("pipe-g", p.gap/150.0);
        json.setFloat("pipe-w", p.pipe_width/120.0);
        json.setFloat("jumping",this.bird.jumping==true?1:0);
        this.record_data.setJSONObject(this.record_data.size(), json);
      }
    }
  }
  void draw() {
    background(35);
    for (int i=pipes.size()-1; i>=0; i--) {
      Pipe p=pipes.get(i);
      if (game_state==true) {
        p.update();
      }
      p.draw();
      if (p.offScreen==true) {
        pipes.remove(i);
        pipes.add(new Pipe(this));
      }
    }
    bird.update();
    bird.draw();
    if (bird.end==true&&game_state==true) {
      game_state=false;
      println("Score: "+bird.score);
    }
    if (bird.restart==true) {
      this.setup();
    }
    if (this.RECORD.length()>0) {
      if (frameCount%2==0) {
        this.record_action();
      }
    }
  }
}
class Bird {
  float y_vel;
  float gravity;
  PVector pos;
  boolean end;
  int w, h;
  int score;
  int aniamation_step;
  boolean restart;
  boolean jumping;
  FlappyBird e;
  Bird(FlappyBird e) {
    this.e=e;
    this.y_vel=0;
    this.pos=new PVector(200, height/2);
    this.gravity=0;
    this.end=false;
    this.w=25;
    this.h=20;
    this.score=0;
    this.aniamation_step=-1;
    this.restart=false;
    this.jumping=false;
  }
  void jump() {
    this.gravity=0.115;
    this.y_vel-=3;
    this.y_vel=constrain(this.y_vel, -4, 4);
  }
  void update() {
    if (this.aniamation_step==0) {
      this.y_vel=-3;
      this.gravity=0.2;
    }
    if (this.end==false) {
      this.pos.y+=this.y_vel;
      this.y_vel+=this.gravity;
      if (this.pos.y<10) {
        this.pos.y=10;
        this.y_vel=0;
      }
      if (this.pos.y>=height-10) {
        this.end=true;
      }
      for (Pipe p : this.e.pipes) {
        if (p.collision(this)) {
          this.end=true;
        }
      }
    }
    if (this.end==true) {
      this.pos.y+=this.y_vel;
      this.y_vel+=this.gravity;
      this.aniamation_step++;
    }
    if (this.pos.y-this.w/2>=height) {
      this.restart=true;
    }
  }
  void draw() {
    noStroke();
    fill(#FAD728);
    ellipseMode(CENTER);
    translate(this.pos.x, this.pos.y);
    if (this.aniamation_step>0&&this.aniamation_step<20) {
      rotate(map(this.aniamation_step, 0, 20, 0, PI/2));
    }
    if (this.aniamation_step>=20) {
      rotate(PI/2);
    }
    ellipse(0, 0, this.w, this.h);
  }
}
class Pipe {
  PVector pos;
  int pipe_width, gap;
  boolean offScreen;
  int scoreState;
  FlappyBird e;
  Pipe(FlappyBird e) {
    this.e=e;
    this.pipe_width=int(random(50, 120));
    this.gap=int(random(110, 150));
    this.pos=new PVector(this.e.pipes.size()>0?(this.e.pipes.get(this.e.pipes.size()-1).pos.x+this.e.PIPE_GAP):width+this.pipe_width+this.e.START_PIPE_GAP, this.e.pipes.size()>0?constrain(int(this.e.pipes.get(this.e.pipes.size()-1).pos.y+random(-350, 350)), this.gap/2+25, height-this.gap/2-25):int(random(this.gap/2+25, height-this.gap/2-25)));
    this.offScreen=false;
    this.scoreState=0;
  }
  void update() {
    this.pos.x-=this.e.SPEED;
    if (this.pos.x+this.pipe_width/2<0) {
      this.offScreen=true;
    }
  }
  boolean collision(Bird bird) {
    if (bird.pos.x+bird.w/2>=this.pos.x-this.pipe_width/2&&bird.pos.x-bird.w/2<=this.pos.x+this.pipe_width/2&&((this.pos.y-this.gap/2>=bird.pos.y-bird.h/2)||(this.pos.y+this.gap/2<=bird.pos.y+bird.h/2))) {
      this.scoreState=-1;
      return true;
    }
    if (this.scoreState==0&&bird.pos.x+bird.w/2>=this.pos.x-this.pipe_width/2&&bird.pos.x-bird.w/2<=this.pos.x+this.pipe_width/2) {
      this.scoreState=1;
    }
    if (this.scoreState==1&&bird.pos.x-bird.w/2>=this.pos.x+this.pipe_width/2) {
      this.scoreState=2;
      bird.score+=10;
    }
    return false;
  }
  void draw() {
    noStroke();
    fill(230);
    if (this.scoreState==1) {
      fill(#FFDE39);
    }
    if (this.scoreState==2) {
      fill(#A3FA2B);
    }
    if (this.scoreState==-1) {
      fill(#C6230A);
    }
    rectMode(CORNER);
    rect(this.pos.x-this.pipe_width/2, 0, this.pipe_width, this.pos.y-this.gap/2);
    rect(this.pos.x-this.pipe_width/2, this.pos.y+this.gap/2, this.pipe_width, height-this.pos.y-this.gap/2);
  }
}
