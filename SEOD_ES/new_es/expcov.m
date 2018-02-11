function y = expcov(vara,dx,dy,etax,etay)
h = abs(dx/etax) + abs(dy/etay);
y = vara * exp(-h);