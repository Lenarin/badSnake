class ScoreObject{
  PVector pos; 
  color col = color(0, 255, 0);
  
  //------------------------------------------
  ScoreObject(int sizeX, int sizeY) {
    pos = new PVector(round(random(sizeX)), round(random(sizeY))); 
  }
  
  //------------------------------------------
  void moveTo(int posX, int posY) {
    pos.set(posX, posY);  
  }
}
