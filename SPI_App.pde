import de.bezier.data.sql.*;
import de.bezier.data.sql.mapper.*;
SQLite db;

int[][] allCrd;
String[][] allUsr;
int lexSize;
int usrSize;

int[] s1crd;
int[] s2crd;
int[] s3crd;
int[] tempcrd;

int[][] gridCrdVals = new int[25][2];

int editNum = 0;

Shape s1, s2, s3, temps1, temps2, temps3;

int s1Ind = 26;
int s2Ind = 1;
int s3Ind = 16;

String userName = "guy2000";
int userLogoHash;

boolean checkedLogo = false;
boolean isAvail;
boolean canDownload = false;
boolean downloaded = false;
boolean editMode = false;
boolean currentlyEditing = false;
int currentlyEditingNum = 0;
boolean editedShape1 = false;
boolean editedShape2 = false;
boolean editedShape3 = false;

color c1, c2;

int gridNum = 0;

boolean viewAlphabet = false;
int alphaShift = 0;

boolean editColor = false;

boolean string2shape = false;
boolean stsComplete = false;
// Variable to store text currently being typed
String typing = "";
// Variable to store saved text when return is hit
String saved = "";
//ASCII bin values.
int ASCIIsum[] = new int[3];

void setup() {
  //scale by 3
  //size(200,100);
  size(600,330);
  
  //default color values
  c1 = color(0,100,255);
  c2 = color(0,255,255);
  
  //array of strings, each element is a line from users.txt
  String[] usrLines = loadStrings("users.txt");
  allUsr = new String[usrLines.length][2];
  usrSize = usrLines.length;
  //for each line in users.txt
  for (int i = 0; i < usrSize; i++) {
    //console output
    print(i + ": ");
    //split line into tokens, delimited by ','
    String[] usrLine = split(usrLines[i], ',');
    for (int j = 0; j < 2; j++) {
      allUsr[i][j] = usrLine[j];
      //verify on console that coordinates have been read appropriately
      print(allUsr[i][j] + " ");
    }
    print('\n');
  }
  
  //array of strings, each element is a line from lexicon.txt
  String[] lines = loadStrings("lexicon.txt");
  //determine size of array for storing shape coordinates based on # of shapes (lines) in lexicon.txt
  allCrd = new int[lines.length][12];
  lexSize = lines.length;
  //for each line in lexicon.txt
  for (int i = 0; i < lexSize; i++) {
    //console output
    print(i + ": ");
    //split line into tokens, delimited by ','
    String[] line = split(lines[i], ','); 
    //for each token, of each line (shape), place values into coordinate array
    for (int j = 0; j < 12; j++) {
      allCrd[i][j] = int(line[j]);
      //verify on console that coordinates have been read appropriately
      print(allCrd[i][j] + " ");
    }
    print('\n');
  }  
  int j = 0;
  //populate gridCrdVals table
  for (int i = 0; i < 5; i++) {
      gridCrdVals[0+i][0] = (20*3);
      gridCrdVals[0+i][1] = (20*3) + j;
      gridCrdVals[1+i][0] = (20*3) + 10*3;
      gridCrdVals[1+i][1] = (20*3) + j;
      gridCrdVals[2+i][0] = (20*3) + 20*3;
      gridCrdVals[2+i][1] = (20*3) + j;
      gridCrdVals[3+i][0] = (20*3) + 30*3;
      gridCrdVals[3+i][1] = (20*3) + j;
      gridCrdVals[4+i][0] = (20*3) + 40*3;
      gridCrdVals[4+i][1] = (20*3) + j;
      j = j + 10*3;
  }  
  s1 = new Shape(s1Ind,1,c1,c2);
  s2 = new Shape(s2Ind,2,c1,c2);
  s3 = new Shape(s3Ind,3,c1,c2);
  s1crd = s1.getShapeCrd();
  s2crd = s2.getShapeCrd();
  s3crd = s3.getShapeCrd();
  temps1 = s1;
  temps2 = s2;
  temps3 = s3;
}

