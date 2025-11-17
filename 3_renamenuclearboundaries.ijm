n = roiManager('count');
for (i = 0; i < n; i++) {
    roiManager('select', i);
    name = Roi.getName;
    newname = replace(name, "cb", "nuclearboundary");
    roiManager("rename", newname);
    roiManager("update");
}