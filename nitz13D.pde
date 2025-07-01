/********************************************/
/********************************************/
/***  NITZ Version 13D                   ***/
/********************************************/
/********************************************/



/********************************************/
/***  Class BaseShape                     ***/
/********************************************/
abstract class BaseShape {
  public float rotation = 0;
  abstract protected int getX();
  abstract protected int getY();
  private float speedX = 0;
  private float speedY = 0;
  public int speed = 0;
  public int direction;


  public BaseShape() {
    //frameRate(30);
  }

  protected int advanceSpeedX() {
    int advanceX = 0;
    if (speed == 0) {
      speedX = 0;
    } else {
      speedX += (speed) * cos(radians(direction));

      advanceX = round(speedX);

      speedX = speedX - advanceX;
    }
    return advanceX;
  }
  protected int advanceSpeedY() {
    int advanceY = 0;
    if (speed == 0) {
      speedY = 0;
    } else {
      speedY += (speed) * sin(radians(direction));

      advanceY = round(speedY);

      speedY = speedY - advanceY;
    }
    return advanceY;
  }
  protected void rotateIt() {
    pushMatrix();
    translate(getX(), getY());
    rotate(radians(rotation));
    translate(-getX(), -getY());
    this.drawIt();
    popMatrix();
  }
  abstract protected void drawIt();
  public void draw() {
    if (abs(rotation)%360!=0) {
      this.rotateIt();
    } else {
      this.drawIt();
    }
  }
}

/********************************************/
/***  Class Direction                     ***/
/********************************************/
class Direction {
  public final static int UP = 270;
  public final static int DOWN = 90;
  public final static int LEFT = 180;
  public final static int RIGHT = 0;
  public final static int UPRIGHT = 315;
  public final static int DOWNRIGHT = 45;
  public final static int UPLEFT = 225;
  public final static int DOWNLEFT = 135;
}


/********************************************/
/***  Class Ellipse                       ***/
/********************************************/
class Ellipse extends BaseShape {
  public int x;
  public int y;
  public int radiusX;
  public int radiusY;
  public color brush;
  public int alpha = 255;
  public color pen;
  public int penThickness;

  protected void drawIt() {
    brush = (brush & 0xffffff) | (alpha << 24);
    pen = (pen & 0xffffff) | (alpha << 24);
    fill(brush);
    if (penThickness == 0) {
      noStroke();
    } else {
      strokeWeight(penThickness);
      stroke(pen);
    }
    x += this.advanceSpeedX();
    y += this.advanceSpeedY();
    ellipse(x, y, radiusX * 2, radiusY * 2);
  }

  protected int getX() {
    return x;
  }

  protected int getY() {
    return y;
  }

  public boolean pointInShape(int x1, int y1) {
    double normalizeXPow2 = pow((x1 - x), 2);
    double normalizeYPow2 = pow((y1 - y), 2);
    double radiusXPow2 = pow(radiusX, 2);
    double radiusYPow2 = pow(radiusY, 2);
    return ((normalizeXPow2 / radiusXPow2) + (normalizeYPow2 / radiusYPow2)) <= 1.0;
  }
  public void ZoomIn() {
    x-=1;
    y-=1;
    radiusX+=2;
    radiusY+=2;
  }
  public void ZoomOut() {
    x+=1;
    y+=1;
    radiusX-=2;
    radiusY-=2;
  }
}


/********************************************/
/***  Class Hexagon                       ***/
/********************************************/
class Hexagon extends BaseShape {
  public int x;
  public int y;
  public int radius;
  public color brush;
  public int alpha = 255;
  public color pen;
  public int penThickness;
  private PVector[] verts;

  protected void drawIt() {
    brush = (brush & 0xffffff) | (alpha << 24);
    pen = (pen & 0xffffff) | (alpha << 24);
    fill(brush);
    if (penThickness == 0) {
      noStroke();
    } else {
      strokeWeight(penThickness);
      stroke(pen);
    }
    x += this.advanceSpeedX();
    y += this.advanceSpeedY();
    pushMatrix();
    polygon();
    popMatrix();
  }

