class Comrade extends GameObject
{
  //constructor
  Comrade(PVector position, int w, int h, int c, String i, ID id)
  {
    super(position, w, h, c, i, id);
    minSpeed = 0.01;
    maxSpeed = 0.05;
    speed = r.nextFloat() * (maxSpeed - minSpeed) + minSpeed;
  }

  //update
  void update()
  {
    rotation += speed;
  }

  void draw()
  {
    drawImage();
  }
}