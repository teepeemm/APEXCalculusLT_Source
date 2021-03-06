include apexconfig;

//ASY file for fig:parsurf1 in Section 14.6

size(200,200,IgnoreAspect);
currentprojection=orthographic(11.9,9.6,17.8);

// setup and draw the axes
real[] myxchoice={-3,3};
real[] myychoice={-3,3};
real[] myzchoice={5,10};

pair xbounds=(-3.5,3.5);
pair ybounds=(-3.5,3.5);
pair zbounds=(-1,12);

xaxis3("",xbounds.x,xbounds.y,black,OutTicks(myxchoice),Arrow3(size=3mm));
yaxis3("",ybounds.x,ybounds.y,black,OutTicks(myychoice),Arrow3(size=3mm));
zaxis3("",zbounds.x,zbounds.y,black,OutTicks(myzchoice),Arrow3(size=3mm));

label("$x$",(xbounds.y+0.05*(xbounds.y-xbounds.x),0,0));
label("$y$",(0,ybounds.y+0.05*(ybounds.y-ybounds.x),0));
label("$z$",(0,0,zbounds.y+0.05*(zbounds.y-zbounds.x)));

//Draw the top half of the surface z^2 = x^2+2y^2
triple f(pair t) {
	return (t.x,t.y,t.x^2+2*t.y^2);//
}
surface s=surface(f,(-3,-1),(3,1),16,16,
usplinetype=new splinetype[] {notaknot,notaknot,monotonic},
vsplinetype=new splinetype[] {notaknot,notaknot,monotonic});
pen p=colorone;
draw(s,emissive(coloronefill),meshpen=p);

pen curvepen=.6mm+colorone;
draw(surface((3,1,0)--(3,-1,0)--(-3,-1,0)--(-3,1,0)--cycle),
curvepen+opacity(.5));
draw((3,1,0)--(3,-1,0)--(-3,-1,0)--(-3,1,0)--cycle,curvepen);
