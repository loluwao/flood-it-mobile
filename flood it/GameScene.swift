//
//  GameScene.swift
//  flood it
//
//  Created by Temi Akinyoade on 12/21/23.
// I guess this one controls the screen

import SpriteKit
import GameplayKit
import Foundation

extension UIColor {
    struct CustomColor {
        static var pink = UIColor(red: 238/255, green: 156/255, blue: 168/255, alpha: 1)
        static var green = UIColor(red: 117/255, green: 150/255, blue: 96/255, alpha: 1)
        static var blue = UIColor(red: 91/255, green: 104/255, blue: 202/255, alpha: 1)
        static var purple = UIColor(red: 114/255, green: 77/255, blue: 147/255, alpha: 1)
        static var darkBlue = UIColor(red: 15/255, green: 36/255, blue: 92/255, alpha: 1)
        static var black = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
}

let colors: [UIColor] = [
    UIColor.CustomColor.pink,
    UIColor.CustomColor.green,
    UIColor.CustomColor.blue,
    UIColor.CustomColor.purple,
    UIColor.CustomColor.darkBlue,
    UIColor.CustomColor.black,
]


class GameScene: SKScene {
    
    class Cell {
        
        var x: Int
        var y: Int
        
        var color: UIColor
        var flooded: Bool
        
        var left: Cell?
        var right: Cell?
        var top: Cell?
        var bottom: Cell?
        
        
        
        
        init(x: Int, y: Int) {
            self.x = x
            self.y = y
            self.color = (colors.randomElement())!
            self.flooded = false
        }
        
        func setFlooded(flooded: Bool) {
            self.flooded = flooded
        }
        
//        func draw(size: Int) {
//            SKShapeNode(rectOf: CGSize(width: size, height: size))
//        }
    }
    

    var board: [[Cell]]?
    var boardSize: Int?
    let cellSize: Int = 35
    var clicksMade: Int = 0
    var totalClicks: Int?
    var currentFloodColor: UIColor?
    
    let leftMostX: Int = -230
    let topMostY: Int = 300
    
    //override var position: CGPoint = CGPoint(x: 0.5, y: 0.5)
    //override var size: CGSize = 40
    func initBoard(size: Int){
        var newBoard: [[Cell]] = []
        for i in 0...size-1 {
            var newRow: [Cell] = []
            for j in 0...size-1 {
                newRow.append(Cell(x: j, y: i))
            }
            newBoard.append(newRow)
        }
        
        newBoard[0][0].flooded = true
        //newBoard[0][0].setFlooded(flooded: true)
        
        self.board = newBoard
        //self.currentFloodColor = self.board![0][0].color
        //self.floodRest(floodColor: self.currentFloodColor!)
        //print(self.countFlooded())
    }
    
    func linkBoard() {
        for row in 0...self.boardSize! - 1 {
            for col in 0...self.boardSize! - 1 {
                if col < self.boardSize! - 1 { // there's a right
                    self.board![row][col].right = self.board![row][col + 1]
                }
                
                if col > 0 { // there's a left
                    self.board![row][col].left = self.board![row][col - 1]
                }
                
                if row > 0 { // there's a top
                    self.board![row][col].top = self.board![row - 1][col]
                }
                
                if row < self.boardSize! - 1 { // there's a bottom
                    self.board![row][col].bottom = self.board![row + 1][col]
                }
            }
        }
        
        //print(self.bordersFlooded(cell: self.board![1][1]))
        // put function that floods any cells the same color as top left
        //Sself.floodRest(floodColor: self.board![0][0].color)
    }
    
    
    
    func drawCell(size: Int, cell: Cell) {
        let cellToDraw = SKShapeNode(rectOf: CGSize(width: size, height: size))
        cellToDraw.name = String(cell.x) + "-" + String(cell.y)
        cellToDraw.position = CGPoint(x: cell.x * size + self.leftMostX, y: self.topMostY - cell.y * size)
        cellToDraw.fillColor = cell.color
        cellToDraw.strokeColor = cell.color
        
        self.addChild(cellToDraw)
    }
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    // returns true if boardSize is between 4...15 and false if else or boardSize is nil
    func validBoardSize() -> Bool {
        if let b = self.boardSize {
            return (b >= 4 && b <= 15)
        }
        
        return false
    }
    
