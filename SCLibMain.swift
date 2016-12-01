//
//  SCLibMain.swift
//  Game
//
//  Created by Lance Walker on 4/19/16.
//
//

import UIKit; import SpriteKit; import Foundation; import MediaPlayer;
var skView = SKView();
var currentFrame = CFTimeInterval();
let enemyInt:Int=6; let platformInt:Int=7; var indexer: Int=0;
let totalNodes:Int=enemyInt+coinInt+platformInt;
var bodyA = String(); var bodyB = String(); let coinInt=platformInt-1; var time = NSTimer();
var platformPositionX:[CGFloat]=[]; var platformPositionY:[CGFloat]=[];
var enemyPosistionX:[CGFloat]=[]; var enemyPosistionY:[CGFloat]=[];
var coinPositionX:[CGFloat]=[]; var coinPositionY:[CGFloat]=[];
var amoPositionX = CGFloat(); var amoPositionY = CGFloat();
var flagPositionX = CGFloat(); var flagPositionY = CGFloat();

var pauseBool:Bool = false;
var contactX = CGFloat(); var contactY = CGFloat();
var scoreList:[Int]=[];

class SCLib : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad();
        skView = self.view as! SKView;
        skView.showsFPS = true;
        skView.showsNodeCount = true;
        skView.ignoresSiblingOrder = true;
        if let scene = mainMenu(fileNamed:"GameScene") {
            scene.scaleMode = .AspectFill;
            skView.presentScene(scene);
        }
    }
    override func shouldAutorotate() -> Bool {
        return true;
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Landscape;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
}
enum CollisionBitMask:UInt32 {
    case player = 1;
    case platform = 2;
    case enemy = 4;
    case flag = 8;
    case score = 16;
    case coin = 32;
    case bullet = 128;
    case amo = 256;
}

class mainMenu : SKScene {
    let mainTitle = SKLabelNode(text: "Space Adventure!"); let playButton = SKLabelNode(text: "Play"); let scoreMenuButton = SKLabelNode(text: "Scores");
    let backButton = SKLabelNode(text: "Back");
    let char = SKSpriteNode(imageNamed: "r_idle.png"); let backGround1 = SKSpriteNode(imageNamed: "backGround.png"); let backGround2 = SKSpriteNode(imageNamed: "backGround.png");
    var animateTimer = NSTimer();
    let imgA:[NSString]=["r_walk-0","r_walk-1","r_walk-2","r_walk-3","r_walk-4","r_walk-5","r_walk-6","r_walk-7"];
    override func didMoveToView(view: SKView) {
        mainTitle.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)-150);
        mainTitle.fontSize = 60; mainTitle.fontName = "helvetica";
        mainTitle.zPosition = 1;
        self.addChild(mainTitle);
        playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-40);
        playButton.fontSize = 50; playButton.fontName = "helvetica";
        playButton.zPosition = 1; playButton.name = "play";
        self.addChild(playButton);
        scoreMenuButton.position = CGPointMake(CGRectGetMinX(self.frame)+30, CGRectGetMinY(self.frame)+50);
        scoreMenuButton.fontSize = 40; scoreMenuButton.fontName = "helvetica";
        scoreMenuButton.zPosition = 1; scoreMenuButton.name = "scores";
        self.addChild(scoreMenuButton);
        backGround1.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        backGround1.size.width = 4000; backGround1.size.height = CGRectGetMaxY(self.frame);
        backGround1.zPosition = 0;
        self.addChild(backGround1);
        backGround2.position = CGPointMake(backGround1.frame.width, CGRectGetMidY(self.frame));
        backGround2.size.width = 4000; backGround2.size.height = CGRectGetMaxY(self.frame);
        backGround2.zPosition = 0;
        self.addChild(backGround2);
        char.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        char.size.width = 150; char.size.height = 180;
        char.zPosition = 0;
        //self.addChild(char);
        enemyTimer.invalidate();
        platformPositionX.removeAll(); platformPositionY.removeAll();
        coinPositionX.removeAll(); coinPositionY.removeAll();
        enemyPosistionX.removeAll(); enemyPosistionY.removeAll();
        enemyNodes.removeAll();
        animateTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(mainMenu.animte(_:)), userInfo: nil, repeats: true);
        NSRunLoop.mainRunLoop().addTimer(animateTimer, forMode: NSRunLoopCommonModes);
        generatePosistions();
    }
    var index=0; var charInt=0;
    func animte(sender: NSTimer) {
        if (backGround1.position.x < -2000) {
            backGround1.position.x = backGround2.frame.width;
        } else if (backGround2.position.x < -2000) {
            backGround2.position.x = backGround1.frame.width;
        }
        backGround1.position.x -= 1; backGround2.position.x -= 1;
        index+=2;
        if (index>10) {
            index=0;
            if (charInt>6) {
                charInt=0;
                char.texture = SKTexture(imageNamed: "r_walk-0.png");
            } else {
                charInt+=1;
                char.texture = SKTexture(imageNamed: imgA[charInt] as String + ".mp3");
            }
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self);
            let nodeTouch = self.nodeAtPoint(location).name;
            
            if (nodeTouch == "play") {
                let scene = GameScene(fileNamed: "GameScene");
                scene!.scaleMode = .AspectFill;
                skView.presentScene(scene);
            } else if (nodeTouch == "scores") {
                
            } else if (nodeTouch == "back") {
                
            }
        }
    }
    func cleanMenu() {
        self.removeAllChildren();
        animateTimer.invalidate();
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreList.count;
    }
    var scoreArray = [];
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.font = UIFont(name: "Papyrus", size: 17);
        cell.textLabel?.text = scoreArray[indexPath.row] as? String;
        return cell;
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
}
func generatePosistions() {
    var platformX : CGFloat = -1200; var platformY = CGFloat(); var posistionIndex : Int = 0;
    while posistionIndex < platformInt {
        let screenTop = CGRectGetMidY(skView.frame)
        let maxY = UInt32(screenTop); let y = CGFloat(arc4random_uniform(maxY));
        if (y >= 250) { platformY = y * 1; } else { platformY = y * -1; }
        platformPositionX.append(platformX); platformPositionY.append(platformY);
        coinPositionX.append(platformPositionX[posistionIndex]); coinPositionY.append(platformPositionY[posistionIndex]+60);
        enemyPosistionX.append(platformPositionX[posistionIndex]); enemyPosistionY.append(platformPositionY[posistionIndex]+60);
        if (posistionIndex>5) {
            amoPositionX=platformPositionX[3]-60; amoPositionY=platformPositionY[3]+60;
            flagPositionX=platformPositionX[6]; flagPositionY=platformPositionY[6]+105;
        }
        platformX+=400;
        posistionIndex+=1;
    }
}

