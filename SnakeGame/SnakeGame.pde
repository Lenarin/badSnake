Population population;

void settings() {
  size(1280, 920);  
}

void setup() {
  background(0);
  population = new Population(2000);
  stroke(0, 0);
  frameRate(60);
}

void draw() {
  if (!population.allDead()) {
    population.updateAll();
  } else {
    population.naturalSelection();  
  }
}