void draw() {
  background(255);
  if (editNum == 0) {
    s1.updateColor(c1,c2);
    s2.updateColor(c1,c2);
    s3.updateColor(c1,c2);
    s1.selectDisplay();
    s2.selectDisplay();
    s3.selectDisplay();
    if (downloaded) {
      fill(0);
      textSize(20);
      text("wooo", 40*3,70*3);
      saveLogo(userName, userLogoHash);
    }
    else {
      fill(c1);
      textSize(16);
      text("WELCOME!",86*3,69*3);
      text("TO START CREATING YOUR LOGO, CLICK A SHAPE!",30*3,78*3);
    }
  }
  else if (editNum != 0) {
    if (viewAlphabet && !editColor && !string2shape) {
      //BACK button
      stroke(c1);
      fill(c1);
      rect(5*3,5*3,40*3,5*3);
      fill(255);
      textSize(12);
      text("BACK", 19*3,9*3);
      //SCROLL DOWN button
      fill(c1);
      rect(55*3,5*3,40*3,5*3);
      fill(255);
      textSize(12);
      text("SCROLL DOWN", 60*3,9*3);
      //SCROLL UP button
      fill(c1);
      rect(105*3,5*3,40*3,5*3);
      fill(255);
      textSize(12);
      text("SCROLL UP", 114*3,9*3); 
      //special shape for displaying alphabet
      Shape alpha = new Shape();
      alpha.displayAlphabet(lexSize,alphaShift,c1,c2);
    }
    else if (editColor && !viewAlphabet && !string2shape) {
      //draw BACK button
      stroke(c1);
      fill(c1);
      rect(5*3,5*3,40*3,5*3);
      fill(255);
      textSize(12);
      text("BACK", 19*3,9*3);
      //COLOR 1 ROW 1 
      stroke(255,0,0);
      fill(255,0,0);
      rect(20*3,20*3,20*3,20*3);
      stroke(255,145,0);
      fill(255,145,0);
      rect(40*3,20*3,20*3,20*3);
      stroke(255,255,0);
      fill(255,255,0);
      rect(60*3,20*3,20*3,20*3);
      stroke(145,255,0);
      fill(145,255,0);
      rect(80*3,20*3,20*3,20*3);
      stroke(0,255,100);
      fill(0,255,100);
      rect(100*3,20*3,20*3,20*3);
      stroke(0,255,255);
      fill(0,255,255);
      rect(120*3,20*3,20*3,20*3);
      stroke(0,100,255);
      fill(0,100,255);
      rect(140*3,20*3,20*3,20*3);
      stroke(255,0,255);
      fill(255,0,255);
      rect(160*3,20*3,20*3,20*3);
      //COLOR 2 ROW 2
      stroke(255,0,0);
      fill(255,0,0);
      rect(20*3,50*3,20*3,20*3);
      stroke(255,145,0);
      fill(255,145,0);
      rect(40*3,50*3,20*3,20*3);
      stroke(255,255,0);
      fill(255,255,0);
      rect(60*3,50*3,20*3,20*3);
      stroke(100,255,0);
      fill(100,255,0);
      rect(80*3,50*3,20*3,20*3);
      stroke(0,255,100);
      fill(0,255,100);
      rect(100*3,50*3,20*3,20*3);
      stroke(0,255,255);
      fill(0,255,255);
      rect(120*3,50*3,20*3,20*3);
      stroke(0,100,255);
      fill(0,100,255);
      rect(140*3,50*3,20*3,20*3);
      stroke(255,0,255);
      fill(255,0,255);
      rect(160*3,50*3,20*3,20*3);
      //COLOR EXAMPLE
      stroke(c1);
      fill(c1);
      triangle(90*3,80*3,90*3,100*3,110*3,100*3);
      stroke(c2);
      fill(c2);
      triangle(90*3,80*3,110*3,80*3,110*3,100*3);
    }
    else if (string2shape && !editColor && !viewAlphabet) {
      //draw BACK button
      stroke(c1);
      fill(c1);
      rect(5*3,5*3,40*3,5*3);
      fill(255);
      textSize(12);
      text("BACK",19*3,9*3);
      //
      fill(c1);
      textSize(14);
      text("CLICK IN THE BOX AND TYPE,\nHIT ENTER TO SEE THE RESULT:",60*3,70*3);
      rect(60*3,80*3,80*3,15*3);
      textSize(12);
      fill(255);
      text(typing,(60*3)+5,(80*3)+5,(80*3)-10,(15*3)-5);
      if (stsComplete) {
        temps1 = new Shape(ASCIIsum[0],1,c1,c2);
        temps2 = new Shape(ASCIIsum[1],2,c1,c2);
        temps3 = new Shape(ASCIIsum[2],3,c1,c2);
        s1 = temps1;
        s2 = temps2;
        s3 = temps3;
        s1.selectDisplay();
        s2.selectDisplay();
        s3.selectDisplay();
      }
    }
    //DEFAULT, LOGO SELECT MODE
    else {
    //draw shapes
    temps1 = new Shape(s1crd,1);
    temps2 = new Shape(s2crd,2);
    temps3 = new Shape(s3crd,3);
    s1 = temps1;
    s2 = temps2;
    s3 = temps3;
    temps1.updateColor(c1,c2);
    temps2.updateColor(c1,c2);
    temps3.updateColor(c1,c2);
    s1.updateColor(c1,c2);
    s2.updateColor(c1,c2);
    s3.updateColor(c1,c2);
    s1.selectDisplay();
    s2.selectDisplay();
    s3.selectDisplay();
    //draw mode buttons
    stroke(c1);
    fill(c1);
    //view alphabet button
    rect(5*3,5*3,40*3,5*3);
    fill(255);
    textSize(12);
    text("VIEW ALPHABET", 9*3,9*3);
    //string-to-shape button
    fill(c1);
    rect(55*3,5*3,40*3,5*3);
    fill(255);
    textSize(12);
    text("STRING-TO-SHAPE", 57*3,9*3);
    //edit color button
    fill(c1);
    rect(105*3,5*3,40*3,5*3);
    fill(255);
    textSize(12);
    text("EDIT COLORS", 111*3,9*3);
    //HELP button
    fill(c1);
    rect(155*3,5*3,40*3,5*3);
    fill(255);
    textSize(12);
    text("HELP",170*3,9*3);
    //draw edit arrows and edit shape button
    switch (editNum) {
      case 1:
        stroke(c2);
        fill(c2);
        triangle(20*3,75*3,30*3,70*3,40*3,75*3);
        stroke(c1);
        fill(c1);
        triangle(40*3,70*3,50*3,75*3,60*3,70*3);
        rect(20*3,80*3,40*3,5*3);
        fill(255);
        if (editMode) {
          textSize(12);
          text("DONE EDITING",26*3,84*3);
        }
        else {
          textSize(12);
          text("EDIT SHAPE",29*3,84*3);
        }
        break;
      case 2:
        stroke(c2);
        fill(c2);
        triangle(80*3,75*3,90*3,70*3,100*3,75*3);
        stroke(c1);
        fill(c1);
        triangle(100*3,70*3,110*3,75*3,120*3,70*3);
        rect(80*3,80*3,40*3,5*3);
        fill(255);
        if (editMode) {
          textSize(12);
          text("DONE EDITING",86*3,84*3);
        }
        else {
          textSize(12);
          text("EDIT SHAPE",89*3,84*3);
        }
        break;
      case 3:
        stroke(c2);
        fill(c2);
        triangle(140*3,75*3,150*3,70*3,160*3,75*3);
        stroke(c1);
        fill(c1);
        triangle(160*3,70*3,170*3,75*3,180*3,70*3);
        rect(140*3,80*3,40*3,5*3);
        fill(255);
        if (editMode) {
          textSize(12);
          text("DONE EDITING",146*3,84*3);
        }
        else {
          textSize(12);
          text("EDIT SHAPE",149*3,84*3);
        }
        break;
    }
    switch (gridNum) {
      case 1:
        stroke(0);
        //horizontal lines
        line(20*3,20*3,60*3,20*3);
        line(20*3,30*3,60*3,30*3);
        line(20*3,40*3,60*3,40*3);
        line(20*3,50*3,60*3,50*3);
        line(20*3,60*3,60*3,60*3);
        //vertical lines
        line(20*3,20*3,20*3,60*3);
        line(30*3,20*3,30*3,60*3);
        line(40*3,20*3,40*3,60*3);
        line(50*3,20*3,50*3,60*3);
        line(60*3,20*3,60*3,60*3);
        //draw points on each triangle
        s1crd = s1.getShapeCrd();
        //first triangle
        for (int i = 0; i < 6; i=i+2) {
          ellipse(s1crd[i],s1crd[i+1],5,5);
        }
        //second triangle
        for (int i = 6; i < 12; i=i+2) {
          ellipse(s1crd[i],s1crd[i+1],5,5);
        }
        break;
      case 2:
        stroke(0);
        //horizontal lines
        line(80*3,20*3,120*3,20*3);
        line(80*3,30*3,120*3,30*3);
        line(80*3,40*3,120*3,40*3);
        line(80*3,50*3,120*3,50*3);
        line(80*3,60*3,120*3,60*3);
        //vertical lines
        line(80*3,20*3,80*3,60*3);
        line(90*3,20*3,90*3,60*3);
        line(100*3,20*3,100*3,60*3);
        line(110*3,20*3,110*3,60*3);
        line(120*3,20*3,120*3,60*3);
        //draw points on each triangle
        s2crd = s2.getShapeCrd();
        //first triangle
        for (int i = 0; i < 6; i=i+2) {
          ellipse((60*3)+s2crd[i],s2crd[i+1],5,5);
        }
        //second triangle
        for (int i = 6; i < 12; i=i+2) {
          ellipse((60*3)+s2crd[i],s2crd[i+1],5,5);
        }
        break;
      case 3:
        stroke(0);
        //horizontal lines
        line(140*3,20*3,180*3,20*3);
        line(140*3,30*3,180*3,30*3);
        line(140*3,40*3,180*3,40*3);
        line(140*3,50*3,180*3,50*3);
        line(140*3,60*3,180*3,60*3);
        //vertical lines
        line(140*3,20*3,140*3,60*3);
        line(150*3,20*3,150*3,60*3);
        line(160*3,20*3,160*3,60*3);
        line(170*3,20*3,170*3,60*3);
        line(180*3,20*3,180*3,60*3);
        //draw points on each triangle
        s3crd = s3.getShapeCrd();
        //first triangle
        for (int i = 0; i < 6; i=i+2) {
          ellipse((120*3)+s3crd[i],s3crd[i+1],5,5);
        }
        //second triangle
        for (int i = 6; i < 12; i=i+2) {
          ellipse((120*3)+s3crd[i],s3crd[i+1],5,5);
        }
        break;
    }  
    //draw button
    stroke(c1);
    fill(c1);
    rect(80*3,90*3,40*3,10*3);    
    if (!checkedLogo) {
      //draw check availability text
      fill(255);
      textSize(16);
      text("AVAILABLE?", 85*3,97*3);
    }
    else {
      if (isAvail) {
        //draw download text
        fill(255);
        textSize(16);
        text("DOWNLOAD!", 84*3,97*3);
        canDownload = true;
      }
      else {
        //draw not available text
        fill(255);
        textSize(14);
        text("NOT AVAILABLE!", 82*3,97*3);
        checkedLogo = false;
      }
    }
  }
  }
  noLoop();
}

