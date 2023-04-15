/*
Almanza Ibarra Marco Alejandro (220793465)
Hipermedia 2022-A (D02)
CUCEI
P5 Processing*/

float dirx=1, diry=1, pendiente=1.0, x=0, y=0, px=0, py=0, ayuda=5, grados=330, tran=30; //direccion para el movimiento (1 o -1)
boolean flag=true, flag2=true, flag3=true;//bandera
color boton=color(71, 215, 51), boton2=color(58, 218, 243), auxi=color(0,0,0);
float [] pox = new float[501], poy = new float[501];//Arrays que guardan las coordenadas
int aux=0, tam=20, crecimiento=5, puntos=0, diam=20, tiempo, caso=0, t=16, vidas=3;//Variables de control de crecimiento
int t_real=0, t_actualizado=0, t_retardo=5000, t_detenido=0, t_play=0, t_aux=0, c_tiempo=10, entorno=0, opc=0;//Variables de control de tiempo
PImage punto, fondo, viborita, cara, eleccion, cafe, muerte, mensaje;
import processing.sound.*;
SoundFile botones, colisiones, perd, entrada;

void setup(){//tamaño y color del lienzo
  size(728, 450);//tamaño
  frameRate(100);//"Velocidad" (cantidad de fotogramas por segundo)
  punto = loadImage("/punto1.png");
  fondo = loadImage("/fondo.png");
  //cafe = loadImage("/vida3.png");
  comprobar_vidas();
  eleccion = loadImage("/Meleccion.png");
  muerte = loadImage("/NoGod.jpg");
  mensaje = loadImage("/gameOver.png");
  muerte.resize(width, height);
  mensaje.resize(300,300);
  cafe.resize(90,40);
  eleccion.resize(500, 500);
  fondo.resize(width, height);
  punto.resize(diam,diam);
  image(fondo, 0, 0, width,height);
  botones = new SoundFile(this, "botones.mp3");
  strokeWeight(2);//Tamaño del perimetro
  entrada = new SoundFile(this, "parkour.mp3");
}

void draw(){//traza en el lienzo
  if(entorno==0)
    pantalla_inicio();
  if(entorno==1)
    pantalla_juego();
  if(entorno==2)
    pantalla_muerte();  
}

void mouseClicked(){//Da clic
  if(entorno==0)
    clics_inicio();
  if(entorno==1)
    clics_juego();
  //if(entorno==2)
    //clics_muerte()
}

void keyPressed(){
  if (key == CODED){
    if (keyCode == UP){
      if(diry==1){
        diry*=-1;
      } 
      if(dirx==-1)
       grados=130-ayuda;
      else
       grados=240-ayuda;
    }
    if (keyCode == DOWN) {
      if(diry==-1){
        diry*=-1;
      }
      if(dirx==-1)
       grados=30-ayuda;
      else
       grados=330-ayuda;
    }
    if (keyCode == LEFT) {
      if(dirx==1)
        dirx*=-1;
      if(diry==-1)
        grados=130-ayuda;
      else
        grados=30-ayuda;
    }
    if (keyCode == RIGHT){
      if(dirx==-1)
        dirx*=-1;
      if(diry==-1)
        grados=240-ayuda;
      else
        grados=330-ayuda;
    }
  }
}

//MIS FUNCIONES
void crearPunto(){
  redibuja();
  px=random(width-diam);py=random(height-40-diam);
  if(flag3){
    for(int o=0; o<tam; o++){
      if((px>=pox[o]-diam/2 && px<=pox[o]+diam/2)&&(py>=poy[o]-diam/2 && py<=poy[o]+diam/2)){
        crearPunto();
        return;
     }
    }
  }
  image(punto, px, py, diam,diam);
}

void crearBoton(int a, int b, color c){
  fill(c);//cambia el color del area del boton
  stroke(0,0,0);//Cambia el perimetro del boton
  rect (a,b,70,30);//crea el boton
  fill(0,0,0);//Cambia el color a negro
  noStroke();
  if(flag){//Si presiona "Detener", detiene el loop
    triangle(40,height-30, 40,height-10, 65, height-20);//Crea el triangulo
    noLoop();
  }else{
    rect(34, height-30, 13, 20);//Crea los rectangulos del STOP
    rect(54, height-30, 13, 20);
  }
  if(flag2){//Esta en +
    rect(width-51, height-30, 5, 20);}//Crea el rectangulo vertical
  rect(width-58.5, height -22, 20, 5);//crea la barra horizontal
}

