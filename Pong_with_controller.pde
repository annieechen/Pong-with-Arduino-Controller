//define global variables
//specify height and width of output window in pixels
int w = 1000;
int h = 600;
//specify size of ball in pixels
int diameter = 100;
//initial position of ball
float x = w/2;
float y = h/4;

//velocity in pixels  per frame
float vx =24;
float vy = 20; 

//aceleration in pixels per frame
float ay = 0;

//lives remaining
int lives=3;
int scene =1;

//score
int score = 0;
int prevScore=0;

//paddle controller
float pot;

//imports information from arduino
import processing.serial.*;
String port_name = "COM3"; 
Serial port; 

boolean pressed = false;


//code to run first
void setup () {
  size (w,h);
   // SERIAL PORT
  // open the serial port associated with the Arduino Serial Monitor
  port = new Serial(this, port_name, 9600);
  // generate Serial event when new line is received
  port.bufferUntil('\n');
  port.bufferUntil('x');
}


void draw () {
  // everything happens in the serialEvent()
}

void serialEvent (Serial port) {
  
  println(scene);
  // get the ASCII string for paddle
  String inString = port.readStringUntil('\n');
  //get the string for button
    String inButton = port.readStringUntil('x');


  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);
    // convert to an int and map to the screen height:
    float inByte = float(inString); 
    inByte = map(inByte, 0, 1023, 0, w);
  
  //paddle controller
  pot = inByte;
  
  //button function (replaces mouseClicked)
  makeButton(inButton);
  

  //speed increases gradually as score increases, with a max at score = 50
  if (score <50) {
  ay = (floor (score/20)/40);
  } else
  ay =.005;
  
  
  // start screen
if (scene == 1) 
{  
  // background
  background(255,255,255);
  textSize(100);
  fill(5, 24, 240);
  text( "BALL BOUNCE!", 140,300);
    fill(3, 135, 9);
  rect(380,500,290,70);
  fill(0,0,0);
  textSize(35);
    text ("INSTRUCTIONS",400,540);
}

// instructions screen
if (scene == 2)
{  
   background(255,255,255);
  textSize(40);
  fill(0,0,0);
  textAlign(CENTER);
  text("INSTRUCTIONS", 500,100);
  textSize(20);
  //should make this into a for loop, since text yPos increases the same increment every time
  text("*catch the ball with your paddle by moving your mouse!",500,200);
  text("*if you miss the ball, you lose a life",500,230);
  text("*as your score goes up, the ball moves faster!",500,260);
  text("*keep paddle in contact with the ball for HUGE increases in score!",500,290);
  text("*but be careful! The higher your score, the faster the ball moves",500,320);
  fill(8, 240, 23);
  rect(380,400,290,70);
  textSize (40);
  fill(0,0,0);
  text ("PLAY",500,450);
  
  //example ball at bottom of screen
  diameter = 30; 
  ball();

    //make velocities and positions change
  vy = vy + ay; //vertical velocity
  x = x + vx;
  y = y + vy;
  
  //side walls, bounces if ball too far to left or right
  if (( x > w) || ( x < 0 )) {
    xBack();
  }
  //top wall, bounces back down
   if (y < 300|| y > (h-55) ) {
    yBack();
   }
   
   //paddle
   fill (122, 10, 25);  
  rect (x-75, h - 55, 150, 50);
}

// play screen
if ((scene == 3)|| (scene == 4) || (scene == 5)) 
{
    background(255,255,255);
  button();

  //draw circle for ball to move, changes as score changes
  fill(0, 50+(score),0);
  ball() ;
  diameter = 100;
  //draw paddle 
  paddle();
  
  //lives and score
  textSize(25);
  fill(0,0,0);
  text ("Score: " + score, 750, 30);
  text("Lives: " + lives, 750, 80);
  
  //make velocities and positions change
  vy = vy + ay; //vertical velocity
  x = x + vx;
  y = y + vy;
  
  //side walls, bounces if ball too far to left or right
  if (( x > w) || ( x < 0 )) {
    xBack();
  }
  //top wall, bounces back down
   if (y < 0) {
    yBack();
   }
   
  //bottom paddle contact
  if ( x > pot && x < (pot +150) && (y >500)) {
      yBack();
      score = score + 1;
    } 
    
    else if ( y >550) {
    x=2000;

  }
} 
  // game over scene
if (scene == 6) {
  
  background(255,255,255);
  textSize(50);
  textAlign(CENTER);
   text ("SORRY :(", 500,140);
  text ("GAME OVER", 500,200);
  text ("SCORE: " + score, 500, 300);
  if (prevScore!=0) {
    text ("PREVIOUS SCORE: " + prevScore, 500,350);
  }
   //restart button <= should make this code into a function, since it's repeated so often
  fill(8, 240, 23);
  rect(350,400,290,70);
  textSize (40);
  fill(0,0,0);
  textSize(40);
  text ("RESTART",500,450);
  }
}
}

// changes between scenes
void makeButton(String inButton) 
{
if (inButton.equals("0x")) 
  { 
    pressed = true;
  }
  
  if(pressed == true) 
  {
   
        if (scene ==1) 
        {
         scene ++;
         y=h/2;
          pressed = false;
        }
       else if (scene == 2)
       {
         scene ++;
         lives = 3;
          pressed = false;
       } 
       else if (scene == 3)
       {
         scene = 4;
       lives = 2;
        x = w/2;
        y = h/4;
         pressed = false;
      } 
      else if (scene == 4)
      {
          scene = 5;
          lives = 1;
          x = w/2;
          y = h/4;
           pressed = false;
        }
      else if (scene == 5)
      {
          scene = 6;
          lives = 0; 
           pressed = false;
        }
      else if (scene ==6 )
      {
      scene = 3;
      lives = 3;
      //updates previous score
      prevScore=score;
      //resets score
      score = 0;
      x = w/2;
      y = h/2; 
       pressed = false;
      }
  }
}


  //draw circle for ball to move
void ball () {  
  ellipse(x,y,diameter, diameter);
}
  
  //draw usercontrolled paddle
void paddle () {
  fill (122, 10, 25);  
  rect (pot, h - 55, 150, 50);
}  

//relaunch button
void button() {
  fill (0,0,0);
  rect (0,0,280,30);
  textSize(20);
  textAlign(LEFT);
  fill(255,255,255);
  text("click to launch ball again",7,25);
}

//makes ball change x velocity for side walls
void xBack () {
    x = x - vx;
    vx = - vx;
}

//makes ball change y velocity for top and bottom walls

void yBack() {
     y = y -vy;
     vy = -vy;
}

