/*  Arduino must be running Standard Firmata for this sketch to work
 Open Arduino program > File > Examples > Firmata > StandardFirmata and upload it to your board. */

/*--- ARDUINO SETUP ---*/
import processing.serial.*;
import cc.arduino.*;
Arduino arduino;
/*--- ARDUINO VARIABLES ---*/
int waterLevelSensor = 3; //Port where the water sensor is connected, WRITE HERE the number of the digital input port you are using
//The water level sensor is digital. It reads either 0 or 1 depending on its status
//0 -> inside water; 1 -> outside water
//These values vary by the position you installed the sensor, TRY IT FIRST and see if your case matches this one.
int savedSensorRead = 0; //leitura salva é a leitura na ultima modificacao de estado do sensor. 0 aqui é o sensor dentro da agua
int currentSensorRead; //leitura atual é sempre o jeito que o sensor estiver lendo no momento

/*--- PROCESSING VARIABLES ---*/
int screen = 0; //screen 0: instructions, 1: start, 2: game
int maxTime = 60; //each game duration
int timer; //current time of the game

//images and files
PImage imgFish;
PImage imgHook;
PImage imgTrash;
PImage imgRock;
PImage imgBackground;
PImage imgLogo;
PFont fontTitan;

//Position of items
int posXFish; //fish X position + animation
int posXHook; //hook X position, is defined by the horizontal screen size
float posYHook; //hook Y position, defined by the vertical screen size
int fishSpeed = 4; //speed of the first fish, every fish has a random speed defined
int posXTrash; //trash X position

//Points and bonus
int points; //total points
int bonus = 1; //amount of points you win by each fish you catch
boolean isTrashHit = false; //the trash collides once with the hook and then changes to true to avoid it from colliding many times

//Points text animation
boolean bonusAnimation = false; //is the animation active right now?
int posYBonusText; //position of the text, it goes up the screen
int bonusText; //text of the amount of points you won
//same thing but now for lost points:
int posYLossesText;
float posXLossesText; //position X defines if the text shows up at the hook or at the rock
boolean lossesAnimation = false;


void setup() {
  /*--- ARDUINO SETUP ---*/
  printArray(Arduino.list()); //Print the serial ports available, see which port your arduino is connected
  println("Write the serial port your Arduino is connected in Arduino.list()[NUMBER] on setup()");
  arduino = new Arduino(this, Arduino.list()[1], 57600); // <<<<< write here the serial port your arduino is connected
  arduino.pinMode(waterLevelSensor, arduino.INPUT);

  /*--- SETUP PROCESSING ---*/
  //size(1080, 720);
  fullScreen();

  //fish and hook positions in the screen
  //this is done here to happen after the setup. this way it already gets the current screen size
  posXHook = int(width*0.55);
  posXTrash = -50; //the trash begins the game outside the screen

  //image files and resizing
  imgHook = loadImage("anzol.png");
  imgHook.resize(61, 212);
  imgFish = loadImage("peixe.png");
  imgFish.resize(200, 108);
  imgTrash = loadImage("bota.png");
  imgTrash.resize(90, 116);
  imgRock = loadImage("pedra.png");
  imgRock.resize(width, height);
  imgLogo = loadImage("logo.png");
  imgLogo.resize(480, 200);
  imgBackground = loadImage("fundo.png");
  imgBackground.resize(width, height);

  //text font
  fontTitan = createFont("titanone.ttf", 32);
}