void redibuja(){
  image(fondo, 0, 0, width,height-40);
  image(punto, px, py, diam,diam);
  for(int i=1;i<tam-1;i++){
    if(!(pox[i]==0 && pox[i]==0))
      image(viborita, pox[i], poy[i], 20,20);
  }
  if(aux==0)
    image(cara, pox[tam-1], poy[tam-1], 20,20);
  else{
    pushMatrix();
    imageMode(CENTER);
    translate(pox[aux-1]+10, poy[aux-1]+10);
    rotate(radians(grados+(pendiente*ayuda)));
    image(cara, 0, 0, 20,20);
    popMatrix();
    imageMode(CORNER);
  }
  if(aux>=tam-1) aux=0;
}

boolean perdio(){
 int alex,i;
 if(aux==0)
     alex=tam-1;
   else
     alex=aux-1;
  if(alex+10>=tam){
    i=tam-alex;
  }else
    i=alex+10;
  do{
    if((x>=pox[i] && x<=pox[i])&&(y>=poy[i] && y<=poy[i])){
     return true;
     }
    i++;
    if(i>=tam-1)
      i=0;
  }while(i != alex);
 return false;
}

void reinicio(){
  //tam=20;
  //flag=true;
  image(fondo, 0,0,width, height-40);
  dirx*=-1;diry*=-1;
  boton =color (71, 215, 51);
  crearBoton(15,height-35,boton);
  c_tiempo=10;
  noLoop();
}

void comprobar_vidas(){
  if(vidas==3)
    cafe = loadImage("/vida3.png");
  if(vidas==2)
    cafe = loadImage("/vida2.png");
  if(vidas==1)
    cafe = loadImage("/vida1.png");
  if(vidas==0)
    cafe = loadImage("/vida3.png");
  cafe.resize(90,40);
}
//-------------------------------------------------
//-------------------------------------------------
//              FUNCION DEL JUEGO
//-------------------------------------------------
//-------------------------------------------------

void clics_inicio(){
  if((mouseX>=469 && mouseX<=699)&&(mouseY>=289 && mouseY<=411)){
    entorno=1;
    fondo = loadImage("/f1.jpg");
    fondo.resize(width, height-40);
    if(opc==0){
       viborita = loadImage("/m.png");
       cara = loadImage("/Michael.png");
       colisiones = new SoundFile(this, "no.mp3");
       perd = new SoundFile(this, "nogod.mp3");
    }else if(opc==1){
       viborita = loadImage("/d.png");
       cara = loadImage("/Dwight.png");
       colisiones = new SoundFile(this, "dwight_scream.mp3");
       perd = new SoundFile(this, "dwight_lose.mp3");
    }else if(opc==2){
       viborita = loadImage("/j.png");
       cara = loadImage("/Jim.png");
       colisiones = new SoundFile(this, "jim_notnow.mp3");
       perd = new SoundFile(this, "jim_messing.mp3");
    }
    viborita.resize(20,20);
    cara.resize(20,20);
    entrada.play();
  }
  if((mouseX>=26 && mouseX<=93)&&(mouseY>=188 && mouseY<=278)){
    botones.play();
    if(opc==0){
      opc=2;
      eleccion = loadImage("/Jeleccion.png");
      entrada = new SoundFile(this, "jim_oktu.mp3");
    }else if(opc==1){
      opc=0;
      eleccion = loadImage("/Meleccion.png");
      entrada = new SoundFile(this, "parkour.mp3");
    }else if(opc==2){
      opc=1;
      eleccion = loadImage("/Deleccion.png");
      entrada = new SoundFile(this, "dwight_spin.mp3");
    }
    eleccion.resize(180, 180);
  }
  if((mouseX>=351 && mouseX<=416)&&(mouseY>=187 && mouseY<=280)){
    botones.play();
    if(opc==0){
      opc=1;
      eleccion = loadImage("/Deleccion.png");
      entrada = new SoundFile(this, "dwight_spin.mp3");
    }else if(opc==1){
      opc=2;
      eleccion = loadImage("/Jeleccion.png");
      entrada = new SoundFile(this, "jim_oktu.mp3");
    }else if(opc==2){
      opc=0;
      eleccion = loadImage("/Meleccion.png");
      entrada = new SoundFile(this, "parkour.mp3");
    }
    eleccion.resize(180, 180);
  }
}

