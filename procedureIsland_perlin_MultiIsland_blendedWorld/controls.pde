
ArrayList<BitScreen> screens = new ArrayList<BitScreen>();

void keyPressed() {
  BitScreen x = screens.get(screenIndex);
  if(key=='n'){
    x.randomNoise(positiveFillRate, color(255));
    x.flush();
  }
  if(key=='N'){
    x.randomNoise(negativeFillRate, color(0));
    x.flush();
  }
  if(key=='C'){
    x.clearBuffers();
    x.flush();
  }
  if(key=='s'){
    x.smooth(smoothIterations, smoothNeighbors);
    x.flush();
  }
  if(key=='d'){
    x.flush();
  }
  if(key=='i'){
    x.nudgeY(1);
    x.flush();
  }
  if(key=='f'){
    x.flush();
  }
  if(key=='k'){
    x.nudgeY(-1);
    x.flush();
  }
  if(key=='c'){
    //x.flushTmpBuffer();
    //x.compress(3);
    //x.flush();
  }
  if(key=='e'){
    //x.flushTmpBuffer();
    //x.expand(1);
    //x.flush();
  }
  if(key=='b'){
    //x.flushTmpBuffer();
    println("trying to blend");
    BitScreen y = screens.get(1);
    blend(screens.get(0).screen, 0, 0, (int)(x.w*x.s), (int)(x.h*x.s), 0, 0, (int)(y.w*y.s), (int)(y.h*y.s), MULTIPLY);
  }
  
  if(key=='='){
    ND++;
    
  }
  if(key=='-'){
    ND--;
    if(ND < 0){
      ND ++;
    }
  }
  
   if(key=='p'){
    //x.perlinNoise(perlinRate);
    x.flush();
  }
  
  if(key=='S'){
    doSmooth = !doSmooth;
  }
  if(key=='M'){
    doMove = !doMove;
  }
  
  if(key=='R'){
    doRecord = !doRecord;
  }
}