    override func sceneDidLoad() {
        // show menu and prompt user for board size
//        let mainMenu = SKShapeNode(rectOf: CGSize(width: 200, height: 200))
//        mainMenu.name = "mainMenu"
//        mainMenu.position = CGPoint(x: 0, y: 0)
//        mainMenu.fillColor = UIColor.black
//        mainMenu.strokeColor = UIColor.white
//        
//        self.addChild(mainMenu)
//        
//        var sizeField: UITextField?
//        let alertController = UIAlertController(title: "Enter board size between 4 and 15", message: "blehg", preferredStyle: .alert)
//
//
//        while self.validBoardSize() == false {
//            alertController.addTextField { (textField) in
//                sizeField = textField
//            }
//            self.boardSize = Int(sizeField?.text ?? "0")
//        }
        
        self.boardSize = 13
        // initialize board
        self.initBoard(size: self.boardSize!)
        
        // set # of total clicks
        var x: Double
        if self.boardSize! > 13 {
            x = Double(self.boardSize!) * 1.5 + 6.0
            self.totalClicks = Int(round(x))
        } else if self.boardSize! < 5 {
            self.totalClicks = self.boardSize! + 4
        } else {
            self.totalClicks = self.boardSize! + 7
        }
        
        // link board
        self.linkBoard()
        
        // set flood color to topleft cell
        self.currentFloodColor = self.board![0][0].color
        
        // draw board
        for i in 0...self.boardSize! - 1 {
            for j in 0...self.boardSize! - 1 {
                self.drawCell(size: self.cellSize, cell: self.board![i][j])
            }
        }
        
        let clicksNode = SKLabelNode(text: String(self.clicksMade) + "/" + String(self.totalClicks!))
        clicksNode.name = "clicks"
        clicksNode.position = CGPoint(x: 0, y: -230)
        clicksNode.fontColor = UIColor.black
        
        self.addChild(clicksNode)
        
    }
    
