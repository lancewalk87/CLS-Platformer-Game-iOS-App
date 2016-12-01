//Platformer Game
//Simply Coding 

import SpriteKit;
import MediaPlayer;

class GameScene: SKScene, SKPhysicsContactDelegate {
    //Buttons (Game Controls)
    let pauseButton = SKSpriteNode(imageNamed:"Pause.png");
    let quitButton = SKLabelNode(text:"Quit");
    let leftButton = SKSpriteNode(imageNamed:"Left.png");
    let rightButton = SKSpriteNode(imageNamed:"Right.png");
    let shootButton = SKSpriteNode(imageNamed: "Shoot.png");

    var gameTimer = NSTimer();
    var themeSong = AVAudioPlayer()
    let backGround = SKSpriteNode(imageNamed:"backGround.png");
    
    //Game Elements
    let player = SKSpriteNode(imageNamed:"r_walk-0.png");
    var bulletNode = SKSpriteNode()

    let scoreLabel = SKLabelNode(text: "Score: ");
    
    //Game Operators
    var gameBool = Bool();
    var sandBoxBool = Bool();
    
    var leftBool = Bool(); var l_facing = Bool();
    var rightBool = Bool(); var r_facing = Bool();
    var jumpBool = Bool();
    
    var playerLock = CGFloat();

    var shootBool = Bool();
    var l_shoot = Bool();
    var r_shoot = Bool();
    
    var l_contact = Bool(); var r_contact = Bool();
    
    var animationBool = Bool();

    var scoreInt:Int = 0;
    
    var l_animate = SKAction(); var r_animate = SKAction();
    
    var coin_animate = SKAction();

    override func didMoveToView(view: SKView) {
        leftButton.position = CGPointMake(CGRectGetMinX(self.frame)+75, CGRectGetMinY(self.frame)+170);
        leftButton.size.width = 100; leftButton.size.height = 100;
        leftButton.zPosition = 2;
        leftButton.name = "Left";
        self.addChild(leftButton);
        
        rightButton.position = CGPointMake(CGRectGetMinX(self.frame)+235, CGRectGetMinY(self.frame)+170)
        rightButton.size.width = 100; rightButton.size.height = 100;
        rightButton.zPosition = 2;
        rightButton.name = "Right";
        self.addChild(rightButton);
        
        shootButton.position = CGPointMake(CGRectGetMaxX(self.frame)-75, CGRectGetMinX(self.frame)+170);
        shootButton.size.width = 100; shootButton.size.height = 100;
        shootButton.zPosition = 2;
        shootButton.name = "Shoot";
        shootButton.hidden = true;
        self.addChild(shootButton);
        
        pauseButton.position = CGPointMake(CGRectGetMinX(self.frame)+60, CGRectGetMaxY(self.frame)-150)
        pauseButton.size.width = 100; pauseButton.size.height = 100;
        pauseButton.zPosition = 2;
        pauseButton.name = "Pause";
        self.addChild(pauseButton);
        
        quitButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-40);
        quitButton.fontSize = 60; quitButton.fontName = "Helvetica";
        quitButton.zPosition = 2;
        quitButton.name = "Quit";
        quitButton.hidden = true;
        self.addChild(quitButton);
        
        scoreLabel.position = CGPointMake(CGRectGetMaxX(self.frame)-150, CGRectGetMaxY(self.frame)-150);
        scoreLabel.fontSize = 45; scoreLabel.fontName = "Helvetica";
        scoreLabel.zPosition = 2;
        self.addChild(scoreLabel);
        
        backGround.position = CGPointMake(1500, CGRectGetMidY(self.frame))
        backGround.size.width = 4000; backGround.size.height = CGRectGetMaxY(self.frame);
        backGround.zPosition = 0;
        self.addChild(backGround);
        
        player.position = CGPointMake(CGRectGetMidX(self.frame), 160);
        player.size.width = 120; player.size.height = 150;
        player.name = "player";
        player.zPosition = 1;
        
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.categoryBitMask = CollisionBitMask.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionBitMask.platform.rawValue
        player.physicsBody?.collisionBitMask = CollisionBitMask.platform.rawValue
        self.addChild(player);
        
