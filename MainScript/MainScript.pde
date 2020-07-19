ArrayList<Boid> boids;
int nbrBoids;
int boidHeight;
int boidWidth;
float perceptRadius;
float adjustSpeed;

void setup(){
  size(600, 600);
  frameRate(30);
  
  boids = new ArrayList<Boid>();
  nbrBoids = 40;
  boidHeight = 20;
  boidWidth = 12;
  perceptRadius = 50;
  adjustSpeed = 0.1;
  
  Boid boid = new Boid(random(width), random(height), random(2*PI), 1, perceptRadius, true, adjustSpeed);
  boids.add(boid);
  for(int i=0; i<nbrBoids; i++){
    boid = new Boid(random(width), random(height), random(2*PI), 1, perceptRadius, false, adjustSpeed);
    boids.add(boid);
  }
}

void draw(){
  background(0);
  
  for(Boid boid : boids){
    boid.update();
  }
  for(Boid boid : boids){
    boid.display(); 
  }
}

float getDist(Boid a, Boid b){
  float dist = 0;
  dist = pow(pow(a.old_xPos-b.old_xPos, 2) + pow(a.old_yPos-b.old_yPos, 2), 0.5);
  return dist;
}

void line(Boid a, Boid b){
  line(a.new_xPos, a.new_yPos, b.new_xPos, b.new_yPos);
}
