class Governor extends GameObject
{
  //variables
  ArrayList<Segment> segments = new ArrayList<Segment>();
  int minLength = 5;

  //constructor
  Governor(PVector position, float speed, int w, int h, int c, String i, ID id)
  {
    super(position, w, h, c, i, id);
    this.speed = speed;
    reset();
  }

  //update
  void update(PVector target)
  {
    //seek the player
    PVector force = target.copy().sub(position);
    force.normalize();
    force.mult(speed);
    force.limit(1);
    force.div(10);
    velocity = velocity.add(force);
    position.add(velocity);

    //set position of first segment
    segments.get(0).position.set(position);

    //keep object within screen bounds
    clamp();
  }

  //draw
  void draw()
  {
    //draw head
    drawImage();

    //draw segments
    for (int i = segments.size() - 1; i > 0; i --)
    {
      //offset each segment behind the previous segment
      Segment p1 = segments.get(i - 1);
      Segment p2 = segments.get(i);
      PVector diff = p1.position.copy().sub(p2.position);
      float angle = (float)Math.atan2(diff.y, diff.x);
      p2.position.x = p1.position.x - (float)(Math.cos(angle) * (w + 8));
      p2.position.y = p1.position.y - (float)(Math.sin(angle) * (h + 8));
      p2.rotation = angle;
      p2.draw();
      if (Collision.calcAABB2(p2, player))
      {
        updateScore(10);
        segments.remove(i);
        explode.trigger();
      }
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