void mouseClicked() {
  //MODE BUTTONS
  //view alphabet + back buttons
  if (mouseX >= 5*3 && mouseX <= 45*3 && mouseY >= 5*3 && mouseY <= 10*3 && !viewAlphabet && !editColor && !string2shape) {
    viewAlphabet = true;
    editColor = false;
    string2shape = false;
    redraw();
  }
  else if (mouseX >= 5*3 && mouseX <= 45*3 && mouseY >= 5*3 && mouseY <= 10*3 && viewAlphabet) {
    viewAlphabet = false;
    editColor = false;
    string2shape = false;
    redraw();
  }
  //edit color + back buttons
  else if (mouseX >= 105*3 && mouseX <= 145*3 && mouseY >= 5*3 && mouseY <= 10*3 && !viewAlphabet && !editColor && !string2shape) {
    editColor = true;
    viewAlphabet = false;
    string2shape = false;
    redraw();
  }
  else if (mouseX >= 5*3 && mouseX <= 45*3 && mouseY >= 5*3 && mouseY <= 10*3 && editColor) {
    editColor = false;
    viewAlphabet = false;
    string2shape = false;
    redraw();
  }
  //shape-to-string + back buttons
  else if (mouseX >= 55*3 && mouseX <= 95*3 && mouseY >= 5*3 && mouseY <= 10*3 && !viewAlphabet && !editColor && !string2shape) {
    string2shape = true;
    viewAlphabet = false;
    editColor = false;
    redraw();
  }
  else if (mouseX >= 5*3 && mouseX <= 45*3 && mouseY >= 5*3 && mouseY <= 10*3 && string2shape) {
    string2shape = false;
    editColor = false;
    viewAlphabet = false;
    redraw();
  }
  
  //first shape
  if (mouseX >= 20*3 && mouseX <= 60*3 && mouseY >= 20*3 && mouseY <= 60*3 && !editMode) {
    editNum = 1;
    gridNum = 0;
    editMode = false;
    redraw();
  }
  //second shape
  else if (mouseX >= 80*3 && mouseX <= 120*3 && mouseY >= 20*3 && mouseY <= 60*3 && !editMode) {
    editNum = 2;
    gridNum = 0;
    editMode = false;
    redraw();
  }
  //third shape
  else if (mouseX >= 140*3 && mouseX <= 180*3 && mouseY >= 20*3 && mouseY <= 60*3 && !editMode) {
    editNum = 3;
    gridNum = 0;
    editMode = false;
    redraw();
  }
  
  //available + download button 
  else if (editNum != 0 && !viewAlphabet && !editColor && !string2shape && mouseX >= 80*3 && mouseX <= 120*3 && mouseY >= 90*3 && mouseY <= 100*3) {
    if (!canDownload) {
      userLogoHash = logoHash(s1Ind,s2Ind,s3Ind);
      checkLogoAvail(userLogoHash);
      checkedLogo = true;
      editMode = false;
      gridNum = 0;
      redraw();
    }
    //download
    else {
      exportLogo(userLogoHash);
      downloaded = true;
      editNum = 0;
      redraw();
    }
  }

  //first shape is selected, display edit arrows, if clicked
  else if (editNum == 1) {
    //if just clicked and dragged within Shape space - must be editing
    if (mouseX >= 20*3 && mouseX <= 60*3 && mouseY >= 20*3 && mouseY <= 60*3) {
      temps1 = new Shape(s1crd,1);
    }
    //first up arrow
    if (mouseX >= 20*3 && mouseX <= 40*3 && mouseY >= 70*3 && mouseY <= 75*3) {
      s1Ind++;
      if (s1Ind == lexSize) {
        s1Ind = 0;
      }
      changedLogo(1);
      redraw();
    }
    //first down arrow
    else if (mouseX >= 40*3 && mouseX <= 60*3 && mouseY >= 70*3 && mouseY <= 75*3) {
      s1Ind--;
      if (s1Ind < 0) {
        s1Ind = lexSize-1;
      }
      changedLogo(1);
      redraw();
    }
    //edit shape / done editing button
    else if (mouseX >= 20*3 && mouseX <= 60*3 && mouseY >= 80*3 && mouseY <= 85*3 && editMode) {
      gridNum = 0;
      editMode = false;
      redraw();
    }
    else if (mouseX >= 20*3 && mouseX <= 60*3 && mouseY >= 80*3 && mouseY <= 85*3 && !editMode) {
      gridNum = 1;
      editMode = true;
      checkedLogo = false;
      canDownload = false;
      redraw();
    }
  }
  
  else if (editNum == 2) {
    //if just clicked and dragged within Shape space - must be editing
    if (mouseX >= 80*3 && mouseX <= 120*3 && mouseY >= 20*3 && mouseY <= 60*3) {
      temps2 = new Shape(s2crd,2);
    }
    //second up arrow
    if (mouseX >= 80*3 && mouseX <= 100*3 && mouseY >= 70*3 && mouseY <= 75*3) {
      s2Ind++;
      if (s2Ind == lexSize) {
        s2Ind = 0;
      }
      changedLogo(2);
      redraw();
    }
    //second down arrow
    else if (mouseX >= 100*3 && mouseX <= 120*3 && mouseY >= 70*3 && mouseY <= 75*3) {
      s2Ind--;
      if (s2Ind < 0) {
        s2Ind = lexSize-1;
      }
      changedLogo(2);
      redraw();
    }
    //edit shape / done editing button
    else if (mouseX >= 80*3 && mouseX <= 120*3 && mouseY >= 80*3 && mouseY <= 85*3) {
      if (editMode) {
        gridNum = 0;
        editMode = false;
        redraw();
      }
      else {
        gridNum = 2;
        editMode = true;
        checkedLogo = false;
        canDownload = false;
        redraw();
      }
    }
  }
  
  else if (editNum == 3) {
    //if just clicked and dragged within Shape space - must be editing
    if (mouseX >= 140*3 && mouseX <= 180*3 && mouseY >= 20*3 && mouseY <= 60*3) {
      temps3 = new Shape(s3crd,3);
    }
    //third up arrow
    if (mouseX >= 140*3 && mouseX <= 160*3 && mouseY >= 70*3 && mouseY <= 75*3) {
      s3Ind++;
      if (s3Ind == lexSize) {
        s3Ind = 0;
      }
      changedLogo(3);
      redraw();
    }
    //third down arrow
    else if (mouseX >= 160*3 && mouseX <= 180*3 && mouseY >= 70*3 && mouseY <= 75*3) {
      s3Ind--;
      if (s3Ind < 0) {
        s3Ind = lexSize-1;
      }
      changedLogo(3);
      redraw();
    }
    //edit shape button
    else if (mouseX >= 140*3 && mouseX <= 180*3 && mouseY >= 80*3 && mouseY <= 85*3) {
      if (editMode) {
        gridNum = 0;
        editMode = false;
        redraw();
      }
      else {
        gridNum = 3;
        editMode = true;
        checkedLogo = false;
        canDownload = false;
        redraw();
      }
    }
  }
}

