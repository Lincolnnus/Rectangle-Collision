//
//  ViewController.m
//  FallingBricks
//
//  Created by Shaohuan Li on 12/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize worldModel;
@synthesize worldView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    worldModel= [[WorldModel alloc] initWorld];
    [self loadWalls];
    //[self testRotation];
    //[self testGravity];
    //[self testFriction];
    //[self testTwoCollision];
    //[self testThreeCollision];
    [self testMultipleCollision];
    // Use accecerometer delegate to perform the update
    UIAccelerometer *acc = [UIAccelerometer sharedAccelerometer];
    acc.delegate = self;
    acc.updateInterval = timerInterval;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    //EFFECT:accelerometer delegate method, checks for device's acceleration and convert to a reasonable gravity
    
    [self collisionDetection];// Collision detection
    
    for(id controller in self.childViewControllers){
        //if([UIDevice currentDevice].orientation==UIInterfaceOrientationPortrait)
        //{
            [controller updateGravity:[Vector2D vectorWith:acceleration.x*accCoef y:-acceleration.y*accCoef]];// Update gravity
            [controller updateVelocity]; // Update velocity
            [controller updatePosition]; // Update position
            [controller reloadView]; // Reload view
       // }
    }
}

-(void)collisionDetection
{
    //REQUIRES:worldModel cannot be nil
    //EFFECT: handle collision of all the objects in the worldModel
    for (int i = 0; i < [worldModel.objects count]; i++){
        for (int j = i + 1; j < [worldModel.objects count]; j++){
            if(![[worldModel.objects objectAtIndex:i] isEqual:[worldModel.objects objectAtIndex:j]]){
                    [self handleCollision:[worldModel.objects objectAtIndex:i] with:[worldModel.objects objectAtIndex:j]];
            }
        }
    }
}
-(void)handleCollision: (ObjectModel*) two with: (ObjectModel*) one
{
    //REQUIRES: all objects passed in cannot be nil. This is ensured by caller
    //EFFECT: find coresponding handler to handle the collision according to the object type
    
    if((two.objectType==kRectType)&&(one.objectType==kRectType)){
        
        [self handleCollisionRR:(BrickModel*)two with:(BrickModel*)one];
    }else if((two.objectType==kRectType)&&(one.objectType==kCircleType)){
        
        [self handleCollisionCR:(CircleModel*)one with:(BrickModel*)two];
    }else if((two.objectType==kCircleType)&&(one.objectType==kCircleType)){
        
       // [self handleCollisionCC:(CircleModel*)two with:(CircleModel*)one];
    }
}
-(BOOL) segmentsIntr:(CGPoint)a And: (CGPoint)b With: (CGPoint)c And: (CGPoint)d Radius:(CGFloat)r
{
    
    //线段ab的法线N1
    CGPoint n1=CGPointMake(a.x-b.x, b.y-a.y);
    
    //线段cd的法线N2
    CGPoint n2=CGPointMake(c.x-d.x, d.y-c.y);
    //var nx2 = (d.y - c.y), ny2 = (c.x - d.x);
    
    //两条法线做叉乘, 如果结果为0, 说明线段ab和线段cd平行或共线,不相交
    CGFloat denominator = n1.x*n2.y - n1.y*n2.x;
    if (denominator==0) {
        return false;
    }
    
    //在法线N2上的投影
    CGFloat distC_N2=n2.x * c.x + n2.y * c.y;
    CGFloat distA_N2=n2.x * a.x + n2.y * a.y-distC_N2;
    CGFloat distB_N2=n2.x * b.x + n2.y * b.y-distC_N2;
    
    // 点a投影和点b投影在点c投影同侧 (对点在线段上的情况,本例当作不相交处理);
    if ( distA_N2*distB_N2>=0  ) {
        return false;
    }
    
    //
    //判断点c点d 和线段ab的关系, 原理同上
    //
    //在法线N1上的投影
    CGFloat distA_N1=n1.x * a.x + n1.y * a.y;
    CGFloat distC_N1=n1.x * c.x + n1.y * c.y-distA_N1;
    CGFloat distD_N1=n1.x * d.x + n1.y * d.y-distA_N1;
    if ( distC_N1*distD_N1>=0  ) {
        return false;
    }
    CGFloat fraction= distA_N2 / denominator;
    CGFloat dx= fraction * n1.y,
    dy= -fraction * n1.x;
    
    if(sqrt(dx*dx+dy*dy)>r)
        return false;
    else return true;
}

