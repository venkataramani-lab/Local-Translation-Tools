print("\\Clear");
waitForUser("open the corresponding RoiSet with cell boundaries");
count = roiManager("count");
roiArray = newArray();
n = roiManager('count');

function getZ(roiname) {
	curZ_string = substring(roiname, lastIndexOf(roiname, "z")+1, lastIndexOf(roiname, "z")+3);
	curZ = parseInt(curZ_string);
	return curZ;	
}

print("#####");
roiManager("Sort");

for (i = 0; i < n; i++) {
    roiManager('select', i);
    roiname = Roi.getName;
    roiArray = Array.concat(roiArray,newArray(roiname));   
}

for (i = 0; i < roiArray.length; i++) {
	print(roiArray[i]);
}

sortedArray = roiArray;

for (i = 0; i < sortedArray.length; i++) {
	print(sortedArray[i]);
}
print("#####");

noNextRoi = false;
for (i = 0; i < sortedArray.length; i++) {
	
	selectedRoiArray = newArray();
	iplus1 = i + 1;
	curRoi = sortedArray[i];
	print("#############################");
	print("#############################");
	print("#############################");
	print("curRoi "+ curRoi);
	curZ = getZ(curRoi);
	print("curZ: " + curZ);
	selectedRoiArray = Array.concat(selectedRoiArray, i);

	if ((i+1) <sortedArray.length) {
		otherRoiRanCount = 0;
		for (otherRoi = iplus1; otherRoi < (sortedArray.length); otherRoi++) {
	print("-----------otherroiloop------");
	otherRoiRanCount = otherRoiRanCount + 1;
	print("otherRoi loop ran: " + otherRoiRanCount);
	nextRoi = sortedArray[otherRoi];
	print("nextRoi: " + nextRoi);
	nextZ = getZ(nextRoi);
	print("nextZ: " + nextZ);
	print("curZ: " + curZ);
	if (nextZ == curZ) {
		print("nextZ equals curz");
		selectedRoiArray = Array.concat(selectedRoiArray, otherRoi);
	} else {
		print("nextroi is not part o the thing");
		}
		print("otherRoi: " + otherRoi);
		}

for (sel = 0; sel < selectedRoiArray.length; sel++) {	
	print("selectedroiarray: " + selectedRoiArray[sel]);
	print("length: " + selectedRoiArray.length);
}
setSlice(curZ);

roiManager("select", selectedRoiArray);
roiManager("Combine");
run("Make Inverse");
run("Clear", "slice");

selRoiLength = selectedRoiArray.length;
i = i + selRoiLength -1 ;
	
	}else {
		print("there is no next roi");
		roiManager("select", selectedRoiArray);
		setSlice(curZ);
		for (sel = 0; sel < selectedRoiArray.length; sel++) {	
	print("selectedroiarray: " + selectedRoiArray[sel]);
	print("length: " + selectedRoiArray.length);
roiManager("select", selectedRoiArray);
roiManager("Combine");
run("Make Inverse");
run("Clear", "slice");
	
}
		noNextRoi = true;
	}
	wait(200);
}

title = getTitle();
titlenew = replace(title, ".tif", "");
titlenew = titlenew + "_cellcropped";
rename(titlenew);

print("Done.");
beep();
waitForUser("save the stack");