int logoHash(int first, int second, int third) {
  int id = int((first*pow(2,16)) + (second*pow(2,8)) + (third));
  println(first + " " + second + " " + third);
  return id;
}

boolean checkLogoAvail(int id) {
  int idFromDB;
  for (int i = 0; i < usrSize; i++) {
    idFromDB = parseInt(allUsr[i][1]);
    println("comparing " + idFromDB + " from the database with the user hash: " + id);
    if (idFromDB != id) {
      isAvail = true;
    }
    else {
      isAvail = false;
      break;
    }
  }
  if (!isAvail) {
    println("not is available");
  }
  else {
    println("is available");
  }
  return isAvail;
}

void exportLogo(int userLogoHash) {
  println(userLogoHash);
}

void changedLogo(int position) {
  switch (position) {
    case 1:
      temps1 = new Shape(s1Ind,1,c1,c2);
      s1crd = temps1.getShapeCrd();
    case 2:
      temps2 = new Shape(s2Ind,2,c1,c2);
      s2crd = temps2.getShapeCrd();
    case 3:
      temps3 = new Shape(s3Ind,3,c1,c2);
      s3crd = temps3.getShapeCrd();
  }
  temps1 = new Shape(s1crd,1);
  temps2 = new Shape(s2crd,2);
  temps3 = new Shape(s3crd,3);
  temps1.updateColor(c1,c2);
  temps2.updateColor(c1,c2);
  temps3.updateColor(c1,c2);
  editMode = false;
  checkedLogo = false;
  canDownload = false;
  downloaded = false;
  gridNum = 0;
}

