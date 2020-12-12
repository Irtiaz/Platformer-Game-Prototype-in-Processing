import java.util.StringTokenizer;

final int PLATFORM = 1;
final int COIN = 2;

float coinRadius = 7.5;
int coins = 0;

boolean editing = false;

int[][] map;

Player player;

float mapWidth, mapHeight;
int rows = 100, cols = 50;
float cellW = 100, cellH = 20;

float camX, camY;

void setup() {
  size(600, 400);

  map = new int[rows][cols];
  mapWidth = cols * cellW;
  mapHeight = rows * cellH;

  camX = 0;
  camY = mapHeight - height;

  player = new Player();

  String[] lines = loadStrings("map.txt");
  for (String line : lines) {
    StringTokenizer st = new StringTokenizer(line);
    int i = Integer.parseInt(st.nextToken());
    int j = Integer.parseInt(st.nextToken());
    int value = Integer.parseInt(st.nextToken());
    map[i][j] = value;
  }
  
  textAlign(CENTER, CENTER);
}

void draw() {
  background(255);

  drawMap();

  player.display();
  player.update();
  
  fill(237, 214, 9);
  stroke(0);
  textSize(32);
  text(coins, width - 40, 20);


  //If not in development mode then camera fixes the player in the center
  if (!editing) {
    camX = player.position.x - width/2;
    camY = player.position.y - height/2;

    if (camX < 0) camX = 0;
    else if (camX > mapWidth - width) camX = mapWidth - width;
    if (camY < 0) camY = 0;
    else if (camY > mapHeight - height) camY = mapHeight - height;
  }

  if (player.position.y - player.w/2 > mapHeight) {
    //Game Over stuff goes here
    fill(255, 0, 0);
    textSize(56);
    stroke(0);
    text("Game Over", width/2, height/2);
    noLoop();
  }
}

void mousePressed() {
  if (editing) {
    int i = (int)((camY + mouseY) / cellH);
    int j = (int)((camX + mouseX) / cellW);
    if (map[i][j] != 0) map[i][j] = 0;
    else map[i][j] = PLATFORM;
  }
}

void keyPressed() {
  //Game developer mode
  if (editing) {
    if (keyCode == ENTER) {
      PrintWriter elements = createWriter("map.txt");

      for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
          if (map[i][j] != 0) elements.println("" + i + " " + j + " " + map[i][j]);
        }
      }

      elements.flush();
      elements.close();
      println("Done");
    } else if (key == 'z' || key == 'x') {
      camX += key == 'x'? 10 : -10;
    } else if (key == 't' || key == 'g') {
      camY += key == 'g'? 10 : -10;
    } else if (key == 'c') {
      int i = (int)((camY + mouseY) / cellH);
      int j = (int)((camX + mouseX) / cellW);
      if (map[i][j] != 0) map[i][j] = 0;
      else map[i][j] = COIN;
    }
  } 


  //Main Game stuff
  if (keyCode == RIGHT || keyCode == LEFT) {
    player.velocity.x = keyCode == RIGHT? player.xspeed : -player.xspeed;
  } else if (key == ' ') {
    if (player.standing) {
      player.velocity.y = -player.jumpVel;
      player.standing = false;
    }
  }
}


void keyReleased() {
  if (keyCode == RIGHT || keyCode == LEFT) {
    player.velocity.x = 0;
  }
}


void drawMap() {
  for (int i = 0; i < rows; ++i) {
    for (int j = 0; j < cols; ++j) {
      if (editing && map[i][j] == 0) {
        stroke(0);
        noFill();
        rect(cellW * j - camX, cellH * i - camY, cellW, cellH);
      }

      //Draw Plattfrom
      else if (map[i][j] == PLATFORM) {
        fill(209, 111, 6);
        noStroke();
        rect(cellW * j - camX, cellH * i - camY, cellW, cellH);
      }

      //Draw Coin
      else if (map[i][j] == COIN) {
        stroke(0);
        fill(237, 214, 9);
        ellipse(cellW * j + cellW/2 - camX, cellH * i + cellH/2 - camY, 2 * coinRadius, 2 * coinRadius);
      }
    }
  }
}
