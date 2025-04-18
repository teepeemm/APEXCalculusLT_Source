include apexconfig;

//ASY file for fig:mass3 in Chapter 12 sec:center_of_mass

size(200,200,Aspect);
//currentprojection=perspective(7,2,1);
currentprojection=orthographic(4,4,2);

// setup and draw the axes
real[] myxchoice={-2,2};
real[] myychoice={-2,2};
real[] myzchoice={5};

pair xbounds=(-2.75,2.75);
pair ybounds=(-2.75,2.75);
pair zbounds=(0,6);

xaxis3("",xbounds.x,xbounds.y,black,OutTicks(myxchoice),Arrow3(size=3mm));
yaxis3("",ybounds.x,ybounds.y,black,OutTicks(myychoice),Arrow3(size=3mm));
zaxis3("",zbounds.x,zbounds.y,black,OutTicks(myzchoice),Arrow3(size=3mm));

label("$x$",(xbounds.y+0.05*(xbounds.y-xbounds.x),0,0));
label("$y$",(0,ybounds.y+0.05*(ybounds.y-ybounds.x),0));
label("$z$",(0,0,zbounds.y+0.05*(zbounds.y-zbounds.x)));

triple f(pair t) {
  return (cos(t.x)*t.y,sin(t.x)*t.y,2*t.y+1);
}
surface s=surface(f,(0,0),(2*pi,2),16,16,Spline);
draw(s,emissive(coloronefill),meshpen=colorone);

draw(circle(O,2,Z),colorone+linewidth(2));