  protected int getX() {
    return x;
  }

  protected int getY() {
    return y;
  }

  private void polygon() {
    verts = new PVector[7];
    float angle = 2 * PI / 6;
    beginShape();
    float sx;
    float sy;
    int index = 0;
    for (float i = 0; i < 2 * PI; i += angle) {
      sx = x + cos(i) * radius;
      sy = y + sin(i) * radius;
      verts[index++] = new PVector(sx, sy);
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
  public boolean pointInShape(int x1, int y1) {
    PVector pos = new PVector(x1, y1);
    int i, j;
    boolean c = false;
    int sides = 6;
    for (i = 0, j = sides - 1; i < sides; j = i++) {
      if ((((verts[i].y <= pos.y) && (pos.y < verts[j].y)) || ((verts[j].y <= pos.y) && (pos.y < verts[i].y))) &&
        (pos.x < (verts[j].x - verts[i].x) * (pos.y - verts[i].y) / (verts[j].y - verts[i].y) + verts[i].x)) {
        c = !c;
      }
    }
    return c;
  }
  public void ZoomIn() {
    x-=1;
    y-=1;
    radius+=2;
  }
  public void ZoomOut() {
    x+=1;
    y+=1;
    radius-=2;
  }
}

/********************************************/
/***  Class Image                          ***/
/********************************************/

class Image extends BaseShape {
  private PImage image;
  private String path;
  public int x;
  public int y;
  public int width = -1;
  public int height = -1;
  public int originalWidth = -1;
  public int originalHeight = -1;
  public float alpha = 1;

  public String getPath() {
    return path;
  }
  protected int getX() {
    return x;
  }
  protected int getY() {
    return y;
  }
  public void setImage(String path_) {
    path = path_;
    image = loadImage(path);
    if (width == -1) {
      width = image.width;
    }
    if (height == -1) {
      height = image.height;
    }
    originalWidth = width;
    originalHeight = height;
    /*
        if(width==-1){
     width = image.width;
     }
     if(height==-1){
     height = image.height;
     }
     */
  }
  public void resetSize() {
    if (image != null) {
      width = image.width;
      height = image.height;
    }
  }
  protected void drawIt() {
    x += this.advanceSpeedX();
    y += this.advanceSpeedY();

    image(image, x, y, width, height);
  }
  public boolean pointInShape(int x1, int y1) {

    if (x1 >= x && x1 <= (x + width) && y1 >= y && y1 <= (y + height)) {

      return true;
    } else {
      return false;
    }
  }
  public void ZoomIn() {
    x-=1;
    y-=1;
    width+=2;
    //height+=2;
    height = (originalHeight*width)/originalWidth;
  }
  public void ZoomOut() {
    x+=1;
    y+=1;
    width-=2;
    height = (originalHeight*width)/originalWidth;
  }
}


/********************************************/
/***  Class Line                          ***/
/********************************************/
class Line extends BaseShape {
  public int x1;
  public int y1;
  public int x2;
  public int y2;
  public int alpha = 255;
  public color pen;
  public int penThickness;

  protected void drawIt() {
    //brush = (brush & 0xffffff) | (alpha << 24);
    pen = (pen & 0xffffff) | (alpha << 24);
    if (penThickness == 0) {
      noStroke();
    } else {
      strokeWeight(penThickness);
      stroke(pen);
    }
    int advancedSpeedX = this.advanceSpeedX();
    int advancedSpeedY = this.advanceSpeedY();
    x1 += advancedSpeedX;
    y1 += advancedSpeedY;
    x2 += advancedSpeedX;
    y2 += advancedSpeedY;
    line(x1, y1, x2, y2);
  }
  protected int getX() {
    return x1;
  }
  protected int getY() {
    return y1;
  }
}


/********************************************/
/***  Class Pentagon                      ***/
/********************************************/
class Pentagon extends BaseShape {
  public int x;
  public int y;
  public int radius;
  public color brush;
  public int alpha = 255;
  public color pen;
  public int penThickness;
  private PVector[] verts;

  protected void drawIt() {
    brush = (brush & 0xffffff) | (alpha << 24);
    pen = (pen & 0xffffff) | (alpha << 24);
    fill(brush);
    if (penThickness == 0) {
      noStroke();
    } else {
      strokeWeight(penThickness);
      stroke(pen);
    }
    x += this.advanceSpeedX();
    y += this.advanceSpeedY();
    pushMatrix();
    polygon(); //(x, y, radius, 5);
    popMatrix();
  }

  protected int getX() {
    return x;
  }

  protected int getY() {
    return y;
  }

  private void polygon() {
    verts = new PVector[5];
    float angle = 2 * PI / 5;
    beginShape();
    float sx;
    float sy;
    int index = 0;
    for (float i = 0; i < 2 * PI; i += angle) {
      sx = x + cos(i) * radius;
      sy = y + sin(i) * radius;
      verts[index++] = new PVector(sx, sy);
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
  public boolean pointInShape(int x1, int y1) {
    PVector pos = new PVector(x1, y1);
    int i, j;
    boolean c = false;
    int sides = 5;

    for (i = 0, j = sides - 1; i < sides; j = i++) {
      if ((((verts[i].y <= pos.y) && (pos.y < verts[j].y)) || ((verts[j].y <= pos.y) && (pos.y < verts[i].y))) &&
        (pos.x < (verts[j].x - verts[i].x) * (pos.y - verts[i].y) / (verts[j].y - verts[i].y) + verts[i].x)) {
        c = !c;
      }
    }
    return c;
  }
  public void ZoomIn() {
    x-=1;
    y-=1;
    radius+=2;
  }
  public void ZoomOut() {
    x+=1;
    y+=1;
    radius-=2;
  }
}


/********************************************/
/***  Class Rect                          ***/
/********************************************/

class Rect extends BaseShape {
  public int x;
  public int y;
  public int width;
  public int height;
  public int originalWidth = -1;
  public int originalHeight = -1;
  public color brush;
  public int alpha = 255;
  public color pen;
  public int penThickness;

  protected void drawIt() {
    brush = (brush & 0xffffff) | (alpha << 24);
    pen = (pen & 0xffffff) | (alpha << 24);
    fill(brush);
    if (penThickness == 0) {
      noStroke();
    } else {
      strokeWeight(penThickness);
      stroke(pen);
    }

    x += this.advanceSpeedX();
    y += this.advanceSpeedY();

    rect(x, y, width, height);
  }

  protected int getX() {
    return x;
  }

  protected int getY() {
    return y;
  }

  public boolean pointInShape(int x1, int y1) {
    if (x1 >= x && x1 <= (x + width) && y1 >= y && y1 <= (y + height)) {
      return true;
    } else {
      return false;
    }
  }
  public void ZoomIn() {
    int originalWidth = width;
    int originalHeight = height;
    x-=1;
    y-=1;
    width+=2;
    height = (originalHeight*width)/originalWidth;
    //height+=2;
  }
  public void ZoomOut() {
    int originalWidth = width;
    int originalHeight = height;
    x+=1;
    y+=1;
    width-=2;
    height = (originalHeight*width)/originalWidth;
    //height -= 2;
  }
}



/********************************************/
/***  Class Text                          ***/
/********************************************/
class Text extends BaseShape {
  public int x;
  public int y;
  public color brush;
  public int alpha = 255;

  public String text;
  public int textSize;
  public String font;

  protected void drawIt() {
    brush = (brush & 0xffffff) | (alpha << 24);
    textSize(textSize);
    fill(brush);

    x += this.advanceSpeedX();
    y += this.advanceSpeedY();


    if (font!=null) {
      PFont myFont;
      myFont = createFont(font, textSize, true);
      textFont(myFont);
    }


    text(text, x, y);
  }

  protected int getX() {
    return x;
  }

  protected int getY() {
    return y;
  }
  public void ZoomIn() {
    x-=1;
    y-=1;
    textSize+=2;
  }
  public void ZoomOut() {
    x+=1;
    y+=1;
    textSize-=2;
  }
}


/********************************************/
/***  Class Triangle                      ***/
/********************************************/
class Triangle extends BaseShape {
  public int x1;
  public int y1;
  public int x2;
  public int y2;
  public int x3;
  public int y3;
  public color brush;
  public int alpha = 255;
  public color pen;
  public int penThickness;

  protected void drawIt() {
    brush = (brush & 0xffffff) | (alpha << 24);
    pen = (pen & 0xffffff) | (alpha << 24);
    fill(brush);
    if (penThickness == 0) {
      noStroke();
    } else {
      strokeWeight(penThickness);
      stroke(pen);
    }
    int advancedSpeedX = this.advanceSpeedX();
    int advancedSpeedY = this.advanceSpeedY();
    x1 += advancedSpeedX;
    y1 += advancedSpeedY;
    x2 += advancedSpeedX;
    y2 += advancedSpeedY;
    x3 += advancedSpeedX;
    y3 += advancedSpeedY;
    triangle(x1, y1, x2, y2, x3, y3);
  }
  protected int getX() {
    return x1;
  }
  protected int getY() {
    return y1;
  }
  public boolean pointInShape(int x, int y) {
    float s = y1 * x3 - x1 * y3 + (y3 - y1) * x + (x1 - x3) * y;
    float t = x1 * y2 - y1 * x2 + (y1 - y2) * x + (x2 - x1) * y;

    if ((s < 0) != (t < 0))
      return false;
    float A = -y2 * x3 + y1 * (x3 - x2) + x1 * (y2 - y3) + x2 * y3;
    if (A < 0.0) {
      s = -s;
      t = -t;
      A = -A;
    }
    return s > 0 && t > 0 && (s + t) < A;
  }
}


/********************************************/
/***  Class SpriteSheet                   ***/
/********************************************/
class SpriteSheet extends Image {
  public int x;
  public int y;
  public Image img = new Image();
  private int imgNum = 1;
  public int NumOfImage=0; 
  public int animationFactor = 50;
  private int drawInvokeCounter = 0;
  public String imageBaseName; 
  public int height;
  public int width;

  protected int getX() {
    return x;
  }
  protected int getY() {
    return y;
  }
  protected void drawIt() {
    drawInvokeCounter++;
    if (frameCount%animationFactor==0) {
      imgNum++;
      if (imgNum>NumOfImage) {
        imgNum=1;
      }
    }
    img.setImage(imageBaseName+imgNum+".png");
    img.x=x;
    img.y=y;
    if (width>0)
      img.width= width;
    if (height>0)
      img.height = height;
    width = img.width;
    height = img.height;  
    img.draw();
    x += this.advanceSpeedX();
    y += this.advanceSpeedY();
    img.x = x;
    img.y = y;
    //println(imgNum);
  }
  //public boolean pointInShape(int x1, int y1) {
  ////println(x1 >= x && x1 <= (x + width) && y1 >= y && y1 <= (y + height));
  //if (x1 >= x && x1 <= (x + width) && y1 >= y && y1 <= (y + height)) {
  //  return true;
  //} else {
  //  return false;
  //}
  //}
  public boolean pointInShape(int x1, int y1) {
    if (x1 >= x && x1 <= (x + width) && y1 >= y && y1 <= (y + height)) {
      return true;
    } else {
      return false;
    }
  }
  public void ZoomIn() {
    x-=1;
    y-=1;
    width+=2;
    height+=2;
  }
  public void ZoomOut() {
    x+=1;
    y+=1;
    width-=2;
    height-=2;
  }
}


/********************************************/
/***  Class Music                         ***/
/********************************************/
PApplet papplet = this;

import ddf.minim.*;

class Music {
  private Minim minim;
  private AudioPlayer player;

  private String path;

  public boolean loop;

  public Music() {
  }

  public void load(String path_) {

    path = path_;
    if (minim == null) {
      minim = new Minim(papplet);
    }

    if (player != null) {
      player.close();
    }

    player = minim.loadFile(path);
  }

  public void play() {
    if (player != null) {
      if (loop) {
        player.loop();
      } else {
        player.rewind();
        player.play();
      }
    }
  }

  public void stop() {
    if (player != null) {
      player.pause();
      player.rewind();
    }
  }
}





/********************************************/
/***  Class DynamicBackground             ***/
/********************************************/

class ImageNode {
  public Image background = new Image();
  public ImageNode next;
}


class DynamicBackground {
  //private Image background1 = new Image();
  //private Image background2 = new Image();
  private String imgPath1;
  private String imgPath2;
  private int backgroundDirection = Direction.LEFT;
  ImageNode node1;
  ImageNode node2; 

  public DynamicBackground()
  {
    // direction = Direction.LEFT;
  }

  void initBackImages(String img1, String img2) {
    imgPath1 = img1;
    imgPath2 = img2;
    node1 = new ImageNode();
    node1.background.setImage(img1);
    //background1.x = 0;
    //background1.y = 0;
    node1.background.direction = backgroundDirection;//Direction.LEFT;
    node1.background.speed = 1;
    node2 = new ImageNode();
    node1.background.setImage(img2);
    //background2.x = 0;
    //background2.y = 0;
    node2.background.direction = backgroundDirection;//Direction.LEFT;
    node2.background.speed = 1;
    node1.next = node2;
    node2.next = node1;
    if (backgroundDirection == Direction.LEFT)
    {
      node1.background.setImage(img1);
      node1.background.x = 0;
      node1.background.y = 0;
      node1.background.direction = backgroundDirection;//Direction.LEFT;
      node1.background.speed = 1;

      node2.background.setImage(img2);
      node2.background.x = node1.background.x + node1.background.width;
      node2.background.y = 0;
      node2.background.direction = backgroundDirection;//Direction.LEFT;
      node2.background.speed = 1;
    } else {
      node1.background.setImage(img1);
      node1.background.x = 0;
      node1.background.y = 0;
      node1.background.direction = backgroundDirection;//Direction.LEFT;
      node1.background.speed = 1;

      node2.background.setImage(img2);
      node2.background.x = node1.background.x - node1.background.width;
      node2.background.y = 0;
      node2.background.direction = backgroundDirection;//Direction.LEFT;
      node2.background.speed = 1;
    }
    this.draw();
  }

  void updateBackgroundBoundaries() {  
    if (backgroundDirection == Direction.LEFT)
    {
      if (node1.background.x == -node1.background.width) {
        node1.background.x = node2.background.x + node2.background.width;
      }

      if (node2.background.x == -node2.background.width) {
        node2.background.x = node1.background.x + node1.background.width;
      }
    } else
    {

      if (node1.background.x == node1.background.width) {
        node1.background.x = node2.background.x - node2.background.width;
      }

      if (node2.background.x == node2.background.width) {
        node2.background.x = node1.background.x - node1.background.width;
      }
    }
  }

  void draw() { 
    node1.background.draw();
    node2.background.draw();
    updateBackgroundBoundaries();
  }

  public void stop()
  {

    node1.background.speed=0;
    node2.background.speed=0;
  }
  public void run()
  {

    node1.background.speed=1;
    node2.background.speed=1;
  }
  public void setDirection(int new_direction)
  {
    backgroundDirection = new_direction;
    updateImages();
  }

  void updateImages() 
  {

    node1.background.direction = backgroundDirection;//Direction.LEFT;
    node2.background.direction = backgroundDirection;//Direction.LEFT;
    if (backgroundDirection == Direction.LEFT)
    {

      node1.background.direction = backgroundDirection;//Direction.LEFT;
      node1.background.speed = 1;


      //node2.background.x = node1.background.x + node1.background.width;
      node2.background.y = 0;
      node2.background.direction = backgroundDirection;//Direction.LEFT;
      node2.background.speed = 1;
    } 
    //if (backgroundDirection == Direction.RIGHT){
    else {
      node1.background.direction = backgroundDirection;//Direction.LEFT;
      node1.background.speed = 1;


      //node2.background.x = node1.background.x - node1.background.width;
      node2.background.y = 0;
      node2.background.direction = backgroundDirection;//Direction.LEFT;
      node2.background.speed = 1;
    }
  }
}


/********************************************/
/***  Class SplashScreen                  ***/
/********************************************/
class SplashScreen
{

  public color backgroundColor;
  public String image;
  public String gameName;
  public String gameAuthor1;
  public String gameAuthor2;
  public String gameAuthor3;
  public Music introMusic;
  private boolean flag = true;


  private int time;

  public SplashScreen()
  {
    time = millis();
    introMusic=new Music();
  }
  public boolean show()
  {
    Rect window = new Rect();
    window.width = 650;
    window.height = 480;
    window.x = (width - window.width)/2;
    window.y = (height - window.height)/2;
    window.brush = backgroundColor;
    window.alpha = 80;

    Text gameNameTxt = new Text();
    gameNameTxt.text = gameName;
    gameNameTxt.x=window.x+50;
    gameNameTxt.y=window.y+50;
    gameNameTxt.font = "ARIAL";
    gameNameTxt.textSize = 60;
    gameNameTxt.brush  = ~backgroundColor|0xff000000;

    Text author1 = new Text();
    author1.text = gameAuthor1;
    author1.x=window.x+20;
    author1.y=window.y+150;
    author1.font = "ARIAL";
    author1.textSize = 40;
    author1.brush  = ~backgroundColor|0xff0ff000;
    Text author2 = new Text();
    author2.text = gameAuthor2;
    author2.x=window.x+20;
    author2.y=window.y+200;
    author2.font = "ARIAL";
    author2.textSize = 40;
    author2.brush  = ~backgroundColor|0xff0ff000;

    Image image1 = new Image();
    image1.setImage(image);
    image1.x=window.x+350;
    image1.y = window.y+150;
    image1.width = 250;
    float scale = 250.0/float(image1.width);
    image1.height = 250;
    image1.width = int(image1.width * scale);
   
    if ( millis() < time + 5000) {
      window.draw();
      gameNameTxt.draw();
      author1.draw();
      author2.draw();
      image1.draw();
      if (flag==true) {
        if (introMusic. path !="") {
          introMusic.play();
        }
        flag=false;
      }
      return true;
    } else
    {
      introMusic.stop();
      return false;
    }
  }
}

/********************************************/
/***  Class ImageLink                  ***/
/********************************************/
class ImageLinkItem {
  public Image image;
  public String urlAddress;
}

class ImageLink {
  public ArrayList<ImageLinkItem> items = new ArrayList<ImageLinkItem>();
  //Music music= new Music();
  private int nextX = 10;
  private int nextY = 10;
  public void Add(String image, String url)
  {
    ImageLinkItem item = new ImageLinkItem();
    item.image= new Image();
    item.image.setImage(image);

    float scale = 250.0/float(item.image.width);
    item.image.height = 250;
    float tmp = item.image.width * scale;
    //item.image.width = int(item.image.width * scale);

    if ((item.image.width + nextX)>width)
    {
      nextX = 10;
      nextY += 300;
    }
    item.image.x= nextX;
    item.image.y = nextY;
    nextX += item.image.width+10;

    item.urlAddress=url;
    items.add(item);
    item.image.draw();
  }

  public void Browse(int x, int y)
  {
    ImageLinkItem tmp = null;
    for (int i = 0; i < items.size(); i++) {
      tmp = items.get(i);
      if (tmp.image.pointInShape(x, y))
      {
        link(tmp.urlAddress);
      }
    }
  }
}

/********************************************/
/***  Class Game             ***/
/********************************************/
private class Game
{
  public int score;
  public int live;
}
