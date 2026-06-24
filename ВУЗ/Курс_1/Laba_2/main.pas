unit Main;

interface

uses Types, DateUtils;

procedure check_snils(s: string; var snils: string; var good: integer);
function check_pol(s: string; var name: string): boolean;
procedure parse_full(s: string; var h: human; var ray: erroring);
procedure check_dub(h_right: rhuman; hcur: human; count: integer; var error: erroring);
procedure write_h(count: integer; rh: rhuman; var normal_f: text);
procedure sort_records(var rh: rhuman; var count: integer);
procedure check_con(h_right: rhuman; hcur: human; count: integer; var error: erroring);
procedure check_identity_conflict(h_right: rhuman; hcur: human; count: integer; var error: erroring);

implementation

procedure check_snils(s: string; var snils: string; var good: integer);
var
  i: integer;
  valid: boolean;
  foundError: boolean;
begin
  good := 0;
  snils := '';
  valid := true;
  foundError := false;
  
  // ================= НОВАЯ ПРОВЕРКА ДЛИНЫ СНИЛС =================
  // Теперь проверяем строгое равенство 14 символам (и не больше, и не меньше)
  if length(s) <> 14 then
  begin
    good := 1;
    valid := false;
  end;
  // ===============================================================
  
  if valid then
  begin
    i := 1;
    while (i <= 14) and (not foundError) do
    begin
      case i of
        4, 8: if s[i] <> '-' then foundError := true;
        12: if s[i] <> ' ' then foundError := true;
      else
        if not (s[i] in ['0'..'9']) then foundError := true;
      end;
      i := i + 1;
    end;
    
    if foundError then good := 1;
  end;
  
  if good = 0 then snils := s;
end;

function check_pol(s: string; var name: string): boolean;
begin
  name := ' ';
  if length(s) > 1 then check_pol := false
  else
  begin
    s := s.ToUpper;
    case s of
      'M', 'W': begin name := s; check_pol := true; end;
    else check_pol := false;
    end;
  end;
end;

procedure check_identity_conflict(h_right: rhuman; hcur: human; count: integer; var error: erroring);
var i: integer; foundConflict: boolean;
begin
  foundConflict := false; i := 1;
  while (i <= count) and (not foundConflict) do
  begin
    if hcur.snils = h_right[i].snils then
    begin
      if (hcur.kod <> h_right[i].kod) or (hcur.pol <> h_right[i].pol) or
         (hcur.birth.dd <> h_right[i].birth.dd) or (hcur.birth.mm <> h_right[i].birth.mm) or
         (hcur.birth.yy <> h_right[i].birth.yy) then
      begin error[1] := 1; foundConflict := true; end;
    end;
    i := i + 1;
  end;
end;

procedure parse_full(s: string; var h: human; var ray: erroring);
var
  ss: string;
  er1, er2, er3, er4, er5, er6: integer;
  pos1, i: integer;
  tempDate: string;
begin
  for i := 1 to 5 do ray[i] := 0;
  
  pos1 := pos(' ', s); ss := copy(s, 1, pos1 - 1); delete(s, 1, pos1);
  pos1 := pos(' ', s); ss := ss + ' ' + copy(s, 1, pos1 - 1);
  check_snils(ss, h.snils, er1); delete(s, 1, pos1);
  
  pos1 := pos(' ', s); tempDate := copy(s, 1, pos1 - 1);
  check_date(tempDate, h.birth.dd, h.birth.mm, h.birth.yy, er2); delete(s, 1, pos1);
  
  pos1 := pos(' ', s); ss := copy(s, 1, pos1 - 1);
  if check_pol(ss, h.pol) then er3 := 0 else begin if ss = ' ' then er3 := 2 else er3 := 1; end;
  delete(s, 1, pos1);
  
  pos1 := pos(' ', s); tempDate := copy(s, 1, pos1 - 1);
  check_date(tempDate, h.start.dd, h.start.mm, h.start.yy, er4); delete(s, 1, pos1);
  
  pos1 := pos(' ', s); tempDate := copy(s, 1, pos1 - 1);
  check_date(tempDate, h.finish.dd, h.finish.mm, h.finish.yy, er5); delete(s, 1, pos1);
  
  h.kod := s;
  er6 := 0;
  if (er4 = 0) and (er5 = 0) then
    check_2date(h.start.dd, h.start.mm, h.start.yy, h.finish.dd, h.finish.mm, h.finish.yy, er6);
  
  case er1 of 1: ray[1] := 1; end;
  case er2 of 1: ray[1] := 1; 2: ray[2] := 1; 3: ray[3] := 1; end;
  case er3 of 1: ray[1] := 1; 2: ray[2] := 1; end;
  case er4 of 1: ray[1] := 1; 2: ray[2] := 1; 3: ray[3] := 1; end;
  case er5 of 1: ray[1] := 1; 2: ray[2] := 1; 3: ray[3] := 1; end;
  case er6 of 3: ray[3] := 1; 4: ray[1] := 1; end;