        let musicPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("theme", ofType: ".mp3")!)
        themeSong = try! AVAudioPlayer(contentsOfURL: musicPath);
        themeSong.prepareToPlay();// themeSong.play();
        themeSong.numberOfLoops = -1;
        
        //Player Animations
        let Right =  SKTextureAtlas(named: "Right");
        r_animate = SKAction.animateWithTextures([
            Right.textureNamed("r_walk-0.png"),
            Right.textureNamed("r_walk-1.png"),
            Right.textureNamed("r_walk-2.png"),
            Right.textureNamed("r_walk-3.png"),
            Right.textureNamed("r_walk-4.png"),
            Right.textureNamed("r_walk-5.png"),
            Right.textureNamed("r_walk-6.png"),
            Right.textureNamed("r_walk-7.png"),
            ], timePerFrame: 0.08);
        r_animate = SKAction.repeatActionForever(r_animate);
        
        let Left = SKTextureAtlas(named: "Left");
        l_animate = SKAction.animateWithTextures([
            Left.textureNamed("l_walk-0.png"),
            Left.textureNamed("l_walk-1.png"),
            Left.textureNamed("l_walk-2.png"),
            Left.textureNamed("l_walk-3.png"),
            Left.textureNamed("l_walk-4.png"),
            Left.textureNamed("l_walk-5.png"),
            Left.textureNamed("l_walk-6.png"),
            Left.textureNamed("l_walk-7.png"),
            ], timePerFrame: 0.08);
        l_animate = SKAction.repeatActionForever(l_animate);

        let Coin = SKTextureAtlas(named: "coin");
        coin_animate = SKAction.animateWithTextures([
            Coin.textureNamed("coin1.png"),
            Coin.textureNamed("coin2.png"),
            Coin.textureNamed("coin3.png"),
            Coin.textureNamed("coin4.png"),
            Coin.textureNamed("coin5.png"),
            Coin.textureNamed("coin6.png"),
            Coin.textureNamed("coin7.png"),
            Coin.textureNamed("coin8.png"),
            Coin.textureNamed("coin9.png"),
            Coin.textureNamed("coin10.png"),
            Coin.textureNamed("coin11.png"),
            ], timePerFrame: 0.1);
        coin_animate = SKAction.repeatActionForever(coin_animate);
        
        gameBool=true; animationBool=true;
        
        self.physicsWorld.contactDelegate = self;
        self.createScene();
        
        
        playerLock = player.position.x
    }
    func createScene() {
        for _ in 0 ..< enemyInt {
            let enemyNode = enemyClass().createEnemy()
            backGround.addChild(enemyNode);
        }
        enemyClass().enemyProperties()
        
        for i in 0 ..< platformInt {
            let platformNode = SKSpriteNode(imageNamed: "Platform.png");
            platformNode.name = "platform";
            platformNode.position = CGPointMake(platformPositionX[i], platformPositionY[i]);
            platformNode.zPosition = 1;
            platformNode.size.width = 260; platformNode.size.height = 60;
            
            platformNode.physicsBody = SKPhysicsBody(rectangleOfSize:  platformNode.size);
            platformNode.physicsBody?.affectedByGravity = false;
            platformNode.physicsBody?.allowsRotation = false; platformNode.physicsBody?.dynamic = false;
            platformNode.physicsBody?.categoryBitMask = CollisionBitMask.platform.rawValue;
            platformNode.physicsBody?.collisionBitMask = CollisionBitMask.player.rawValue;
            platformNode.physicsBody?.contactTestBitMask = CollisionBitMask.player.rawValue;
            
            backGround.addChild(platformNode);
        }
        
        for i in 0 ..< coinInt {
            let coinNode = SKSpriteNode(imageNamed: "coin1.png");
            coinNode.zPosition = 4;
            coinNode.runAction(coin_animate);
            coinNode.name = "coin";
            coinNode.position = CGPointMake(coinPositionX[i], coinPositionY[i]);
            coinNode.size.width = 45; coinNode.size.height = 45;
            coinNode.runAction(coin_animate)
            coinNode.physicsBody = SKPhysicsBody(rectangleOfSize: coinNode.size);
            coinNode.physicsBody?.affectedByGravity = false;
            coinNode.physicsBody?.pinned = true;
            coinNode.physicsBody?.allowsRotation = false;
            coinNode.physicsBody?.dynamic = true;
            coinNode.physicsBody?.categoryBitMask = CollisionBitMask.coin.rawValue;
            coinNode.physicsBody?.collisionBitMask = CollisionBitMask.player.rawValue;
            coinNode.physicsBody?.contactTestBitMask = CollisionBitMask.player.rawValue;
            
            backGround.addChild(coinNode);
        }
        let amoNode = SKSpriteNode(imageNamed: "amo.png");
        amoNode.name = "amo";
        amoNode.position = CGPointMake(amoPositionX, amoPositionY);
        amoNode.size.width = 45; amoNode.size.height = 45;
        amoNode.zPosition = 1;
        
        amoNode.physicsBody = SKPhysicsBody(rectangleOfSize: amoNode.size);
        amoNode.physicsBody?.affectedByGravity = false; amoNode.physicsBody?.pinned = true;
        amoNode.physicsBody?.allowsRotation = false; amoNode.physicsBody?.dynamic = true;
        amoNode.physicsBody?.categoryBitMask = CollisionBitMask.amo.rawValue;
        amoNode.physicsBody?.collisionBitMask = CollisionBitMask.player.rawValue;
        amoNode.physicsBody?.contactTestBitMask = CollisionBitMask.player.rawValue;
        backGround.addChild(amoNode);
        
        let flagNode = SKSpriteNode(imageNamed: "flag.png");
        flagNode.name = "flag";
        flagNode.position = CGPointMake(flagPositionX, flagPositionY);
        flagNode.size.width = 65; flagNode.size.height = 170;
        flagNode.zPosition = 1;
        
        flagNode.physicsBody = SKPhysicsBody(rectangleOfSize: flagNode.size);
        flagNode.physicsBody?.affectedByGravity = false; flagNode.physicsBody?.pinned = true;
        flagNode.physicsBody?.allowsRotation = false; flagNode.physicsBody?.dynamic = true;
        flagNode.physicsBody?.categoryBitMask = CollisionBitMask.flag.rawValue;
        flagNode.physicsBody?.collisionBitMask = CollisionBitMask.player.rawValue;
        flagNode.physicsBody?.contactTestBitMask = CollisionBitMask.player.rawValue;
        backGround.addChild(flagNode);
        
        gameTimer = NSTimer.scheduledTimerWithTimeInterval(0.005, target: self, selector: #selector(GameScene.activityManager), userInfo: nil, repeats: true);
        NSRunLoop.mainRunLoop().addTimer(gameTimer, forMode: NSRunLoopCommonModes);
    }
    
    func activityManager(sender: NSTimer) {
        if (player.position.x != playerLock) {
            player.position.x = playerLock;
        }
        if (leftBool == true && backGround.position.x < 1725) { //moving left within border
            backGround.position.x += 6;
            
            if (animationBool==true) {
                player.runAction(l_animate);
                animationBool = false;
            }
            
        } else if (rightBool == true && backGround.position.x > -720) { //Moving right within border
            backGround.position.x -= 6;
            
            if (animationBool==true) {
                player.runAction(r_animate);
                animationBool = false;
            }
            
        } else {    //Still
            backGround.position.x += 0;
            if (l_facing==true) { player.texture = SKTexture(imageNamed: "l_idle.png");
            } else if (r_facing==true) { player.texture = SKTexture(imageNamed: "r_idle.png"); }
        }
        
        if (jumpBool == true) {
            if (player.position.y < view!.frame.size.height*2-75) { player.position.y += 5; } 
           
        } else {
            if (player.position.y > 170) { player.position.y -= 5; }
        }
        
        if (shootBool==true) {
            if (l_shoot == true) {
                bulletNode.position.x -= 10;
            } else if (r_shoot == true) {
                bulletNode.position.x += 10;
            }
            
            if (bulletNode.position.x<0 || bulletNode.position.x>self.frame.width) {
                bulletNode.removeFromParent();
                shootButton.hidden = false;
                shootBool=false;
            }
        }
    }
    var backGroundX = CGFloat(); var playerContactY = CGFloat();
    
    //Physics Managers
    func didBeginContact(contact: SKPhysicsContact) {
        bodyA = contact.bodyA.node!.name!;
        bodyB = contact.bodyB.node!.name!;
        
        contactY = contact.contactPoint.y;
        
        if (bodyA=="player") {
            if (bodyB == "coin") {
                let node = contact.bodyB.node!
                node.removeFromParent();
                scoreInt+=1;
                scoreLabel.text = "Score: \(scoreInt)";
            } else if (bodyB == "flag") {
                self.win();
            } else if (bodyB == "amo") {
                let node = contact.bodyB.node!;
                node.removeFromParent();
                shootButton.hidden = false;
            } else if bodyB.containsString("enemy") == true {
                fail();
            }
        } else {
            enemyClass().enemyContact()
        }
        
        if (bodyA == "bullet" || bodyB == "bullet") {
            let node1 = contact.bodyA.node!
            let node2 = contact.bodyB.node!
            
            node1.removeFromParent()
            node2.removeFromParent()
            
            shootBool = false
            shootButton.hidden = false
        }
    }
    
    //Controls
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let nodeTouch = self.nodeAtPoint(location).name
            
            //Controls
            if (nodeTouch=="Left") {
                rightBool = false; leftBool = true; l_facing=true; r_facing=false;
                
            } else if (nodeTouch=="Right") {
                leftBool = false; rightBool = true; r_facing=true; l_facing=false;
            }
            
            if location.y > 400 {    //Jump
                jumpBool = true; animationBool = true;
                self.performSelector(#selector(endJump), withObject: nil, afterDelay: 0.8);
            }
            
            if (nodeTouch=="Shoot") {
                shoot();
            }

            if (nodeTouch=="Pause") {
                pause();
            } else if (nodeTouch=="Quit") {
                quit();
            }
        }
    }
    func endJump() {
        jumpBool = false;
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        animationBool = true;
        leftBool = false
        rightBool = false
        player.removeAllActions();
    }

    
    func shoot() {
        bulletNode.size.width = 125
        bulletNode.size.height = 75
        bulletNode.name = "bullet"
        bulletNode.zPosition = 1
        
        bulletNode.physicsBody = SKPhysicsBody(rectangleOfSize: bulletNode.size)
        bulletNode.physicsBody?.affectedByGravity = false
        bulletNode.physicsBody?.dynamic = true
        bulletNode.physicsBody?.categoryBitMask = CollisionBitMask.bullet.rawValue
        bulletNode.physicsBody?.collisionBitMask = CollisionBitMask.enemy.rawValue
        bulletNode.physicsBody?.contactTestBitMask = CollisionBitMask.enemy.rawValue
        
        if (l_facing == true) {
            l_shoot = true
            r_shoot = false
            bulletNode.position = CGPointMake(player.position.x-60, player.position.y)
            bulletNode.texture = SKTexture(imageNamed: "Bullet_left.png")
        } else if (r_facing == true) {
            r_shoot = true
            l_shoot = false
            bulletNode.position = CGPointMake(player.position.x+60, player.position.y)
            bulletNode.texture = SKTexture(imageNamed: "Bullet_right.png")
        }
        
        shootButton.hidden = true
        shootBool = true
        self.addChild(bulletNode)
    }
    
    func win() {
        //Save Data
        scoreList.append(scoreInt);
        quit();
    }
    
    func fail() {
        quit();
    }
    
    func pause() {
        if pauseBool == true {
            pauseBool = false;
            gameTimer = NSTimer.scheduledTimerWithTimeInterval(0.005, target: self, selector: #selector(GameScene.activityManager), userInfo: nil, repeats: true);
            
            themeSong.play()
            quitButton.hidden = true;
            leftButton.hidden = false;
            rightButton.hidden = false;
            pauseButton.texture = SKTexture(imageNamed: "Pause.png");
        } else {
            pauseBool = true;
            gameTimer.invalidate();
            
            themeSong.stop()
            quitButton.hidden = false;
            leftButton.hidden = true;
            rightButton.hidden = true;
            pauseButton.texture = SKTexture(imageNamed: "Play.png");
        }
     }
    func quit() {
        gameTimer.invalidate()
        pauseBool = false
        self.removeAllChildren()
        
        if let scene = mainMenu(fileNamed: "GameScene") {
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
    }
 
}
