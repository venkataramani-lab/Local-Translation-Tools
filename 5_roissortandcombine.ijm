waitForUser("please load the RoiSet of the boundaries you want to sort");
zmax = 0;
n = roiManager("count");
waitForUser("open the previous imagestack of the ROI");

for (zit = 0; zit < n; zit++) {
	roiManager("select", zit);

	name = Roi.getName;
	print("actual name is: " + name);
	zindex = indexOf(name, "z");
	zlevel = substring(name, zindex+1, zindex+3);
	if (zlevel> zmax) {
		zmax = zlevel;
	}
}

roiManager("sort");
actualrois = roiManager("count");
xtranslation = getNumber("please insert x translation here", 0);
ytranslation = getNumber("please insert y translation here", 0);
print("xtranlsation = " + xtranslation);
print("ytranlsation = " + ytranslation);

function checkForValue(array, value) {
	for (i = 0; i < array.length; i++) {
		curArItem = array[i];
		if (curArItem == value) {
			return true;
		}
	}
	return false;
}

directory  = getDirectory("locate to directory, where you want the rois to be saved");
print(directory);
function getZ(roiname) {
curZ_string = substring(roiname, lastIndexOf(roiname, "z")+1, lastIndexOf(roiname, "z")+3);
curZ = parseInt(curZ_string);
return curZ;	
}

while (roiManager("count") > 0) {
	null = 0;
	array = newArray("0");
	roiManager("select", 0);
	baseName = Roi.getName;
	baseZ = getZ(baseName);
	print(baseZ);
	index = indexOf(baseName, "_i");
	shortname = substring(baseName, 0, index);

CurRoiCount = roiManager("count");
	for (otherRoi = 0; otherRoi <CurRoiCount ; otherRoi++) {
			roiManager("select", otherRoi);
	otherName = Roi.getName;
	otherZ = getZ(otherName);
	if (baseZ == otherZ) {
		roiindex = roiManager("index");
		print("same!!!!" + roiindex);
		array = Array.concat(array,newArray(""+roiindex+""));	}
	}

for (ar = 0; ar < array.length; ar++) {
print(array[ar]);

}
numberArray = newArray(array.length);
for (k = 0; k < numberArray.length; k++) {
	numberArray[k] = parseInt(array[k]);
}

roiManager("select", numberArray);

roiManager("combine");
roiManager("add");
newName = Roi.getName;
newName = shortname;
roiManager("select", roiManager("count")-1);

getSelectionBounds(x, y, width, height);
print("x= " + x);
print("y= " + y);
print("width= " + width);
print("height= " + height);
newx = x - xtranslation;
newy = y - ytranslation;
Roi.move(newx, newy);
roiManager("Update");
wait(1000);
roiManager("rename", newName);
roiManager("save selected", directory +newName + ".roi" );
roiManager("delete");
roiManager("select", numberArray);
roiManager("delete");
}





