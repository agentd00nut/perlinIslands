class BitScreen {
  int w;
  int h;
  int x;
  int y;
  float s;
  
  int[][] buffer;
  int[][] tmpBuffer;
  PImage screen;
  BitScreen(int _w, int _h, int _scale, int _x, int _y){
    w = floor(_w/_scale);
    h = floor(_h/_scale);
    s = _scale;
    buffer = new int[w][h];
    tmpBuffer = new int[w][h];
    screen = createImage(_w, _h, ARGB);
    clearBuffers();
    
    x=_x;
    y=_y;
    
    println("w",w);
    println("h",h);
    println("s",s);
  }
  
  void fill(int c){
    screen.loadPixels();
    for(int y=0; y<h; y++){
      for(int x=0; x<w; x++){
        screen.pixels[x+(y*w)]=c;
      }
    }
    screen.updatePixels();
  }
  
  void clearBuffer(){
     for(int y=0; y < h; y++){
      for(int x=0; x< w; x++){
          buffer[x][y]=color(0,0,0,0);
      }
    }
  }
  
  void clearBuffers(){
    for(int y=0; y < h; y++){
      for(int x=0; x< w; x++){
          buffer[x][y]=color(0,0,0,0);
          tmpBuffer[x][y]=color(0,0,0,0);
      }
    }
  }
  
  void randomNoise(float fillRate, int fill ){
    //println("Noise,",fillRate,",",fill);
    for(int y=1; y < h-1; y++){
      for(int x=1; x< w-1; x++){
        if( random(0, 1) < fillRate){
          buffer[x][y]=fill;
        }
      }
    }    
  }
  
  
  void perlinNoise(float increment, float offx, float offy ){

    float island_size=w;
    float yd=offy+(this.x*1);
    for(int y=1; y < h-1; y++){
      yd+=increment;
      float xd=offx+(this.y*100);
      for(int  x=1; x< w-1; x++){
        xd+=increment;
        
        float distance_x = abs(x - island_size * 0.5f);
        float distance_y = abs(y - island_size * 0.5f);
        float distance = sqrt(distance_x*distance_x + distance_y*distance_y); // circular mask
        
        float max_width = island_size * 0.5f - 10.0f;
        float delta = distance / max_width;
        float gradient = delta * delta;
        
        
        // Apply circle gradient to our noise
        float b = noise(xd, yd);        
        b = b*255;
        b *= max(0.0f, 1.0f - gradient);
        
        // Map the noise into color gradients
        int n = (int)map(b, 80, 200, 0,colors.size()-1);
        n=max(n,0);
        n=min(n,colors.size()-1);
           
        // Offset the colored pixels by some amount to create black banding for illusion of height.
        //int newY = y-( (n*(n/2)) / 2 );
        int newY = y-( n );
        if( newY < 1 ){ newY = 1; }
       
        buffer[x][y]=color(0); //color(b);
        if( n == 0 ){
          buffer[x][newY]=color(0,0,0,0 );
        }else{
          buffer[x][newY]=colors.get( n ); 
        }
        
      }
    }
  }
    
  void flush(){
    
    screen.loadPixels();
    for(int y=0; y < h; y++){
      for(int x=0; x < w; x++){
        for( int tY=0; tY<s; tY++){
          for( int tX=0; tX<s; tX++){
            //if( screen.pixels[((int)(s*x)+tX)+(int)((tY+(y*s))*(w*s))] == color(#436adb) ){
              screen.pixels[((int)(s*x)+tX)+(int)((tY+(y*s))*(w*s))]=buffer[x][y];
            //}
          }
        }
      }
    }
    screen.updatePixels();
    
    //image(screen,this.x,this.y);

  }
  
  void smooth(int iterations, int threshold){
    int n=0;
    while(n < iterations){
      for(int y=1; y < h-1; y++){
        for(int x=1; x < w-1; x++){
          if( countNeighbors(x,y) >= threshold){
            tmpBuffer[x][y]=color(255);
          }else{
            tmpBuffer[x][y]=color(0,0,0); 
          }
        }
      }      
      n++;
      flushTmpBuffer();
    }
  }
  
  void flushTmpBuffer(){
     for(int y=1; y < h-1; y++){
        for(int x=1; x < w-1; x++){
          buffer[x][y] = tmpBuffer[x][y];
          tmpBuffer[x][y] = color(0);
        }
     }
  }
  
  int countNeighbors(int x, int y){
    // TODO: Check if x and y are within bounds.
    int c=0;
    int cutoffColor=100;
    if( x-1 > 0 ){
      if(y-1 > 0){
        if(buffer[x-1][y-1] > color(cutoffColor)){ c++; }
      }
      if(buffer[x-1][y]   > color(cutoffColor)){ c++; }
      if(y+1 <= h){
        if(buffer[x-1][y+1] > color(cutoffColor)){ c++; }
      }
    }
    
    if(y-1 > 0){
      if(buffer[x][y-1] > color(cutoffColor)){ c++; }
    }
    if(y+1 <= h){
      if(buffer[x][y+1] > color(cutoffColor)){ c++; }
    }
    
    if(x+1 <= w ){
      if(y-1 > 0){
        if(buffer[x+1][y-1] > color(cutoffColor)){ c++; }
      }
      if(buffer[x+1][y]   > color(cutoffColor)){ c++; }
      if(y+1 < h){
        if(buffer[x+1][y+1] > color(cutoffColor)){ c++; }
      }
    }

    return c;
  }
  
  void nudgeY(float dY){
    println("NudgeY, ", dY);
    if(dY == 1 ){

     for(int y=0; y < h-dY; y++){
        for(int x=0; x < w; x++){
          buffer[x][y]=buffer[x][y+1];
        }
     }
     for(int x=0; x<w; x++){
       buffer[x][(int)h-1]= color(0);
     }
    }else{

      for(int y=h-1; y > 0; y--){
        for(int x=0; x < w; x++){
          buffer[x][y]=buffer[x][y-1];
        }
      }
      for(int x=0; x<w; x++){
        buffer[x][0] = color(0);
      }
    }
  }
  
  void compress(int threshold){

    int tX=0;
    int tY=0;
    for(int y=0; y < h; y+=3){
      tY++;
      tX=0;
      for(int x=0; x < w; x+=3){
        tX++;
       
        if( countNeighbors(x,y) > threshold ){
          tmpBuffer[tX][tY] = color(255);
        }else{
          //println("remove this", x,y);
          tmpBuffer[tX][tY] = color(0);
        }
      }
      
    }
    clear();
    flushTmpBuffer();
    flush();
    //w=tX;
    //h=tY;

  }
  
  /* Has issues with tmpBuffer size...*/
  void expand(int threshold){ 
    for(int y=0; y < h; y++){
      for(int x=0; x < w; x++){
        for( int tY=0; tY<threshold; tY++){
          for( int tX=0; tX<threshold; tX++){
            println( y, x, tY, tX );
            println( tY, y, threshold, y*threshold, w, w*threshold );
            println( (threshold*x)+tX, (tY+(y*threshold))*(w*threshold) ); 
            tmpBuffer[((int)(threshold*x)+tX)][(int)((tY+(y*threshold))*(w*threshold))]=buffer[x][y];
            //screen.pixels[((int)(s*x)+tX)+(int)((tY+(y*s))*(w*s))]=buffer[x][y];
          }
        }
      }
    }
    flushTmpBuffer();
  }
  
}