-(void) handleCollisionCR: (CircleModel*) cir with: (BrickModel*) rect
{
    //METHOD DEALS WITH CIRCLE RECTANGLE COLLISION, PLZ IGNORE FOR NOW :D
    CGPoint pa = cir.center;
    CGPoint pb = rect.center;
    
    for(int i=0;i<4;i++)
    {
        CGPoint pc = rect.corners[i+1%4];
        CGPoint pd = rect.corners[i];
        if([self segmentsIntr:pa And:pb With:pc And:pd Radius:cir.radius])
        {
            //http://mathworld.wolfram.com/Circle-LineIntersection.html
            CGPoint d = CGPointMake(pc.x-pd.x,pc.y-pd.y);
            CGFloat dr = sqrt(d.x*d.x+d.y+d.y);
            CGFloat D = pd.x*pc.y-pc.x*pd.y;
            CGFloat x,y;
            if(d.y<0)
                x=(D*d.y-d.y*d.x*sqrt(cir.radius*cir.radius*dr*dr-D*D))/(dr*dr);
            else
                x=(D*d.y+d.y*d.x*sqrt(cir.radius*cir.radius*dr*dr-D*D))/(dr*dr);
            
            y=(-D*d.x+abs(d.y)*sqrt(cir.radius*cir.radius*dr*dr-D*D))/(dr*dr);
            
            Vector2D *contact=[Vector2D vectorWith:x y:y];
            CGFloat dist=[[contact subtract:[Vector2D vectorWith:pa.x y:pa.y]]length];
            Vector2D *normal=[[contact subtract:[Vector2D vectorWith:pa.x y:pa.y]]multiply:-1/dist];
            CGFloat separation = dist=cir.radius;
            [self handleImpulse:cir with: rect contacting:contact withNormal:normal seperatedBy: separation];

        }
        
    }
  /*  Vector2D *cirCenter = [Vector2D vectorWith:cir.center.x y:cir.center.y];
    //get the 2 edges that may collide with circle
    CGPoint*corners = rect.corners;
    CGFloat minDist = MAXFLOAT;
    int choice = 0;
    for(int i=0;i<4;i++){
        Vector2D *temp = [Vector2D vectorWith:corners[i].x y:corners[i].y];
        CGFloat tempdist = [[temp subtract:cirCenter] length];
        if(minDist > tempdist){
            minDist = tempdist;
            choice = i;
        }
    }
    Vector2D *edge1, *edge2;
    int node1 = (choice==0)?3:choice-1;
    Vector2D *refPt = [Vector2D vectorWith:corners[choice].x y:corners[choice].y];
    Vector2D *Node1 = [Vector2D vectorWith:corners[node1].x y:corners[node1].y];;
    edge1 = [refPt subtract:Node1];
    int node2 = (choice==3)?0:choice+1;
    Vector2D *Node2 = [Vector2D vectorWith:corners[node2].x y:corners[node2].y];
    edge2 = [refPt subtract:Node2];
    
    //get the perpendicular distance
    Vector2D *edge1Unit = [edge1 multiply:1/[edge1 length]];
    Vector2D *edge2Unit = [edge2 multiply:1/[edge2 length]];
	Vector2D *cirCenterToPt = [refPt subtract:cirCenter];
    
	Vector2D *projOnEdge1 = [edge1Unit multiply:[cirCenterToPt dot:edge1Unit]];
    Vector2D *projOnEdge2 = [edge2Unit multiply:[cirCenterToPt dot:edge2Unit]];
    
    //determine if they collides
    CGFloat dist1 = [[cirCenterToPt subtract:projOnEdge1] length];
    CGFloat dist2 = [[cirCenterToPt subtract:projOnEdge2] length];
    if(dist1>cir.radius && dist2>cir.radius){
        //do not collide
        //NSLog(@"do not collide");
        return;
    }
    
    //determine where the perpendicular foot lands
    Vector2D *foot1 = [[cirCenterToPt subtract:projOnEdge1] add:cirCenter];
    Vector2D *foot2 = [[cirCenterToPt subtract:projOnEdge2] add:cirCenter];
    CGFloat leftBound, rightBound, upperBound, lowerBound;
    //foot1 against edge 1
    BOOL foot1OnEdge1 = YES;
    leftBound = MIN(refPt.x,Node1.x);
    rightBound = MAX(refPt.x,Node1.x);
    upperBound = MIN(refPt.y,Node1.y);
    lowerBound = MAX(refPt.y,Node1.y);
    if(foot1.x<leftBound || foot1.x>rightBound || foot1.y<upperBound || foot1.y>lowerBound)
        foot1OnEdge1 = NO;
    //foot2 against edge 2
    BOOL foot2OnEdge2 = YES;
    leftBound = MIN(refPt.x,Node2.x);
    rightBound = MAX(refPt.x,Node2.x);
    upperBound = MIN(refPt.y,Node2.y);
    lowerBound = MAX(refPt.y,Node2.y);
    if(foot2.x<leftBound || foot2.x>rightBound || foot2.y<upperBound || foot2.y>lowerBound)
        foot2OnEdge2 = NO;
    
    //determine contact point
    //normal has problem
    Vector2D *contact;
    CGFloat separation;
    Vector2D *normal;
    if(foot1OnEdge1){
        if(dist1 > cir.radius)
            return;
        else{
            contact = foot1;
            separation = dist1-cir.radius;
            normal = [[cirCenter subtract:foot1] multiply:1/dist1];
        }
    }
    else if(foot2OnEdge2){
        if(dist2 > cir.radius)
            return;
        else{
            contact = foot2;
            separation = dist2-cir.radius;
            normal = [[cirCenter subtract:foot2] multiply:1/dist2];
        }
    }
    else{
        CGFloat dist = [[refPt subtract:cirCenter] length];
        if(dist > cir.radius)
            return;
        else{
            contact = refPt;
            separation = dist-cir.radius;
            normal = [[refPt subtract:cirCenter] multiply:-1/dist];
        }
    }
   */
}


