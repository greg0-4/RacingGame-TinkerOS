$SP,"<1>",BI=1$






$SP,"<2>",BI=2$






$SP,"<3>",BI=3$
//1









































/*
44
*/




$SP,"<4>",BI=4$
//1









































/*
44
*/

#include "~/GameDev/PointSound.HC.Z";


public CBGR48 gr_palette_game[COLORS_NUM]=
{
  0x000000000000,0x00000000AAAA,0x0000AAAA0000,0x0000AAAAAAAA,
  0xAAAA00000000,0xAAAA0000AAAA,0xAAAA55550000,0xAAAAAAAAAAAA,
  0x555555555555,0x55555555FFFF,0x5555FFFF5555,0x5555FFFFFFFF,
  0xFFFF55555555,0xFFFF5555FFFF,0xFFFFFFFF5555,0x222222222222
};



I64 SpeedModifier = 0;
I64 framecount = 0;
Bool showFirst = TRUE;


SetFPS(60);

class Player{
I64 lane,xcord,score;
Bool gaming; 
};

class Keys{
Bool left,right,space;
};

class EnemyCar{
I64 lane,xcord,ycord;
Bool initialized;
};


Player player;
Keys keys;
EnemyCar ecar;

U0 Init() {
QueInit(&player);
QueInit(&keys);
QueInit(&ecar);
}



I64 CheckCollision(I64 rect1x,I64 rect1y,I64 rect1width,I64 rect1height,I64 rect2x,I64 rect2y,I64 rect2width,I64 rect2height){
if(rect1x > rect2x + rect2width){
return 0;
}
if(rect1x + rect1width < rect2x){
return 0;
}
if(rect1y > rect2y + rect2height){
return 0;
}
if(rect1y + rect1height < rect2y){
return 0;
}

return 1;
}


U0 InitCar(){
ecar.lane = RandRange(1,2);
ecar.ycord = 0;
}



U0 UpdateCar(){
ecar.ycord = ecar.ycord+5+(player.score/2000);
}

U0 DrawIt(CTask *task, CDC *dc)
{

if(player.gaming){
if(!ecar.initialized){
InitCar;
ecar.initialized=TRUE;
}



if(ecar.ycord>300){
player.score = player.score + 100;
ecar.initialized=FALSE;
Noise(100,60,80);
}

UpdateCar;
if(keys.left){
player.lane = player.lane - 1;
keys.left=FALSE;
}else{
if(keys.right) {
player.lane = player.lane + 1;
keys.right=FALSE;
}
}
if(keys.space){
SpeedModifier = 5;
keys.space=FALSE;
}else{
SpeedModifier = 0;
}
}


if(player.lane>2){
player.lane=2;
}
if(player.lane<1){
player.lane=1;
}

if(ecar.lane==1){
ecar.xcord=200;
}

if(ecar.lane==2){
ecar.xcord=300;
}



if(player.lane==1){
player.xcord=200;
}
if(player.lane==2){
player.xcord=300;
}


GrPrint(dc,0,0,"Score: %d",player.score);


Bool colli = CheckCollision(player.xcord,200,56,40,ecar.xcord,ecar.ycord,56,40);
   
if(colli){
GrPrint(dc,0,8,"Game Over!");
    player.gaming=FALSE;
}


if(++framecount > 10){
framecount = 0;
showFirst = !showFirst;
}

if(player.gaming){
if(showFirst){
Sprite3(dc,190,0,0,$IB,"<3>",BI=3$);
}else{
Sprite3(dc,190,0,0,$IB,"<4>",BI=4$);
}
}else{
Sprite3(dc,190,0,0,$IB,"<3>",BI=3$);
}
// GrPrint(dc,0,16,"Frame count:%d",framecount);
Sprite3B(dc,player.xcord,200,1,$IB,"<1>",BI=1$);
if(ecar.ycord<300){
Sprite3B(dc,ecar.xcord,ecar.ycord,1,$IB,"<2>",BI=2$);
}
}


