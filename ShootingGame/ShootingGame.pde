import processing.sound.*;

SoundFile bgm;
int initBall = 5;
int numBall = initBall;
int maxNumBall = 30;
Ball[] ball = new Ball[maxNumBall];
int craftSize = 7; // player spacecraft size
boolean shoot=false; // shooting status
int laserLimit = 150; // mouse moving area
int hp = 5;
int tick = 0;
int ballSpeed = 1;
int score = 0;
int getScore = 100;
int missile = 3;
boolean missileLaunched = false;
float explosionLine;
float missileX;
float missileY;
float missileSpeed;





void setup() { // basic setting
  size(800,800); // game window size
  for (int i=0; i<maxNumBall; i++) { 
     ball[i] = new Ball(); 
  }
  bgm = new SoundFile(this, "gradius.wav");
  bgm.play();
}

void draw() {
  background(0);
  spaceCraft();
  for (int i=0; i<numBall; i++) {
     ball[i].ballDrop(); 
     ball[i].gameStop();
  }
  if (shoot == true) {
    for (int i=0; i<numBall; i++) {
      ball[i].ballHit(mouseX);
    }
    shoot = false;
  }
  if (missileLaunched == true) {
    displayMissile();
    for (int i=0;i<numBall; i++) {
      ball[i].ballBlast(explosionLine);
    }
  }
  stroke(255,255,255);
  line(0, height-laserLimit, width, height-laserLimit); 
  displayHP();
  displayMissileNum();
  displayScore();
  difficulty();
}


void spaceCraft() { // display spacecraft 
  if (mouseY >= height-laserLimit) { // spacecraft appears when mouse position is under the line
    drawSpaceCraft(mouseX, mouseY, craftSize);
  }
}


void drawSpaceCraft(float x, float y, float craftSize) {
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
  if (mouseButton == LEFT) {
    if (mouseY >= height-laserLimit) // player can shoot when mouse position is under the line
      shoot = true; // shoot status is true
  }
  else if (mouseButton == RIGHT){
    if ((mouseY >= height-laserLimit) && (missileLaunched == false) && (missile > 0)){
      missile--;
      missileLaunched = true;
      missileX = mouseX;
      missileY = height;
      missileSpeed = 1;
      explosionLine = -100;
    }
  }
}

void keyPressed() { // Restrart Game
  if (key == 'r') {
  bgm.stop();
  numBall = initBall;
  hp = 5;
  tick = 0;
  ballSpeed = 1;
  missile = 3;
  score = 0;
  explosionLine = -100;
  for (int i =0 ; i<numBall; i++)
  ball[i].reposition();
  bgm.play();
  loop();
  }
}


class Ball { // target class
   int posX, posY;
   int ballSize = 32;
   Ball() {
    ballSize = 64;
    reposition();
   }

  void ballHit(int x) { // check if target hit by laser
    boolean hit = false;
    stroke(255, 0, 0);
    fill(255, 200, 0);
    if ( (x >= posX-ballSize/2) && (x <= posX+ballSize/2) ) {
       hit = true;
       line(mouseX, mouseY, mouseX, posY);
       ellipse(posX, posY, ballSize+25, ballSize+25);
       score += getScore;
       reposition();
    } 
    if (hit== false) {
       line(mouseX, mouseY, mouseX, 0);
    }
  }  
  
  void ballBlast(float y) {
   boolean blast = false;
   stroke(255,100,0,50);
   fill(255,200,0,100);
   if ((y >= posY-ballSize/2) && (y <= posY+ballSize/2)) {
     blast = true;
     ellipse(posX, posY, ballSize+25, ballSize+25);
     reposition();
   }
  }
  
  void ballDrop() { // ball moving control
    stroke(255);
    fill(255);
    posY += ballSpeed;
    ellipse(posX, posY, ballSize, ballSize);
  }
  
  // void drawBall()
  
  void reposition() {
    posX = int(random(20, width-20));
    posY = 0;
  }

  void gameStop() { // define game over
     if (posY > height-laserLimit) { // if ball's Y-position reaches
       --hp;
       reposition();
       background(200,0,0);
       if (hp <= 0) 
          gameover();
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
  stroke(255,0,0);
  line(0,explosionLine,width,explosionLine);
  if (explosionLine > height) {
    missileLaunched = false;
  }
}





void difficulty() {
  tick++;
  if ((tick+300) % 600 == 0 && ballSpeed < 10) {
   ballSpeed += 1; 
   getScore += 50;
  }
  if (tick % 600 == 0 && numBall < maxNumBall) {
   numBall++;
  }
}
