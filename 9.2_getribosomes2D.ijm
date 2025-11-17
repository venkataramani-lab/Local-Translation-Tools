function selectItemsWithSubstring(array, substr) {
	return_array = newArray();
	for (e = 0; e < array.length; e++) {
		cur_item = array[e];
		if (indexOf(cur_item, substr) >-1) {
			print(cur_item);
		return_array = Array.concat(return_array,newArray(cur_item));
		}
	}
	return return_array;
}

function getLastPath() {
	dir = "xxx";
	if (File.exists(dir)==0) {
		dir = "xxx";
	}
	if (File.exists(dir)==0) {
		dir = "xxx";
	}

 	if (File.exists(dir) ==0){
		print("Cant pull last folder bc file cant be found.");
		return -1;
	}

	Table.open(dir);
	nrows = Table.size;
	last_val = Table.getString("lastfile", nrows-1);
	print("LastDirectory: " + last_val);
	return last_val;
}
function writeToLastPath(path) {
	dir = "xxx";
	if (File.exists(dir)==0) {
		dir = "xxx";
	}
	if (File.exists(dir)==0) {
		dir = "xxx";
	}
 	if (File.exists(dir) ==0){
		print("Cant pull last folder bc file cant be found.");
		return -1;
	}

	Table.open(dir);
	nrows = Table.size;
	Table.set("lastfile", nrows, path);
	Table.save(dir);
	print("Saved last file: " + path);	
}

close("*");
print("\\Clear");
roiManager("reset");
Table.create("CountRibosomes");

roi = getString("ROI?", getLastPath());
writeToLastPath(roi);
base_path = "xxx";
if (File.exists(base_path)==0) {
	base_path =  "xxx";
}

cell_path = base_path + File.separator + roi + File.separator;
cellpathwithoutlast = substring(cell_path, 0, cell_path.length-1);
print("cellpathwithoutlast: " + cellpathwithoutlast);
lastindex = lastIndexOf(cellpathwithoutlast, "\\");
roi = substring(cell_path, lastindex+1, cell_path.length-1);

px_size_filepath = cell_path  + File.separator + "px_size.txt";
print("cell path: " + cell_path);
print("roi: " + roi);
print("px_size_filepath path: " + px_size_filepath);
selectWindow("Log");

if (File.exists(px_size_filepath)) {
	print("Pixelsize file exists. Opening...");
	num = File.openAsRawString(px_size_filepath);
	print("Read Pixelsize: " + num);
	pixelsize = parseFloat(num);
}else {
	print("Pixelsize not found.");
	pixelsize = getNumber("Pixelsize not found. The pixel size is", 5);
	
}
print("USING PIXELSIZE: " + pixelsize); 

files_in_cellpath = getFileList(cell_path);
filtered = selectItemsWithSubstring(files_in_cellpath, "nucleuscropped");
if (filtered.length == 0) {
	Array.show(files_in_cellpath);
	showMessage("this doesnt have any fitting nucleuscropped file."); 
			Dialog.create("select previous image");
			Dialog.addChoice("Previous Image", files_in_cellpath);
			Dialog.show();
			previous_image = Dialog.getChoice();
}

if (filtered.length == 1) {
	previous_image = filtered[0];
	print("previous image..." + previous_image);
}else {
		filtered2 = selectItemsWithSubstring(filtered, "8bit");
		if (filtered2.length == 0) {
			Dialog.create("select previous image");
			Dialog.addChoice("Previous Image", filtered);
			Dialog.show();
			previous_image = Dialog.getChoice();

		} else if (filtered2.length == 1) {
		previous_image = filtered2[0];
		print("previous image..." + previous_image);


}else {
			Dialog.create("select previous image");
			Dialog.addChoice("Previous Image", filtered);
			Dialog.show();
			previous_image = Dialog.getChoice();
}

}
print("USING PREVIOUS IMAGE:" + previous_image);
 
open(cell_path + File.separator + previous_image);
rename("C2-Composite");

raw = getTitle();

h5_path = cell_path + File.separator + "h5";
if (File.exists(h5_path) != 1) {
	exit("h5-path doesn't exist --> do the training first!");
}

print("h5_path: " + h5_path);
h5_filelist = getFileList(h5_path);
Array.show(h5_filelist);

