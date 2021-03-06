include apexconfig;

//ASY file for fig:sphericalwedge in Section 13.7

size(200,200,IgnoreAspect);
//currentprojection=perspective(7,2,1);
currentprojection=orthographic(14.4,2.6,10);

// setup and draw the axes
real[] myxchoice={};
real[] myychoice={};
real[] myzchoice={};

pair xbounds=(-.1,.6);
pair ybounds=(-.1,.6);
pair zbounds=(-.1,1);

xaxis3("",xbounds.x,xbounds.y,black,OutTicks(myxchoice),Arrow3(size=3mm));
yaxis3("",ybounds.x,ybounds.y,black,OutTicks(myychoice),Arrow3(size=3mm));
zaxis3("",zbounds.x,zbounds.y,black,OutTicks(myzchoice),Arrow3(size=3mm));

label("$x$",(xbounds.y+0.05*(xbounds.y-xbounds.x),0,0));
label("$y$",(0,ybounds.y+0.05*(ybounds.y-ybounds.x),0));
label("$z$",(0,0,zbounds.y+0.05*(zbounds.y-zbounds.x)));

real t1=pi/3-.2;
real t2=pi/3+.2;
real p1=pi/6-.2;
real p2=pi/6+.2;
real r1=.75;
real r2=.9;

//Draw the inner sphere
triple f(pair t) {
	return (r1*cos(t.x)*sin(t.y),r1*sin(t.x)*sin(t.y),r1*cos(t.y));//
}
surface s=surface(f,(t1,p1),(t2,p2),4,4,
usplinetype=new splinetype[] {notaknot,notaknot,monotonic},
vsplinetype=new splinetype[] {notaknot,notaknot,monotonic});
pen p=colorone+.1mm;
draw(s,emissive(coloronefill),meshpen=p);

// draw the outer sphere
triple f(pair t) {
	return (r2*cos(t.x)*sin(t.y),r2*sin(t.x)*sin(t.y),r2*cos(t.y));//
}
surface s=surface(f,(t1,p1),(t2,p2),4,4,
usplinetype=new splinetype[] {notaknot,notaknot,monotonic},
vsplinetype=new splinetype[] {notaknot,notaknot,monotonic});
draw(s,emissive(coloronefill),meshpen=p);

triple f(pair t) {
	return (t.y*cos(t.x)*sin(p1),t.y*sin(t.x)*sin(p1),t.y*cos(p1));//
}
surface s=surface(f,(t1,r1),(t2,r2),4,4,
usplinetype=new splinetype[] {notaknot,notaknot,monotonic},
vsplinetype=new splinetype[] {notaknot,notaknot,monotonic});
draw(s,emissive(coloronefill),meshpen=p);

triple f(pair t) {
	return (t.y*cos(t.x)*sin(p2),t.y*sin(t.x)*sin(p2),t.y*cos(p2));//
}
surface s=surface(f,(t1,r1),(t2,r2),4,4,
usplinetype=new splinetype[] {notaknot,notaknot,monotonic},
vsplinetype=new splinetype[] {notaknot,notaknot,monotonic});
draw(s,emissive(coloronefill),meshpen=p);

triple f(pair t) {
	return (t.y*cos(t1)*sin(t.x),t.y*sin(t1)*sin(t.x),t.y*cos(t.x));//
}
surface s=surface(f,(p1,r1),(p2,r2),4,4,
usplinetype=new splinetype[] {notaknot,notaknot,monotonic},
vsplinetype=new splinetype[] {notaknot,notaknot,monotonic});
draw(s,emissive(coloronefill),meshpen=p);

triple f(pair t) {
	return (t.y*cos(t2)*sin(t.x),t.y*sin(t2)*sin(t.x),t.y*cos(t.x));//
}
surface s=surface(f,(p1,r1),(p2,r2),4,4,
usplinetype=new splinetype[] {notaknot,notaknot,monotonic},
vsplinetype=new splinetype[] {notaknot,notaknot,monotonic});
draw(s,emissive(coloronefill),meshpen=p);

// lines for phi
draw( (r1*cos(t1)*sin(p1),r1*sin(t1)*sin(p1),r1*cos(p1)) -- (0,0,0)
-- (r1*cos(t1)*sin(p2),r1*sin(t1)*sin(p2),r1*cos(p2)), black+.25mm+dashed);

draw( arc( (0,0,0),
(r1*cos(t1)*sin(p1)/2.5,r1*sin(t1)*sin(p1)/2.5,r1*cos(p1)/2.5),
(r1*cos(t1)*sin(p2)/2.5,r1*sin(t1)*sin(p2)/2.5,r1*cos(p2)/2.5) ),
black+.25mm,Arrow3(size=1.5mm));

