let screen;

function setup() {
    createCanvas(windowWidth, windowHeight);
    screen = createGraphics(width, height);

    screen.background(50);
    screen.stroke(255);
    screen.strokeWeight(4);

}


function draw() {
    image(screen, 0,0);

    if(mouseIsPressed){
        screen.line(mouseX, mouseY, pmouseX, pmouseY);
    }

}