void saveLogo(String userName, int userLogoHash) {
  loadStrings("/Users/Zeno/Desktop/cs370/Cycle2/SPI_App2/SPI_App/Data/loadLogo.php?x=" + userName + "&y=" + userLogoHash);
}

void mousePressed() {
  //actions in non-default modes
  //VIEW ALPHABET MODE
  //scroll down button
  //rect(55*3,5*3,40*3,5*3);
  if (mouseX >= 55*3 && mouseX <= 95*3 && mouseY >= 5*3 && mouseY <= 10*3 && viewAlphabet && !editColor) {
    //alphaShift = alphaShift+90;
    alphaShift++;
    redraw();
  }
  //scroll up button
  //rect(105*3,5*3,40*3,5*3);
  else if (mouseX >= 105*3 && mouseX <= 145*3 && mouseY >= 5*3 && mouseY <= 10*3 && viewAlphabet && !editColor) {
    //alphaShift = alphaShift-90;
    alphaShift--;
    if (alphaShift < 0) {
      alphaShift = 0;
    }
    redraw();
  }
  //STRING-TO-SHAPE MODE
  else if (string2shape && !viewAlphabet && !editColor) {
    
  }
  //EDIT COLOR MODE
  else if (editColor && !viewAlphabet && !string2shape) {
    //which color box was clicked 
    //ROW 1
    if (mouseX >= 20*3 && mouseX <= 40*3 && mouseY >= 20*3 && mouseY <= 40*3) {
      println("CLICKED ROW 1 RED");
      c1 = color(255,0,0);
    }
    else if (mouseX >= 40*3 && mouseX <= 60*3 && mouseY >= 20*3 && mouseY <= 40*3) {
      println("CLICKED ROW 1 ORANGE");
      c1 = color(255,145,0);
    }
    else if (mouseX >= 60*3 && mouseX <= 80*3 && mouseY >= 20*3 && mouseY <= 40*3) {
      println("CLICKED ROW 1 YELLOW");
      c1 = color(255,255,0);
    }
    else if (mouseX >= 80*3 && mouseX <= 100*3 && mouseY >= 20*3 && mouseY <= 40*3) {
      println("CLICKED ROW 1 LIME GREEN");
      c1 = color(100,255,0);
    }
    else if (mouseX >= 100*3 && mouseX <= 120*3 && mouseY >= 20*3 && mouseY <= 40*3) {
      println("CLICKED ROW 1 JADE GREEN");
      c1 = color(0,255,100);
    }
    else if (mouseX >= 120*3 && mouseX <= 140*3 && mouseY >= 20*3 && mouseY <= 40*3) {
      println("CLICKED ROW 1 LIGHT BLUE");
      c1 = color(0,255,255);
    }
    else if (mouseX >= 140*3 && mouseX <= 160*3 && mouseY >= 20*3 && mouseY <= 40*3) {
      println("CLICKED ROW 1 DARK BLUE");
      c1 = color(0,100,255);
    }
    else if (mouseX >= 160*3 && mouseX <= 180*3 && mouseY >= 20*3 && mouseY <= 40*3) {
      println("CLICKED ROW 1 PURPLE");
      c1 = color(255,0,255);
    }
    //ROW 2
    else if (mouseX >= 20*3 && mouseX <= 40*3 && mouseY >= 50*3 && mouseY <= 70*3) {
      println("CLICKED ROW 2 RED");
      c2 = color(255,0,0);
    }
    else if (mouseX >= 40*3 && mouseX <= 60*3 && mouseY >= 50*3 && mouseY <= 70*3) {
      println("CLICKED ROW 2 ORANGE");
      c2 = color(255,145,0);
    }
    else if (mouseX >= 60*3 && mouseX <= 80*3 && mouseY >= 50*3 && mouseY <= 70*3) {
      println("CLICKED ROW 2 YELLOW");
      c2 = color(255,255,0);
    }
    else if (mouseX >= 80*3 && mouseX <= 100*3 && mouseY >= 50*3 && mouseY <= 70*3) {
      println("CLICKED ROW 2 LIME GREEN");
      c2 = color(100,255,0);
    }
    else if (mouseX >= 100*3 && mouseX <= 120*3 && mouseY >= 50*3 && mouseY <= 70*3) {
      println("CLICKED ROW 2 JADE GREEN");
      c2 = color(0,255,100);
    }
    else if (mouseX >= 120*3 && mouseX <= 140*3 && mouseY >= 50*3 && mouseY <= 70*3) {
      println("CLICKED ROW 2 LIGHT BLUE");
      c2 = color(0,255,255);
    }
    else if (mouseX >= 140*3 && mouseX <= 160*3 && mouseY >= 50*3 && mouseY <= 70*3) {
      println("CLICKED ROW 2 DARK BLUE");
      c2 = color(0,100,255);
    }
    else if (mouseX >= 160*3 && mouseX <= 180*3 && mouseY >= 50*3 && mouseY <= 70*3) {
      println("CLICKED ROW 2 PURPLE");
      c2 = color(255,0,255);
    }
    redraw();
  }
  
  if (editMode) {
    switch (editNum) {
      case 1:
        if (mouseX >= s1crd[0]-5 && mouseX <= s1crd[0]+5 && mouseY >= s1crd[1]-5 && mouseY <= s1crd[1]+5) {
          fill(255,0,0);
          ellipse(s1crd[0],s1crd[1],5,5);
          currentlyEditingNum = 1;
        }
        else if (mouseX >= s1crd[2]-5 && mouseX <= s1crd[2]+5 && mouseY >= s1crd[3]-5 && mouseY <= s1crd[3]+5) {
          fill(255,0,0);
          ellipse(s1crd[2],s1crd[3],5,5);
          currentlyEditingNum = 2;
        }
        else if (mouseX >= s1crd[4]-5 && mouseX <= s1crd[4]+5 && mouseY >= s1crd[5]-5 && mouseY <= s1crd[5]+5) {
          fill(255,0,0);
          ellipse(s1crd[4],s1crd[5],5,5);
          currentlyEditingNum = 3;
        }
        else if (mouseX >= s1crd[6]-5 && mouseX <= s1crd[6]+5 && mouseY >= s1crd[7]-5 && mouseY <= s1crd[7]+5) {
          fill(255,0,0);
          ellipse(s1crd[6],s1crd[7],5,5);
          currentlyEditingNum = 4;
        }
        else if (mouseX >= s1crd[8]-5 && mouseX <= s1crd[8]+5 && mouseY >= s1crd[9]-5 && mouseY <= s1crd[9]+5) {
          fill(255,0,0);
          ellipse(s1crd[8],s1crd[9],5,5);
          currentlyEditingNum = 5;
        }
        else if (mouseX >= s1crd[10]-5 && mouseX <= s1crd[10]+5 && mouseY >= s1crd[11]-5 && mouseY <= s1crd[11]+5) {
          fill(255,0,0);
          ellipse(s1crd[10],s1crd[11],5,5);
          currentlyEditingNum = 6;
        }
        else {
          currentlyEditingNum = 0;
        }
        break;
      case 2:
        if (mouseX >= (60*3)+s2crd[0]-5 && mouseX <= (60*3)+s2crd[0]+5 && mouseY >= s2crd[1]-5 && mouseY <= s2crd[1]+5) {
          fill(255,0,0);
          ellipse((60*3)+s2crd[0],s2crd[1],5,5);
          currentlyEditingNum = 1;
        }
        else if (mouseX >= (60*3)+s2crd[2]-5 && mouseX <= (60*3)+s2crd[2]+5 && mouseY >= s2crd[3]-5 && mouseY <= s2crd[3]+5) {
          fill(255,0,0);
          ellipse((60*3)+s2crd[2],s2crd[3],5,5);
          currentlyEditingNum = 2;
        }
        else if (mouseX >= (60*3)+s2crd[4]-5 && mouseX <= (60*3)+s2crd[4]+5 && mouseY >= s2crd[5]-5 && mouseY <= s2crd[5]+5) {
          fill(255,0,0);
          ellipse((60*3)+s2crd[4],s2crd[5],5,5);
          currentlyEditingNum = 3;
        }
        else if (mouseX >= (60*3)+s2crd[6]-5 && mouseX <= (60*3)+s2crd[6]+5 && mouseY >= s2crd[7]-5 && mouseY <= s2crd[7]+5) {
          fill(255,0,0);
          ellipse((60*3)+s2crd[6],s2crd[7],5,5);
          currentlyEditingNum = 4;
        }
        else if (mouseX >= (60*3)+s2crd[8]-5 && mouseX <= (60*3)+s2crd[8]+5 && mouseY >= s2crd[9]-5 && mouseY <= s2crd[9]+5) {
          fill(255,0,0);
          ellipse((60*3)+s2crd[8],s2crd[9],5,5);
          currentlyEditingNum = 5;
        }
        else if (mouseX >= (60*3)+s2crd[10]-5 && mouseX <= (60*3)+s2crd[10]+5 && mouseY >= s2crd[11]-5 && mouseY <= s2crd[11]+5) {
          fill(255,0,0);
          ellipse((60*3)+s2crd[10],s2crd[11],5,5);
          currentlyEditingNum = 6;
        }
        else {
          currentlyEditingNum = 0;
        }
        break;
      case 3:
        if (mouseX >= (120*3)+s3crd[0]-5 && mouseX <= (120*3)+s3crd[0]+5 && mouseY >= s3crd[1]-5 && mouseY <= s3crd[1]+5) {
          fill(255,0,0);
          ellipse((120*3)+s3crd[0],s3crd[1],5,5);
          currentlyEditingNum = 1;
        }
        else if (mouseX >= (120*3)+s3crd[2]-5 && mouseX <= (120*3)+s3crd[2]+5 && mouseY >= s3crd[3]-5 && mouseY <= s3crd[3]+5) {
          fill(255,0,0);
          ellipse((120*3)+s3crd[2],s3crd[3],5,5);
          currentlyEditingNum = 2;
        }
        else if (mouseX >= (120*3)+s3crd[4]-5 && mouseX <= (120*3)+s3crd[4]+5 && mouseY >= s3crd[5]-5 && mouseY <= s3crd[5]+5) {
          fill(255,0,0);
          ellipse((120*3)+s3crd[4],s3crd[5],5,5);
          currentlyEditingNum = 3;
        }
        else if (mouseX >= (120*3)+s3crd[6]-5 && mouseX <= (120*3)+s3crd[6]+5 && mouseY >= s3crd[7]-5 && mouseY <= s3crd[7]+5) {
          fill(255,0,0);
          ellipse((120*3)+s3crd[6],s3crd[7],5,5);
          currentlyEditingNum = 4;
        }
        else if (mouseX >= (120*3)+s3crd[8]-5 && mouseX <= (120*3)+s3crd[8]+5 && mouseY >= s3crd[9]-5 && mouseY <= s3crd[9]+5) {
          fill(255,0,0);
          ellipse((120*3)+s3crd[8],s3crd[9],5,5);
          currentlyEditingNum = 5;
        }
        else if (mouseX >= (120*3)+s3crd[10]-5 && mouseX <= (120*3)+s3crd[10]+5 && mouseY >= s3crd[11]-5 && mouseY <= s3crd[11]+5) {
          fill(255,0,0);
          ellipse((120*3)+s3crd[10],s3crd[11],5,5);
          currentlyEditingNum = 6;
        }
        else {
          currentlyEditingNum = 0;
        }
        break;
    }
  }
}

