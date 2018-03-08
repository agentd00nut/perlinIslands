import controlP5.*;
ControlP5 cp5;

float positiveFillRate = .7;
float negativeFillRate = .3;


int smoothIterations=12;
int smoothNeighbors=5;

int screenIndex=0;
int dir=1;

int cp5_Y=850;

ArrayList<Integer> colors = new ArrayList<Integer>();

PImage world;

int worldX,worldY;

void setup(){
  size(850,910);
  
  worldX=850;
  worldY=910;
  world = createImage(worldX, worldY, ARGB);

  //smooth(8);
  cp5 = new ControlP5(this);
  
  
  cp5.addSlider("screenIndex").setPosition(0,cp5_Y).setSize(200,20).setRange(0,1);
  cp5.addSlider("perlinRate").setPosition(0,cp5_Y+20).setSize(800,20).setRange(.001,.1);
  
  cp5.addSlider("smoothIterations").setPosition(0,cp5_Y+40).setSize(200,20).setRange(1,24);
  cp5.addSlider("smoothNeighbors").setPosition(0,cp5_Y+60).setSize(200,20).setRange(2,8);
  //cp5.addSlider("positiveFillRate").setPosition(0,cp5_Y+100).setSize(200,20).setRange(0,1);
  //cp5.addSlider("negativeFillRate").setPosition(0,cp5_Y+120).setSize(200,20).setRange(0,1);
  
  
  //screens.add(new BitScreen(600,600,0, 0, 0));
  //screens.add(new BitScreen(800,800,4, 300,500));
  
  for(int i=0; i<4; i++){
    int a = (int)random(50,200)*2;
    screens.add(new BitScreen(a,a,  1,  (int)random(0,worldX-a), (int)random(0, worldY-a)) );
  }
  
  //screens.get(0).randomNoise(.7, color(255));
  //screens.get(0).perlinNoise(.5);
  //screens.get(1).perlinNoise(.5);
  screens.get(0).flush();
  screens.get(1).flush();
  
  colors.add(color(#436adb));
  colors.add(color(#c7dffc));
  colors.add(color(#feecc3));
  colors.add(color(#fdd183));
  colors.add(color(#00c44b));
  colors.add(color(#40eb5c));
  colors.add(color(#9a682e));
  colors.add(color(#5a544b));
  colors.add(color(#9d9a8d));
  colors.add(color(#cbe0e0));
  colors.add(color(#eef7ff));
  colors.add(color(#ffffff));

}
float perlinRate = .01;
float incr=0.00; // .001
float offx=20;
float offy=0;
int ND=3;

boolean doSmooth = false;
boolean doMove = true;
boolean doRecord = false;
void draw(){
  background(colors.get(0));
  world = createImage(worldX, worldY, ARGB);
  for(int i=0; i < screens.size(); i++){
    BitScreen x = screens.get(i);
    x.clearBuffers();
    x.flush();
    //x.perlinNoise(perlinRate, offx, offy);
    x.perlinNoise(perlinRate, offx,offy);
    if ( doSmooth == true){
      x.smooth(smoothIterations,smoothNeighbors);
    }
    x.flush();
    
    if( doMove == true){
      offx+=.01;
      offy+=.04;
    }
    
    world.blend(x.screen,0,0,worldX,worldY,x.x,x.y,x.w,x.h,ADD);
  }
  delay(16);
  image(world,0,0);
  
  
  if( doRecord == true){
    saveFrame("/Users/abrothers/Desktop/newIslands/######.tif");
  }
  
  //println(offx, offy);
  
}