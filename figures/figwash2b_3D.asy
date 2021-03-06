include apexconfig;

//ASY file for fig:wash2 in Chapter 7 section sec:disk

size(200,200,IgnoreAspect);
//currentprojection=perspective(7,2,1);
currentprojection=orthographic((13.6,14.55,43),(0,1,0),(0,0,0),1,(0.029,-0.015));

// setup and draw the axes
real[] myxchoice={-1,-2,1,2};
real[] myychoice={1,2,3};
real[] myzchoice={};

pair xbounds=(-2.2,2.2);
pair ybounds=(-.2,3.2);
pair zbounds=(-2.2,2.2);

xaxis3("",xbounds.x,xbounds.y,black,OutTicks(myxchoice),Arrow3(size=3mm));
yaxis3("",ybounds.x,ybounds.y,black,OutTicks(myychoice),Arrow3(size=3mm));
zaxis3("",zbounds.x,zbounds.y,invisible,OutTicks(myzchoice),Arrow3(size=3mm));

label("$x$",(xbounds.y+0.05*(xbounds.y-xbounds.x),0,0));
label("$y$",(0,ybounds.y+0.05*(ybounds.y-ybounds.x),0));
//label("$z$",(0,0,zbounds.y+0.05*(zbounds.y-zbounds.x)));

path3 p1=(1,1,0)--(2,1,0)--(2,3,0)--cycle;
draw(surface(p1), emissive(coloronefill));
draw(p1,colorone+.4mm);

draw(circle((0,2,0),1.5,Y),colortwo+.4mm);
draw(circle((0,2,0),2,Y),colortwo+.4mm);

triple f2(pair t) {return (cos(t.x)*t.y,2,sin(t.x)*t.y);}
surface s2=surface(f2,(0,1.5),(2*pi,2),16,1,Spline);
draw(s2,emissive(colortwofill));

draw((1.5,2,0)--(2,2,0),.5*colorone+.5*colortwo+dashed+.3mm);
