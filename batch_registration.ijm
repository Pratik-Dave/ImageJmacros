// Define input and outup directory !!!
directory = "/Users/pratik/Desktop/04-05-2022/pPD44-Fe-set2/";
outputDirectory = "/Users/pratik/Desktop/04-05-2022_registered/pPD44-Fe-set2_registered/";

fileList = getFileList(directory);
run("Bio-Formats Macro Extensions");
setBatchMode(true);

// Loop for files with a given extension
for (i=0; i<fileList.length; i++) {	
	if (endsWith(fileList[i], "nd")) {

  file = directory + fileList[i];
    Ext.openImagePlus(file);

	// Reapplying Registration
	run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");
	rename("substacked");
	run("Split Channels");
	run("Descriptor-based registration (2d/3d)", "first_image=C1-substacked second_image=C2-substacked reapply");
	rename("registered");

	// Saving separate channels and closing
	run("Split Channels"); 
	selectWindow("C2-registered");
 	newimage = outputDirectory + replace( fileList[i] , "-", "_" ); 
 	outFile = replace(newimage, ".nd" , "-green.tiff" );
	saveFile(outFile);
	selectWindow("C1-registered");
 	outFile = replace(newimage, ".nd" , "-red.tiff" );
	saveFile(outFile);
    close("*");
}
  }

showStatus("Finished.");
setBatchMode(false);

function saveFile(outFile) {
   run("Bio-Formats Exporter", "save=[" + outFile + "] compression=Uncompressed");
}
