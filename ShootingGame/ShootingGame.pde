import processing.sound.*;

SoundFile bgm; // Background Music
int initBall = 5; // initial number of enemies
int numBall = initBall; // current number of enemies (set to initial number at first)
int maxNumBall = 30; // maximum number of enemies
Ball[] ball = new Ball[maxNumBall]; // ball class
backgroundEffect[] bgEffect = new backgroundEffect[50];
int craftSize = 7; // player spacecraft size
boolean shoot=false; // shooting status (false = not shooting, true = shooting)
int laserLimit = 150; // mouse moving area (vertical)
int hp = 5; // current life
int tick = 0; // game time (60 tick = 1 secs)
int ballSpeed = 1; // current enemy moving speed
int score = 0; // player score
int getScore = 100; // score for destroying one enemy
int missile = 3; // current number of missile
boolean missileLaunched = false; // check if missile is launched and working now
float explosionLine; // range of missile explosion
float missileX; // missile X pos
float missileY; // missile Y pos
float missileSpeed; // missile speed





void setup() { // basic setting
  size(800,800); // game window size
  for (int i=0; i<numBall; i++) { // generate enemy class up to maximum number of enemies
     ball[i] = new Ball(); 
  }
  for (int i=0;i<50;i++) {
     bgEffect[i] = new backgroundEffect(); 
  }
  bgm = new SoundFile(this, "gradius.wav"); // background music set
  bgm.play(); // play background music
}

void draw() { // mainloop of the game
  background(0); // set basic background to black
  for (int i=0;i<50;++i) {
   bgEffect[i].drawBackgroundEffect();
  }
  spaceCraft(); // execute function related to player spacecraft
  for (int i=0; i<numBall; i++) { // generate enemy up to current number of enemies
     ball[i].ballDrop(); // moving ball from top of the screen to bottom line
     ball[i].damage(); // player get damaged if an enemy reached the bottom line
  }
  if (shoot == true) { // when player shoots laser
    for (int i=0; i<numBall; i++) { // check if each enemy hit by laser
      ball[i].ballHit(mouseX);
    }
    shoot = false; // after check laser hit, shooting is done
  }
  if (missileLaunched == true) { // when player launches missile
    displayMissile(); // missile launches from player position to top of the screen, and generate explosion line
    for (int i=0;i<numBall; i++) { // check if each enemy hit by explosion
      ball[i].ballBlast(explosionLine);
    }
  }
  stroke(255,255,255); // set line to white color
  line(0, height-laserLimit, width, height-laserLimit); // draw bottom line that separates enemy area and player area
  difficulty(); // set difficulty as game progresses
 if (hp <= 0) 
  gameover();
 displayUI();
}


void spaceCraft() { // display spacecraft 
  if (mouseY >= height-laserLimit) { // spacecraft appears when mouse position is under the line
    drawSpaceCraft(mouseX, mouseY, craftSize); // display spacecraft at mouse position
  } 
}


void drawSpaceCraft(float x, float y, float craftSize) { // draw player spacecraft sprite
    rectMode(CENTER);
    fill(255-(hp*10),242,244);
    stroke(255,255,255);
    rect(x, y, craftSize*2,craftSize*6);
    rect(x, y-craftSize*4, craftSize*0.6,craftSize*2);
    triangle(x-craftSize,y-craftSize*2,x-craftSize,y+craftSize*2.4,x-craftSize*3,y+craftSize*2.4);
    triangle(x+craftSize,y-craftSize*2,x+craftSize,y+craftSize*2.4,x+craftSize*3,y+craftSize*2.4);
    fill(255,100,0,200);
    stroke(255,255,0);
    ellipse(x,y+craftSize*4,craftSize,craftSize*1.6);
    fill(0, 0, 0); 
    stroke(255,255,255);
}

void mousePressed() { // mouse click event
  if (mouseButton == LEFT) { // left click
    if (mouseY >= height-laserLimit) // player can shoot when mouse position is under the line
      shoot = true; // shoot status is true
  }
  else if (mouseButton == RIGHT){ // right click
    if ((mouseY >= height-laserLimit) && (missileLaunched == false) && (missile > 0)){ // player can shoot missile when mouse position is under the line, missile is still not launched now, and missile is left
      missile--; // subtract 1 from number of missile 
      missileLaunched = true; // set missile launch status to true
      missileX = mouseX; // set initial missile Xposition to mouseX
      missileY = mouseY; // set initial missile Yposition to mouseY
      missileSpeed = 1; // set initial missile speed to 1
      explosionLine = -100; // set initial explosion line to -100 (generate explosion line but not affect to enemies until missile reaches the top of the screen)
    }
  }
}

void keyPressed() { // keyboard key event
  if (key == 'r') { // 'r' key
    restart(); // game restart
  }
}

void restart() { // game restart
  bgm.stop(); // stop current background music first
  numBall = initBall; // set enemy number to initial
  hp = 5; // set hp count to initial
  tick = 0; // set game time to 0
  ballSpeed = 1; // set enemy speed to initial
  missile = 3; // set missile number to initial
  score = 0; // set score to 0
  explosionLine = -100; // set explosion line to -100
  missileLaunched = false; // set missilelaunch status to false
  for (int i =0 ; i<numBall; i++) // enemies reposition
  ball[i].reposition();
  bgm.play(); // background music restart
  loop(); // resume mainloop of the game 
}


class Ball { // enemy class
   int posX, posY; // postion
   int ballSize; // size
   int hitSize; // hit range of enemy (range of laser hit)
   Ball() { //
    ballSize = 7; // set size to 64
    hitSize = ballSize*9; // set hit range of enemy
    reposition(); // reposition enemy when generate
   }