void mouseDragged() {
  if (editMode) {
    updateShape();
  }
}

void updateShape() {
  switch (editNum) {
    case 1:
      switch (currentlyEditingNum) {
        case 1:
          s1crd[0] = mouseX;
          s1crd[1] = mouseY;
          redraw();
          break;
        case 2:
          s1crd[2] = mouseX;
          s1crd[3] = mouseY;
          redraw();
          break;
        case 3:
          s1crd[4] = mouseX;
          s1crd[5] = mouseY;
          redraw();
          break;
        case 4:
          s1crd[6] = mouseX;
          s1crd[7] = mouseY;
          redraw();
          break;
        case 5:
          s1crd[8] = mouseX;
          s1crd[9] = mouseY;
          redraw();
          break;
        case 6:
          s1crd[10] = mouseX;
          s1crd[11] = mouseY;
          redraw();
          break;
      }
      break;
    case 2:
      switch (currentlyEditingNum) {
        case 1:
          s2crd[0] = mouseX-(60*3);
          s2crd[1] = mouseY;
          redraw();
          break;
        case 2:
          s2crd[2] = mouseX-(60*3);
          s2crd[3] = mouseY;
          redraw();
          break;
        case 3:
          s2crd[4] = mouseX-(60*3);
          s2crd[5] = mouseY;
          redraw();
          break;
        case 4:
          s2crd[6] = mouseX-(60*3);
          s2crd[7] = mouseY;
          redraw();
          break;
        case 5:
          s2crd[8] = mouseX-(60*3);
          s2crd[9] = mouseY;
          redraw();
          break;
        case 6:
          s2crd[10] = mouseX-(60*3);
          s2crd[11] = mouseY;
          redraw();
          break;
      }
      break;
    case 3:
      switch (currentlyEditingNum) {
        case 1:
          s3crd[0] = mouseX-(120*3);
          s3crd[1] = mouseY;
          redraw();
          break;
        case 2:
          s3crd[2] = mouseX-(120*3);
          s3crd[3] = mouseY;
          redraw();
          break;
        case 3:
          s3crd[4] = mouseX-(120*3);
          s3crd[5] = mouseY;
          redraw();
          break;
        case 4:
          s3crd[6] = mouseX-(120*3);
          s3crd[7] = mouseY;
          redraw();
          break;
        case 5:
          s3crd[8] = mouseX-(120*3);
          s3crd[9] = mouseY;
          redraw();
          break;
        case 6:
          s3crd[10] = mouseX-(120*3);
          s3crd[11] = mouseY;
          redraw();
          break;
      }
      break;
  }
}