void clics_juego(){
if((mouseX>=15 && mouseX<=85)&&(mouseY>=height-35 && mouseY<=height-5)){//Presiona el boton izquierdo
    if(flag3){
      t_real=millis();
      println("---Tamaño---\n    ", tam);//imprimimos su tamaño
      flag3=!flag;
      t_detenido=t_real-t_actualizado;
      redibuja();
    }
    if(!flag){//Cambia a CONTINUAR
      t=16;//tamaño de letra
      boton=color(71, 215, 51);//cambia el color a verde
    }else{//Cambia a DETENER
      t_real=millis();
      boton=color(252, 85, 98);//cambia a rojo
      t=20;//tamaño de letra
      t_detenido=t_real-t_actualizado;
      loop();//continua el loop
    }
    flag=!flag;//cambia la bandera
    botones.play();//play del sonido
  } 
  
  if((mouseX>=width-85 && mouseX<=width-15)&&(mouseY>=height-35 && mouseY<=height-5)){//Presiona boton derecho
    if(flag2==true){//Esta en más
      if(pendiente< 1){
        pendiente+= 0.1;//Aumenta la pendiente
      }else{//llega al limite
        flag2=!flag2;//cambia la bandera
        boton2=color(238, 124, 18);//cambia color
      }
    }else{//esta en menos
      if(pendiente> 0.1){//comprueba limites
        pendiente-= 0.1;//disminuye la pendiente
      }else{//sobrepasa
        flag2=!flag2;//cambia la bandera
        boton2=color(58, 218, 243);//cambia el color
      }
    }
    botones.play();
  }
}

void pantalla_juego(){
  t_real = millis();
  t_aux++;
  if (flag3) 
    crearPunto();
  if(t_real>=t_actualizado+t_retardo+t_detenido && tam<500){//Si pasan 5 segundos y el tamaño no es el maximo
    t_actualizado+=t_retardo;//Obtenemos el tiempo en play
    tam+=crecimiento;//la serpiente crece
    println("---Tamaño---\n    ", tam);//imprimimos su tamaño
  }
  
  if(t_aux>=100){
    t_aux=0;
    c_tiempo--;
  }
  
  if(c_tiempo<=0){
    c_tiempo+=10;
    colisiones.play();
    vidas--;
    if(vidas<=0)
      entorno=2;
    else
      reinicio();
    comprobar_vidas();
  }

  fill(243, 229, 58);//area del rectangulo inferior
  stroke(255,255,255);//perimetro
  rect(0, height-40, width, 40);//Cuadrado de interfaz
  
  crearBoton(width/2-35, height-35, color(255));
  fill(0,0,0);
  textSize(10);text("Puntos: ", width/2-16,height-25);
  textSize(20);text(puntos, width/2-(str(puntos).length()*5),height-9);
  
  crearBoton(width-230, height-35, color(255));
  fill(0,0,0);
  textSize(10);text("Tiempo: ", width-210,height-25);
  textSize(20);text(c_tiempo, width-202,height-9);
  image(cafe, 300, width-35, 60, 30);
  
  crearBoton(15,height-35,boton);
  crearBoton(width-85,height-35,boton2);  
  pox[aux]=x; poy[aux]=y;//guardamos coordenadas
  
  image(cafe, 150, height-37, 90,40);
  
  image(viborita, x+=dirx,y+=diry*pendiente, 20,20);
  if(aux<500)aux++;

  if(t_real>=tiempo+1000){
    caso++;
    tiempo=t_real;
    if (caso==4) caso=0;
  }
  
  if((pox[aux-1]>=px-diam && pox[aux-1]<=px+diam) && (poy[aux-1]>=py-diam && poy[aux-1]<=py+diam)){//Choca con puntos
    redibuja();
    crearPunto();
    entrada.play();
    puntos++;
    c_tiempo+=2;
    tam+=crecimiento;//crece
    println("---Tamaño---\n    ", tam);//imprimimos su tamaño
  }
  if(perdio()){
    colisiones.play();
    flag=true;
    //noLoop();
    vidas--;
    if(vidas==0)
      entorno=2;
    else
      reinicio();
    comprobar_vidas();
  }
  
  if (pox.length>=tam-1){
    redibuja();
  }
  
  if(x>=width-20){//Si la posicion en x pega
    dirx*=-1;//Cambia la dirección en x
    if(diry==-1)
      grados=130-ayuda;
    else
      grados=60-ayuda;
  }if(x<=0){
    dirx*=-1;
    if(diry==-1)
      grados=240-ayuda;
    else
      grados=330-ayuda;
  }if(y>=height-60 ){//Si la posicion en y
    diry*=-1;//Cambia la dirección en x
    if(dirx==-1)
      grados=130-ayuda;
    else
    grados=240-ayuda;
  }if(y<=0){
    diry*=-1;
    if(dirx==-1)
      grados=30-ayuda;
    else
    grados=330-ayuda;
  }
}

//-------------------------
void pantalla_inicio(){
  image(fondo, 0, 0, width,height);
  fill(247, 199, 63);
  stroke(0);
  circle(222,218,250);
  imageMode(CENTER);
  image(eleccion, 225, 210,180, 180);
  imageMode(CORNER);
}

void pantalla_muerte(){
  image(muerte,0,0, width, height);
  imageMode(CENTER);
  tint(255,tran);
  if(tran<=255);
    tran+=35;
  image(mensaje, width/2, height/2, 300,300);
  delay(500);
  imageMode(CORNER);
  noTint();
  stroke(0);
}