  void ballHit(int x) { // check if target hit by laser
    boolean hit = false; // initial hit status set to false
    stroke(255, 0, 0); // set stroke color to red
    fill(255, 200, 0); // set color to orange
    if ( (x >= posX-hitSize/2) && (x <= posX+hitSize/2) ) { // if laser is in range of enemy X position
       hit = true; // set hit status to true
       line(mouseX, mouseY, mouseX, posY); // 
       ellipse(posX, posY, hitSize+25, hitSize+25);
       score += getScore;
       reposition();
    } 
    if (hit== false) {
       line(mouseX, mouseY, mouseX, 0);
    }
  }  
  
  void ballBlast(float y) {
   stroke(255,100,0,50);
   fill(255,200,0,100);
   if ((y >= posY-hitSize/2) && (y <= posY+hitSize/2)) {
     ellipse(posX, posY, ballSize+25, ballSize+25);
     score += 50;
     reposition();
   }
  }
  
  void ballDrop() { // ball moving control
    stroke(255);
    fill(255);
    posY += ballSpeed;
    ellipse(posX, posY, ballSize, ballSize);
    drawBall();
  }
  
  void drawBall() {
    rectMode(CENTER);
    fill(255,160,20);
    stroke(128,128,128);
    rect(posX, posY, ballSize*2,ballSize*6);
    rect(posX, posY+craftSize*3.5, craftSize*0.6,craftSize);
    arc(posX, posY+ballSize*4, ballSize,ballSize, 0, PI);
    triangle(posX-ballSize,posY-ballSize*2,posX-ballSize,posY+ballSize*2.4,posX-ballSize*3,posY-ballSize*2.4);
    triangle(posX+ballSize,posY-ballSize*2,posX+ballSize,posY+ballSize*2.4,posX+ballSize*3,posY-ballSize*2.4);
    stroke(255,0,0);
    line(posX-ballSize/2, posY-ballSize*3, posX-ballSize/2, posY+ballSize*3);
    line(posX, posY-ballSize*3, posX, posY+ballSize*3);
    line(posX+ballSize/2, posY-ballSize*3, posX+ballSize/2, posY+ballSize*3);
    fill(255,100,0,200);
    stroke(255,255,0);
    ellipse(posX,posY-ballSize*4,ballSize,ballSize*1.6);
    fill(0, 0, 0); 
    stroke(255,255,255);
    
  }
  
  void reposition() {
    posX = int(random(50, width-50));
    posY = 0;
  }

  void damage() { // define player get damaged
     if (posY > height-laserLimit) { // if ball's Y-position reaches
       --hp;
       reposition();
       background(200,0,0);
     }
  } 
}

void gameover() {
   noLoop(); // stop game
   textSize(50);
   fill(100,100,100);
   noStroke();
   rect(0,0,width*2,height*2);
   fill(255, 0, 0); 
   text("GAME OVER",width/2-150, height/2-100);
   fill(255,255,0);
   textSize(25);
   text("Your Score is " + score, width/2-150, height/2);
   textSize(22);
   fill(50,50,50);
   text("Press 'R' Key To Restart", width/2-150, height/2+100);
   bgm.stop();
}


void displayUI() {
  displayHP(); // display hp UI at top-left of the screen
  displayMissileNum(); // display missile UI under the hp UI
  displayScore(); // display score UI at top-right of the screen
}

void displayHP() {
  for (int i = 1; i <= hp; i++) {
    drawSpaceCraft(20*i,20,2);
  }
}

void displayMissileNum() {
  for (int i = 1; i <= missile; i++) {
    drawMissile(20*i,50,3);
  }
}

void displayScore() {
 textSize(20);
 fill(255,255,255);
 text("Score : " + score, width-150, 30);
}




void displayMissile() {
  drawMissile(missileX, missileY, 10);
  missileY -= missileSpeed;
  missileSpeed *= 1.1;
  if (missileY < 0) {
    explosion();
  }
}

  
void drawMissile(float x, float y, float size) {
  rectMode(CENTER);
  noStroke();
  fill(205,242,244);
  rect(x,y,size,size*4);
  fill(250,100,0);
  triangle(x,y-size*4,x-size/2,y-size*2,x+size/2,y-size*2);
  fill(255,100,0,200);
  stroke(255,255,0);
  ellipse(x,y+size*3,size,size*1.6);
}

void explosion() {
  explosionLine += 20;
  noStroke();
  fill(255,200,0,100);
  for (int i = 0;i<width;i+=2) {
    if (int(random(10)) > 8)
    ellipse(i,explosionLine+int(random(80))-40,100,100);
  }
  if (explosionLine > height) {
    missileLaunched = false;
  }
}

class backgroundEffect {
  int posX, posY;
  int size;
  backgroundEffect() {
   posX = int(random(width));
   posY = 0-int(random(height));
   size = int(random(10)); 
   drawBackgroundEffect();
  }
  
  void drawBackgroundEffect() {
    noStroke();
    fill(100,100,100);
    ellipse(posX, posY, size, size);
    posY+=5;
    if (posY > height)
      posY = 0-int(random(height));
  }
  
}



void difficulty() {
  tick++;
  if ((tick+300) % 600 == 0 && ballSpeed < 10) {
   ballSpeed += 1; 
   getScore += 50;
  }
  if (tick % 600 == 0 && numBall < maxNumBall) {
   ball[numBall] = new Ball(); 
   numBall++;
  }
}
