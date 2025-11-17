print("\\Clear");
roiManager("deselect");
n = roiManager('count');
roiManager("Remove Slice Info");

function getZ(roiname) {
	curZ_string = substring(roiname, lastIndexOf(roiname, "z")+1, lastIndexOf(roiname, "z")+3);
	curZ = parseInt(curZ_string);
	print("curZ1: " + curZ);
	return curZ;	
}

for (i = 0; i < n; i++) {
    roiManager("select", i);
 	Roi.getPosition(channel, slice, frame);
 	roiManager("select", i);
 	name = Roi.getName;
 	curZ = getZ(name);
 	print("curZ= " + curZ);
 	print(name + "   " + slice);
 	setSlice(curZ);
 	wait(500);
 	Roi.setPosition(channel, curZ, frame);
 	roiManager("update");
 	Roi.getPosition(channel, slice, frame);
 	newZ = slice;
 	print("new slice set to ROI " + name + " is " + newZ);
}
beep;
print("finished");
showMessage("setting slice is finished");

getDimensions(width, height, channels, slices, frames);
print(slices);
selectWindow("Log");