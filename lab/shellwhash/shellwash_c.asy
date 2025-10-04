include apexconfig;

// ASY file for shell_wash_fig in 07_Shell_Method

currentprojection=orthographic((8,7.7,21.1),(0,1,0),(0,0,0),1,(-0.088,.0039));
size(200,200,IgnoreAspect);

// setup and draw the axes
real[] myxchoice={1};
real[] myychoice={1,2,3,4};
real[] myzchoice={};

pair xbounds=(-1.2,1.2);
pair ybounds=(-.1,4.2);
pair zbounds=(-1.2,1.2);

xaxis3("",xbounds.x,xbounds.y,black,OutTicks(myxchoice),Arrow3(size=3mm));
yaxis3("",ybounds.x,ybounds.y,black,OutTicks(myychoice),Arrow3(size=3mm));
zaxis3("",zbounds.x,zbounds.y,invisible,OutTicks(myzchoice),Arrow3(size=3mm));

label("$x$",(xbounds.y+0.05*(xbounds.y-xbounds.x),0,0));
label("$y$",(0,ybounds.y+0.05*(ybounds.y-ybounds.x),0));
//label("$z$",(0,0,zbounds.y+0.05*(zbounds.y-zbounds.x)));


triple g1(real t) {return (t,t*t+3,0);}
path3 parab=graph(g1,0,1,operator ..);
draw(parab,colorone+.4mm);

path3 linebdy=(0,1,0)--(1,3,0)--(1,4,0);
draw(linebdy,colorone+.4mm);

triple botwashfunc(pair t) {return (t.y*cos(t.x),2,t.y*sin(t.x));}
surface botwash=surface(botwashfunc,(0,0),(2*pi,.5),16);
draw(botwash,emissive(colortwofill));

triple topwashfunc(pair t) {return (t.y*cos(t.x),3.64,t.y*sin(t.x));}
surface topwash=surface(topwashfunc,(0,.8),(2*pi,1),16);
draw(topwash,emissive(colortwofill));

//draw(circle((0,1,0),1,Y),black+.4mm);
//draw(circle((0,2,0),1,Y),black+.4mm);
