class Player extends GameObject //<>//
{
  //variables
  ArrayList<Segment> segments = new ArrayList<Segment>();
  int minLength = 5;
  int maxLength = 20;
  float damping = .5;

  //constructor
  Player(PVector position, float speed, int w, int h, int c, String i, ID id)
  {
    super(position, w, h, c, i ,id);
    this.speed = speed;
  }
  
  //add segment
  void addSegment()
  {
   segments.add(new Segment(new PVector(0, 0), w, h, c, p, ID.SEGMENT)); 
  }

  //update
  void update()
  { 
    //check key to change direction
    if (keyDown[0] == true) velocity.x = speed; //right
    if (keyDown[1] == true) velocity.x = -speed; //left
    if (keyDown[2] == true) velocity.y = speed; //down
    if (keyDown[3] == true) velocity.y = -speed; //up

    //multiply velocity by friction
    velocity.mult(damping);

    //set position of head
    position.add(velocity);
    
    //set rotation
    rotation = velocity.heading();

    //set position of first segment
    segments.get(0).position.set(position);

    //remove last segment if the size of the tail is greater than the maxLength
    if (segments.size() - 1 > maxLength) segments.remove(segments.size() - 1);
  }

  //draw
  void draw()
  {
    //draw head
    drawImage();

    //draw segments
    for (int i = segments.size() - 1; i > 0; i --)
    {
      //makes each (segment)tail piece appear behind the next
      Segment p1 = segments.get(i - 1);
      Segment p2 = segments.get(i);
      PVector diff = p1.position.copy().sub(p2.position);
      float angle = (float)Math.atan2(diff.y, diff.x);
      p2.position.x = p1.position.x - (float)(Math.cos(angle) * (w + 2));
      p2.position.y = p1.position.y - (float)(Math.sin(angle) * (h + 2));
      p2.rotation = angle;
      p2.draw();
    }
  } 
  
  //reset
  void reset()
  {
    //add the minium amount of segments to the player
    segments.clear();
    for (int i = 0; i < minLength + 1; i ++) {
      segments.add(new Segment(new PVector(position.x + (w * i), position.y), w, h, c, p, ID.SEGMENT));
    }
  }
} 