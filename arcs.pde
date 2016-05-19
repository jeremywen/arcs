//For sound, open the Pure Data patch: osc_pathreceive.pd

import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;
int MIN_W = 500, MIN_H = 500;
int RINGS = 10;
int S_WEIGHT = 20;
PGraphics pg;
boolean FULL = false;
float midX = 0.0, midY = 0.0;

void setup(){
  size(1000,1000);
	oscP5 = new OscP5(this,12000);
	myRemoteLocation = new NetAddress("127.0.0.1",12300);
	pg = createGraphics(width, height);
	midX = width / 2.0;
	midY = height / 2.0;
	sendVal(0,0);
}

void draw(){
	pg.beginDraw();
	pg.stroke(255);
	pg.strokeWeight(S_WEIGHT);
	pg.strokeCap(SQUARE);
	pg.noFill();
	pg.smooth();
	pg.background(0);  

	float start = (sin(frameCount/1500.0))*PI;
	float start2 = -(cos(frameCount/1000.0))*PI;

	for(int i=0;i<RINGS;i++){
		pg.stroke(RINGS+i*25, 100, 150);

		float arcStart = sin(frameCount/100.0+i*20) * (i%2==0?start:start2);
		float arcStop = arcStart + PI*0.75;

		float lineEndX = midX + cos(arcStart)*(MIN_W/2 + i * 50);
		float lineEndY = midY + sin(arcStart)*(MIN_H/2 + i * 50);

		sendVal(i+1, (height - (int)lineEndY)/2);

		// pg.line(midX, midY, lineEndX, lineEndY);
		pg.arc(midX, midY, MIN_W + i * 50, MIN_H + i * 50, arcStart, arcStop );
	}
	pg.endDraw();
	image(pg,0,0);
}

void keyPressed(){ if (key == ESC) { stop(); } }
public void stop(){ sendVal(0,0); }

void sendVal(int key, int val) {
	OscMessage myMessage = new OscMessage("/test/"+key);  
	myMessage.add(val);
	oscP5.send(myMessage, myRemoteLocation); 
}