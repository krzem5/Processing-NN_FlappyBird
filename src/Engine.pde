class Engine{
	Bird bird;
	ArrayList<Pipe> pipes;
	float SPEED;
	int PIPE_GAP;
	int START_PIPE_GAP;
	boolean game_state;
	String RECORD;
	JSONArray record_data;



	Engine(){
		this.RECORD="";
		this.SPEED=5;
		this.PIPE_GAP=500;
		this.START_PIPE_GAP=width;
		this.setup();
	}



	void setup(){
		this.record_data=new JSONArray();
		this.game_state=true;
		this.bird=new Bird(this);
		this.pipes=new ArrayList<Pipe>();
		for (int i=0;i<int(width/this.PIPE_GAP)+10;i++){
			this.pipes.add(new Pipe(this));
		}
	}



	void keyPress(){
		if (keyCode==32&&game_state==true){
			bird.jump();
			bird.jumping=true;
		}
		if (keyCode==27){
			this.save_record();
		}
	}



	void keyRelease(){
		if (keyCode==32&&game_state==true){
			bird.jumping=false;
		}
	}



	void save_record(){
		saveJSONArray(this.record_data,"data/"+this.RECORD+".json");
	}



	void record_action(){
		for (Pipe p : this.pipes){
			if (p.scoreState==0||p.scoreState==1){
				if ((p.pos.x-p.pipe_width/2-this.bird.pos.x)/300>1){
					return;
				}
				JSONObject json=new JSONObject();//Y pos,Y vel,Dist to nearest pipe,Y pos of the nearest pipe,Pipe gap,Pipe width
				json.setFloat("bird-pos",this.bird.pos.y/height);
				json.setFloat("bird-vel",this.bird.y_vel/4);
				json.setFloat("pipe-d",(p.pos.x-p.pipe_width/2-this.bird.pos.x)/300);
				json.setFloat("pipe-y",p.pos.y/height);
				json.setFloat("pipe-g",p.gap/150.0);
				json.setFloat("pipe-w",p.pipe_width/120.0);
				json.setFloat("jumping",this.bird.jumping==true?1:0);
				this.record_data.setJSONObject(this.record_data.size(),json);
			}
		}
	}



	void draw(){
		background(35);
		for (int i=pipes.size()-1;i>=0;i--){
			Pipe p=pipes.get(i);
			if (game_state==true){
				p.update();
			}
			p.draw();
			if (p.offScreen==true){
				pipes.remove(i);
				pipes.add(new Pipe(this));
			}
		}
		bird.update();
		bird.draw();
		if (bird.end==true&&game_state==true){
			game_state=false;
			println("Score: "+bird.score);
		}
		if (bird.restart==true){
			this.setup();
		}
		if (this.RECORD.length()>0){
			if (frameCount%2==0){
				this.record_action();
			}
		}
	}
}
