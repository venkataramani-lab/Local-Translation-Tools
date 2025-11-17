close("*");
print("\\Clear");

if (isOpen("Results")) {
	selectWindow("Results");
	run("Close");
}

directory = File.openDialog("choose the .tif image");
print("directory= " + directory);
open(directory);
lastindex = lastIndexOf(directory, "\\");
shortdir = substring(directory, 0, lastindex);
print("shortdir= " + shortdir);
dirribos = shortdir + File.separator + "h5" + File.separator;
filelistribo = getFileList(dirribos);
roiManager("reset");
print("Start");

for (i = 0; i < filelistribo.length; i++) {
	if (endsWith(filelistribo[i], "_centroids.zip")) {
		close("*");
		exit("centroids already exist!");
	}
}

for (i = 0; i < filelistribo.length; i++) {
	//for (i = 0; i < 4; i++) {
	
if (endsWith(filelistribo[i], "_ribosomes.zip")) {
	print("i= " + i);
	print("filelistribo[i]= " + filelistribo[i]);
	indexslice = indexOf(filelistribo[i], "slice");
	zlevel = substring(filelistribo[i], indexslice+5, indexslice+7);
	print("zlevel= " + zlevel);
		if(nSlices!=1) {
			setSlice(zlevel);
		}
open(dirribos + filelistribo[i]);

totalRibos = roiManager("count");
array = newArray();
		for (rib = 0; rib < totalRibos; rib++) {
			showProgress(rib, totalRibos);
			roiManager("select", rib);
			integer = rib;
			addArray = newArray(1);
			addArray[0] = integer;
			array = Array.concat(array,addArray);
			run("Set Measurements...", " centroid redirect=None decimal=3");
			roiManager("Measure");
			x = getResult("X", nResults-1);
			y = getResult("Y", nResults-1);
			makePoint(x, y);
			roiManager("add");
		}
		
		roiManager("select", array);
		roiManager("delete");
		roiManager("deselect");
		name = filelistribo[i];
		newname = replace(name, ".zip", "");
		newname = newname + "_centroids.zip";
		pathribo = dirribos + newname;
		roiManager("save", pathribo);
		roiManager("reset");
}

}

if (isOpen("Results")) {
	selectWindow("Results");
	run("Close");
}
close("*");
waitForUser("Macro finished");




		