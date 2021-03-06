include apexconfig;

//ASY file for fig:washeridea in Chapter 7 section sec:disk

size(200,200,IgnoreAspect);
//currentprojection=perspective(7,2,1);
currentprojection=orthographic((10.17,5.3,46),(0,1,0),(0,0,0),1,(-0.0999,0.0072));

// setup and draw the axes
real[] myxchoice={};
real[] myychoice={};
real[] myzchoice={};
defaultpen(0.5mm);

pair xbounds=(-.2,3.5);
pair ybounds=(-3.5,3.5);
pair zbounds=(-3.5,3.5);

xaxis3("",xbounds.x,xbounds.y,black,OutTicks(myxchoice),Arrow3(size=3mm));
yaxis3("",ybounds.x,ybounds.y,black,OutTicks(myychoice),Arrow3(size=3mm));
zaxis3("",zbounds.x,zbounds.y,invisible,OutTicks(myzchoice),Arrow3(size=3mm));

label("$x$",(xbounds.y+0.05*(xbounds.y-xbounds.x),0,0));
label("$y$",(0,ybounds.y+0.05*(ybounds.y-ybounds.x),0));
//label("$z$",(0,0,zbounds.y+0.05*(zbounds.y-zbounds.x)));

pen p=colorone+.1mm;


triple g1(real t) {return (t,((t-2)^2+1),0);}
path3 p1=graph(g1,1,3,operator ..);
draw(p1,colortwo+.5mm);

triple g2(real t) {return (t,(-.5*(t-2)^2+3),0);}
path3 p2=graph(g2,3,1,operator ..);
draw(p2,colorone+.5mm);

triple f2(pair t) {return (1,cos(t.x)*t.y+.5,sin(t.x)*t.y);}
surface s2=surface(f2,(0,1.5),(2*pi,2),16,1,Spline);
draw(s2,emissive(coloronefill),meshpen=p);

triple f3(pair t) {return (3,cos(t.x)*t.y+.5,sin(t.x)*t.y);}
surface s3=surface(f3,(0,1.5),(2*pi,2),16,1,Spline);
draw(s3,emissive(coloronefill),meshpen=p);

triple g3(real t) {return (1,1.5*cos(t)+.5,1.5*sin(t));}
path3 p3=graph(g3,0,2*pi,operator ..);
draw(p3,colortwo+.3mm);

triple g3(real t) {return (3,1.5*cos(t)+.5,1.5*sin(t));}
path3 p3=graph(g3,0,2*pi,operator ..);
draw(p3,colortwo+.3mm);

triple g3(real t) {return (1,2*cos(t)+.5,2*sin(t));}
path3 p3=graph(g3,0,2*pi,operator ..);
draw(p3,colorone+.3mm);

triple g3(real t) {return (3,2*cos(t)+.5,2*sin(t));}
path3 p3=graph(g3,0,2*pi,operator ..);
draw(p3,colorone+.3mm);

draw((-.2,.5,0)--(3.5,.5,0),dashed+.2mm);

triple f(pair t) {return (t.x,(-.5*(t.x-2)^2+3-.5)*cos(t.y)+.5,(-.5*(t.x-2)^2+3-.5)*sin(t.y));}
surface s=surface(f,(1,0),(3,2*pi),5,16,
	usplinetype=new splinetype[] {notaknot,notaknot,monotonic},
	vsplinetype=new splinetype[] {notaknot,notaknot,monotonic});
draw(s,emissive(coloronefill),meshpen=p);

triple f1(pair t) {return (t.x,((t.x-2)^2+1-.5)*cos(t.y)+.5,((t.x-2)^2+1-.5)*sin(t.y));}
surface s1=surface(f1,(1,0),(3,2*pi),5,16,
	usplinetype=new splinetype[] {notaknot,notaknot,monotonic},
	vsplinetype=new splinetype[] {notaknot,notaknot,monotonic});
draw(s1,emissive(colortwofill),meshpen=p);
