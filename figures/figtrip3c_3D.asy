include apexconfig;

//ASY file for fig:trip3b in Chapter 13 sec:triple_int

size(200,200,IgnoreAspect);
//currentprojection=perspective(7,2,1);
currentprojection=orthographic(7.1,1.9,2);

// setup and draw the axes
real[] myxchoice={-1,1};
real[] myychoice={-1,-0.5};
real[] myzchoice={1};

pair xbounds=(-1.25,1.25);
pair ybounds=(-1.25,0.5);
pair zbounds=(-0.25,1.5);

xaxis3("",xbounds.x,xbounds.y,black,OutTicks(myxchoice),Arrow3(size=3mm));
yaxis3("",ybounds.x,ybounds.y,black,OutTicks(myychoice),Arrow3(size=3mm));
zaxis3("",zbounds.x,zbounds.y,black,OutTicks(myzchoice),Arrow3(size=3mm));

label("$x$",(xbounds.y+0.05*(xbounds.y-xbounds.x),0,0));
label("$y$",(0,ybounds.y+0.05*(ybounds.y-ybounds.x),0));
label("$z$",(0,0,zbounds.y+0.05*(zbounds.y-zbounds.x)));

triple g(real t) {return (cos(t),0,-sin(t));}
path3 mypath=graph(g,pi,2*pi,operator ..);
draw(mypath,colorone+linewidth(2));

//line
draw((-1,0,0)--(1,0,0),colorone+linewidth(2));

triple right(pair t) {return (t.y*cos(t.x),0,-t.y*sin(t.x));}
surface s=surface(right,(-pi,0),(0,1),16,2,Spline);
draw(s,emissive(coloronefill),meshpen=colorone);
