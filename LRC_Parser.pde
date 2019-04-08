float[] rand;
PVector[] rndvec;
Lyric lbn ;


PFont f;

float sketchBeginTime;
void setup() {
  size(800, 700);
  rand = new float[5000]; 
  rndvec = new PVector[5000];

  f = createFont("Arial-Black", 74);
  textFont(f);
  for (int i = 0; i < 5000; i++) {
    rand[i] = random(5);
    rndvec[i] = PVector.random2D();
  }
  lbn = new Lyric("lbn.lrc", LANG.CHN);
  lbn.showRawSentence();
}



void draw() {
  background(189);

  fill(40, 255);
  textSize(18);
  int i = 0;
  float t = millis()+20000;

  text("current Time(millis): " + str(t), 258, 34);
  text("start time,        lyric,     end time", 241, 57);
  for (Sentence s : lbn.sentences) {
    //println(millis(), sketchBeginTime);
    if (s.onTime(t)) { 
      text(s.text, 320, 70 + i * 20);
      text(s.startTime, 162, 70 + i * 20);
      text(s.endTime, 526, 70 + i * 20);
    }

    i++;
  }
}

float sign(float f) {
  return f==0?0:(f/abs(f));
}
void resetRandom() {

  for (int i = 0; i < 5000; i++) {
    rand[i] = random(5); 
    rndvec[i].set(PVector.random2D());
  }
}
void keyPressed() {
  if (keyCode == ' ') {
    resetRandom();
  }
}
