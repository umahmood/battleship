int interval          = 100;
int currentIterations = 0;
int lastRecordedTime  = 0;

int[][] grid;
int gridSize = 40;

// battleship sizes
int aircraftCarrier = 5;
int battleship      = 4;
int submarine       = 3;
int cruiser         = 3;
int destroyer       = 2;

boolean gameOver  = false;
int missilesFired = 0;
int missilesHit   = 0;

String currentMode;
boolean targetMode      = false;
int targetModeAttempts  = 4;
int lastMissileX        = 0;
int lastMissileY        = 0;
 
color ship   = color(153, 165, 178);
color hit    = color(228, 64, 93);
color miss   = color(249, 118, 37);

final int SHIP =  1;
final int HIT  = -1;
final int MISS = -2;

void setup() {
    size(641, 361, FX2D);   
    // draw background of grid
    stroke(50);
    noSmooth();
    // init. array
    grid = new int[width/gridSize][height/gridSize];
    for(int x=0; x < width/gridSize; x++) {
        for(int y=0; y< height/gridSize; y++) {
            grid[x][y] = 0;
        }
    } 
    placeShips();
}

// Draw game state to canvas.
void draw() {   
    background(color(50, 57, 66));
    // draw grid    
    for (int x=0; x < width/gridSize; x++) {
        for (int y=0; y < height/gridSize; y++) {
           if(grid[x][y] == SHIP) {
             fill(ship);  
           } else if (grid[x][y] == HIT) { 
             fill(hit);
           } else if (grid[x][y] == MISS) { 
             fill(miss);
           }
           rect(x*gridSize, y*gridSize, gridSize, gridSize);
           noFill();
       } 
   } 
   
   if (targetMode) {
       currentMode = "target";    
   } else {
        currentMode = "hunt";   
   }
   
   surface.setTitle("Battleships - Mode " + currentMode + " - Fired: " + 
                    parseInt(missilesFired) + " Hits " + parseInt(missilesHit));
    
   if (gameOver) {
       textSize(50);
       fill(255);
       text("GAME OVER!", width/4, height/2); 
       noFill();
   }
   // iterate if timer ticks
   if(millis()-lastRecordedTime>interval) {
       // when the clock ticks 
       iteration();
       currentIterations++;
       lastRecordedTime = millis();
   }
}

// Determine if the game is over.
boolean allShipsDestroyed() {
     for(int x=0; x < width/gridSize; x++) {
        for(int y=0; y< height/gridSize; y++) {
            if (grid[x][y] == SHIP) {
                return false;
            }
        }
    }
    gameOver = true;
    return true;
}

// Add N E S W locations relative to fromX and fromY. 
ArrayList<PVector> findTargets(int fromX, int fromY) {    
    ArrayList<PVector> coords = new ArrayList<PVector>();
    // FIX: this is naive we do not take into account whether the 
    // coordinate has already been hit or missed.
    coords.add(new PVector(fromX+1, fromY));
    coords.add(new PVector(fromX-1, fromY));
    coords.add(new PVector(fromX, fromY+1));
    coords.add(new PVector(fromX, fromY-1));
    return coords;
}

// Iteration updates world state.
void iteration() {
    if (allShipsDestroyed()) {
        return;   
    }
    
    int x = 0;
    int y = 0;
    
    if (targetMode) {
        targetModeAttempts = targetModeAttempts - 1;
        ArrayList<PVector> tg = findTargets(lastMissileX, lastMissileY);
        PVector p = tg.get(targetModeAttempts);
        x = int(p.x);
        y = int(p.y);
        if (targetModeAttempts == 0) {                
            targetMode = false;
            targetModeAttempts = 4;    
        } 
    } else {
        x = int(random(width/gridSize));
        y = int(random(height/gridSize));
    }
    
    if (grid[x][y] == SHIP) {
        // we hit a battle ship 
        grid[x][y] = HIT;    
        targetMode = true;
        lastMissileX = x;
        lastMissileY = y;  
        missilesHit++;
    } else if (grid[x][y] != HIT && grid[x][y] != SHIP) {
        // we missed
        grid[x][y] = MISS; 
    } 
    
    missilesFired++;
}

// Place ships on grid.
void placeShips() {   
    // TODO: randomize battleships rather than hardcode. 
    
    // aircraftCarrier 5
    grid[1][1] = SHIP;
    grid[1][2] = SHIP;
    grid[1][3] = SHIP;
    grid[1][4] = SHIP;
    grid[1][5] = SHIP;
    
    // battleship 4 
    grid[5][6] = SHIP;
    grid[6][6] = SHIP;
    grid[7][6] = SHIP;
    grid[8][6] = SHIP;
    
    // submarine 3
    grid[8][2] = SHIP;
    grid[8][3] = SHIP;
    grid[8][4] = SHIP;
    
    // destroyer 2
    grid[14][7] = SHIP;
    grid[15][7] = SHIP;   
   
    // cruiser 3 
    grid[12][2] = SHIP;
    grid[13][2] = SHIP;
    grid[14][2] = SHIP;
}