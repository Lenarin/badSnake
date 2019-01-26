class PlayerObject{
  color col = color(255);
  PVector[] pos;
  PVector dir = new PVector(0, 1);
  boolean dead = false;
  float fitness;
  float lifetime;
  int turnsForLive;
  
  
  
  //-----------------------
  PlayerObject(int posX, int posY){
    pos = new PVector[4];
    fitness = 0;
    lifetime = 0;
    turnsForLive = 200;
    for (int i = 0; i < pos.length; i++) {
      pos[i] = new PVector(posX, posY - i); 
    }
  }
  
   //-----------------------
  void calculateFitness(){
     if (pos.length < 10) {
       fitness = floor(lifetime * lifetime * pow(2, pos.length - 1));  
     } else {
       fitness = floor(lifetime * lifetime * 1000 * (pos.length - 9));  
     }
  }
  
  //-----------------------
  void step(){
    inputs();
    
    PVector[] newPos = new PVector[pos.length];
    newPos[0] = pos[0].copy().add(dir);
    for (int i = 1; i < newPos.length; i++) {
       newPos[i] = pos[i - 1];
    }
    pos = newPos;
  }
  
  //-----------------------
  void neuralStep(float x, float y){
    dir.x = x;
    dir.y = y;
    
    lifetime++;
    turnsForLive--;
    
    if (turnsForLive <= 0) {
      kill(); 
    } else {
      PVector[] newPos = new PVector[pos.length];
      newPos[0] = pos[0].copy().add(dir);
      for (int i = 1; i < newPos.length; i++) {
         newPos[i] = pos[i - 1];
      }
      pos = newPos;
    }
  }
  
  //----------------------
  boolean hasIn(int posX, int posY){
    for (int i = 1; i < pos.length; i++) {
      if (pos[i].x == posX && pos[i].y == posY) return true; 
    }
    
    return false;
  }
  
  //----------------------
  void inputs(){
    if (keyPressed) {
      if (keyCode == UP) {
        if (!(dir.y == 1)) dir.set(0, -1); 
      } else if (keyCode == DOWN) {
        if (!(dir.y == -1)) dir.set(0, 1); 
      } else if (keyCode == LEFT) {
        if (!(dir.x == 1)) dir.set(-1, 0); 
      } else if (keyCode == RIGHT) {
        if (!(dir.x == -1)) dir.set(1, 0); 
      }
    }
  }
  
  //----------------------
  void grow(){
     PVector[] newPos = new PVector[pos.length + 1];
     for (int i = 0; i < newPos.length - 1; i++) {
       newPos[i] = pos[i];    
     }
     newPos[newPos.length - 1] = newPos[newPos.length - 2];
     
     pos = newPos;
     turnsForLive += 100;
  }
  
  //----------------------
  void kill(){
    dead = true;
    calculateFitness();
  }
  
  //----------------------
  boolean isAlive(){
    return !dead; 
  }
}
