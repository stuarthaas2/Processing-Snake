class Spawner 
{
  //variables
  Random r = new Random();
  //the lower the spawn chance, the more often the object will spawn
  int comSpawnChance = 100;
  int govSpawnChance = 400;
  
  //constructor
  Spawner() {}
  
  //update
  void update()
  {
    //spawn comrade
   if((int)(Math.random() * comSpawnChance) == 0)
   {
     addObject(new Comrade(getPosition(), 16, 16, #00ff00, "artwork/comrade.png", ID.COM));
     spawnSound2.trigger();
   }
   //spawn governor
   if((int)(Math.random() * govSpawnChance) == 0)
   {
     float speed = getSpeed(1, 2);
     addObject(new Governor(getPosition(), speed, 16, 16, #ff0000, "artwork/governor.jpg", ID.GOV));
     spawnSound.trigger();
   }
  }
  
  //get position to prevent objects from spawning on player
  PVector getPosition()
  {
    PVector pos;
    do
    {
      pos = new PVector(r.nextInt(width), r.nextInt(height));
    }
    while(pos.dist(player.position) < 100);
    return pos;
  }
  
  //get random speed
  float getSpeed(float min, float max)
  {
    return r.nextFloat() * (max - min) + min; //<>//
  }
}