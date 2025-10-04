include apexconfig;

// ASY file for shell_wash_fig in 07_Shell_Method

currentprojection=orthographic((8,7.7,21.1),(0,1,0),(0,0,0),1,(-0.088,.0039));
size(200,200,IgnoreAspect);

// setup and draw the axes
real[] myxchoice={1};
real[] myychoice={1,2,3,4};
real[] myzchoice={};

pair xbounds=(-1.2,1.2);
pair ybounds=(-.1,4.2);
pair zbounds=(-1.2,1.2);

xaxis3("",xbounds.x,xbounds.y,black,OutTicks(myxchoice),Arrow3(size=3mm));
yaxis3("",ybounds.x,ybounds.y,black,OutTicks(myychoice),Arrow3(size=3mm));
zaxis3("",zbounds.x,zbounds.y,invisible,OutTicks(myzchoice),Arrow3(size=3mm));

label("$x$",(xbounds.y+0.05*(xbounds.y-xbounds.x),0,0));
label("$y$",(0,ybounds.y+0.05*(ybounds.y-ybounds.x),0));
//label("$z$",(0,0,zbounds.y+0.05*(zbounds.y-zbounds.x)));


triple topf(pair t) {return (cos(t.y)*t.x,t.x*t.x+3,sin(t.y)*t.x);}
surface tops=surface(topf,(0,0),(1,2*pi),4,16,Spline);
draw(tops,emissive(coloronefill),meshpen=colorone);

triple outf(pair t) {return (cos(t.y),t.x,sin(t.y));}
surface outs=surface(outf,(3,0),(4,2*pi),4,16,Spline);
draw(outs,emissive(coloronefill),meshpen=colorone);

triple botf(pair t) {return (cos(t.y)*t.x,2*t.x+1,sin(t.y)*t.x);}
surface bots=surface(botf,(0,0),(1,2*pi),4,16,Spline);
draw(bots,emissive(coloronefill),meshpen=colorone);

triple topline(real t) {return (t,t*t+3,0);}
path3 toppath=graph(topline,0,1,operator ..);
draw(toppath,black+.4mm);

path3 botoutpath=(0,1,0)--(1,3,0)--(1,4,0);
draw(botoutpath,black+.4mm);