void draw() {
  currentSensorRead = arduino.digitalRead(waterLevelSensor); //currentSensorRead = current water level sesnor data, 0 or 1
  //print("currentSensorRead: ");
  //println(currentSensorRead);

  image(imgBackground, 0, 0); //ocean background image
  textFont(fontTitan); //all the texts use Titan One font

  /*--- LOADING ---*/
  //It takes a few seconds for the arduino data to be properly read
  //this fake loading takes 4 seconds, enough time for the arduino to be properly running and getting the actual data from the sensor
  if (screen == 0) {
    if (frameCount % 60 == 0) { //if it is 0 then 1 second has passed
      timer++;
      //println(timer);
    }

    textAlign(CENTER);
    textSize(30);
    //loading... animation
    if (timer == 0) {
      text("Loading", width/2, height/2);
    } else if (timer == 1) {
      text("Loading.", width/2, height/2);
    } else if (timer == 2) {
      text("Loading..", width/2, height/2);
    } else if (timer == 3) {
      text("Loading...", width/2, height/2);
    } else if (timer == 4) { //when it hits 4 seconds
      timer = 5;
      screen = 1; //changes screen to screen 1
    }
  }

  /*--- START and GAME OVER screens ---*/
  if (screen == 1) {
    if (currentSensorRead == 0) { //if the sensor is in the water
      if (frameCount % 60 == 0) {
        timer--;
        //println(timer);
      }
    } else if (currentSensorRead == 1) { //if the sensor is outside the water
      timer = 5; //redefines to 5
    }

    fill(255); //text color is white
    textAlign(CENTER);

    if (points!=0) { //if the points are different from 0 it means the game has already been played, so it is game over
      textSize(50);
      text(points + " points", width/2, height*0.25); //shows last game points in the screen
    }

    imageMode(CENTER);
    image(imgLogo, width/2, height*0.4); //fishing logo
    imageMode(CORNER);

    //text saying how many seconds to keep the sensor in the water to start the game
    textSize(30);
    text("Keep the fishing rod in the water for", width/2, height*0.6);
    textSize(42);
    text(timer, width/2, height*0.65);
    textSize(30);
    text("seconds to play the game!", width/2, height*0.7);

    if (currentSensorRead == 0 && timer <= 0) { //if the sensor is in the water and timer is 0
      points = 0; //reset points
      bonus = 1; //reset bonus
      timer = maxTime; //timer is set as maxTime
      posXFish = width; //fish is set at the right border of the screen
      lossesAnimation = false;
      bonusAnimation = false;
      screen = 2;
    }
  }

  /*--- GAME ---*/
  if (screen == 2) {

    if (frameCount % 60 == 0) { //game timer
      timer--;
      //println(timer);
    }
    if (timer <= 0) { //if timer is 0 it is game over
      timer = 5; 
      screen = 1; 
    }

    //INTERFACE
    //background(200);
    textSize(50);
    //text(currentSensorRead, 200, 200);
    textAlign(LEFT);
    fill(255);
    text(points + " points", width*0.05, height*0.10); //points
    textAlign(RIGHT);
    text(timer, width*0.95, height*0.10); //timer
    textAlign(LEFT);

    //HOOK
    if (currentSensorRead == 0) { //0 is inside the water
      posYHook = height/2-height*0.1; //hook shows at half of vertical screen size
    } else if (currentSensorRead == 1) { //1 is out of water
      posYHook = height*0.10; //hook shows at top of the screen
    }
    
    strokeWeight(6);
    stroke(102, 102, 102);
    line(posXHook, 0, posXHook, posYHook); 
    image(imgHook, posXHook-15, posYHook);

    //FISH
    posXFish = posXFish - fishSpeed;
    image(imgFish, posXFish, (height/2 - 92/2));

    if (posXFish <= width*0.2) { //if the fish is under the rock
      posXFish = width; //goes back to the right side of the screen
      points--; //loses 1 points
      bonus = 1; //bonus are reseted to 1
      fishSpeed = int(random(2, 10)); //new random velocity for the next fish

      //point losses animation
      posXLossesText = width*0.22;
      posYLossesText = height/2;
      lossesAnimation = true;
    }

    //BOOT - TRASH
    if (timer%12 == 0 && timer!=maxTime && timer!=0) {
      posXTrash = width; //boot starts at the right of the screen every 12 seconds
    }
    image(imgTrash, posXTrash, (height/2 - 20));
    posXTrash = posXTrash - 3; //trash goes 3 pixels left every frame

    //ROCHA
    image(imgRock, 0, 0); //rock image

    //These lines show the area where the fishing is successful
    /*stroke(255,0,0);
     line(posXHook-15, 0, posXHook-15, height/2);
     line(posXHook-40, 0, posXHook-40, height/2);
     line(posXHook + 65, 0, posXHook + 65, height/2);*/

    /*-- FISHING --*/
    //0 > water, 1 > out of water;
    //if the saved reading is inside the water (0) but the current is out of water (1) then you removed the sensor from the water (fished)
    if (savedSensorRead == 0 && currentSensorRead == 1) {
      if (posXHook-40 <= posXFish && posXHook + 65 >= posXFish) { //if the fish is N pixels close to the hook
        //println("pescou");
        points = points + bonus; //points! points = current points + current bonus (fish streak)
        bonusText = bonus; //bonus text is defined
        bonus++; //adds +1 in bonus value
        posXFish = width; //fish goes back to the right
        fishSpeed = int(random(2, 12)); //new random speed for the next fish

        //bonus text
        posYBonusText = height/2; //sets position Y as half of the screen
        bonusAnimation = true; //sets animation as true
      }

      savedSensorRead = currentSensorRead; //current reading of the sensor is now the saved reading
    }
    //if the saved reading is out of water (1) but current is inside the water (0) the sensor was put in the water again
    if (savedSensorRead == 1 && currentSensorRead == 0) {
      savedSensorRead = currentSensorRead;
    }

    /*-- TRASH HIT DETECTION --*/
    if (currentSensorRead == 0) { //if the sensor is in the water
      if (posXHook-40 <= posXTrash && posXHook + 65 >= posXTrash) { //if the trash is inside the fishing area
        //println("pescou");
        if (isTrashHit == false) { //if this is the first time the trash is hitting the fishing hook
          isTrashHit = true;
          points--;
          bonus = 1; 
          //losses animation
          posXLossesText = posXHook + width*0.015;
          posYLossesText = height/2; 
          lossesAnimation = true;
        }
      }
    }

    if (posXTrash >= width*0.9) { //if the trash is at 90% of the screen size it means the trash has resetted
      isTrashHit = false;
    }


    //bonus points animation
    if (bonusAnimation == true) {
      fill(255, 255, 255, posYBonusText);
      text("+"+bonusText, posXHook + width*0.015, posYBonusText); 
      posYBonusText = posYBonusText - 3; 
    }
    if (posYBonusText<0) {
      bonusAnimation = false;
    }
  }

  //lost points animation
  if (lossesAnimation == true) { 
    fill(255, 255, 255, posYLossesText); 
    text("-1", posXLossesText, posYLossesText); 
    posYLossesText = posYLossesText - 3;
  }
  if (posYLossesText<0) {
    lossesAnimation = false; 
  }
}
