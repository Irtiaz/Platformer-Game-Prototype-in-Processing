class Player {

  PVector position, velocity, accelaration;
  float w, h;

  float xspeed = 5;
  float jumpVel = 14;

  boolean standing = false;

  Player() {
    position = new PVector(20, mapHeight - 140);
    velocity = new PVector();
    accelaration = new PVector(0, 0.8);

    w = 30;
    h = 30;
  }

  void display() {
    fill(105, 245, 66);
    stroke(0);
    rect(position.x - camX, position.y - camY, w, h);
  }

  void update() {
    float dt = 0.1;

    for (int updateCount = 0; updateCount < 1.0/dt; updateCount ++) {
      velocity.add(PVector.mult(accelaration, dt));
      position.add(PVector.mult(velocity, dt));

      player.position.x = constrain(player.position.x, 0, map[0].length * cellW);

      int playerI = (int)(position.y / cellH);
      int playerJ = (int)(position.x / cellW);

      int lowerI = max(playerI - 1, 0);
      int upperI = min(playerI + 2, rows - 1);

      int lowerJ = max(playerJ - 1, 0);
      int upperJ = min(playerJ + 1, cols - 1);


      for (int i = lowerI; i <= upperI; ++i) {
        for (int j = lowerJ; j <= upperJ; ++j) {
          if (map[i][j] == PLATFORM) {

            //Platfrom stuff
            float x1 = j * cellW + cellW/2;
            float y1 = i * cellH + cellH/2;

            //Player stuff
            float x2 = position.x + w/2;
            float y2 = position.y + h/2;

            if (velocity.y > 0 && x2 + w/2 >= x1 - cellW/2 && x2 - w/2 <= x1 + cellW/2 && y1 > y2 && y1 - y2 <= cellH/2 + h/2) {
              position.y = y1 - cellH/2 - h;
              velocity.y = 0;
              standing = true;
            }
          }
          
          else if (map[i][j] == COIN) {
            //Approximate the player as a circle for checking collision with coin
            float playerRadius = max(w/2, h/2);
            
            float x1 = player.position.x + w/2;
            float y1 = player.position.y + h/2;
            
            float x2 = j * cellW + cellW/2;
            float y2 = i * cellH + cellH/2;
            
            if (sq(x1 - x2) + sq(y1 - y2) < sq(playerRadius) + sq(coinRadius)) {
              //Player grabbed the coin!
              coins ++;
              map[i][j] = 0;
            }
          }
        }
      }
    }
  }
}
