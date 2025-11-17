print("\\Clear");
roi = getString("ROI-name?", "5xx-ROIx");

dirarea = "xxx";
filelistdirarea = getFileList(dirarea);
for (i = 0; i < filelistdirarea.length; i++) {
	if (endsWith(filelistdirarea[i], ".csv")&&filelistdirarea[i].contains("areas2")&&filelistdirarea[i].contains(roi)) { 
		open(dirarea + filelistdirarea[i]);
		print("if area");
	}
	else if (endsWith(filelistdirarea[i], ".csv")&&filelistdirarea[i].contains("area")&&filelistdirarea[i].contains(roi)) {
		open(dirarea + filelistdirarea[i]);
		print("else if area");
	}
}
areatable = Table.title;
lengtharea = Table.size;
print("length of the ribo area is: " + lengtharea);
dirribos = "xxx";
filelistdirribos = getFileList(dirribos);
for (i = 0; i < filelistdirribos.length; i++) {
	if (endsWith(filelistdirribos[i], ".csv")&&filelistdirribos[i].contains(roi)&&filelistdirribos[i].contains("counting2")) {
		print("if counting");
		ifix = i;
		break;
	}
	else if (endsWith(filelistdirribos[i], ".csv")&&filelistdirribos[i].contains(roi)&&filelistdirribos[i].contains("counting")) {
		print("else if counting");
		ifix = i;
	}
}
open(dirribos + filelistdirribos[ifix]);

ribotable = Table.title;
lengthribo = Table.size;
print("length of the ribo table is: " + lengthribo);

if (lengtharea != lengthribo) {
	exit("area and ribo table do not have the same dimensions!");
}
density = "RibosomalDensity";
Table.create(density);
selectWindow(areatable);
for (i = 0; i < lengthribo; i++) {
	selectWindow(areatable);
	zlevel = Table.get("zlevel", i);
	print("zlevel= " + zlevel);
	selectWindow(density);
	Table.set("zlevel", i, zlevel);
	selectWindow(areatable);
	areanm = Table.get("AreaCytosol(nm^2)", i);
	print("areanm= " + areanm);
	selectWindow(ribotable);
	nribso = Table.get("nribosomes", i);
	print("nribos= " + nribso);
	densitynm = nribso/areanm;
	print("densitynm= " + densitynm);
	selectWindow(density);
	Table.set("RibosomalDensity(nm^-2)", i, densitynm);
	selectWindow(areatable);
	areaum = Table.get("AreaCytosol(um^2)", i);
	print("areaum= " + areaum);
	selectWindow(ribotable);
	densityum = nribso/areaum;
	print("densityum= " + densityum);
	selectWindow(density);
	Table.set("RibosomalDensity(um^-2)", i, densityum);
	Table.update;
}

selectWindow(density);
densitypath = "xxx" + roi + "_ribosomaldensity.csv";
Table.save(densitypath);

selectWindow(areatable);
run("Close");
selectWindow(ribotable);
run("Close");
