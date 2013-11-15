//Constants for user to change:
int fps = 30;
float waveZoom = 300; //Larger waveZoom is more zoomed out.
float waveSpeed = 1f/700f; //Smaller is slower.
boolean blackAndWhite = true;

//Variables:
float colorRange = 1; //OpenGL color [0..1]
float colorShift = 0; //optional shift of hue spectrum
DrunkWalk rangeWalk = new DrunkWalk(0);

PShader quasiShader;
PGraphics pg;

int waveCount = 7;

void setup(){
  size(1024,768,P2D);
  frameRate(fps);
  noStroke();
  pg = createGraphics(width, height, P2D);
  
  quasiShader = loadShader("quasi.fragment");
  quasiShader.set("resolution", float(pg.width),float(pg.height));
  quasiShader.set("zoom", waveZoom);
  quasiShader.set("colorRange", colorRange);
  quasiShader.set("colorShift", colorShift);
  quasiShader.set("blackAndWhite", blackAndWhite?1:0);
  
}

void draw(){
  quasiShader.set("time",float(millis())*waveSpeed);
  colorRange = rangeWalk.update();
  quasiShader.set("colorRange", colorRange);
  
  //Optional:
  //colorShift = (1.0-colorRange)/2;
  //quasiShader.set("colorShift", colorShift);
  
  background(0);
  shader(quasiShader);
  rect(0,0,width,height);
  frame.setTitle("frame: " + frameCount + " - fps: " + int(frameRate)); 
}

// Continuously walks to a new destination from [0..1]
// after reaching previous.
class DrunkWalk{
  float dest, curr, step, speed;
  DrunkWalk(float _curr){
    this(_curr,0.001f); //Default speed
  }
  DrunkWalk(float _curr,float _speed){
    curr = _curr;
    speed = _speed;
    reset();
  }
  public float update(){
    curr += step;
    if(isFinished()){
      reset();
    }
    return curr;
  }
  private boolean isFinished(){
    return (step < 0 && curr <= dest) ||
         (step > 0 && curr >= dest );
  }
  public void reset(){
    dest = random();
    if(dest<curr)step=-speed;
    else step = speed;
  }
}

float random(){
  return random(10000)/10000;
}
