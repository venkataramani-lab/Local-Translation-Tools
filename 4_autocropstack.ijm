print("\\Clear");
slices = nSlices;
titel = getTitle();
print ("title= " + titel);
print("slices= " + slices);
getDimensions(width, height, channels, slices, frames);
valueshorizontallines = newArray(height);

for (fillzero = 0; fillzero < valueshorizontallines.length; fillzero++) {
	valueshorizontallines[fillzero] = 0;
}
valuesverticallines = newArray(width);
for (fillzero = 0; fillzero < valuesverticallines.length; fillzero++) {
	valuesverticallines[fillzero] = 0;
}

minhor = 0;
minver = 0;
for (i = 1; i <= slices; i++) {
	setSlice(i);
	print ("actual slice is: " + i);
	sumhor = 0;
	sumver = 0;
	
	for (ver = 0; ver < height; ver++) {
		for (hor = 0; hor < width; hor++) {
		sumhor = sumhor + getPixel(hor, ver);
		}
		if(sumhor > valueshorizontallines[ver]) {valueshorizontallines[ver] = sumhor;}
		sumhor = 0;
	}
	for (hor = 0; hor < width; hor++) {
		for (ver = 0; ver < height; ver++) {
		sumver = sumver + getPixel(hor, ver);
		}
		if (sumver > valuesverticallines[hor]) {valuesverticallines[hor] = sumver;}
		sumver = 0;
	}
	
}

xleft = 0;
yleft = 0;
xright = 0;
yright = 0;
for (findxleft = 0; findxleft < valuesverticallines.length; findxleft++) {
	xleft = findxleft+1;
	if (valuesverticallines[findxleft] > 0) {
		print("actual value is " + findxleft + "and defined the upper left corner");
		break;
	}
}

for (findyleft = 0; findyleft < valueshorizontallines.length; findyleft++) {
	yleft = findyleft+1;
	if (valueshorizontallines[findyleft] > 0) {
		print("actual value is " + findyleft + "and defined the upper left corner");
		break;
	}
}

for (findxright = valuesverticallines.length; findxright > 0; findxright--) {
	xright = findxright-1;
	if (valuesverticallines[findxright-1] > 0) {
		print("actual value is " + findxright + "and defined the upper right corner");
		break;
	}
}

for (findyright = valueshorizontallines.length; findyright > 0; findyright--) {
	yright = findyright-1;
	if (valueshorizontallines[findyright-1] > 0) {
		print("actual value is " + findyright + "and defined the upper right corner");
		break;
	}
}

print("xleft = " + xleft);
print("yleft = " + yleft);
print("xright = " + xright);
print("yright = " + yright);
widthrectangle = xright - xleft;
heightrectangle = yright - yleft;
makeRectangle(xleft, yleft, widthrectangle, heightrectangle);
titel = titel + "_autoresizecrop";
arg = "title="+titel+" duplicate";
run("Duplicate...", arg);
translationtable = "translationtable";
Table.create(translationtable);
selectWindow("translationtable");
table_size = Table.size;
Table.set("xtranslation",table_size, xleft);
Table.set("ytranslation",table_size, yleft);
Table.update;
waitForUser("save the table and the autocropped stack!!!");