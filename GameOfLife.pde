int cells;
int cellSize = 10;
boolean[][] workingPlaces;
boolean[][] places;

boolean isPlaying = false;

void setup() {
  size(600, 600);
  
  cells = width / cellSize;
  workingPlaces = new boolean[cells][cells];
  places = new boolean[cells][cells];

  frameRate(30);
  noStroke();
  textSize(12);
}

void draw() {
  if(isPlaying) {
    processNextIteration();
    delay(100);
  }
  
  drawCells();
  drawStatus();
}

void processNextIteration() {
  for(int i = 0; i < cells; ++i) {
    for(int j = 0; j < cells; ++j) {
      workingPlaces[i][j] = shouldLiveInNextIteration(i, j);
    }
  }
  
  for(int i = 0; i < cells; ++i) {
    for(int j = 0; j < cells; ++j) {
      places[i][j] = workingPlaces[i][j];
    }
  }
}

boolean shouldLiveInNextIteration(int x, int y) {
  int neighbours = 0;
  if(isInArrayBounds(x - 1, y - 1)) {
    if(isAlive(x - 1, y - 1)) neighbours++;
  }
  if(isInArrayBounds(x - 1, y)) {
    if(isAlive(x - 1, y)) neighbours++;
  }
  if(isInArrayBounds(x - 1, y + 1)) {
    if(isAlive(x - 1, y + 1)) neighbours++;
  }
  
  if(isInArrayBounds(x + 1, y - 1)) {
    if(isAlive(x + 1, y - 1)) neighbours++;
  }
  if(isInArrayBounds(x + 1, y)) {
    if(isAlive(x + 1, y)) neighbours++;
  }
  if(isInArrayBounds(x + 1, y + 1)) {
    if(isAlive(x + 1, y + 1)) neighbours++;
  }
  
  if(isInArrayBounds(x, y - 1)) {
    if(isAlive(x, y - 1)) neighbours++;
  }
  if(isInArrayBounds(x, y + 1)) {
    if(isAlive(x, y + 1)) neighbours++;
  }
  
  if(isAlive(x, y)) {
    if(neighbours == 2 || neighbours == 3) {
      return true;
    }
  } else {
    if(neighbours == 3) {
      return true;
    }
  }
  
  return false;
}

boolean isInArrayBounds(int x, int y) {
  return (x >= 0) && (x < cells) && (y >= 0) && (y < cells);
}

void drawCells() {
  for(int i = 0; i < cells; ++i) {
    for(int j = 0; j < cells; ++j) {
      drawCell(i, j);
    }
  }
}

void drawCell(int i, int j) {
  if(isAlive(i, j)) {
    fill(255);
  } else {
    fill(0);
  }
  rect(i * cellSize, j * cellSize, cellSize, cellSize);
}

void drawStatus() {
  fill(100, 200, 255);
  String status = "Paused";
  if(isPlaying) {
    status = "Playing";
  }
  text(status, 5, 14);
}

void keyPressed() {
  if(key == ENTER) {
    togglePlayPause();
  }
  else if(key == BACKSPACE) {
    clearCells();
  }
}

void togglePlayPause() {
  isPlaying = !isPlaying;
}

void clearCells() {
  for(int i = 0; i < cells; ++i) {
    for(int j = 0; j < cells; ++j) {
      makeDead(i, j);
    }
  }
}

void mousePressed() {
  if (isPlaying) {
    return;
  }
  
  int xPos = mouseX / cellSize;
  int yPos = mouseY / cellSize;
  
  toggleAliveDeadState(xPos, yPos);
}

void toggleAliveDeadState(int xPos, int yPos) {
  places[xPos][yPos] = !places[xPos][yPos];
}

void mouseDragged() 
{
  if (isPlaying) {
    return;
  }
  
  int xPos = mouseX / cellSize;
  int yPos = mouseY / cellSize;
  
  makeAliveIfDead(xPos, yPos);
}

void makeAliveIfDead(int xPos, int yPos) {
  if(isWithinBoundsAndDead(xPos, yPos)) {
    makeAlive(xPos, yPos);
  }
}

boolean isWithinBoundsAndDead(int xPos, int yPos) {
  return isInArrayBounds(xPos, yPos) && !isAlive(xPos, yPos);
}

void makeAlive(int xPos, int yPos) {
  places[xPos][yPos] = true;
}

void makeDead(int xPos, int yPos) {
  places[xPos][yPos] = false;
}

boolean isAlive(int xPos, int yPos) {
  return places[xPos][yPos];
}
