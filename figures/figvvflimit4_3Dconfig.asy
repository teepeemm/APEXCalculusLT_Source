// setup and draw the axes
real[] myxchoice={-1,1};
real[] myzchoice={0,2,4,6};
real[] myychoice={-1,1};

pair xbounds=(-1.25,1.25);
pair ybounds=(-1.25,1.25);
pair zbounds=(-0.5,7);

xaxis3("",xbounds.x,xbounds.y,black,OutTicks(myxchoice),Arrow3(size=3mm));
yaxis3("",ybounds.x,ybounds.y,black,OutTicks(myychoice),Arrow3(size=3mm));
zaxis3("",zbounds.x,zbounds.y,black,OutTicks(myzchoice),Arrow3(size=3mm));

label("$x$",(xbounds.y+0.05*(xbounds.y-xbounds.x),0,0));
label("$y$",(0,ybounds.y+0.05*(ybounds.y-ybounds.x),0));
label("$z$",(0,0,zbounds.y+0.05*(zbounds.y-zbounds.x)));

triple g(real t) {return (cos(t),sin(t),t);}
path3 mypath=graph(g,0,2pi,operator ..);
draw(mypath,colorone,Arrow3(size=4mm));

draw(O--(-1,0,1),colortwo,Arrow3(size=4mm));
draw(g(pi/2)--g(pi/2)+(-1,0,1),colortwo,Arrow3(size=4mm));