int[] snapToGrid(int x, int y) {
  //snap to grid / bounds
  int[] snapped = new int[2];
  int tempX, tempY;
  float minDist, tempDist;
  minDist = sqrt(pow(x-gridCrdVals[0][0])+pow(y-gridCrdVals[0][1]));
  tempX = gridCrdVals[0][0];
  tempY = gridCrdVals[0][1];
  for (int i = 1; i < 25; i++) {
    tempDist = sqrt(pow(x-gridCrdVals[0][0])+pow(y-gridCrdVals[0][1]));
    if (tempDist < minDist) {
      minDist = tempDist;
      tempX = gridCrdVals[i][0];
      tempY = gridCrdVals[i][1];
    }
  }
  snapped[0] = tempX;
  snapped[1] = tempY;
  return snapped;
}

void keyPressed() {
  char entered;
  //in string2shape mode
  if (string2shape) {
    //not finished typing (user has not hit enter)
    stsComplete = false;
    //if delete key is pressed without any string yet then ignore it
    if (keyCode == BACKSPACE) {
      if (typing.length() > 0) {
        typing = typing.substring(0, typing.length()-1);
      }
      //do nothing - no characters
      else if (typing.length() == 0) { 
      }
    }
    //if return key is hit then save the string and change asciisum to 0 before summing up again
    else {
      if (key == '\n') {
        ASCIIsum[0] = 0;
        ASCIIsum[1] = 0;
        ASCIIsum[2] = 0;
        for (int i = 0; i < typing.length; i++) {
          ASCIIsum[i%3] = typing.charCodeAt(i) +ASCIIsum[i%3];
        }
        //each bin must b less than size of alphabet
        ASCIIsum[0] = ASCIIsum[0] % lexSize;
        ASCIIsum[1] = ASCIIsum[1] % lexSize;
        ASCIIsum[2] = ASCIIsum[2] % lexSize;
        typing = "";
        stsComplete = true;
      } 
      else {
        // Each character typed by the user is added to the end of the String variable.
        entered = String.fromCharCode(key);
        typing = typing + entered;
      }
    }
  }
  redraw();
}

