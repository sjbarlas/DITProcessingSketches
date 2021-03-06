import ddf.minim.*;


class LifeBoard
{
  boolean[][] current;
  boolean[][] next;
  int cellWidth = 3;
  int cellHeight = 3;
  int boardWidth;
  int boardHeight;
  float fps = 50;
  boolean paused = true;
  float elapsed = 0;
  
  float timeDelta = 1.0f / 60.0f;
  Minim minim;
  
  AudioPlayer walkerSound;
  AudioPlayer tumblerSound;
  AudioPlayer backgroundSong;
  AudioPlayer spaceShipSound;
  AudioPlayer gosperSound;
  
  LifeBoard()
  {
  }
  
  void on(int x, int y)
  {
      if ((x >= 0) && (x < boardWidth) && (y >= 0) && (y < boardHeight))
      {
          current[y][x] = true;
      }
  }

  PVector screenToCell(int screenX, int screenY)
  {
      PVector ret = new PVector();
      ret.x = screenX / cellWidth;
      ret.y = screenY / cellHeight;
      return ret;
  }
  
  void toggle(int x, int y)
  {
    if ((x >= 0) && (x < boardWidth) && (y >= 0) && (y < boardHeight))
      {
          current[y][x] = ! current[y][x];
      }
  }

  void off(int x, int y)
  {      
      if ((x >= 0) && (x < boardWidth) && (y >= 0) && (y < boardHeight))
      {
          current[y][x] = false;
      }
  }
  
  void randomise()
  {
      int live = (boardHeight * boardWidth) / 2; // 50% coverage
      while (live > 0)
      {
          int x = (int) random(boardWidth);
          int y = (int) random(boardHeight);
          if (!current[y][x])
          {
              current[y][x] = true;
              live--;
          }
      }          
  }
        
  int countLiveCellsSurrounding(int x, int y)
    {
        int count = 0;
        
        // Check to the left
        if ((x > 0) && (current[y][x - 1]))
        {
            count++;
        }
        // Check above left
        if ((x > 0) && (y > 0) && (current[y - 1][x - 1]))
        {
            count++;
        }
        // Check above
        if ((y > 0) && (current[y - 1][x]))
        {
            count++;
        }
        // Check above right
        if ((y > 0) && (x < (boardWidth - 1)) && (current[y - 1][x + 1]))
        {
            count++;
        }
        // Check right
        if ((x < (boardWidth - 1)) && (current[y][x + 1]))
        {
            count++;
        }

        // Check bottom right
        if ((y < (boardHeight - 1) ) && (x < (boardWidth - 1)) && (current[y + 1][x + 1]))
        {
            count++;
        }

        // Check bottom 
        if ((y < (boardHeight - 1)) && (current[y + 1][x]))
        {
            count++;
        }

        // Check bottom left 
        if ((x >0) && (y < (boardHeight - 1)) && (current[y + 1][x - 1]))
        {
            count++;
        }

        return count;
    }

    void clear()
    {
        clearBoard(current);
    }

    void clearBoard(boolean[][] board)
    {
        for (int x = 0; x < boardWidth; x++)
        {
            for (int y = 0; y < boardHeight; y++)
            {
                board[y][x] = false;
            }
        }
    }
        
    void setup()
    {
      
      minim = new Minim(ProcessingLife.this);
  
      walkerSound = minim.loadFile("124919__altemark__highfreqloop.wav");
      tumblerSound = minim.loadFile("6340__jovica__ppg-019-brassy-g-3.wav");
      backgroundSong = minim.loadFile("08 - Duktus.mp3");
      spaceShipSound = minim.loadFile("1956__miulew__mechanic3.wav");
      gosperSound = minim.loadFile("3007__jovica__stab-096-mastered-16-bit.wav");
      
      boardWidth = width / cellWidth;
      boardHeight = height / cellHeight;
      
      current = new boolean[boardHeight][boardWidth];
      next = new boolean[boardHeight][boardWidth];
      //randomBoard();            
    }
    
