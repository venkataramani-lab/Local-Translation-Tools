
xtranslation = getNumber("please insert x translation here", 0);
ytranslation = getNumber("please insert y translation here", 0);
print("xtranlsation = " + xtranslation);
print("ytranlsation = " + ytranslation);

n = roiManager('count');
for (i = 0; i < n; i++) {
    roiManager("select", i);
	setSlice(i+1);
	getSelectionBounds(x, y, width, height);
	print("x= " + x);
	print("y= " + y);
	print("width= " + width);
	print("height= " + height);
	newx = x - xtranslation;
	newy = y - ytranslation;
	Roi.move(newx, newy);
	roiManager("update");
}



