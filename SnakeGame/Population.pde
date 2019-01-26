class Population {
  TileSet[] snakes;
  
  int generation = 1;
  int bestSize = 4;
  int bestFitness = 0;
  int currentBestSize = 4;
  int currentBestSnake = 0;
  float mutationRate = 0.02;
  boolean showAll = false;
  
  TileSet bestSnake;
  
  //-----------------------------------------
  Population(int size){
    snakes = new TileSet[size];
    
    for (int i = 0; i < size; i++) {
      snakes[i] = new TileSet();  
    }
    
    bestSnake = snakes[0].clone();
  }
  
  //-----------------------------------------
  void updateAll(){
    snakes[0].show();
    for (int i = 0; i < snakes.length; i++) {
      if (!(i == currentBestSnake)) {
        snakes[i].neuralUpdate(showAll);
      } else {
        snakes[i].neuralUpdate(true);  
      }
    }
    
    setCurrentBest();
  }
  
  //-----------------------------------------
  void calculateFitness(){
    for (int i = 0; i < snakes.length; i++) {
      snakes[i].player.calculateFitness();  
    }
  }
  
  //-----------------------------------------
  boolean allDead(){
    for (int i = 0; i < snakes.length; i++) {
      if (snakes[i].player.isAlive()) {
        return false;  
      }
    }
    return true;
  }
  
  //-----------------------------------------
  void setCurrentBest(){
    float max = 0;
    int maxIndex = 0;
    for (int i = 0; i < snakes.length; i++) {
      if (snakes[i].player.pos.length > max && snakes[i].player.isAlive()) {
        max = snakes[i].player.pos.length;  
        maxIndex = i;
      }
    }
    
    if (floor(max) > currentBestSize) {
      currentBestSize = floor(max);      
    }
    
    if (!snakes[currentBestSnake].player.isAlive() || max > (snakes[currentBestSnake].player.pos.length + 5)) {
      currentBestSnake = maxIndex;  
    }
    
    if (currentBestSize > bestSize) {
      bestSize = currentBestSize;  
    }
  }
  
  //-----------------------------------------
  void setBestSnake(){
    float max = 0;
    int maxIndex = 0;
    
    for (int i = 0; i < snakes.length; i++) {
      if (snakes[i].player.fitness > max) {
        max = snakes[i].player.fitness;
        maxIndex = i;
      }
    }
    
    if (max > bestFitness) {
      bestFitness = floor(max);
      bestSnake = snakes[maxIndex].clone();
    }
  }
  
  //-----------------------------------------
  void mutate(){
    for (int i = 1; i < snakes.length; i++) {
      snakes[i].mutate(mutationRate);  
    }
  }
  
  //-----------------------------------------
  TileSet selectOne(){
    float fitnessSum = 0;
    for (int i = 0; i < snakes.length; i++) {
      fitnessSum += snakes[i].player.fitness;  
    }
    
    float randomSnake = floor(random(fitnessSum));
    
    float calcSum = 0;
    for (int i = 0; i < snakes.length; i++) {
      calcSum += snakes[i].player.fitness;
      if (calcSum > randomSnake) {
        return snakes[i];  
      }
    }
    
    return snakes[0];
  }
  
  //-----------------------------------------
  void naturalSelection(){
    TileSet[] newSnakes = new TileSet[snakes.length];
    
    setBestSnake();
    newSnakes[0] = bestSnake.clone();
    
    println(generation + ": " + newSnakes[0].player.fitness);
    
    for (int i = 1; i < newSnakes.length; i++) {
      TileSet mother = selectOne();
      TileSet father = selectOne();
      
      TileSet child = mother.crossover(father);
      child.mutate(mutationRate);
      newSnakes[i] = child;
    }
    
    snakes = newSnakes;
    generation++;
    bestSize = 4;
    currentBestSize = 4;
    currentBestSnake = 0;
  }
}
