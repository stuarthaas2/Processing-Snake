class Segment extends GameObject
{
  //constructor
 Segment(PVector position, int w, int h, int c, String i, ID id)
 {
  super(position, w, h, c, i, id); 
 }
 
 void draw()
 {
  drawImage(); 
 }
}