label("\scriptsize$\Delta\varphi$",.95*(r1*cos(t1)*sin((p1+p2)/2)/2,
r1*sin(t1)*sin((p1+p2)/2)/2,r1*cos((p1+p2)/2)/2));

//  lines for theta
draw( (0,0,0) -- (r1*cos(t1)*sin(p2),r1*sin(t1)*sin(p2),0) -- (r1*cos(t1)*sin(p2),r1*sin(t1)*sin(p2),r1*cos(p2)),
black+.25mm+dashed);

draw( (0,0,0) -- (r1*cos(t2)*sin(p2),r1*sin(t2)*sin(p2),0) -- (r1*cos(t2)*sin(p2),r1*sin(t2)*sin(p2),r1*cos(p2)),
black+.25mm+dashed);

draw( arc( (0,0,0),
.5*(r1*cos(t1)*sin(p2),r1*sin(t1)*sin(p2),0),
.5*(r1*cos(t2)*sin(p2),r1*sin(t2)*sin(p2),0)),
black+.25mm,Arrow3(size=1.5mm));

label("\scriptsize$\Delta\theta$",1.2*.5*(r1*cos((t1+t2)/2)*sin(p2),r1*sin((t1+t2)/2)*sin(p2),0));

// lines for rho
draw( arc( (0,0,0),
(r1*cos(t1)*sin(0),r1*sin(t1)*sin(0),r1*cos(0)),
(r1*cos(t1)*sin(p1),r1*sin(t1)*sin(p1),r1*cos(p1))),
black+.25mm+dashed);

draw( arc( (0,0,0),
(r2*cos(t1)*sin(0),r2*sin(t1)*sin(0),r2*cos(0)),
(r2*cos(t1)*sin(p1),r2*sin(t1)*sin(p1),r2*cos(p1))),
black+.25mm+dashed);

label("\scriptsize$\Delta\rho$",
( (r1+r2)/2*cos(t1)*sin(.65*(p1)),
(r1+r2)/2*sin(t1)*sin(.65*(p1)),
(r1+r2)/2*cos(.65*(p1)) ) );

real poff = -0.05;

draw( (r1*cos(t1)*sin(p1+poff),r1*sin(t1)*sin(p1+poff),r1*cos(p1+poff))
-- (r2*cos(t1)*sin(p1+poff),r2*sin(t1)*sin(p1+poff),r2*cos(p1+poff)),
black+.25mm,Arrows3(size=1.5mm));

label("\scriptsize$\rho$",(0,-.04,.5*r1));

draw((0,-.02,.01) -- (0,-.02,.99*r1),black+.25mm,Arrows3(size=1.5mm));

//  lines for theta length
draw( (r1*cos(t1)*sin(p2),r1*sin(t1)*sin(p2),r1*cos(p2)-.05)
-- (r1*cos(t2)*sin(p2),r1*sin(t2)*sin(p2),r1*cos(p2)-.05),
black+.25mm,Arrows3(size=1.5mm));

label("\scriptsize$\rho\sin(\varphi)\Delta\theta$",
1.5*( (r1*cos(t1)*sin(p2),r1*sin(t1)*sin(p2),r1*cos(p2)-.05)
+ (r1*cos(t2)*sin(p2),r1*sin(t2)*sin(p2),r1*cos(p2)-.05)
+(0,0,-.05))/2+(0,0,-.25),S);

draw( 1.5*((r1*cos(t1)*sin(p2),r1*sin(t1)*sin(p2),r1*cos(p2)-.05) + (r1*cos(t2)*sin(p2),r1*sin(t2)*sin(p2),r1*cos(p2)-.05)+(0,0,-.05))/2
+ (0,0,-.25)
-- 1.05((r1*cos(t1)*sin(p2),r1*sin(t1)*sin(p2),r1*cos(p2)-.05) + (r1*cos(t2)*sin(p2),r1*sin(t2)*sin(p2),r1*cos(p2)-.05))/2
+(0,0,-.01),
black+.25mm+dashed,Arrow3(size=1.5mm));

// lines for phi length

label("\scriptsize$\rho\Delta\varphi$",
.85*(r1*cos(t1)*sin((p1+p2)/2),r1*sin(t1)*sin((p1+p2)/2),r1*cos((p1+p2)/2)));

draw( arc( (0,0,0),
.95*(r1*cos(t1)*sin(p1),r1*sin(t1)*sin(p1),r1*cos(p1)),
.95*(r1*cos(t1)*sin(p2),r1*sin(t1)*sin(p2),r1*cos(p2))),
black+.25mm,Arrows3(size=1.5mm));