    // checks if every flooded element post click has been colored correctly
    func doneFloodingPostClick(floodColor: UIColor) -> Bool {
        for i in 0...self.boardSize! - 1 {
            for j in 0...self.boardSize! - 1 {
                if self.board![i][j].flooded {
                    if self.board![i][j].color != floodColor {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    func colorNeighbors(row: Int, col: Int) {
        //let c = self.board![row][col]
        //c.color = self.currentFloodColor!
        self.board![row][col].color = self.currentFloodColor!
        if let cell = self.childNode(withName: String(col) + "-" + String(row)) as? SKShapeNode {
            cell.fillColor = self.currentFloodColor!
            cell.strokeColor = self.currentFloodColor!
        }
        
        if row < self.boardSize! - 1 { // there's a bottom so color bottom
            if self.board![row][col].bottom!.flooded == true {
                self.board![row + 1][col].color = self.currentFloodColor!
                if let cell = self.childNode(withName: String(col) + "-" + String(row + 1)) as? SKShapeNode {
                    cell.fillColor = self.currentFloodColor!
                    cell.strokeColor = self.currentFloodColor!
                }
            }
        }
        
        if col < self.boardSize! - 1 { // there's a right so color right
            if self.board![row][col].right!.flooded == true {
                self.board![row][col + 1].color = self.currentFloodColor!
                if let cell = self.childNode(withName: String(col + 1) + "-" + String(row)) as? SKShapeNode {
                    cell.fillColor = self.currentFloodColor!
                    cell.strokeColor = self.currentFloodColor!
                }
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    // dont need
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
     // dont need
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    func bordersFlooded(cell: Cell) -> Bool {
        if cell.x < self.boardSize! - 1 { // check right
            if cell.right?.flooded == true {
                
                return true
            }
        }
        
        if cell.x > 0 { // check left
            if cell.left?.flooded == true {
                return true
            }
        }
        
        if cell.y < self.boardSize! - 1 { // check bottom
            if cell.bottom?.flooded == true {
                return true
            }
        }
        
        if cell.y > 0 { // check top
            if cell.top?.flooded == true {
                return true
            }
        }
        
        return false
    }
    
    // mark every necessary cell as flooded if it's next to flooded cells
    func floodRest(floodColor: UIColor) {
        
        for row in 0...self.boardSize! - 1 {
            for col in 0...self.boardSize! - 1 {
                if self.bordersFlooded(cell: self.board![row][col]) && self.board![row][col].color == floodColor {
                    self.board![row][col].flooded = true
                }
            }
        }
    }
    
    func countFlooded() -> Int {
        var count = 0
        for row in 0...self.boardSize! - 1 {
            for col in 0...self.boardSize! - 1 {
                if self.board![row][col].flooded == true {
                    count += 1
                }
            }
        }
        
        return count
    }
    
    func gameWon() -> Bool {
        if self.doneFloodingPostClick(floodColor: self.currentFloodColor!) {
            if self.clicksMade <= self.totalClicks! {
                for row in 0...self.boardSize! - 1 {
                    for col in 0...self.boardSize! - 1 {
                        if self.board![row][col].color != self.currentFloodColor {
                            return false
                        }
                    }
                }
                return true
            }
            
            return false
        }
        return false
        
    }
    
    func gameLost() -> Bool {
        if self.doneFloodingPostClick(floodColor: self.currentFloodColor!) {
            if self.clicksMade == self.totalClicks! {
            for row in 0...self.boardSize! - 1 {
                for col in 0...self.boardSize! - 1 {
                    if self.board![row][col].color != self.currentFloodColor {
                        return true
                    }
                }
            }
        }
            return false
        }
        return false
    }
    
//    func printFlooded() {
//        for i in 0...self.boardSize! - 1 {
//            for j in 0...self.boardSize! - 1 {
//                if self.board![i][j].flooded == true {
//                    print("row " + String(i) + " col " + String(j))
//                }
//            }
//        }
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // get touch and use position to find specific sprite that was clicked
        let touch = touches.first!
        let posInScene = touch.location(in: self)
        let node = self.atPoint(posInScene)
        
        
        if let name = node.name {
            switch name {
                case "pink":
                    if self.currentFloodColor != UIColor.CustomColor.pink {
                        self.currentFloodColor = UIColor.CustomColor.pink
                        self.floodRest(floodColor: self.currentFloodColor!)
                    }
                case "blue":
                    if self.currentFloodColor != UIColor.CustomColor.blue {
                        self.currentFloodColor = UIColor.CustomColor.blue
                        self.floodRest(floodColor: self.currentFloodColor!)
                    }
                case "darkBlue":
                    if self.currentFloodColor != UIColor.CustomColor.darkBlue {
                        self.currentFloodColor = UIColor.CustomColor.darkBlue
                        self.floodRest(floodColor: self.currentFloodColor!)
                    }
                case "green":
                    if self.currentFloodColor != UIColor.CustomColor.green {
                        self.currentFloodColor = UIColor.CustomColor.green
                        self.floodRest(floodColor: self.currentFloodColor!)
                    }
                case "black":
                    if self.currentFloodColor != UIColor.CustomColor.black {
                        self.currentFloodColor = UIColor.CustomColor.black
                        self.floodRest(floodColor: self.currentFloodColor!)
                    }
                case "purple":
                    if self.currentFloodColor != UIColor.CustomColor.purple {
                        self.currentFloodColor = UIColor.CustomColor.purple
                        self.floodRest(floodColor: self.currentFloodColor!)
                    }
                default:
                    break
            }
            
            self.clicksMade += 1
            if let clicksNode = self.childNode(withName: "clicks") as? SKLabelNode {
                clicksNode.text = String(self.clicksMade) + "/" + String(self.totalClicks!)
            }
            //self.printFlooded()
        }
        
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    // makes sure all flooded cells are colored correctly
    func updateBoard() {
        for y in 0...self.boardSize! - 1 {
            for x in 0...self.boardSize! - 1 {
                if self.board![y][x].flooded == true
                    && self.board![y][x].color != self.currentFloodColor {
                    self.colorNeighbors(row: y, col: x)
                    break
                }
            }
        }
    }
    
    func drawMenu(win: Bool) {
        let menu = SKShapeNode(rectOf: CGSize(width: 200, height: 200))
        menu.name = "menu"
        menu.position = CGPoint(x: 0, y: 0)
        menu.fillColor = UIColor.blue
        
        let title = SKLabelNode(text: win ? "Nice!" : "dang bro")
        menu.addChild(title)
        
        self.addChild(menu)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        self.updateBoard()
        self.floodRest(floodColor: self.currentFloodColor!)
        
        if self.gameWon() {
            if self.childNode(withName: "menu") is SKLabelNode {

            } else {
                self.drawMenu(win: true)
            }
        }
        
        if self.gameLost() {
            if self.childNode(withName: "menu") is SKLabelNode {

            } else {
                self.drawMenu(win: false)
            }
        }

        
//        for y in 0...self.boardSize! - 1 {
//            for x in 0...self.boardSize! - 1 {
//                if self.board![y][x].flooded == true
//                    && self.board![y][x].color != self.currentFloodColor {
//                    self.colorNeighbors(row: y, col: x)
//                }
//            }
//        }
        
    }
}