    void makeGosperGun(int x, int y)
    {
        gosperSound.rewind();
        gosperSound.play();
        on(x + 23, y);
        on(x + 24, y);
        on(x + 34, y);
        on(x + 35, y);

        on(x + 22, y + 1);
        on(x + 24, y + 1);
        on(x + 34, y + 1);
        on(x + 35, y + 1);

        on(x + 0, y + 2);
        on(x + 1, y + 2);
        on(x + 9, y + 2);
        on(x + 10, y + 2);
        on(x + 22, y + 2);
        on(x + 23, y + 2);

        on(x + 0, y + 3);
        on(x + 1, y + 3);
        on(x + 8, y + 3);
        on(x + 10, y + 3);

        on(x + 8, y + 4);
        on(x + 9, y + 4);
        on(x + 16, y + 4);
        on(x + 17, y + 4);

        on(x + 16, y + 5);
        on(x + 18, y + 5);

        on(x + 16, y + 6);

        on(x + 35, y + 7);
        on(x + 36, y + 7);

        on(x + 35, y + 8);
        on(x + 37, y + 8);

        on(x + 35, y + 9);

        on(x + 24, y + 12);
        on(x + 25, y + 12);
        on(x + 26, y + 12);

        on(x + 24, y + 13);

        on(x + 25, y + 14);
    }

    void makeLightWeightSpaceShip(int x, int y)
    {
        spaceShipSound.rewind();
        spaceShipSound.play();
        on(x + 1, y);
        on(x + 2, y);
        on(x + 3, y);
        on(x + 4, y);

        on(x, y + 1);
        on(x + 4, y + 1);

        on(x + 4, y + 2);

        on(x, y + 3);
        on(x + 3, y + 3);
    }


    void makeTumbler(int x, int y)
    {
        tumblerSound.rewind();
        tumblerSound.play();
        on(x + 1, y);
        on(x + 2, y);
        on(x + 4, y);
        on(x + 5, y);
        
        on(x + 1, y + 1);
        on(x + 2, y + 1);
        on(x + 4, y + 1);
        on(x + 5, y + 1);

        on(x + 2, y + 2);
        on(x + 4, y + 2);

        on(x, y + 3);
        on(x + 2, y + 3);
        on(x + 4, y + 3);            
        on(x + 6, y + 3);

        on(x, y + 4);
        on(x + 2, y + 4);
        on(x + 4, y + 4);
        on(x + 6, y + 4);

        on(x, y + 5);
        on(x + 1, y + 5);
        on(x + 5, y + 5);
        on(x + 6, y + 5);          
    }


    void makeGlider(int x, int y)
    {      
      walkerSound.rewind();
      walkerSound.play();
      on(x + 1, y);
      on(x + 2, y + 1);
      on(x, y + 2);
      on(x + 1, y + 2);
      on(x + 2, y + 2);
    }
    
    
    
    void update()
    {
        float needsToPass = 1.0f / fps;
        
        elapsed += timeDelta;
        if (!paused && (elapsed > needsToPass))
        {
            clearBoard(next);

            for (int x = 0; x < boardWidth; x++)
            {
                for (int y = 0; y < boardHeight; y++)
                {
                    int count = countLiveCellsSurrounding(x, y);
                    if (current[y][x])
                    {
                        // Any live cell with less than 2 live neighbours dies
                        if (count < 2)
                        {
                            next[y][x] = false;
                        }

                        // Any live cell with 2 or 3 live neighbours survives
                        if ((count == 2) || (count == 3))
                        {
                            next[y][x] = true;
                        }

                        // Any live cell > 3 live neighbours dies due to overcrowding
                        if (count > 3)
                        {
                            next[y][x] = false;
                        }
                    }
                    else
                    {
                        // Any dead cell with exactly 3 neighbours comes to life due to reproduction
                        if (count == 3)
                        {
                            next[y][x] = true;
                        }
                    }
                }
            }
            // Swap current and next
            boolean[][] temp;
            temp = current;
            current = next;
            next = temp;
            elapsed = 0.0f;
        }
    }
    
    void draw()
    {
        for (int x = 0; x < boardWidth; x++)
        {
            for (int y = 0; y < boardHeight; y++)
            {
                PVector pos = new PVector(x * cellWidth, y * cellHeight);                    
                if (current[y][x])
                {                    
                    if (paused)
                    {
                        fill(127, 127, 127);                            
                    }
                    else
                    {
                        fill(0,255,0);
                    }
                    rect(pos.x, pos.y, cellWidth, cellHeight);                    
                }                 
            }
        }
    }
}
