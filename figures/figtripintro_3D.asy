include apexconfig;

//ASY file for fig:tripintro in Chapter 13 sec:triple_int

size(200,200,IgnoreAspect);
//currentprojection=perspective(7,2,1);
currentprojection=orthographic(4,4,2);

// setup and draw the axes
real[] myxchoice={-2,2};
real[] myychoice={-2,2};
real[] myzchoice={-2,2};

pair xbounds=(-2.25,2.25);
pair ybounds=(-2.25,2.25);
pair zbounds=(-2.25,2.25);

xaxis3("",xbounds.x,xbounds.y,black,OutTicks(myxchoice),Arrow3(size=3mm));
yaxis3("",ybounds.x,ybounds.y,black,OutTicks(myychoice),Arrow3(size=3mm));
zaxis3("",zbounds.x,zbounds.y,black,OutTicks(myzchoice),Arrow3(size=3mm));

label("$x$",(xbounds.y+0.05*(xbounds.y-xbounds.x),0,0));
label("$y$",(0,ybounds.y+0.05*(ybounds.y-ybounds.x),0));
label("$z$",(0,0,zbounds.y+0.05*(zbounds.y-zbounds.x)));

//Ellipsoid
triple f(pair t) {
  return (cos(t.x)*2*cos(t.y),sin(t.x)*cos(t.y),sin(t.y));
}
surface s=surface(f,(-pi,-pi/2),(1*pi,pi/2),16,16,Spline);
draw(s,emissive(coloronefill),meshpen=colorone);