U0 Main() {
I64 sc;
I64 sc2;
CDC *dc=DCAlias;
SettingsPush;
WinMax;
DocCursor;
DocClear;
$FG$
PopUpOk($FG,14$"Press OK to start the game, you control the cars with arrow keys$ER$$FG,0$");
// GrPaletteSet(gr_palette_game);
$FG,15$$FG,8$$FG,0$keys.right=FALSE;$FG$
keys.left=FALSE;
player.score = 0;
player.gaming=TRUE;
ecar.initialized=FALSE;
Fs->draw_it=&DrawIt;
Init;


try{
while(TRUE){
switch(GetKey(&sc)){
case '\n':
Init;
break;
case CH_ESC:
case CH_SHIFT_ESC:
goto fs_done;
break;
case 0:
switch(sc.u8[0]){
case SC_CURSOR_RIGHT:
keys.right=TRUE;
break;
case SC_CURSOR_LEFT:
keys.left=TRUE;
break;
}
}
}

fs_done:
}catch{
DocClear;
PutExcept;
SettingsPop;
MenuPop;
GrPaletteSet(gr_palette_std);
}

}

Main;        �     
       0       
0       0   (   
0   (      (   
   (                  
0       8       
8       8      
8      8      
8      0      
0      8      
8      8   (   
8   (   0   (   
              
   (       (   
    (          
             
             
               
               
      (      
(      (      
(            
               	          3      6   !                  �     
               
             
               
          (   
   (       (   
    (          
             
       0       
0       0   (   
0   (      (   
0       8       
8       8      
8      0      
0      8      
8      8   (   
8   (   0   (   
      (      
(      (      
(            
                         6   	   3       	                    �     
       �      
�      �   `  
�   `  �   h  
�   h      h  
    h         8   �    
X      `      
`      `       
`       X       
X       X      
X   (   X   8   
X   @   X   P   
X   X   X   h   
X   p   X   �   
X   �   X   �   
X   �   X   �   
X   �   X   �   
X   �   X   �   
X   �   X   �   
X      X     
X     X   (  
X   0  X   @  
X   H  X   X  
X   X  `   X  
`   X  `   H  
`   H  X   H  
X   @  `   @  
`   @  `   0  
`   0  X   0  
X   (  `   (  
`   (  `     
`     X     
X     `     
`     `      
`      X      
X   �   `   �   
`   �   `   �   
`   �   X   �   
X   �   `   �   
`   �   `   �   
`   �   X   �   
X   �   `   �   
`   �   `   �   
`   �   X   �   
X   �   `   �   
`   �   `   �   
`   �   X   �   
X   �   `   �   
`   �   `   �   
`   �   X   �   
X   �   `   �   
`   �   `   p   
`   p   X   p   
X   h   `   h   
`   h   `   X   
`   X   X   X   
X   P   `   P   
`   P   `   @   
`   @   X   @   
X   8   `   8   
`   8   `   (   
`   (   X   (   \      [   3   ]   G   ]   \   [   z   \   �   \   �   \   �   [   �   \   �   \   
  \   "  \   9  Z   N          �     
           h  
       �      
�      �   h  
�   h      h  0   x    
X      X      
X      `      
`      `      
X       `       
`       `   0   
`   0   X   0   
X   0   X       
X   8   `   8   
`   8   `   H   
`   H   X   H   
X   H   X   8   
X   P   `   P   
`   P   `   `   
`   `   X   `   
X   `   X   P   
X   h   `   h   
`   h   `   x   
`   x   X   x   
X   x   X   h   
X   �   `   �   
`   �   `   �   
`   �   X   �   
X   �   X   �   
X   �   `   �   
`   �   `   �   
`   �   X   �   
X   �   X   �   
X   �   `   �   
`   �   `   �   
`   �   X   �   
X   �   X   �   
X   �   `   �   
`   �   `   �   
`   �   X   �   
X   �   X   �   
X   �   `   �   
`   �   `   �   
X   �   X   �   
X   �   `   �   
X   �   `   �   
`   �   `     
`     X     
X     X   �   
X     `     
`     `      
`      X      
X      X     
X   (  `   (  
`   (  `   8  
`   8  X   8  
X   8  X   (  
X   @  `   @  
`   @  `   P  
`   P  X   P  
X   P  X   @  
X   X  `   X  
`   X  `   h  
X   X  X   h  ]      \   #   ]   C   ^   [   ^   o   \   �   \   �   ]   �   [   �   ]   �   [     Z     [   1  [   F  \   c   