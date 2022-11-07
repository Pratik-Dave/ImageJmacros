// Daniel Mateju 2022-04-29
// Using a composite movie, this macro creates a montage movie of individual channels, with labels and scale bar, plus saves one single-frame image
// Define the directory for saving (line 4) and your single frame (line 5). If needed change scale bar properties (line 74/75) and time label properties (87).
directory = "/Users/pratik/Desktop/movies_pPD43 and 44/";
favorite_frame = 18;

// open files
setBatchMode(true);
rename("name");
run("Split Channels");

frames = nSlices;
width = getWidth;
height = getHeight;
run("Merge Channels...", "c2=C2-name c6=C1-name keep ignore");
run("RGB Color", "frames");
newImage("new.tif", "RGB white", 8+width*3, height+40, frames);
for (i=0; i<nSlices; i++) {	

//paste individual movies
setSlice(i+1);
selectWindow("C1-name");
run("Grays");
setSlice(i+1);
run("Copy");
selectWindow("new.tif");
makeRectangle(0, 40, width, height);
run("Paste");
selectWindow("C2-name");
run("Grays");
setSlice(i+1);
run("Copy");
selectWindow("new.tif");
makeRectangle(width+4, 40, width, height);
run("Paste");
selectWindow("Merged");
setSlice(i+1);
run("Copy");
selectWindow("new.tif");
makeRectangle(2*width+8, 40, width, height);
run("Paste");


//make black boxes above movies
makeRectangle(0, 0, width, 36);
run("Properties... ", "  fill=black");
run("Add Selection...");
makeRectangle(width+4, 0, width, 36);
run("Properties... ", "  fill=black");
run("Add Selection...");
makeRectangle(2*width+8, 0, width, 36);
run("Properties... ", "  fill=black");
run("Add Selection...");

}

// make labels for channels
setJustification("center")
setFont("SansSerif", 24, " antialiased");
setColor("magenta");
Overlay.drawString("MS2", (width*0.5), 25, 0.0);
setColor("green");
Overlay.drawString("SunTag", (width*1.5), 25, 0.0);
setColor("white");
Overlay.drawString("Merge", (width*2.5), 25, 0.0);
run("Flatten", "stack");
run("Select None");

// save tif
outFile = directory + "Montage"; 
saveAs("Tif",outFile);

//add scale bar
run("Set Scale...", "distance=7.6923 known=1 unit=µm");
run("Scale Bar...", "width=5 height=3 font=20 color=White background=None location=[Lower Right] overlay label");
run("Flatten", "stack");
outFileScale = directory + "Montage_scaleBar"; 
saveAs("Tif",outFileScale);

//create single frame image
outFileSingleFrame = directory + "Montage_singleFrame"; 
run("Make Substack...", "  slices=" +favorite_frame);
saveAs("Tif",outFileSingleFrame);

//create time label
selectWindow("Montage_scaleBar.tif");
run("Time Stamper", "starting=0 interval=0.05 x=" + (width*2)+20 + " y=" + (height)+35 +  " font=20 decimal=2 anti-aliased or=sec");
outFileScaleTime = directory + "Montage_scaleBarTime"; 
saveAs("Tif",outFileScaleTime);

//save movie
outFile7 = directory + "Montage_6fps.avi"; 
run("AVI... ", "compression=JPEG frame=6 save=" + directory + "Montage_scaleBarTime.avi");
//close
setBatchMode(false);
close("*");