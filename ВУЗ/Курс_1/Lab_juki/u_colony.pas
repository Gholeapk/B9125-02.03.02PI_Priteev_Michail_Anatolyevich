unit u_colony;

interface
uses u_bug, GraphABC;

type colony = class
private
  clr:color;
  max,cur:byte;
  ar:array of bug;
public
  constructor Create(c:color;m:byte);
  procedure add(b:bug);
  procedure move;
  procedure draw;
  procedure life;
  procedure hide;
  procedure war(c:colony);
end;

implementation

constructor colony.Create(c:color;m:byte);
begin
  clr:=c;
  max:=m;
  cur:=0;
  ar:=new bug[m];
end;

procedure colony.add(b:bug);
begin
  if cur < max then
  begin
    ar[cur]:=bug.create(b);
    cur += 1;
  end;
end;

procedure colony.life;
var i,j:integer; b:bug;
begin
  for i:=0 to cur-2 do
    for j:=i+1 to cur-1 do
      if ar[i].meat(ar[j]) then
      begin
        b:=bug.create(20+random(100), 20+random(100), (ar[i].get_r+ar[j].get_r) div 2, clr);
        b.set_dx_dy(random(10)-5, random(10)-5);
        add(b);
      end;
end;

procedure colony.war(c:colony);
var k,i,j:integer;
begin
  i := 0;
  while i < cur do
  begin
    j := 0;
    while j < c.cur do
    begin
      if (ar[i] <> nil) and (c.ar[j] <> nil) and ar[i].meat(c.ar[j]) then
      begin
        if ar[i].get_r > c.ar[j].get_r then
        begin
          ar[i].set_r(ar[i].get_r + c.ar[j].get_r div 2);  // Исправлено: было c.ar[i]
          c.ar[j].hide;
          for k := j+1 to c.cur-1 do
            c.ar[k-1] := c.ar[k];
          c.cur := c.cur - 1;
          // Не увеличиваем j, так как элементы сдвинулись
        end
        else if ar[i].get_r < c.ar[j].get_r then
        begin
          c.ar[j].set_r(c.ar[j].get_r + ar[i].get_r div 2);
          ar[i].hide;
          for k := i+1 to cur-1 do
            ar[k-1] := ar[k];
          cur := cur - 1;
          break;  // Выходим из внутреннего цикла, так как ar[i] удален
        end
        else
          inc(j);
      end
      else
        inc(j);
    end;
    
    if (i < cur) and (ar[i] <> nil) then
      inc(i);
  end;
end;

procedure colony.move;
var i:integer;
begin
  for i:=0 to cur-1 do
    ar[i].move;
end;

procedure colony.draw;
var i:integer;
begin
  for i:=0 to cur-1 do
    ar[i].draw;
end;

procedure colony.hide;
var i:integer;
begin
  for i:=0 to cur-1 do
    ar[i].hide;
end;

end.