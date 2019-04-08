enum LANG {
  CHN, ENG
};
class Lyric {
  ArrayList<Sentence> sentences = new ArrayList<Sentence>();

  Lyric(String fileName, LANG lan) {

    String[] lines = loadStrings(fileName);
    if (lines == null) {
      println("> ERROR: ERROR IN FILE.");
    }

    //println("there are " + lines.length + " lines");
    for (int i = 0; i < lines.length; i++) {
      //println(lines[i]);
    }
    parseLines(lines, lan);
  }




  void parseLines(String[] lines, LANG lan) { 
    Sentence lastSen = null;
    int timeCodeEnd = -1;
    FloatList times = new FloatList();
    for (int i = 0; i < lines.length; i++) {
      String l = lines[i];

      if (i == 0) {
        for (int j = 0; j < l.length(); j++) {
          char c = l.charAt(j);
          if (c == ']') {
            timeCodeEnd = j;
            break;
          }
        }
        if (timeCodeEnd == -1) {
          println("ERROR: LRC File invalid.");
          return ;
        }
      }

      if (lines[i].length() < timeCodeEnd+1) {
        continue ;
      }

      String timeCode = l.substring(0, timeCodeEnd+1);
      float beginTime = timeCodeToMilliSecond(timeCode);
      times.append(beginTime);
    }

    int j = 0;
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].length() < timeCodeEnd+1) {
        continue ;
      }

      String l = lines[i]; 
      String senStr = l.substring(timeCodeEnd+1);
      senStr.trim(); 
      Sentence newsen;
      if (j < times.size() - 1) {
        newsen = new Sentence(senStr, times.get(j), times.get(j+1));
      } else {
        newsen = new Sentence(senStr, times.get(j), -1);
      }
      sentences.add(newsen);
      j++;
    }
  }

  float timeCodeToMilliSecond(String timeCode) {
    try {
      if (timeCode.charAt(0) != '[' ||
        timeCode.charAt(timeCode.length()-1) != ']') {
        return -1;
      }
    } 
    catch (Exception e) {
      println("ERROR in timeCodeToMilliSecond: Invalid TimeCode");
    }
    float res = 0;
    int min = parseInt(timeCode.substring(1, 3));
    res += min * 60 * 1000;
    float sec = parseFloat(timeCode.substring(4, 9));
    res += sec * 1000;
    return res;
  }

  void showRawSentence() {
    for (Sentence s : sentences) {
      println(s.text);
    }
  }

  //Sentence getCurrentSentence(AudioPlayer p) {
  //  // use with minim
  //  return getSentenceAt(p.position());
  //}
  
  
  
  Sentence getSentenceAt(float t) {
    String str = ""; 
    Sentence sen = null;
    for (Sentence s : sentences) {
      //println(millis(), sketchBeginTime);
      if (s.onTime(t)) { 
        //text(s.text, 300, 70 + i * 20);
        //text(s.startTime, 50, 70 + i * 20);
        //text(s.endTime, 500, 70 + i * 20);

        sen = new Sentence(s.text, s.startTime, s.endTime);
        //println(sen.text);
        break;
      }
    }
    return sen;
  }
}

class Sentence {
  float startTime, endTime; // in milli-second
  String text;
  float lifeSpan;
  Sentence(String txt, float t1, float t2) {
    text = txt + "";
    startTime = t1;
    endTime = t2;
    if (t2 == -1) {
      lifeSpan = 3.0; // default
    } else {
      lifeSpan = t2 - t1;
    }
  }
  boolean onTime(float t) {
    return startTime < t && endTime > t;
  }
  boolean onTime(float t, float timescale) {
    try {
      if (timescale == 0) {
        return false;
      }
    } 
    catch (Exception e) {
      println("ERROR in onTime(float t, float timescale): timescale == 0");
    }
    return startTime < t 
      && endTime > t;
  }
}
