class TileSet {
  ScoreObject score;
  PlayerObject player;
  Neural brain;
  float tileSize = 20.0;  
  int sizeX = (int)(width / tileSize);
  int sizeY = (int)(height / tileSize);
  int[][] tileSet = new int[sizeX][sizeY];
  PVector[] freeTiles;
  float[] vision = new float[24];
  float[] decision = new float[4];
  
  //-----------------------------------
  TileSet(int fill){
    for (int i = 0; i < sizeX; i++) {
      for (int j = 0; j < sizeY; j++) {
        tileSet[i][j] = fill;
      }
    }
    restart();
    
    brain = new Neural(24, 18, 4);
  }
  
  //-----------------------------------
  TileSet(){
    for (int i = 0; i < sizeX; i++) {
      for (int j = 0; j < sizeY; j++) {
        tileSet[i][j] = 0;
      }
    }
    restart();
    brain = new Neural(24, 18, 4);
  }
  
  //-----------------------------------
  void showTile(int posX, int posY, color col){
    fill(col);
    rect(posX * tileSize, posY * tileSize, tileSize, tileSize);
  }
  
  //----------------------------------
  void show(){
    for (int i = 0; i < sizeX; i++) {
      for (int j = 0; j < sizeY; j++) {
        showTile(i, j, tileSet[i][j]);
      }
    }      
  }
  
  //----------------------------------
  void showScore(){
    showTile((int)score.pos.x, (int)score.pos.y, score.col);
  }
  
  //---------------------------------
  void showPlayer(){
    for (int i = 0; i < player.pos.length; i++) {
      showTile((int)player.pos[i].x, (int)player.pos[i].y, player.col); 
    }
  }
  
  //--------------------------------
  void randScorePosition(){
    freeTiles = new PVector[0];
    for (int i = 0; i < sizeX; i++) {
      for (int j = 0; j < sizeY; j++) {
        if (!player.hasIn(i, j)) {
          freeTiles = (PVector[])append(freeTiles, new PVector(i, j));
        }
      }
    }
    
    int ind = floor(random(freeTiles.length));
    score.moveTo((int)freeTiles[ind].x, (int)freeTiles[ind].y);
  }
  
  
  //---------------------------------
  void collisions(){
    if (player.pos[0].x < 0 || player.pos[0].y < 0 || player.pos[0].x > (sizeX - 1) || player.pos[0].y > (sizeY - 1)) {
      player.kill(); 
    } else if (player.pos[0].x == score.pos.x && player.pos[0].y == score.pos.y) {
      player.grow();
      randScorePosition();
    } else if (player.hasIn((int)player.pos[0].x, (int)player.pos[0].y)) {
      player.kill(); 
    }
  }
  
  //---------------------------------
  TileSet clone(){
    TileSet clone = new TileSet();
    clone.brain = brain.clone();
    clone.player.fitness = player.fitness;
    
    return clone;
  }
  
  //---------------------------------
  void mutate(float mutationRate){
    brain.mutate(mutationRate);  
  }
  
  //--------------------------------
  void makeStep(){
    decision = brain.calculate(vision); 
    
    float max = decision[0];
    float maxIndex = 0;
    for (int i = 0; i < decision.length; i++) {
      if (decision[i] > max) {
        max = decision[i];
        maxIndex = i;
      }
    }
    
    switch ((int)maxIndex) {
      case 0:
        player.neuralStep(1.0, 0.0);
        break;
      case 1:
        player.neuralStep(-1.0, 0.0);
        break;
      case 2:
        player.neuralStep(0.0, 1.0);
        break;
      case 3:
        player.neuralStep(0.0, -1.0);
        break;
    }
  }
  
  //--------------------------------
  TileSet crossover(TileSet parthner) {
    TileSet child = new TileSet();
    child.brain = brain.crossover(parthner.brain);
    
    return child;
  }
  
  //---------------------------------
  void look(){
    vision = new float[24];
    
    float[] temps = lookInDirection(1, 0);
    vision[0] = temps[0];
    vision[1] = temps[1];
    vision[2] = temps[2];
    temps = lookInDirection(1, 1);
    vision[3] = temps[0];
    vision[4] = temps[1];
    vision[5] = temps[2];
    temps = lookInDirection(0, 1);
    vision[6] = temps[0];
    vision[7] = temps[1];
    vision[8] = temps[2];
    temps = lookInDirection(1, -1);
    vision[9] = temps[0];
    vision[10] = temps[1];
    vision[11] = temps[2];
    temps = lookInDirection(-1, 0);
    vision[12] = temps[0];
    vision[13] = temps[1];
    vision[14] = temps[2];
    temps = lookInDirection(-1, -1);
    vision[15] = temps[0];
    vision[16] = temps[1];
    vision[17] = temps[2];
    temps = lookInDirection(0, -1);
    vision[18] = temps[0];
    vision[19] = temps[1];
    vision[20] = temps[2];
    temps = lookInDirection(-1, 1);
    vision[21] = temps[0];
    vision[22] = temps[1];
    vision[23] = temps[2];
  }
  
  //---------------------------------
  float[] lookInDirection(int x, int y){
    float[] temp = new float[3]; //0 for food 1 for tail 2 for wall
    PVector lookPosition = player.pos[0].copy();
    PVector direction = new PVector(x, y);
    boolean foundTail = false;
    boolean foundFood = false;
    float distance = 0;
     
    lookPosition.add(direction);
    distance++;
    
    while (!(lookPosition.x < 0 || lookPosition.y < 0 || lookPosition.x >= (sizeX) || lookPosition.y >= (sizeY))) {
      if (!foundFood && lookPosition.x == score.pos.x && lookPosition.y == score.pos.y) {
        foundFood = true;
        temp[0] = 1;
      }
      
      if (!foundTail && player.hasIn((int)lookPosition.x, (int)lookPosition.y)) {
        foundTail = true;
        temp[1] = 1 / distance;
      }
      
      lookPosition.add(direction);
      distance++;
    }
    
    temp[2] = 1 / distance;
    
    return temp;
  }
  
  //--------------------------------
  void restart(){
    score = new ScoreObject(sizeX - 1, sizeY - 1);
    player = new PlayerObject(sizeX / 2, sizeY / 2); 
  }
  
  //--------------------------------
  void inputs(){
    if (keyPressed) {
      if (key == 'r') {
        restart(); 
      }
    }
  }
  
  //---------------------------------
  void update(){
    if (player.isAlive()) {
      player.step();
      collisions();
      show();
      showScore();
      showPlayer();
    } 
    inputs();
  }
  
  //---------------------------------
  void neuralUpdate(boolean show){
    if (player.isAlive()) {
      look();
      makeStep();
      collisions();
      if (show) {
        showScore();
        showPlayer();
      }
    } 
  }
}