-(void)handleCollisionRR: (BrickModel*) two with: (BrickModel*) one
{
    //REQUIRES: all objects passed in cannot be nil. This is ensured by caller
    //EFFECT: find contact points and seperation if one intersects two, and call handleImpulse to resolve collision
    
    //Skip Wall vs Wall
    if((two.mass==INFINITY)&&(one.mass==INFINITY))return;
    
    Vector2D *ha = [Vector2D vectorWith:one.width/2 y:one.height/2];
    Vector2D *hb = [Vector2D vectorWith:two.width/2 y:two.height/2];
    
    Vector2D* pa = [Vector2D vectorWith:one.center.x y:one.center.y];
    Vector2D* pb = [Vector2D vectorWith:two.center.x y:two.center.y];
    
    Vector2D *d = [pb subtract:pa];
    CGFloat rada = one.rotation * M_PI / 180;
    CGFloat radb = two.rotation * M_PI / 180;
    
    Matrix2D* Ra = [Matrix2D matrixWithValues:cos(rada) and:sin(rada) and:-sin(rada) and:cos(rada)];
    Matrix2D* Rb = [Matrix2D matrixWithValues:cos(radb) and:sin(radb) and:-sin(radb) and:cos(radb)];
    
    Vector2D *da = [[Ra transpose] multiplyVector:d];
    Vector2D *db = [[Rb transpose] multiplyVector:d];
    
    Matrix2D *c = [[Ra transpose] multiply:Rb];
    
    Vector2D *chb = [[c abs] multiplyVector:hb];
    Vector2D *ctha = [[[c transpose] abs] multiplyVector:ha];
    
    Vector2D *fa = [[[da abs] subtract:ha] subtract:chb];
    Vector2D *fb = [[[db abs] subtract:hb] subtract:ctha];
    
    double ij[4];
    ij[0] = fa.x;
    ij[1] = fa.y;
    ij[2] = fb.x;
    ij[3] = fb.y;
    
    double pref[4];
    pref[0] = fa.x - constantK*(ha.x);
    pref[1] = fa.y - constantK*(ha.y);
    pref[2] = fb.x - constantK*(hb.x);
    pref[3] = fb.y - constantK*(hb.y);
    
    int i,pos, flag;
    double smallest = pref[0];
    pos = 0;
    flag = 0;
    
    //if any of them are positive then they do not collide
    for (i=0; i<4; i++) {
        if (ij[i] > 0) {
            return;
        }
    }
    
    //favoring the larger edge for reference edge
    for (i=0; i<4; i++) {
        if (pref[i] > Fcoefficient*ij[i]) {
            smallest = pref[i];
            pos = i;
            flag = 1;
        }
    }
    
    if (flag == 0) {
        smallest = ij[0];
        pos = 0;
        for (i=0; i<4; i++) {
            if (ij[i] > smallest)
            {
                smallest = ij[i];
                pos = i;
            }
        }
    }
    
    Vector2D *n;
    Vector2D *nf, *ns;
    Vector2D *ni, *p, *h;
    Matrix2D *r;
    double df, ds, dneg, dpos;
    //df - distance between world origin and reference edge
    
    switch (pos) {
        case 0:
            if (da.x >= 0)
            {
                //rectangle 2 is on the right hand side of rectangle 1
                n = [Ra col1];
            }
            else
            {
                //rectangle 1 is on the right hand side of rectangle 2
                n = [[Ra col1] negate];
            }
            
            nf = n;
            df = [pa dot:nf] + ha.x;
            ns = [Ra col2];
            ds = [pa dot:ns];
            dneg = ha.y - ds;
            dpos = ha.y + ds;
            
            //incident edge
            ni = [[[Rb transpose] multiplyVector:nf] negate];
            p = pb;
            r = Rb;
            h = hb;
            
            break;
            
        case 1:
            if (da.y >= 0)
            {
                //rectangle 2 is on top of rectangle 1.
                n = [Ra col2];
            }
            else
            {
                //rectangle 2 is on bottom of rectangle 1.
                n = [[Ra col2] negate];
            }
            
            nf = n;
            df = [pa dot:nf] + ha.y;
            ns = [Ra col1];
            ds = [pa dot:ns];
            dneg = ha.x - ds;
            dpos = ha.x + ds;
            
            //incident edge
            ni = [[[Rb transpose] multiplyVector:nf] negate];
            p = pb;
            r = Rb;
            h = hb;
            
            break;
        case 2:
            
            if (db.x >= 0)
            {
                //rectangle 1 is on the right hand side of rectangle 2.
                n = [Rb col1];
            }
            else
            {
                //rectangle 1 is on the left hand side of rectangle 2.
                n = [[Rb col1] negate];
            }
            
            nf = [n negate];
            df = [pb dot:nf] + hb.x;
            ns = [Rb col2];
            ds = [pb dot:ns];
            dneg = hb.y - ds;
            dpos = hb.y + ds;
            
            //incident edge
            ni = [[[Ra transpose] multiplyVector:nf]negate];
            p = pa;
            r = Ra;
            h = ha;
            
            break;
        case 3:
            
            if (db.y >= 0)
            {
                //rectangle 1 is on top of rectangle 2.
                n = [Rb col2];
            }
            else
            {
                //rectangle 1 is on bottom of rectangle 2.
                n = [[Rb col2]negate];
            }
            
            nf = [n negate];
            df = [pb dot:nf] + hb.y;
            ns = [Rb col1];
            ds = [pb dot:ns];
            dneg = hb.x - ds;
            dpos = hb.x + ds;
            
            //incident edge
            ni = [[[Ra transpose] multiplyVector:nf]negate];
            p = pa;
            r = Ra;
            h = ha;
            
            break;
    }
    
    Vector2D *v1, *v2;
    //incident edge with vertices v1 and v2
    if ([[ni abs] x] > [[ni abs] y] && [ni x] > 0) {
        v1 = [p add:[r multiplyVector:[Vector2D vectorWith:h.x y:-h.y]]];
        v2 = [p add:[r multiplyVector:[Vector2D vectorWith:h.x y:h.y]]];
    }
    
    if ([[ni abs] x] > [[ni abs] y] && [ni x] <=0) {
        v1 = [p add:[r multiplyVector:[Vector2D vectorWith:-h.x y:h.y]]];
        v2 = [p add:[r multiplyVector:[Vector2D vectorWith:-h.x y:-h.y]]];
    }
    
    if ([[ni abs] x] <= [[ni abs] y] && [ni y] >0) {
        v1 = [p add:[r multiplyVector:[Vector2D vectorWith:h.x y:h.y]]];
        v2 = [p add:[r multiplyVector:[Vector2D vectorWith:-h.x y:h.y]]];
    }
    
    if ([[ni abs] x] <= [[ni abs] y] && [ni y] <=0) {
        v1 = [p add:[r multiplyVector:[Vector2D vectorWith:-h.x y:-h.y]]];
        v2 = [p add:[r multiplyVector:[Vector2D vectorWith:h.x y:-h.y]]];
    }
    
    //First Clipping
    Vector2D *v1c, *v2c; //points after clipping
    double dist1, dist2;
    dist1 = [[ns negate] dot:v1] - dneg;
    dist2 = [[ns negate] dot:v2] - dneg;
    
    if (dist1 > 0 && dist2 > 0) {
        return;
    }
    
    if(dist1 < 0 && dist2 < 0)
    {
        v1c = v1;
        v2c = v2;
    }
    
    if (dist1 < 0 && dist2 > 0) {
        v1c = v1;
        v2c = [v1 add: [[v2 subtract:v1] multiply:(dist1/(dist1-dist2))]];
    }
    
    if (dist1 > 0 && dist2 < 0) {
        v1c = v2;
        v2c = [v1 add: [[v2 subtract:v1] multiply:(dist1/(dist1-dist2))]];
    }
    
    //Second Clipping
    Vector2D *v1cc, *v2cc;
    
    dist1 = [ns dot:v1c] - dpos;
    dist2 = [ns dot:v2c] - dpos;
    
    if (dist1 > 0 && dist2 > 0) {
        return;
    }
    
    if (dist1 < 0 && dist2 < 0) {
        v1cc = v1c;
        v2cc = v2c;
    }
    
    if (dist1 < 0 && dist2 > 0) {
        v1cc = v1c;
        v2cc = [v1c add: [[v2c subtract:v1c] multiply:(dist1/(dist1-dist2))]];
    }
    
    if (dist1 > 0 && dist2 < 0) {
        v1cc = v2c;
        v2cc = [v1c add: [[v2c subtract:v1c] multiply:(dist1/(dist1-dist2))]];
    }
    
    //contact points
    Vector2D *c1, *c2;
    double separation;
    
    separation = [nf dot:v1cc] - df;
    
    if (separation < 0) {
        c1 = [v1cc subtract:[nf multiply:separation]];
        [self handleImpulse:two with: one contacting:c1 withNormal:n seperatedBy: separation];
    }
    
    separation = [nf dot:v2cc] - df;
    
    if (separation < 0) {
        c2 = [v2cc subtract:[nf multiply:separation]];
        [self handleImpulse:two with: one contacting:c2 withNormal:n seperatedBy: separation];
    }
}
-(void) handleImpulse:(ObjectModel*)two with: (ObjectModel*)one contacting:(Vector2D*)contact withNormal: (Vector2D*)normal seperatedBy:(double)separation
{
    //REQUIRES: all objects passed in cannot be nil, seperation must be negative. This is ensured by caller
    //EFFECT: apply impulse on contact point according to depth. universal method
    
    Vector2D *pa = [Vector2D vectorWith:one.center.x y:one.center.y];
    Vector2D *pb = [Vector2D vectorWith:two.center.x y:two.center.y];
    
    Vector2D *tangent = [normal crossZ:1.0];
    
    Vector2D *ra = [contact subtract:pa];
    Vector2D *rb = [contact subtract:pb];
    Vector2D *ua = [one.velocity add:[ra crossZ:-one.angularVelocity]];
    Vector2D *ub = [two.velocity add:[rb crossZ:-two.angularVelocity]];
    Vector2D *u = [ub subtract:ua];
    
    double un = [u dot:normal];
    double ut = [u dot:tangent];
    
    double massn, masst;
    
    massn = (1/two.mass) + (1/one.mass) + (([ra dot:ra] - ([ra dot:normal]*[ra dot:normal]))/one.momentOfInertia) + (([rb dot:rb] - ([rb dot:normal]*[rb dot:normal]))/two.momentOfInertia);
    masst = (1/two.mass) + (1/one.mass) + (([ra dot:ra] - ([ra dot:tangent]*[ra dot:tangent]))/one.momentOfInertia) + (([rb dot:rb] - ([rb dot:tangent]*[rb dot:tangent]))/two.momentOfInertia);
    
    massn = 1/massn;
    masst = 1/masst;
    
    double bias = abs((constantFactor/timerInterval)*(constantK + separation));
    
    if (constantK > fabs(separation)) {
        bias = 0;
    }
    
    double restitution = sqrt(one.restitution * two.restitution);
    
    double pnFactor = MIN((massn * ((1+restitution)*un-bias)),0);
    Vector2D *pn = [normal multiply:pnFactor];
    double dpt = masst * ut;
    
    double ptmax = one.friction * two.friction * [pn length];
    
    dpt = MAX(-ptmax, MIN(dpt, ptmax));
    
    Vector2D *pt = [tangent multiply:dpt];
    
    Vector2D *newV1 = [one.velocity add:[[pn add:pt] multiply:(1/one.mass)]];
    Vector2D *newV2 = [two.velocity subtract:[[pn add:pt] multiply:(1/two.mass)]];
    
    double newW1 = one.angularVelocity + ([ra cross:[pt add:pn]]/one.momentOfInertia);
    double newW2 = two.angularVelocity - ([rb cross:[pt add:pn]]/two.momentOfInertia);
    
    two.velocity = newV2;
    two.angularVelocity = newW2;
    one.velocity = newV1;
    one.angularVelocity = newW1;
    
}

