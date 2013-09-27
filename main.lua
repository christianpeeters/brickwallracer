-- 2013 by Christian Peeters -- 
-- christianpeeters.com for complete tutorial --


-- general stuff
display.setStatusBar(display.HiddenStatusBar)
local cWidth = display.contentCenterX
local cHeight = display.contentCenterY

-- global variables
local createGame
local touchCar
local createCar
local stopGame
local hitWall
local score = 0
local timeLimit =3
local scorelabel
local wall
local car
local carArray
local BLUE_CAR = 1

-- loaded audio
local crash = audio.loadSound ("crash.mp3")
local brake = audio.loadSound ("break.mp3")
-- Create titleScreen
local function createTitleScreen()
	
	local titlescreen = display.newImage("titlescreen.png")
	local startgametext = display.newText("Click here to start", 0 , 0, "Helvetica" , 24 )
	startgametext.x = cWidth
	startgametext.y = cHeight +100
	startgametext:setTextColor(0,0,0)


	
	local function startPressed(event)
		display.remove(event.target)
		display.remove(titlescreen)
		startgametext = nil
		createGame()

	end
		
	startgametext:addEventListener ( "tap", startPressed )

end

-- GameMethods



function createGame()
		

		local gamebackground = display.newImage("gamebackground.png")

		wall = display.newImage("wall.png")
		wall.x = display.contentWidth 
		local backbutton = display.newImage("back.png")
		backbutton.xScale = 0.4; backbutton.yScale = 0.4
		backbutton.x = 40
		backbutton.y = 40
		
			function stopGame()
				car:removeSelf()
				car = nil 
				createTitleScreen()
			 end
		
		backbutton:addEventListener ( "tap", stopGame )

		scorelabel = display.newText( "Score: 0", 0, 0, "Helvetica", 22 )
		scorelabel.x = display.contentWidth - 75
		score = 0	
		timeLimit = 3
		wall.crashnumber = 3
		
		timeLeft = display.newText(timeLimit, cWidth-10, cHeight-30, "Helvetica", 50)

		local function timerDown()
  		 timeLimit = timeLimit-1
   		timeLeft.text = timeLimit
     			if(timeLimit==0)then
       				 createCar()
       				 timeLeft.isVisible = false
       				timeLimit:removeSelf()
						timeLimit = nil 
     			end
  end
		timer.performWithDelay(1000,timerDown,timeLimit)
end


function createCar()
	carArray = { "carblue.png", "cargreen.png",  "carred.png",  "caryellow.png"  }
	carType = math.random (#carArray )    
   car = display.newImage( carArray [ carType ] )
	
	car.x = -200
	car.y = math.random (0, display.contentHeight)
	car.xScale = 0.2
	car.yScale = 0.2
	car:rotate (90)
	car.type = carType
	
	car.moves = transition.to (car, {time = 3000,  x=display.contentWidth-30 , y=math.random(0,display.contentHeight), onComplete = hitWall } )
	car:addEventListener ( "tap", touchCar )
	
	return car
end


function touchCar(event)
	local cartouched = event.target
	transition.cancel ( event.target.moves )
	audio.play(brake)
	cartouched:rotate (370)
			
	if  cartouched.type == BLUE_CAR  then
		score = score + 15
		else score = score +5
	end
	scorelabel.text = "Score: ".. score 
		local function removeCar()
			display.remove(cartouched)
		end	
	timer.performWithDelay(600, removeCar)
	
	createCar()
end

function hitWall(obj)
	
		local function resetWall()
			wall.xScale =1
			wall.yScale = 1
		
				local function removeCar()
					display.remove(obj)
				end
		timer.performWithDelay ( 1200, removeCar )
		end
		car.xScale =0.22
		car.yScale = 0.22
		car:rotate (math.random (-90, 90))
		lifeCount()
		audio.play(crash)
		
		transition.to ( wall, { time=200, xScale=1.1, yScale=1.1, alpha=1, onComplete = resetWall } )
		
		if wall.crashnumber > 0 then	
			createCar()
		end
end

function lifeCount()
	wall.crashnumber = wall.crashnumber  - 1
	if wall.crashnumber <1 then
		gameovertext = display.newText("Game Over", cWidth-80, cHeight, "Helvetica", 24)
		timer.performWithDelay ( 1500, createTitleScreen )
	end
end


createTitleScreen()