include apexconfig;

//ASY file for fig:conopt1 in Chapter 12 sec:multi_extreme_values

size(200,200,IgnoreAspect);
//size(200,200,Aspect);
//currentprojection=perspective(7,2,1);
currentprojection=orthographic(5.6,-7.8,20.3);

// setup and draw the axes
real[] myxchoice={-1,2};
real[] myychoice={-2,1,2};
real[] myzchoice={5};

pair xbounds=(-1.5,3);
pair ybounds=(-2.5,2.5);
pair zbounds=(-1,10);

xaxis3("",xbounds.x,xbounds.y,black,OutTicks(myxchoice),Arrow3(size=3mm));
yaxis3("",ybounds.x,ybounds.y,black,OutTicks(myychoice),Arrow3(size=3mm));
zaxis3("",zbounds.x,zbounds.y,black,OutTicks(myzchoice),Arrow3(size=3mm));

label("$x$",(xbounds.y+0.05*(xbounds.y-xbounds.x),0,0));
label("$y$",(0,ybounds.y+0.05*(ybounds.y-ybounds.x),0));
label("$z$",(0,0,zbounds.y+0.05*(zbounds.y-zbounds.x)));

//Draw surface z=x^2 - y^2 + 5
triple f(pair t) {
  return (t.x,t.y,t.x^2-t.y^2+5);
}
surface s=surface(f,(-1.5,-2.25),(2.25,1.75),16,16,
	vsplinetype=new splinetype[] {notaknot,notaknot,monotonic},
	usplinetype=new splinetype[] {notaknot,notaknot,monotonic});
draw(s,emissive(coloronefill),meshpen=colorone);

//Draw triangle in plane
draw((-1,-2,0)--(0,1,0)--(2,-2,0)--cycle,colortwo+dashed+linewidth(1));

//Draw triangle on surface
triple g(real t) {return (t,-2,t^2+1);}
path3 mypath=graph(g,-1,2,operator ..);
draw(mypath,colortwo); //side 1
triple g(real t) {return (t,3*t+1,t^2-(3*t+1)^2+5);}
path3 mypath=graph(g,-1,0,operator ..);
draw(mypath,colortwo); //side 2
triple g(real t) {return (t,-3*t/2+1,t^2-(-3*t/2+1)^2+5);}
path3 mypath=graph(g,0,2,operator ..);
draw(mypath,colortwo); //side 3
