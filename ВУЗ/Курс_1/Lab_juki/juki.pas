uses GraphABC,u_colony,u_bug;
var c_red,c_green:colony;
b:bug;
i:integer;
begin
  Randomize;
  //LockDrawing;
  c_red:=colony.Create(clred,10);
  c_green:=colony.Create(clgreen,10);
  for i:=1 to 5 do begin
    b:=bug.Create(20+Random(1000),20+Random(1000),Random(10)+5,clred);
    b.set_dx_dy(Random(10)-5,Random(10)-5);
    c_red.add(b);
    end;
    for i:=1 to 5 do begin
    b:=bug.Create(20+Random(1000),20+Random(1000),Random(10)+5,clgreen);
    b.set_dx_dy(Random(10)-5,Random(10)-5);
    c_green.add(b);
    end;
    while true do begin
      c_red.move; c_red.life;
      c_green.move; c_green.life;
      c_red.war(c_green);
  end;
end.