tif_list = selectItemsWithSubstring(h5_filelist, ".tif");
if (tif_list.length == 1) {
	prob_image = tif_list[0];
}else {
	Dialog.create("select probability map image");
			Dialog.addChoice("Probability Map", tif_list);
			Dialog.show();
			prob_image = Dialog.getChoice();
}
print("USING PROBABILITYMAP: "+ prob_image);

open(h5_path +File.separator + prob_image);

rename("C1-Composite");
probabilities = getTitle();
sufficient = false;
Dialog.createNonBlocking("ribosomes sufficient");
Dialog.addCheckbox("training good was good", "true");
runde = 1;

if (pixelsize == 2) {
		sizelow="10";
		sizehigh="20";
		circularitylow="0.5";
		circularityhigh="1.00";
	}
	else if (pixelsize == 3.8) {
		sizelow="8";
		sizehigh="11";
		circularitylow="0.5";
		circularityhigh="1.00";
	}
	else if (pixelsize == 5) {
		sizelow="4";
		sizehigh="8";
		circularitylow="0.5";
		circularityhigh="1.00";
	}
	else {
		exit("the pixel size has to be either 2 or 5 --> change the macro");
	}
	
while (sufficient == false) {
	if (runde>1) {
		open(cell_path + File.separator + previous_image);
		rename("C2-Composite");
		open(h5_path +File.separator + prob_image);
		rename("C1-Composite");
	}
	roiManager("reset");

	selectWindow("C1-Composite");	
	run("8-bit");
	run("Invert");
	run("Merge Channels...", "c1="+probabilities+" c4="+raw+" create");
	run("Channels Tool...");
	run("Brightness/Contrast...");
	waitForUser("adapt min&max in the first channel, so that the ribos are red!");
	run("Split Channels");
	selectWindow("C1-Composite");	
	run("8-bit");
	getMinAndMax(min, max);
	print("min= " + min);
	print("max= " + max);
	minimum = 255-max;
	maximum = 255-min;
	print("minimum= " + minimum);
	print("maximum= " + maximum);
	run("Invert");
	wait(2000);
	if (maximum==255) {
		maximum = 254;
	}
	run("Threshold...");
	setThreshold(minimum, maximum);
	waitForUser("press apply threshold");
	run("Watershed");


	Dialog.createNonBlocking("Parameters");
	Dialog.addNumber("size lowest", sizelow);
	Dialog.addNumber("size highest", sizehigh);
	Dialog.addNumber("circularity lowest", circularitylow);
	Dialog.addNumber("circularity highest", circularityhigh);
	Dialog.show();

	sizelow = Dialog.getNumber();
	sizehigh = Dialog.getNumber();
	circularitylow = Dialog.getNumber();
	circularityhigh = Dialog.getNumber();
	
	arg = "size="+sizelow+"-"+sizehigh+" circularity="+circularitylow+"-"+circularityhigh+" display clear add";
	run("Analyze Particles...", arg);
			
	selectWindow("C1-Composite");
	run("Invert");	
	selectWindow("C2-Composite");
	roiManager("show all without labels");
	selectWindow("ROI Manager");

	n = roiManager("count");
	selectWindow("CountRibosomes");
	Table.set("z-level", 0, "0");
	Table.set("nribosomes", 0, n);
	Table.update;

	run("Synchronize Windows");
	roiManager("show all without labels");
	waitForUser("evaluate  the training");
	Dialog.create("ribosomes sufficient");
	Dialog.addCheckbox("training was good", "true");
	Dialog.show();
	sufficient = Dialog.getCheckbox();
	print("sufficient: " + sufficient);
	runde = runde+1;
	probabilities = "C1-Composite";
	raw = "C2-Composite";
	close("*");

}

n = roiManager("count");
selectWindow("CountRibosomes");
Table.set("z-level", 0, "0");
Table.set("nribosomes", 0, n);
Table.update;

savepath = h5_path+  File.separator + roi + "_slice01_Probabilities_ribosomes.zip";
roiManager("save", savepath);

resultpath = "xxx";
if (File.exists(resultpath)==0) {
	resultpath = "xxx";
}
if (File.exists(resultpath)==0) {
	resultpath = "xxx";
}
pathtable = resultpath + roi + "_ribosomecounting2.csv";
Table.save(pathtable);

beep();
print("macro is finished");
close("*");