class Shape {
  int lexIndex;
  int position;
  int[] crd = new int[12];
  color c1, c2;
  
  Shape(int ind, int p, color color1, color color2) {
    lexIndex = ind;
    position = p;
    c1 = color1;
    c2 = color2;
    getShapeCrd(lexIndex);
  }
  
  Shape(int[] customCrd, int p) {
    for (int i = 0; i < 12; i++) {
      crd[i] = customCrd[i];
    }
    position = p;
    c1 = color(0,100,255);
    c2 = color(0,255,255);
  }
  
  //special shape for displaying alphabet
  Shape(){
  }
  
  int[] getShapeCrd(int index) {
    for (int i = 0; i < 12; i++) {
      crd[i] = 3*allCrd[index][i];
    }
    return crd;
  }
  
  int[] getShapeCrd() {
    return crd;
  }
  
  void updateColor(color color1, color color2) {
    c1 = color1;
    c2 = color2;
  }
  
  void selectDisplay() {
    switch (position) {
    case 1:
      stroke(c1);
      fill(c1);
      triangle(crd[0],crd[1],crd[2],crd[3],crd[4],crd[5]);
      stroke(c2);
      fill(c2);
      triangle(crd[6],crd[7],crd[8],crd[9],crd[10],crd[11]);
      break;
    case 2:
      stroke(c1);
      fill(c1);
      //shift right 60, scale by 3
      triangle((60*3)+crd[0],crd[1],(60*3)+crd[2],crd[3],(60*3)+crd[4],crd[5]);
      stroke(c2);
      fill(c2);
      triangle((60*3)+crd[6],crd[7],(60*3)+crd[8],crd[9],(60*3)+crd[10],crd[11]);
      break;
    case 3:
      stroke(c1);
      fill(c1);
      //shift right 60, scale by 3
      triangle((120*3)+crd[0],crd[1],(120*3)+crd[2],crd[3],(120*3)+crd[4],crd[5]);
      stroke(c2);
      fill(c2);
      triangle((120*3)+crd[6],crd[7],(120*3)+crd[8],crd[9],(120*3)+crd[10],crd[11]);
      break;
    }
  }
  
  //just added
  void displayAlphabet(int lexSize, int screenShift, color c1, color c2) {
    int index = 0+(screenShift*6);
    int xShift, yShift;
    int rows = (lexSize/6)-screenShift;
    if (lexSize % 6 != 0) {
      rows++;
    }
    for (int j = 0; j < rows; j++) {
      yShift = j*30;
      for (int i = 0; i < 6; i++) {
        xShift = i*30;
        crd = getShapeCrd(index);
        for (int k = 0; k < crd.length; k++) {
          //tiny shapes, SCALE BY 1/2
          crd[k] = (crd[k]/2)+15;
        }
        stroke(c1);
        fill(c1);
        triangle(crd[0]+(xShift*3),crd[1]+(yShift*3),crd[2]+(xShift*3),crd[3]+(yShift*3),crd[4]+(xShift*3),crd[5]+(yShift*3)); 
        stroke(c2);
        fill(c2);
        triangle(crd[6]+(xShift*3),crd[7]+(yShift*3),crd[8]+(xShift*3),crd[9]+(yShift*3),crd[10]+(xShift*3),crd[11]+(yShift*3));
        index++;
        if (index == lexSize) {
          break;
        }
      }
    }
  }
  //end newly added
  
}