/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //EFFECT: prevent the app from auto-rotating
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}*/
-(void)loadWalls
{
    
    // Four walls modeled as bricks with infinity mass.
    [self addChildViewController:[[BrickController alloc] initWithContainer:self.worldView World:worldModel At:CGPointMake(384, 3) Width:768 Height:5 Mass:INFINITY Rotation:0 Restitution: 0.3 Friction:0.9 Color:[UIColor greenColor]]];
    [self addChildViewController:[[BrickController alloc] initWithContainer:self.worldView World:worldModel At:CGPointMake(384, 1003) Width:768 Height:5 Mass:INFINITY Rotation:0 Restitution: 0.3 Friction:0.9 Color:[UIColor greenColor]]];
    [self addChildViewController:[[BrickController alloc] initWithContainer:self.worldView World:worldModel At:CGPointMake(3, 500) Width:5 Height:1000 Mass:INFINITY Rotation:0 Restitution: 0.3 Friction:0.9 Color:[UIColor greenColor]]];
    [self addChildViewController:[[BrickController alloc] initWithContainer:self.worldView World:worldModel At:CGPointMake(766, 500) Width:5 Height:1000 Mass:INFINITY Rotation:0 Restitution: 0.3 Friction:0.9 Color:[UIColor greenColor]]];
}
-(void)testGravity
{
    //EFFECT:brick falls
    [self addChildViewController:[[BrickController alloc] initWithContainer:self.worldView World:worldModel At:CGPointMake(150, 150) Width:100 Height:100 Mass:10 Rotation:0 Restitution: 0.3 Friction:0.9 Color:[UIColor greenColor]]];
    [self addChildViewController:[[CircleController alloc] initWithContainer:self.worldView World:worldModel At:CGPointMake(300, 300) Radius:20 Mass:10 Color:[UIColor greenColor]]];
}
-(void)testRotation
{
    //EFFECT:brick with a initial rotation angle rotate after bouncing back from the ground.
    [self addChildViewController:[[BrickController alloc] initWithContainer:self.worldView World:worldModel At:CGPointMake(100, 100) Width:100 Height:100 Mass:10 Rotation:20 Restitution: 0.3 Friction:0.9 Color:[UIColor greenColor]]];
    
}

