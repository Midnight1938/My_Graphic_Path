let points = [];
let delauany, voronoi;
let imaged;

function preload() {
  imaged = loadImage("imgs/Mountain Fog.JPG");
}

function setup() {
  createCanvas(300*2, 300*3);
  for (let i = 0; i < 3000; i++) {
    let x = random(width);
    let y = random(height);

    let col = imaged.get(x, y);
    if (random(100) < brightness(col)) {
      points.push(createVector(x, y));
    } else {
      i--;
    }
  }
  delauany = calculateDelaunay(points);
  voronoi = delauany.voronoi([0, 0, width, height]);

//   noLoop();
}

function draw() {
  background(0);

  for (let v of points) {
    stroke(255);
    strokeWeight(4);
    point(v.x, v.y);
    fill(0, 100);
  }

  //   noFill();
  //   strokeWeight(1);
  //   let { dPoints, triangles } = delauany;
  //   for (let i = 0; i < triangles.length; i += 3) {
  //     let a = 2 * delauany.triangles[i];
  //     let b = 2 * delauany.triangles[i + 1];
  //     let c = 2 * delauany.triangles[i + 2];
  //     triangle(
  //       dPoints[a],
  //       dPoints[a + 1],
  //       dPoints[b],
  //       dPoints[b + 1],
  //       dPoints[c],
  //       dPoints[c + 1]
  //     );
  //   }

  let polygons = voronoi.cellPolygons();
  let cells = Array.from(polygons);

  //   //? Making the polygons
  //   for (let poly of cells) {
  //     stroke(255);
  //     strokeWeight(2);
  //     noFill();
  //     beginShape();
  //     for (let i = 0; i < poly.length; i++) {
  //       vertex(poly[i][0], poly[i][1]);
  //     }
  //     endShape();
  //   }

  //? Centroids, center of each poly
  let arrCentroid = [];
  for (let poly of cells) {
    let area = 0;
    let centroid = createVector(0, 0);
    for (let i = 0; i < poly.length; i++) {
      let v0 = poly[i];
      let v1 = poly[(i + 1) % poly.length]; // cross product for last vector
      let crossProd = v0[0] * v1[1] - v1[0] * v0[1];
      area += crossProd;
      centroid.x += (v0[0] + v1[0]) * crossProd;
      centroid.y += (v0[1] + v1[1]) * crossProd;
    }
    area /= 2;
    centroid.div(6 * area);
    arrCentroid.push(centroid);
  }

  for (let i = 0; i < points.length; i++) {
    points[i].lerp(arrCentroid[i], 1);
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
