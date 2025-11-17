close("*");
print("\\Clear");
waitForUser("open the autocropped imagestack");
output = getDirectory("select output path");
namedatensatz = getString("please type the title of the ROI-stack", "520-ROI1");

rename(namedatensatz);
titlestack = getTitle();
outputpath = output + titlestack + "_slice";
print ("outputpath= " + outputpath);

for (i = 1; i <= nSlices; i++) {
	starttime = getTime();
	interrupt = isKeyDown("space");
	if (interrupt == true) {
		print("Macro was interrupted by pressing space");
		setKeyDown("none");      
	break;
	}
	
    setSlice(i);
    no = i;
    nomod = no;
	if (i<10) {
		nomod = "0" + no;
	}
    title = nomod+ "____"+ "z"+no +".0.tif";
    run("Duplicate...", "title="+title);
    selectWindow(title);s
	run("Export HDF5", "select="+outputpath+nomod+".h5 exportpath="+outputpath+nomod+".h5 datasetname=data compressionlevel=0 input="+title);
	close();
	endtime = getTime();
	time = endtime - starttime;
	timeinsecs = time/1000;
	print("no. "+i+" was converted to .h5, exported towards filepath= " + outputpath+nomod + "and took "+timeinsecs+" seconds");
}
close("*");
selectWindow("Log");
print("Macro is finished");