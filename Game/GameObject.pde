import java.awt.Color;

abstract class GameObject 
{
  //variables
  Random r = new Random();
  PVector position = new PVector(), velocity = new PVector();
  float rotation, speed, minSpeed, maxSpeed;
  int w, h, c;
  ID id;
  String p;
  PImage img;
  
  //constructor
  GameObject(PVector position, int w, int h, int c, String p, ID id)
  {
    this.position = position;
    this.w = w;
    this.h = h;
    this.c = c;
    this.id = id;
    this.p = p;
    img = loadImage(p);
  }
  
  //update
  void update(){};
  
  //update
  void update(PVector target){};
  
  //draw
  void draw(){};
  
  //draw
  void drawImage(){
    pushMatrix();
    translate(position.x, position.y);
    rotate(rotation);
    fill(c);
    image(img, -(w / 2), -(h / 2), w, h);
    popMatrix(); 
   }; 
    
  //draw
  void drawRect(){
    pushMatrix();
    translate(position.x, position.y);
    rotate(rotation);
    fill(c);
    rect(-(w / 2), -(h / 2), w, h);
    popMatrix(); 
  };
  
    //draw
  void drawEllipse(int ox, int oy){
    pushMatrix();
    translate(position.x, position.y);
    rotate(rotation);
    fill(c);
    ellipse(ox, oy, w, h);
    popMatrix(); 
  };
  
  //check if object has gone outside screen bounds
  boolean outOfBounds() 
  {
    if (position.x <= 0) 
    {
      return true;
    }

    if (position.x >= width) 
    {
      return true;
    }

    if (position.y <= 0) 
    {
      return true;
    }

    if (position.y >= height) 
    {
      return true;
    }
    return false;
  }

  //prevent object from going outside the screen bounds
  void clamp() 
  {
    if (position.x - w / 2 <= 0) 
    {
      position.x = w / 2;
      velocity.x = 0;
    }

    if (position.x >= width - w / 2) 
    {
      position.x = width - w / 2;
      velocity.x = 0;
    }

    if (position.y - h / 2 <= 0) 
    {
      position.y = h / 2;
      velocity.y = 0;
    }

    if (position.y >= height - h / 2) 
    {
      position.y = height - h / 2;
      velocity.y = 0;
    }
  }
 
  //getters
  int getWidth()
  {
    return w;
  } 
  
  int getHeight()
  {
    return h;
  }   
  
  ID getId()
  {
    return id;  
  }
}