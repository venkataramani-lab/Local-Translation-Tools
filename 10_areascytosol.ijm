
roiManager("reset");
close("*");
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

print("\\Clear");
    if (isOpen("Results")) {
         selectWindow("Results"); 
         run("Close" );
    }
     if (isOpen("AreaTable")) {
         selectWindow("AreaTable"); 
         run("Close" );
    }

roi = getString("choose the roi", getLastPath());

base_path = "xxx";
segmentation_path = "xxx";
cell_path = base_path + File.separator + roi + File.separator;
seg_cell_path = segmentation_path + File.separator + roi + File.separator + "meshes";
px_size_filepath = cell_path +File.separator + "px_size.txt";
print("cell path: " + cell_path);
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
	// showMessage("this doesnt have any fitting nucleuscropped file."); 
			Dialog.create("select previous image");
			//Dialog.addChoice("Previous Image", files_in_cellpath);
			Dialog.addChoice("Previous Image", files_in_cellpath, "xxx");
			Dialog.show();
			previous_image = Dialog.getChoice();
	
}else if (filtered.length == 1) {
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
autocroppedstack = getTitle();
getDimensions(width, height, channels, slices, frames);

directory = cell_path +File.separator + "cellboundaries";
print("file exists: " + File.exists(directory));
if (File.exists(directory) != true) {
	print("file exists: " + File.exists(directory));
	directory = cell_path +File.separator + "cellcontours";
}

filelist = getFileList(directory);

print("Cellboundaryfolderllistlength: " + filelist.length);
found_in_seg = false;
if (filelist.length == 0) {
	
	seg_folderlist = getFileList(seg_cell_path);
	Array.show(seg_folderlist);
	cb_file = selectItemsWithSubstring(seg_folderlist, "_cb");
	roiManager("reset");
	roiManager("open", seg_cell_path + File.separator + cb_file[0]);
	roiManager("select", 0);
	run("Make Inverse");
	setBackgroundColor(0, 0, 0);
	run("Clear", "slice");
	save(cell_path + File.separator + substring(getTitle(), 0, getTitle().length-4) + "_cellcropped.tif");
	
	nuc_file = selectItemsWithSubstring(seg_folderlist, "_nuclearboundary");
	roiManager("reset");
	roiManager("open", seg_cell_path + File.separator + nuc_file[0]);
		roiManager("select", 0);
	
	setBackgroundColor(0, 0, 0);
	run("Clear", "slice");
	save(cell_path + File.separator + substring(getTitle(), 0, getTitle().length-4) + "_nuclearcropped.tif");
	cb_segpath = seg_cell_path + File.separator + cb_file[0];
	found_in_seg = true;
	
}







areas = "AreaTable";
Table.create(areas);

run("Set Measurements...", "area perimeter redirect=None decimal=3");

roiManager("reset");
Array.show(filelist);

if (found_in_seg == true) {
	run("Select None");
	cb_file = selectItemsWithSubstring(seg_folderlist, "_cb");
	open(seg_cell_path + File.separator + cb_file[0]);	
	roiManager("add");
print("cb_file_ifschleife: " + cb_file[0]);
}else {
	cb_file = selectItemsWithSubstring(getFileList(directory), "_cb");
open(directory + File.separator +cb_file[0]);	
roiManager("add");
print("cb_file_elseschelife: " + cb_file[0]);
}

ZLEVEL_NOTTHERE = false;

selectWindow(autocroppedstack);
close("\\Others");
n = roiManager("count");
for (i = 0; i < n; i++) {
	
    roiManager("select", i);
    roiManager("Measure");
    wait(300);
    selectWindow("Results");
    area = getResult("Area", nResults-1)*pixelsize;
    area = area*pixelsize; //twice because of 2D
    perimeter = getResult("Perim.", nResults-1)*pixelsize;
    
    name = Roi.getName;
    print("actual name is: " + name);
    zindex = lastIndexOf(name, "z");
    print("zindex: " + zindex);
    if (zindex== -1) {
    	ZLEVEL_NOTTHERE = true;
    	zlevel = 1;
    } else {
    zlevel = substring(name, zindex+1, zindex+3);
    zlevelint = parseInt(zlevel);
    print("zlevel =" + zlevel);
    }
    selectWindow("AreaTable");
     Table.set("zlevel", zlevel-1, zlevel);
    Table.set("AreaCell(nm^2)", zlevel-1, area);
    Table.set("Perimeter(nm)", zlevel-1, perimeter);
    areaum = area/1000000;
    perimeterum = perimeter/1000;
    Table.set("AreaCell(um^2)", zlevel-1, areaum);
    Table.set("PerimeterCell(nm)", zlevel-1, perimeterum);
    Table.update;
}

roiManager("reset");

Array.show(filelist);
nuc_bounds = selectItemsWithSubstring(filelist, "_nuclearboundary");
tm_count = selectItemsWithSubstring(filelist, "_tm");
cb_count = selectItemsWithSubstring(filelist, "_cb");
seg_bool = false;
if (nuc_bounds.length == 0) {
	seg_bool = true;
	showMessageWithCancel("names","nuclear boundaries not found. named as '_nuclearboundary'?? .. will check in segmentatoin folder.");
}else {
	print("Nuclear bounds found...");
}
if ((tm_count.length == 0)&&(seg_bool==false)) {
	seg_bool = true;
	showMessageWithCancel("names","tm_ not found. named as '_nuclearboundary'??");
}else {
	print("tm_count  found...");
}
if ((cb_count.length == 0)&&(seg_bool==false)) {
	seg_bool = true;
	showMessageWithCancel("names","cb_ not found. named as '_nuclearboundary'??");
}else {
	print("cb_count  found...");
}

Array.show(filelist);
roiManager("reset");
for (i = 0; i < lengthOf(filelist); i++) {
	print("here");
	name = filelist[i];
	combined = true;
	if (name.contains("_i")) {
		combined = false;
	}
    if (name.contains("_nuclearboundary") && (combined == true)) { 
        run("Select None");
        open(directory + File.separator + filelist[i]);
        roiManager("add");
         
        print("hier wirds geöffnet");
    } 
}
print("a");

n2 = roiManager("count");
print("n2" + n2);
for (i = 0; i < n2; i++) {
    roiManager("select", i);
    roiManager("Measure");
    wait(300);
    selectWindow("Results");
    area = getResult("Area", nResults-1)*pixelsize;
    area = area* pixelsize;
    print("area: " + area);
    perimeter = getResult("Perim.", nResults-1)*pixelsize;
    
    name = Roi.getName;
    print("actual name is: " + name);
    zindex = lastIndexOf(name, "_z");
     if (zindex== -1) {
    	ZLEVEL_NOTTHERE = true;
    	zlevel = 1;
    } else {
    zlevel = substring(name, zindex+2, zindex+4);
    print("zlevel= " + zlevel);
    }
    selectWindow("AreaTable");
    Table.set("AreaNucleus(nm^2)", zlevel-1, area);
    areaum = area/1000000;
    perimeterum = perimeter/1000;
    Table.set("AreaNucleus(um^2)", zlevel-1, areaum);
    Table.set("PerimeterNucleus(um)", zlevel-1, perimeterum);
    Table.update;
}

selectWindow("AreaTable");
for (i = 0; i < n; i++) {
		print("i at settable: " + i);
		areacellnm = Table.get("AreaCell(nm^2)", i);
		areanucleusnm = Table.get("AreaNucleus(nm^2)", i);
		areacytosolnm = areacellnm - areanucleusnm;
		print("areacytosolnm= " + areacytosolnm);
		if (areacytosolnm == "NaN") {
			areacytosolnm = 0;
		}
		Table.set("AreaCytosol(nm^2)", i, areacytosolnm);
		Table.update;
		areacellum = Table.get("AreaCell(um^2)", i);
		areanucleusum = Table.get("AreaNucleus(um^2)", i);
		areacytosolum = areacellum - areanucleusum;
		if (areacytosolum == "NaN") {
			areacytosolum = 0;
		}
		Table.set("AreaCytosol(um^2)", i, areacytosolum);
		Table.update;
	}
resultpath = "xxx";
resultpath = "xxx";
filePath = resultpath + roi + "_areas.csv";
selectWindow("AreaTable");
Table.save(filePath);
selectWindow("AreaTable");
close();
close("*");
beep();
print("macro is finished");
writeToLastPath(roi);