-(void)testTwoCollision
{
    //EFFECT:two bricks collide with each other
    [self addChildViewController:[[BrickController alloc] initWithContainer:self.worldView World:worldModel At:CGPointMake(100, 100) Width:100 Height:100 Mass:10 Rotation:20 Restitution: 0.3 Friction:0.9 Color:[UIColor greenColor]]];
    
    [self addChildViewController:[[BrickController alloc]initWithContainer:self.worldView World:worldModel  At:CGPointMake(100, 400) Width:100 Height:100 Mass:10 Rotation:0  Restitution: 0.3 Friction:0.9 Color:[UIColor redColor]]];
}
-(void)testThreeCollision
{
    //EFFECT:Three bricks collide with each other
    [self addChildViewController:[[BrickController alloc]initWithContainer:self.worldView World:worldModel  At:CGPointMake(100, 200) Width:100 Height:100 Mass:10 Rotation:0  Restitution: 0.3 Friction:0.9 Color:[UIColor redColor]]];
    [self addChildViewController:[[BrickController alloc] initWithContainer:self.worldView World:worldModel At:CGPointMake(100, 500) Width:300 Height:100 Mass:10 Rotation:0  Restitution: 0.3 Friction:0.9 Color:[UIColor blueColor]]];
    [self addChildViewController:[[BrickController alloc] initWithContainer:self.worldView World:worldModel At:CGPointMake(100, 700) Width:200 Height:100 Mass:10 Rotation:0  Restitution: 0.3 Friction:0.9 Color:[UIColor blackColor]]];
}
-(void)testMultipleCollision
{
    //EFFECT:Multiple bricks collide with each other
    [self addChildViewController:[[BrickController alloc] initWithContainer:self.worldView World:worldModel At:CGPointMake(150, 150) Width:100 Height:100 Mass:10 Rotation:20 Restitution: 0.3 Friction:0.9 Color:[UIColor greenColor]]];
    [self addChildViewController:[[BrickController alloc]initWithContainer:self.worldView World:worldModel  At:CGPointMake(250, 100) Width:100 Height:100 Mass:10 Rotation:0  Restitution: 0.3 Friction:0.9 Color:[UIColor redColor]]];
    [self addChildViewController:[[BrickController alloc] initWithContainer:self.worldView World:worldModel At:CGPointMake(550, 100) Width:100 Height:100 Mass:10 Rotation:0  Restitution: 0.3 Friction:0.9 Color:[UIColor blueColor]]];
    [self addChildViewController:[[BrickController alloc] initWithContainer:self.worldView World:worldModel At:CGPointMake(500, 500) Width:100 Height:100 Mass:10 Rotation:0  Restitution: 0.3 Friction:0.9 Color:[UIColor blackColor]]];
    [self addChildViewController:[[BrickController alloc] initWithContainer:self.worldView World:worldModel At:CGPointMake(100, 250) Width:300 Height:100 Mass:30 Rotation:0  Restitution: 0.3 Friction:0.9 Color:[UIColor grayColor]]];
    [self addChildViewController:[[BrickController alloc] initWithContainer:self.worldView World:worldModel At:CGPointMake(450, 250) Width:50 Height:300 Mass:15 Rotation:0 Restitution: 0.3 Friction:0.9 Color:[UIColor orangeColor]]];
    [self addChildViewController:[[BrickController alloc] initWithContainer:self.worldView World:worldModel At:CGPointMake(100, 650) Width:200 Height:200 Mass:40 Rotation:0 Restitution: 0.3 Friction:0.9 Color:[UIColor purpleColor]]];
}
-(void)testFriction
{
    //EFFECT:The brick with smaller friction is easier to move
    [self addChildViewController:[[BrickController alloc] initWithContainer:self.worldView World:worldModel At:CGPointMake(100, 900) Width:100 Height:100 Mass:10 Rotation:0 Restitution: 0.3 Friction:0.1 Color:[UIColor greenColor]]];
    
    [self addChildViewController:[[BrickController alloc] initWithContainer:self.worldView World:worldModel At:CGPointMake(300, 900) Width:100 Height:100 Mass:10 Rotation:0 Restitution: 0.3 Friction:0.9 Color:[UIColor redColor]]];
}

@end
