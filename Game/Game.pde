import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import java.util.*;
import java.awt.Rectangle;

enum State 
{
  START, RUNNING, END;
}

//game variables
Rectangle buttonPosition;
int buttonWidth = 128;
int buttonHeight = 32;
int score = 0;
int pickupPoints = 25;
boolean[] keyDown = new boolean[5];
boolean[] enabledKeys = new boolean[5];
boolean rectOver = false;
State gameState = State.START;

//game objects
ArrayList<GameObject> gameObjects = new ArrayList<GameObject>();
Player player;
Spawner spawner;

//game sounds and fonts
PImage img;
Minim minim;
AudioSample pickupSound;
AudioSample spawnSound;
AudioSample spawnSound2;
AudioSample explode;
AudioPlayer music;
PFont f;

void setup()
{
  //set screen size
  size(800, 600);

  //get center position for play button
  buttonPosition = centerObjectRect(0, 0, buttonWidth, buttonHeight, width, height);

  //create player and spawning system
  player = new Player(new PVector(0, 0), 8, 16, 16, #ffffff, "artwork/player.png", ID.PLAYER);
  spawner = new Spawner();

  //reset game
  reset();

  //create sound manager and add sound files
  minim = new Minim(this);
  pickupSound = minim.loadSample("sounds/pickup2.mp3");
  spawnSound = minim.loadSample("sounds/spawn.mp3");
  spawnSound2 = minim.loadSample("sounds/spawn2.mp3");
  explode = minim.loadSample("sounds/explode.mp3");
  music = minim.loadFile("sounds/music.mp3", 2048);
  music.loop();
  music.play();

  //create font
  f = createFont("Arial", 16, true);
  
  img = loadImage("artwork/background.jpg");
}

void draw()
{
  //draw background
  image(img, 0, 0);

  //check if mouse is within button to begin playing game
  if (overRect((int)buttonPosition.x, (int)buttonPosition.y, buttonPosition.width, buttonPosition.height)) {
    rectOver = true;
  }

  //check if game has started
  if (gameState == State.START) {
    //draw play button
    drawButton("Play!", 32, -8, 0, 0);
  }

  //check if the game is running
  if (gameState == State.RUNNING)
  {
    //update and draw objects
    spawner.update();
    player.update();
    player.draw();
    //use an iterator to make sure the selected object is available in the array
    //reference for how to use iterators http://www.tutorialspoint.com/java/java_using_iterator.htm
    Iterator<GameObject> i = gameObjects.iterator();
    while (i.hasNext()) 
    {
      GameObject obj = i.next();
      obj.update();
      obj.update(player.segments.get(player.segments.size() / 2).position);
      obj.draw();
      //Detecte collision between player and objects
      if (Collision.calcAABB2(player, obj))
      {
        //detect if the player collides with a comrade (green square)
        if (obj.getId() == ID.COM) 
        {
          pickupSound.trigger();
          updateScore(pickupPoints);
          player.addSegment();
          i.remove();
        }
        //detect if the player collides with a governor (red square)
        if (obj.getId() == ID.GOV)
        {
          gameState = State.END;
        }
      }
      if (obj.getId() == ID.GOV)
      {
        if (((Governor)obj).segments.size() == 2)
        {
          updateScore(50);
          explode.trigger();
          i.remove();
        }
      }
    }

    //detect collision between head and tail segments
    for (int j = player.segments.size() - 1; j > 4; j --)
    {
      if (Collision.calcAABB2(player, player.segments.get(j)))
      {
        gameState = State.END;
      }
    }

    //check if player has gone out of bounds
    if (player.outOfBounds())
    {
      gameState = State.END;
    }
  }

  //check if the game has ended
  if (gameState == State.END)
  {
    drawButton("Game Over! Try again?", 116, -8, 48, 0);
  }

  //draw score
  textFont(f, 16);
  fill(#FFFFFF);
  text("Score: " + score, 16, 24);
}

//detect key press
void keyPressed() 
{
  //handle each key typed
  handleKey(keyCode);
}

//detect mouse press
void mousePressed()
{
  //start the game when the play button detects the click within its bounds
  if (rectOver) {
    if (gameState == State.START)
    {
      spawnSound.trigger();
      gameState = State.RUNNING;
    }
    if (gameState == State.END) 
    {
      reset();
      gameState = State.RUNNING;
    }
  }
}

/*
set all other keys to false when another key is pressed to set constant direction of player
 enable or disable keys to force the player to move only left and right or up and down base on their direction
 */
void handleKey(int code) 
{
  //println(code);
  switch(code) 
  {
  case 39: //right
    if (enabledKeys[2] || enabledKeys[3]) { // if moving down or up
      keyDown[0] = true; //right
      keyDown[1] = false; //left
      keyDown[2] = false; //down
      keyDown[3] = false; //up

      enabledKeys[0] = true; //right
      enabledKeys[1] = true;  //left
      enabledKeys[2] = false; //up
      enabledKeys[3] = false; //down
    }
    break;
  case 37: //left
    if (enabledKeys[2] || enabledKeys[3]) { // if moving down or up
      keyDown[0] = false; //right
      keyDown[1] = true; //left
      keyDown[2] = false; //down
      keyDown[3] = false; //up

      enabledKeys[0] = true; //right
      enabledKeys[1] = true;  //left
      enabledKeys[2] = false; //up
      enabledKeys[3] = false; //down
    }
    break;
  case 40: //down
    if (enabledKeys[0] || enabledKeys[1]) { //if moving left or right
      keyDown[0] = false; //right
      keyDown[1] = false; //left
      keyDown[2] = true; //down
      keyDown[3] = false; //up

      enabledKeys[0] = false; //right
      enabledKeys[1] = false;  //left
      enabledKeys[2] = true; //up
      enabledKeys[3] = true; //down
    }
    break;
  case 38: //up
    if (enabledKeys[0] || enabledKeys[1]) { //if moving left or right
      keyDown[0] = false; //right
      keyDown[1] = false; //left
      keyDown[2] = false; //down
      keyDown[3] = true; //up

      enabledKeys[0] = false; //right
      enabledKeys[1] = false;  //left
      enabledKeys[2] = true; //up
      enabledKeys[3] = true; //down
    }
    break;
  case 32:
    //can use spacebar to get ride of all government "red snakes"
    ListIterator<GameObject> i = gameObjects.listIterator();
    while (i.hasNext())
    {
      GameObject obj = i.next();
      if (obj.getId() == ID.GOV)
      {
        i.remove();
      }
    }  
    break;
  }
}

//add game object
void addObject(GameObject obj)
{
  gameObjects.add(obj);
}

//remove game object by id
void removeObject(ID id) {
  for (GameObject obj : gameObjects)
  {
    if (obj.getId() == id) {
      gameObjects.remove(obj);
    }
  }
}

//get game object by id
GameObject getObject(ID id) {
  for (GameObject obj : gameObjects)
  {
    if (obj.getId() == id) return obj;
  }
  return null;
}

/*
  increment the game score by positive or negative values
 example: updateScore(5) or updateScore(-5)
 */
void updateScore(int value) 
{
  score += value;
}

//resets game
void reset()
{
  gameObjects.clear();
  player.reset();
  player.position = centerObjectVector(0, 0, 32, 32, width, height);
  keyDown[0] = true; //right
  keyDown[1] = false; //left
  keyDown[2] = false; //up
  keyDown[3] = false; //down
  enabledKeys[0] = true; //right
  enabledKeys[1] = false;  //left
  enabledKeys[2] = false; //up
  enabledKeys[3] = false; //down
  score = 0;
}

//draws button
void drawButton(String text, int w, int h, int ow, int oh) 
{
  fill(#FFFFFF);
  noStroke();
  rect(buttonPosition.x, buttonPosition.y, buttonPosition.width + ow, buttonPosition.height + oh);
  textFont(f, 16);
  fill(0);
  Rectangle textPosition = centerObjectRect((int)buttonPosition.x, (int)buttonPosition.y, w, h, buttonPosition.width, buttonPosition.height);
  text(text, textPosition.x, textPosition.y);
}


//detect if mouse is within certain rectangular boundaries
boolean overRect(int x, int y, int width, int height)
{
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}


//center object on another object and return Rectangle object
Rectangle centerObjectRect(int ox, int oy, int ow, int oh, int w, int h)
{
  return new Rectangle(ox + (w / 2) - (ow / 2), oy + (h / 2) - (oh / 2), ow, oh);
}

//center object on another object and return PVector object
PVector centerObjectVector(int ox, int oy, int ow, int oh, int w, int h) 
{
  return new PVector(ox + (w / 2) - (ow / 2), oy + (h / 2) - (oh / 2));
} 