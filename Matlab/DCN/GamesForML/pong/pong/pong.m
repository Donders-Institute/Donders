function pong
global curKey;
global MainCanvas;
global CloseReq;
%Create Canvas
[Canvas, MainCanvas] = CreateCanvas(600,400);

%Create paddle (Player 1)
Player1 =  rectangulo(25,200-75,10,75,'white');

%Create paddle (Palyer2)
Player2 = rectangulo(600-25,200-55,10,75,'white');

%Create pong ball
PongBall = circulo(300,200,10,'white');

%Create text to show score
Player1ScoreText = text(100, 25, '0', 'FontSize', 20, 'Color',[1 1 1], 'HorizontalAlignment', 'center');
Player2ScoreText = text(500, 25, '0', 'FontSize', 20, 'Color',[1 1 1], 'HorizontalAlignment', 'center');

%Start score
Player1Score = 0;
Player2Score = 0;

%Pause to let images load
pause(1)

%initial velocity of ball
Ballx = -5;
Bally = 5;

while 1
    
    
    
    movePlayer1()
    
    moveBall()
    
    movePlayer2()
    
    TopAndBottomLimitsBall
    
    LeftAndRightLimitsBall
    
    HitPlayer
    
    %Pause to allow rendering 0.03s => 30 frames per sec
    pause(0.03)
    
    %Close game
    if CloseReq ==1
        delete(Canvas)
        clear all
        return
    end
    
end


%Function so that player 2 tracks allows the ball
    function movePlayer2()
        %If player2 moves off the canvas area don't let
        if Player2.YData(3) > 0 &&  Player2.YData(1) < 400-25 
            %By always having the same y position of the ball player 2 will
            %always hit the ball
            Player2.YData = Player2.YData + Bally;
        end
        
    end




    function HitPlayer
        %Function that calculates if the ball hit one of the players and
        %calculate new direction of the ball
        
        %If ball passed x position of the paddle don't calculate new
        %direction (to stop something like the ball is being the player can
        %changes direction)
        if PongBall.Position(1) > 25 && PongBall.Position(1) < 600-25
            
            %If distance of the ball is within the distance of the player
            %then the ball is hitting the players' paddle
            if PongBall.Position(1)-5 < Player1.XData(2) && PongBall.Position(2) > Player1.YData(1) && PongBall.Position(2) < Player1.YData(3)
                %Calculate new direction of the ball
                MaxWidth = Player1.YData(3) - Player1.YData(1) ;
                Percentage = (PongBall.Position(2) - Player1.YData(1))/MaxWidth;
                NewBallDirection = 90*Percentage - 45;
                VectorVelocityBall = sqrt(Bally^2 + Ballx^2);
                Bally = VectorVelocityBall*sind(NewBallDirection);
                Ballx = VectorVelocityBall*cosd(NewBallDirection);
                %Increase velocity of the ball with each hit
                Bally = Bally + Bally/Bally*2;
                Ballx = Ballx + Ballx/Ballx*2 ;
                
            end
            
            %Same for player 2
            if PongBall.Position(1)+12 > Player2.XData(1) && PongBall.Position(2) > Player2.YData(1) && PongBall.Position(2) < Player2.YData(3)
                MaxWidth = Player2.YData(3) - Player2.YData(1) ;
                Percentage = (PongBall.Position(2) - Player2.YData(1))/MaxWidth;
                NewBallDirection = 90*Percentage - 45;
                VectorVelocityBall = sqrt(Bally^2 + Ballx^2);
                Bally = VectorVelocityBall*sind(NewBallDirection);
                Ballx = -VectorVelocityBall*cosd(NewBallDirection);
                Bally = Bally + Bally/Bally*2;
                Ballx = Ballx + Ballx/Ballx*2 ;
            end
            
        end
    end


    function TopAndBottomLimitsBall
        %If ball hit the top or bottom change direction
        if  (PongBall.Position(2) < 0) || (PongBall.Position(2) > 400 - 10)
            Bally = -1*Bally; %Change direction
        end
    end



    function LeftAndRightLimitsBall
        
        %If ball passes player 1 reset game and add ne point to player 2
        if (PongBall.Position(1) < 0)
            Player2Score = Player2Score + 1;
            Player2ScoreText.String = num2str(Player2Score);
            %Player 2 scores points
            ResetGame(2)
            
        end
        
        if (PongBall.Position(1) > 600-10)
            Player1Score = Player1Score + 1;
            Player1ScoreText.String = num2str(Player1Score);
            %Player 1 scores points
            ResetGame(1)
        end
        
    end


    function ResetGame(player)
        %Reset position of player 2 and ball
        PongBall.Position(1) = 300; %Reset x position
        PongBall.Position(2) = 200; % Reset y position
        Player2.XData = [575 585 585 575];
        Player2.YData = [145 145 220 220];
        %         600-25,200-55
        Ballx = 5;
        Bally = 5;
        %Change staring direction of the ball so that it goes to the player
        %that suffered the goal
        if player == 2
            Ballx = -1*Ballx;
        end
        
    end







    function moveBall()
        %Move ball
        PongBall.Position(1) = PongBall.Position(1) + Ballx;
        PongBall.Position(2) = PongBall.Position(2) + Bally;
        
    end


%move player 1 by it's arrows
    function movePlayer1()
        switch true
            case strcmp(curKey, 'uparrow')
                if Player1.YData(1) >0
                    Move(Player1,0,-10)
                end
            case strcmp(curKey, 'downarrow')
                if Player1.YData(1) < 400-75
                    Move(Player1,0,10)
                end
        end
    end

end