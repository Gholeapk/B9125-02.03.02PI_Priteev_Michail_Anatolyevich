unit u_bug;

interface
uses graphABC;

type bug=class
  private
  r,x,y:word;
  c:color;
  dx,dy:integer;
  public
  constructor create(xx,yy:word; rr:word;cc:color);
  constructor create(b:bug);
  function get_r:word;
  procedure set_r(rr:word);
  procedure draw;
  function meat(b:bug):boolean;
  procedure hide;
  procedure set_dx_dy(_dx,_dy:integer);
  procedure move;
  function get_x:word;
end;

implementation

procedure bug.set_r(rr:word);
begin
  r:=rr;
end;

function bug.get_r:word;
begin
  result:=r;
end;

constructor bug.create(xx,yy,rr:word;cc:color);
begin
  r:=rr;
  x:=xx;
  y:=yy;
  c:=cc;
  if (x<r)or(y<r)or(x>windowwidth-r)or(y>windowheight-r)or(r>(windowwidth div 2))or(r>(windowheight div 2)) then begin
    x:=windowwidth div 2;
    y:=windowheight div 2;
    r:=10;
  end;
end;

function bug.meat(b:bug):boolean;
begin
  if (x-b.x)*(x-b.x)+(y-b.y)*(y-b.y)<=(r+b.r)*(r+b.r) then 
    result:=true
  else 
    result:=false;
end;

constructor bug.Create(b:bug);
begin
  x:=b.x;
  y:=b.y;
  c:=b.c;
  r:=b.r;
  dx:=b.dx;
  dy:=b.dy
end;

procedure bug.draw;
var 
  w: integer;
  pts1, pts2: array of Point;
begin
  w := r div 2; // ширина полосок крестика
  
  // Рисуем X-образную форму из двух пересекающихся полос
  setpencolor(c);
  setbrushcolor(c);
  
  // Первая полоса: из левого верха в правый низ
  pts1 := new Point[4];
  pts1[0] := new Point(x-r, y-w);
  pts1[1] := new Point(x-w, y-r);
  pts1[2] := new Point(x+r, y+w);
  pts1[3] := new Point(x+w, y+r);
  polygon(pts1);
  
  // Вторая полоса: из правого верха в левый низ
  pts2 := new Point[4];
  pts2[0] := new Point(x+w, y-r);
  pts2[1] := new Point(x+r, y-w);
  pts2[2] := new Point(x-w, y+r);
  pts2[3] := new Point(x-r, y+w);
  polygon(pts2);
  
  // Рисуем глазки (белые)
  setbrushcolor(clwhite);
  setpencolor(clwhite);
  circle(x - r div 3, y - r div 4, r div 5);
  circle(x + r div 3, y - r div 4, r div 5);
  
  // Рисуем зрачки (черные)
  setbrushcolor(clblack);
  setpencolor(clblack);
  circle(x - r div 3, y - r div 4, r div 10);
  circle(x + r div 3, y - r div 4, r div 10);
  
  // Рисуем щечки (розовые)
  setbrushcolor(clpink);
  setpencolor(clpink);
  circle(x - r*2 div 3, y + r div 6, r div 8);
  circle(x + r*2 div 3, y + r div 6, r div 8);
  
  // Рисуем радостную улыбку (меньшего размера, выше)
  setpencolor(clwhite);
  setbrushcolor(clwhite);
  setpenwidth(2);
  arc(x, y + r div 5, r div 3, 200, 340);
  setpenwidth(1);
end;

procedure bug.hide;
begin
  setpencolor(clwhite);
  setbrushcolor(clwhite);
  fillrect(x - r - 2, y - r - 2, x + r + 2, y + r + 2);
end;

procedure bug.move;
begin
  hide;
  x:=x+dx; y:=y+dy;
  if (x<r)or(windowwidth-r<x)then begin
    x:=x-dx;
    dx:=-dx
  end;
  if (y<r)or(windowheight-r<y) then begin
    y:=y-dy;
    dy:=-dy;
  end;
  draw;
end;

procedure bug.set_dx_dy(_dx,_dy:integer);
begin
  dx:=_dx;
  dy:=_dy
end;

function bug.get_x:word;
begin
  result := x;
end;

begin
  
end.