;/************************ //<>// //<>//
**  Elyasaf Cohen :)   **
**  ID 311557227       **
**  The final project  **
*************************/

Image theDog = new Image();
Image theBone = new Image();
Image theBackground = new Image();

Image theLife1 = new Image();
Image theLife2 = new Image();
Image theLife3 = new Image();
Image theLife4 = new Image();

Music succsesMusic = new Music();
Music failSoundMusic = new Music();
Music backgroundMusic = new Music();

Text myNameText = new Text();
Text gameOverText = new Text();
Text YouWinText = new Text();
Text scoreText = new Text();

int playerLife = 3;
int playerScore = 0;

public static final int WIN_SCORE = 15;
public static final int SPEED = 3;
public static final int THE_FLOOR_VALUE = 700;

//======================================== Editing game's visibility ==========================================// 
void setup() {
  size(1024, 700); // the canvas' size

  //============= the text objects ===============//

  //====== myNameText ======//
  myNameText.x = 826;
  myNameText.y = 30;
  myNameText.textSize = 30;

  myNameText.font = "Ariel";
  myNameText.text = "Elyasaf Cohen";
  myNameText.brush = color(200, 70, 90);

  //====== YouWinText ======//
  YouWinText.x = 55;
  YouWinText.y = 300;
  YouWinText.textSize = 150;

  YouWinText.font = "Ariel";
  YouWinText.text = "You Win!!!";
  YouWinText.brush = color(230, 255, 0);

  //====== scoreText ======//
  scoreText.x = 980;
  scoreText.y = 70;
  scoreText.textSize = 50;

  scoreText.font = "Ariel";
  scoreText.text = "0";
  scoreText.brush = color(0, 0, 255);

  //===== gameOverText =====//
  gameOverText.x = 55;
  gameOverText.y = 300;
  gameOverText.textSize = 150;

  gameOverText.font = "Arial-Black-48";
  gameOverText.text = "GAME OVER";
  gameOverText.brush = color(230, 255, 0);

  //============= the Image objects ==============//

  //===== the Background =====//
  theBackground.setImage("C:\\Programming\\Nitz13 - 64bit\\MyFirstApp\\data\\the_background.jpg");
  theBackground.x = 0;
  theBackground.y = 0;

  //======= the Dog =========//
  theDog.setImage("C:\\Programming\\Nitz13 - 64bit\\MyFirstApp\\data\\the_dog.png");
  theDog.x = 400;
  theDog.y = 520;

  //====== the Life1 =======//
  theLife1.setImage("C:\\Programming\\Nitz13 - 64bit\\MyFirstApp\\data\\the_life.png");
  theLife1.x = -10;
  theLife1.y = -10;
  theLife1.width = 70;
  theLife1.height = 70;

  //====== the Life2 =======//
  theLife2.setImage("C:\\Programming\\Nitz13 - 64bit\\MyFirstApp\\data\\the_life.png");
  theLife2.x = 35;
  theLife2.y = -10;
  theLife2.width = 70;
  theLife2.height = 70;

  //====== the Life3 =======//
  theLife3.setImage("C:\\Programming\\Nitz13 - 64bit\\MyFirstApp\\data\\the_life.png");
  theLife3.x = 80;
  theLife3.y = -10;
  theLife3.width = 70;
  theLife3.height = 70;

  //====== the Life4 =======//
  theLife4.setImage("C:\\Programming\\Nitz13 - 64bit\\MyFirstApp\\data\\the_life.png");
  theLife4.x = 125;
  theLife4.y = -100;
  theLife4.width = 70;
  theLife4.height = 70;

  //====== the Bone =======//
  theBone.setImage("C:\\Programming\\Nitz13 - 64bit\\MyFirstApp\\data\\the_bone.png");
  theBone.x = 320;

  //================ make the bone fall down ====================//
  theBone.direction = Direction.DOWN;
  theBone.speed = SPEED;

  //=== If the bone reached the ground it goes back up again ===//
  if (theBone.y < 300) {
    theBone.y = (int)random(-150, 300);
  }

  //================= Editing the game's music =================// 
  backgroundMusic.load("background_music.mp3");
  backgroundMusic.loop = true;
  backgroundMusic.play();

  failSoundMusic.load("fail_sound.mp3");
  succsesMusic.load("succses_sound.mp3");
}

//=============================== Showing all the objects we made to the screen ================================//
void draw() {
  theBackground.draw();
  myNameText.draw();
  
  theDog.draw();
  theBone.draw();
  
  theLife1.draw();
  theLife2.draw();
  
  theLife3.draw();
  theLife4.draw();
  
  scoreText.draw();

  if (playerScore == WIN_SCORE) {
    YouWinText.draw();
  }

  if (playerLife == 0) {
    gameOverText.draw();
  }

  //============ Checking if the bone has reached to the floor ============//
  if (theBone.y < THE_FLOOR_VALUE) {
    //============ if the dog did catch the bone ============//
    if (theBone.pointInShape(theDog.x, theDog.y)) {

      succsesMusic.play();
      playerScore++;
      scoreText.text = str(playerScore);
      resetBonePosition();
      
      if (playerScore == WIN_SCORE) {
        endGame();
      }

      //=== check the player life ===// 
      if (playerLife < 4) { // 4 is the maximum I put to the game
        playerLife++;

        if (playerLife == 2) {
          theLife2.y = -10;

        }
        else if (playerLife == 3) {
          theLife3.y = -10;

        }
        else if (playerLife == 4) {
          theLife4.y = -10;

        }
      }
    }
  }
  else {
    failSoundMusic.play();
    playerLife--;
    resetBonePosition();

    if (playerLife == 3) {
      theLife4.y = -100;

    }
    else if (playerLife == 2) {
      theLife3.y = -100;

    }
    else if (playerLife == 1) {
      theLife2.y = -100;

    }
    else if (playerLife == 0) {
      theLife1.y = -100;
      endGame();
    }
  }
}

//================ Editing the Dog's direction ====================// 
void keyPressed() {

  if (keyCode == RIGHT) {
    if (theDog.x <= 950) { // to stop in the screen border
      //=== RIGHT ===// 
      theDog.x = theDog.x + 30;
    }
  }
  else if (keyCode == LEFT) {
    if (theDog.x >= 0) {
      theDog.x = theDog.x - 30;
    }
  }
  else if (keyCode == UP) { // stop the dog
    theDog.x = theDog.x;
  }
}

//========== Reset the bone's position to make it fall again =============//
void resetBonePosition() {
  theBone.x = (int)random(-10, 900); // -80 is the extreme left and 910 is the extreme right
  theBone.y = (int)random(-150, -130); // -150 is the ceiling and 300 is the floor so we want the bone to fall form normal hight that's why -130
}

void endGame() {
  theBone.y = -500;
  theBone.speed = 0;
  theDog.y = -200;
}
