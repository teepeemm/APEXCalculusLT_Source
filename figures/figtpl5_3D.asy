include apexconfig;

//ASY file for fig:tpl5 in Chapter 12 sec:multi_tangent

size(200,200,IgnoreAspect);
//size(200,200,Aspect);
//currentprojection=perspective(7,2,1);
currentprojection=orthographic(15,10,9);

// setup and draw the axes
real[] myxchoice={2,4};
real[] myychoice={2,4};
real[] myzchoice={2,4};

pair xbounds=(-1,5.5);
pair ybounds=(-2,4.5);
pair zbounds=(-1,5.5);

xaxis3("",xbounds.x,xbounds.y,black,OutTicks(myxchoice),Arrow3(size=3mm));
yaxis3("",ybounds.x,ybounds.y,black,OutTicks(myychoice),Arrow3(size=3mm));
zaxis3("",zbounds.x,zbounds.y,black,OutTicks(myzchoice),Arrow3(size=3mm));

label("$x$",(xbounds.y+0.05*(xbounds.y-xbounds.x),0,0));
label("$y$",(0,ybounds.y+0.05*(ybounds.y-ybounds.x),0));
label("$z$",(0,0,zbounds.y+0.05*(zbounds.y-zbounds.x)));

triple f(pair t) {
  return (t.x,t.y,3+t.x-t.y^2);
}
surface s=surface(f,(-.5,-2.1),(4,2),8,16,
	vsplinetype=new splinetype[] {notaknot,notaknot,monotonic},
	usplinetype=Spline);
draw(s,emissive(coloronefill),meshpen=colorone);

//plot point on surface
dotfactor=3;
dot((2,1,4));
dot((3.63,-2.27,2.37));
dot((.37,4.27,5.63));

draw ((.37,4.27,5.63)--(3.63,-2.27,2.37),colortwo+2bp);
