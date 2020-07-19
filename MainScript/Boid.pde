class Boid {
  float old_xPos;
  float old_yPos;
  float old_angle;
  float new_xPos;
  float new_yPos;
  float new_angle;
  float speed;
  float perceptionRadius;
  boolean focus;

  float angleAdjustSpeed;

  Boid(float xp, float yp, float an, float sp, float pr, boolean f, float aas) {
    this.old_xPos = xp;
    this.old_yPos = yp;
    this.old_angle = an;
    this.speed = sp;
    this.perceptionRadius = pr;
    this.focus = f;

    this.angleAdjustSpeed = aas;
  }

  void update() {
    // Update of the position (only the old_angle is used)
    if (this.old_xPos + this.speed*cos(this.old_angle) < 0) {
      this.new_xPos = width - (this.new_xPos - this.speed*cos(this.old_angle));
    } else if (this.old_xPos + this.speed*cos(this.old_angle) > width) {
      this.new_xPos = this.old_xPos - width + this.speed*cos(this.old_angle);
    } else {
      this.new_xPos = this.old_xPos + this.speed*cos(this.old_angle);
    }
    if (this.old_yPos + this.speed*sin(this.old_angle) < 0) {
      this.new_yPos = height - (this.new_yPos - this.speed*sin(this.old_angle));
    } else if (this.old_yPos + this.speed*sin(this.old_angle) > height) {
      this.new_yPos = this.old_yPos - height + this.speed*sin(this.old_angle);
    } else {
      this.new_yPos = this.old_yPos + this.speed*sin(this.old_angle);
    }

    // Update of the angle (only the old_[xy]Pos is used)
    float finalAngle = 0;
    int nbrPerceptible = 0;
    for (Boid boid : boids) {
      if (boid == this) {
        continue;
      }
      if (this.canPercept(boid)) {
        finalAngle += boid.old_angle;
        nbrPerceptible++;
      }
    }
    if(nbrPerceptible != 0){
      float iterAdjustSpeed;
      finalAngle /= nbrPerceptible;
      if (finalAngle > this.old_angle) {
        if (finalAngle-this.old_angle < 2*PI+this.old_angle-finalAngle) {
          iterAdjustSpeed = map(finalAngle-this.old_angle, 0, PI, 0, this.angleAdjustSpeed);
          this.new_angle = this.old_angle + iterAdjustSpeed;
        } else {
          iterAdjustSpeed = map(2*PI+this.old_angle-finalAngle, 0, PI, 0, this.angleAdjustSpeed);
          this.new_angle = this.old_angle - iterAdjustSpeed;
        }
      } else if (finalAngle < this.old_angle) {
        if (this.old_angle-finalAngle < 2*PI+finalAngle-this.old_angle) {
          iterAdjustSpeed = map(this.old_angle-finalAngle, 0, PI, 0, this.angleAdjustSpeed);
          this.new_angle = this.old_angle - iterAdjustSpeed;
        } else {
          iterAdjustSpeed = map(2*PI+finalAngle-this.old_angle, 0, PI, 0, this.angleAdjustSpeed);
          this.new_angle = this.old_angle + iterAdjustSpeed;
        }
      }
    }
  }

  void display() {
    noStroke();
    fill(255);
    if (this.focus) {
      fill(255, 0, 0);
    }
    translate(this.new_xPos, this.new_yPos);
    rotate(this.new_angle);
    triangle(boidHeight/2, 0, -boidHeight/2, boidWidth/2, -boidHeight/2, -boidWidth/2);
    rotate(-this.new_angle);
    translate(-this.new_xPos, -this.new_yPos);

    this.old_xPos = this.new_xPos;
    this.old_yPos = this.new_yPos;
    this.old_angle = this.new_angle;
  }

  boolean canPercept(Boid boid) {
    float dist = getDist(this, boid);
    if (dist <= this.perceptionRadius) {
      return true;
    }
    return false;
  }
}