var enemyNodes:[SKSpriteNode] = []; var enemyMovements:[Int] = [];
var enemyTimer = NSTimer(); var enemyNodeID = 0;
class enemyClass {
    var enemyNode = SKSpriteNode(imageNamed: "r_enemy1.png");
    var enemyX = CGFloat(); var enemyY = CGFloat();
    var el_animate = SKAction();  var er_animate = SKAction();
    let gameScene = GameScene();
    func createEnemy() -> SKSpriteNode {
        enemyNode.name = "enemy\(enemyNodeID)"; enemyMovements.append(0);
        enemyNode.position = CGPointMake(enemyPosistionX[enemyNodeID], enemyPosistionY[enemyNodeID]);
        enemyNode.size.width = 75; enemyNode.size.height = 100;
        enemyNode.zPosition = 1; adoptAnimations();
        enemyNode.physicsBody = SKPhysicsBody(rectangleOfSize: enemyNode.size);
        enemyNode.physicsBody?.affectedByGravity = false; enemyNode.physicsBody?.allowsRotation = false;
        enemyNode.physicsBody?.categoryBitMask = CollisionBitMask.enemy.rawValue;
        enemyNode.physicsBody?.collisionBitMask = CollisionBitMask.platform.rawValue | CollisionBitMask.player.rawValue;
        enemyNode.physicsBody?.contactTestBitMask = CollisionBitMask.platform.rawValue | CollisionBitMask.player.rawValue;
        enemyNodes.append(enemyNode); enemyNodeID+=1;
        if (enemyNodeID>=enemyInt) { enemyNodeID=0; }
        return enemyNode;
    }
    func adoptAnimations() {
        let er_array = SKTextureAtlas(named: "ELeft");
        er_animate = SKAction.animateWithTextures([
            er_array.textureNamed("l_enemy1.png"),
            er_array.textureNamed("l_enemy2.png"),
            er_array.textureNamed("l_enemy3.png"),
            er_array.textureNamed("l_enemy4.png"),
            ], timePerFrame: 0.2);
        er_animate = SKAction.repeatActionForever(er_animate);
        
        let el_array = SKTextureAtlas(named: "ERight");
        el_animate = SKAction.animateWithTextures([
            el_array.textureNamed("r_enemy1.png"),
            el_array.textureNamed("r_enemy2.png"),
            el_array.textureNamed("r_enemy3.png"),
            el_array.textureNamed("r_enemy4.png"),
            ], timePerFrame: 0.2);
        el_animate = SKAction.repeatActionForever(el_animate);
        
        enemyNode.runAction(er_animate);
    }
    var enemyAnimateBool:Bool = true;
    var ground = CGFloat(); var hideBool:Bool=false;
    @objc func enemyProperties() {
        ground = CGRectGetMaxY(skView.frame) * -1 + 100;
        enemyTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(enemyClass.enemy), userInfo: nil, repeats: true);
        NSRunLoop.currentRunLoop().addTimer(enemyTimer, forMode: NSRunLoopCommonModes);
    }
    @objc func enemy() {
        if (pauseBool == true) {
            for i in 0 ..< enemyInt { let reNode = enemyNodes[i]; reNode.hidden = true; hideBool=true; }
        } else {
            if (hideBool==true) { for i in 0 ..< enemyInt { let reNode = enemyNodes[i]; reNode.hidden = false; hideBool=false; } }
            let node = enemyNodes[indexer];
            if (enemyMovements[indexer]==0) {
                node.position.x -= 6
                if (node.position.x <= -1500) { enemyMovements[indexer]=1; enemyAnimateBool=true; }
                if (enemyAnimateBool == true) { node.runAction(el_animate); enemyAnimateBool=false; }
            } else if (enemyMovements[indexer]==1) {
                node.position.x += 6
                if (node.position.x >= 1500) { enemyMovements[indexer]=0; enemyAnimateBool=true; }
                if (enemyAnimateBool == true) { node.runAction(er_animate); enemyAnimateBool=false; }
            }
            if (node.position.y > ground) { node.position.y -= 6; }
            if (indexer<enemyNodes.count-1) { indexer+=1; } else { indexer=0; }
        }
    }
    @objc func enemyContact() {
        if (bodyA.containsString("enemy")==true) {
            let contactBodyName = bodyA.stringByReplacingOccurrencesOfString("enemy", withString: "");
            let nodeID = Int(contactBodyName); let int = nodeID!; let contactEnemy = enemyNodes[int];
            if (contactY > contactEnemy.position.y) {
                if (contactX >= contactEnemy.position.x) { enemyMovements[int] = 1;
                } else if (contactX <= contactEnemy.position.x) { enemyMovements[int] = 0; }
            }
        }
    }
}