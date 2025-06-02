let points = [];
let delauany, voronoi;
let imaged;

function preload() {
  imaged = loadImage("imgs/girlbimbo-insta-revBG.png");
}

function setup() {
  let w = imaged.width;
  let h = imaged.height;
  let maxW = windowWidth;
  let maxH = windowHeight;
  let scale = min(maxW / w, maxH / h, 1);
  createCanvas(w * scale, h * scale);
  imaged.resize(w * scale, h * scale);

  makedots(20_000);
  delauany = calculateDelaunay(points);
  voronoi = delauany.voronoi([0, 0, width, height]);
}

function makedots(dots) {
  for (let i = 0; i < dots; i++) {
    let x = random(width);
    let y = random(height);

    let col = imaged.get(x, y);
    if (random(100) < brightness(col)) {
      points.push(createVector(x, y));
    } else {
      i--;
    }
  }
}

function draw() {
  background(0);

  for (let v of points) {    //! make points

    let col = imaged.get(v.x, v.y); // Get color from image at point's position
    let bright = brightness(col);  // 0 (dark) to 100 (bright)
    let size = map(bright, 100, 0, 8, 2);
    stroke(col);
    //stroke(255)
    //Map brightness to size: darker = bigger, e.g. 2 (bright) to 8 (dark)
    strokeWeight(size);
    //strokeWeight(3);
    point(v.x, v.y);
  }

  let polygons = voronoi.cellPolygons();
  let cells = Array.from(polygons);

  let centroidArr = new Array(cells.length);
  let weightArr = new Array(cells.length).fill(0);
  for (let i = 0; i < cells.length; i++) {
    centroidArr[i] = createVector(0, 0);
  }

  imaged.loadPixels();
  let delauanyIdx = 0;
  for (let i = 0; i < width; i++) {
    for (let j = 0; j < height; j++) {
      let index = (i + j * width) * 4; // 4 values, RGBA
      let r = imaged.pixels[index + 0];
      let g = imaged.pixels[index + 1];
      let b = imaged.pixels[index + 2];
      let bright = 0.2126 * r + 0.7152 * g + 0.0722 * b; //relative luminance
      let weight = 1 - bright / 255;

      delauanyIdx = delauany.find(i, j, delauanyIdx); // lookup which centroid to pair to
      centroidArr[delauanyIdx].x += i * weight; // add
      centroidArr[delauanyIdx].y += j * weight; // vals
      weightArr[delauanyIdx] += weight; // add weight to sum
    }
  }

  // look at centroid, divide by sum of weights
  for (let i = 0; i < centroidArr.length; i++) {
    if (weightArr[i] > 0) {
      centroidArr[i].div(weightArr[i]);
    } else {
      centroidArr[i] = points[i].copy(); // if no weight, use original point
    }
  }

  for (let i = 0; i < points.length; i++) {
    points[i].lerp(centroidArr[i], 0.2);
  }

  delauany = calculateDelaunay(points);
  voronoi = delauany.voronoi([0, 0, width, height]);
}

function calculateDelaunay(points) {
  let pointsArray = [];
  for (let v of points) {
    pointsArray.push(v.x, v.y);
  }
  return new d3.Delaunay(pointsArray);
}
