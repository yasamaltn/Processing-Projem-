import processing.sound.*;

SoundFile sarki; //şarkı dosyası açmak için

PImage arkaplan; //background görseli
PImage yunus;
PImage susise; //atık su şişesi görseli
PImage poset; //atık poşet görseli
PImage kutusise; //atık kutu şişe görseli
PImage girisekran; //başlangıç ekranı background
PImage buton; // başla butonu
PImage girisyunus; //başlangıçtaki el sallayan yunus görseli
PImage tekraroyna;
PImage sonsayfa;
PImage kazanmaekrani; 

PFont font; //yazı fontu eklemek için

float x = 5; //şişe
float y = 5;//şişe

float x2 = 5;//poşet
float y2 = 10;//poşet

float x3 = 10;//kutu şişe
float y3 = 15;//kutu şişe

int dx = 0;
int dy = 6;//nesnelerin düşme hızı

int sayfa = 1; // 1: giriş, 2: oyun, 3: oyun bitiş, 4: kazanma sayfası
int can = 3;   // oyuncunun çarpışma hakkı (can) //ai

int startTime; // oyunun başlangıç zamanı
int sureLimiti = 60000; // ai, 1 dakika (60.000 milisaniye)



void setup() {
  size(1000, 800);
  sarki=new SoundFile(this, "sarki.mp3");
  sarki.play(); 
  sarki.loop(); //şarkı bitince tkrar başlatır
  arkaplan = loadImage("arkaplann.png");
  yunus = loadImage("yunuss.png"); 
  susise = loadImage("şişe.png");
  poset = loadImage("poşet.png");
  kutusise = loadImage("kutu.png");
  girisekran = loadImage("bluerescue.png");
  buton = loadImage("basla.png");
  girisyunus = loadImage("mrbyunus.png");
  tekraroyna = loadImage("tekraroyna.png");
  sonsayfa= loadImage("bitisekran.png");
  kazanmaekrani = loadImage("kazandin.png");
  
  
 font= createFont("ChonkyBunny.ttf", 40); // eklediğim yazı fontu
textFont(font);

  resetNesneler();
}

void draw() { //  ekranlar arası geçişi yönetir
  if (sayfa == 1) { // ai
    drawGiris();
  } else if (sayfa == 2) { // ai
    drawOyun();
  } else if (sayfa == 3) { // ai
    drawBitis();
 } else if (sayfa == 4) {
    drawKazandin(); // kazandın sayfası
  }
}

void drawGiris() { // ai
  background(girisekran);
  image(buton, 250, 180);
  image(girisyunus, 210, 370);
}

void drawOyun() { // oyun sayfası
  background(arkaplan);
  
  image(yunus, mouseX-yunus.width/2,  mouseY - yunus.height / 2); // ai, fareyi yunus görselinin orta noktasına bağlar
  image(susise, x, y);
  image(poset, x2, y2);
  image(kutusise, x3, y3);
  
  y += dy;
  y2 += dy;
  y3 += dy;
  
  if (y > height) {
    y = 10;
    x = random(0, 750);
  }
  if (y2 > height) {
    y2 = 10;
    x2 = random(0, 600);
  }
  if (y3 > height) {
    y3 = 10;
    x3 = random(0, 800);
  }

  // çarpışma kontrolü
  float d1 = dist(mouseX, mouseY, x, y); // ai
  float d2 = dist(mouseX, mouseY, x2, y2); // ai
  float d3 = dist(mouseX, mouseY, x3, y3); // ai

  if (d1 < 80|| d2 < 80 || d3 < 80) { // ai
    can--;              // canı azaltır
    resetNesneler();    // nesnelerin konumlarını sıfırlar

    if (can <= 0) { // ai
      sayfa = 3;        // oyun bitiş, kaybetme ekranına geçer
    }
  }

  // canı ekranda gösterir
  fill(0);
  textSize(30);
  text("Kalan Can: " + can, 30, 40); // "kalan can" yazısı ve yanına oyuncunun mevcut can değişkeni sayısını ekler
  
   int gecenSure = millis() - startTime; // ai
  int kalanSure = max(0, sureLimiti - gecenSure); // ai
  
  textSize(30);
  text("Kazanmana Kalan Süre: " + kalanSure / 1000 + " saniye", 30, 80); // ai
  
 // Kazanma kontrolü
  if (gecenSure >= sureLimiti) { // ai
    sayfa = 4; // kazandı sayfasına geç
  }
}

void drawBitis() {
  background(sonsayfa);
  image(tekraroyna, 250,40);
  fill(0);
  textSize(50);
  text("Kaybettin :(", 400, 130);
  text("Tekrar denemek ister misin?", 250,200);
}

void drawKazandin() {
  background(kazanmaekrani);
  image(tekraroyna,250,310);
  fill(0);
  textSize(60);
  fill(1,113,47);
  text("Tebrikler!", 410, 130);
  textSize(30);
  fill(0);
  text("Yunusun tüm atıklardan kaçmasına yardım ettin.", 250, 170);
  text("Ama unutma, yunusun mutlu ve güvende olması için denizleri temiz tutmalıyız :)", 95, 210);
  
}



void mousePressed() {
  if (sayfa ==1) {
    if (mouseX > 250 && mouseX < 700 && mouseY > 180 && mouseY < 500) { // ai
      sayfa = 2;
      can = 3; // oyuna başlarken canı sıfırla
      resetNesneler();
       startTime = millis(); // ai, süreyi başlat
    }
   } else if (sayfa == 3) {
    if (mouseX > 250 && mouseX < 550 && mouseY > 40 && mouseY < 300) {
     sayfa = 2;
      can = 3;
      resetNesneler();
     startTime = millis(); // ai, süreyi tekrar başlat
    }
      } else if (sayfa == 4) { // kazandın sayfası
    if (mouseX > 250 && mouseX < 550 && mouseY > 260 && mouseY < 700) {
      sayfa = 2;
      can = 3;
      resetNesneler();
      startTime = millis();
  }
}
}

void resetNesneler() {
  x = random(0, width);
  y = 10;
  x2 = random(0, width);
  y2 = 10;
  x3 = random(0, width);
  y3 = 10;
}
