import processing.pdf.*;
import java.io.InputStreamReader;
 
String params[] = { "C:\\Program Files (x86)\\Foxit Software\\Foxit Reader\\FoxitReader.exe", "/p", "C:\\Users\\Christian\\Documents\\Processing\\sketches\\Printtest\\output.pdf" };

void setup() { 
PGraphics pdf = createGraphics(300, 300, PDF, "output.pdf");
pdf.beginDraw();
pdf.background(255, 255, 255);
pdf.stroke(0);
pdf.rect(50,50,200,200);
pdf.line(50, 50, 250, 250);
pdf.dispose();
pdf.endDraw();
}
 
void draw(){
// Nothing    
}
 
void keyPressed() {
println(" PDF created");
println("now silent print via Adobe Reader");

open(params);
println(params);
println("end");
}