end;

procedure check_dub(h_right: rhuman; hcur: human; count: integer; var error: erroring);
var i, err: integer; foundDub: boolean;
begin
  err := 0; foundDub := false; i := 1;
  while (i <= count) and (not foundDub) do
  begin
    if (hcur.snils = h_right[i].snils) and (hcur.pol = h_right[i].pol) and (hcur.kod = h_right[i].kod) and
       (hcur.birth.dd = h_right[i].birth.dd) and (hcur.birth.mm = h_right[i].birth.mm) and (hcur.birth.yy = h_right[i].birth.yy) and
       (hcur.start.dd = h_right[i].start.dd) and (hcur.start.mm = h_right[i].start.mm) and (hcur.start.yy = h_right[i].start.yy) and
       (hcur.finish.dd = h_right[i].finish.dd) and (hcur.finish.mm = h_right[i].finish.mm) and (hcur.finish.yy = h_right[i].finish.yy) then
    begin err := 5; foundDub := true; end;
    i := i + 1;
  end;
  if err <> 0 then error[err] := 1;
end;

procedure check_con(h_right: rhuman; hcur: human; count: integer; var error: erroring);
var i, err, start1, finish1, start2, finish2: integer; foundConflict: boolean;
begin
  err := 0; foundConflict := false; i := 1;
  while (i <= count) and (not foundConflict) do
  begin
    if (hcur.snils = h_right[i].snils) and (hcur.pol = h_right[i].pol) and (hcur.kod = h_right[i].kod) and
       (hcur.birth.dd = h_right[i].birth.dd) and (hcur.birth.mm = h_right[i].birth.mm) and (hcur.birth.yy = h_right[i].birth.yy) then
    begin
      start1 := hcur.start.yy * 10000 + hcur.start.mm * 100 + hcur.start.dd;
      finish1 := hcur.finish.yy * 10000 + hcur.finish.mm * 100 + hcur.finish.dd;
      start2 := h_right[i].start.yy * 10000 + h_right[i].start.mm * 100 + h_right[i].start.dd;
      finish2 := h_right[i].finish.yy * 10000 + h_right[i].finish.mm * 100 + h_right[i].finish.dd;
      if (start1 <= finish2) and (finish1 >= start2) then begin err := 4; foundConflict := true; end;
    end;
    i := i + 1;
  end;
  if err <> 0 then error[err] := 1;
end;
  
procedure write_h(count: integer; rh: rhuman; var normal_f: text);
var i: integer;
begin
  for i := 1 to count do
  begin
    writeln(normal_f, rh[i].snils,'|', redact_day(rh[i].birth.dd),'.',redact_month(rh[i].birth.mm),'.', rh[i].birth.yy, '|',
    rh[i].pol, '|', redact_day(rh[i].start.dd),'.',redact_month(rh[i].start.mm),'.', rh[i].start.yy, '|',
    redact_day(rh[i].finish.dd),'.',redact_month(rh[i].finish.mm),'.', rh[i].finish.yy, '|', rh[i].kod);
  end;
end;

procedure sort_records(var rh: rhuman; var count: integer);
var i, j: integer; temp: human; needSwap: boolean;
begin
  for i := 1 to count - 1 do
    for j := i + 1 to count do
    begin
      needSwap := false;
      if rh[i].kod > rh[j].kod then needSwap := true
      else if rh[i].kod = rh[j].kod then
      begin
        if rh[i].birth.yy > rh[j].birth.yy then needSwap := true
        else if rh[i].birth.yy = rh[j].birth.yy then
        begin
          if rh[i].birth.mm > rh[j].birth.mm then needSwap := true
          else if rh[i].birth.mm = rh[j].birth.mm then
          begin
            if rh[i].birth.dd > rh[j].birth.dd then needSwap := true
            else if (rh[i].birth.dd = rh[j].birth.dd) and (rh[i].pol > rh[j].pol) then needSwap := true;
          end;
        end;
      end;
      if needSwap then begin temp := rh[i]; rh[i] := rh[j]; rh[j] := temp; end;
    end;
end;

end.