unit DateUtils;

interface

function monthNameToNumber(monthName: string): integer;
function redact_month(m: integer): string;
function redact_day(d: integer): string;
procedure check_date(s: string; var day: integer; var month: integer; var year: integer; var err: integer);
procedure check_2date(sd, sm, sy: integer; fd, fm, fy: integer; var err: integer);
function is_leap_year(year: integer): boolean;
function days_in_month(month, year: integer): integer;
function check_duration(start_d, start_m, start_y: integer; end_d, end_m, end_y: integer): integer;

implementation

function monthNameToNumber(monthName: string): integer;
begin
  monthName := lowercase(monthName);
  case monthName of
    'jan': monthNameToNumber := 1; 'feb': monthNameToNumber := 2;
    'mar': monthNameToNumber := 3; 'apr': monthNameToNumber := 4;
    'may': monthNameToNumber := 5; 'jun': monthNameToNumber := 6;
    'jul': monthNameToNumber := 7; 'aug': monthNameToNumber := 8;
    'sep': monthNameToNumber := 9; 'oct': monthNameToNumber := 10;
    'nov': monthNameToNumber := 11; 'dec': monthNameToNumber := 12;
  else
    monthNameToNumber := 0;
  end;
end;
  
function redact_month(m: integer): string;
begin
  case m of
    1: redact_month := 'jan'; 2: redact_month := 'feb';
    3: redact_month := 'mar'; 4: redact_month := 'apr';
    5: redact_month := 'may'; 6: redact_month := 'jun';
    7: redact_month := 'jul'; 8: redact_month := 'aug';
    9: redact_month := 'sep'; 10: redact_month := 'oct';
    11: redact_month := 'nov'; 12: redact_month := 'dec';
  else
    redact_month := '';
  end;
end;

function redact_day(d: integer): string;
var rd: string;
begin
  str(d, rd);
  if d < 10 then rd := '0' + rd;
  redact_day := rd;
end;

function is_leap_year(year: integer): boolean;
begin
  is_leap_year := ((year mod 4 = 0) and (year mod 100 <> 0)) or (year mod 400 = 0);
end;

function days_in_month(month, year: integer): integer;
begin
  case month of
    1, 3, 5, 7, 8, 10, 12: days_in_month := 31;
    4, 6, 9, 11: days_in_month := 30;
    2: if is_leap_year(year) then days_in_month := 29 else days_in_month := 28;
  else
    days_in_month := 0;
  end;
end;

function check_duration(start_d, start_m, start_y: integer; end_d, end_m, end_y: integer): integer;
var
  total_days: longint;
  y, m: integer;
begin
  result := 0;
  total_days := 0;
  
  if start_y = end_y then
  begin
    if start_m = end_m then
      total_days := end_d - start_d
    else
    begin
      total_days := days_in_month(start_m, start_y) - start_d;
      m := start_m + 1;
      while m <= end_m - 1 do begin total_days := total_days + days_in_month(m, start_y); m := m + 1; end;
      total_days := total_days + end_d;
    end;
  end
  else
  begin
    total_days := days_in_month(start_m, start_y) - start_d;
    m := start_m + 1;
    while m <= 12 do begin total_days := total_days + days_in_month(m, start_y); m := m + 1; end;
    y := start_y + 1;
    while y <= end_y - 1 do begin
      if is_leap_year(y) then total_days := total_days + 366 else total_days := total_days + 365;
      y := y + 1;
    end;
    m := 1;
    while m <= end_m - 1 do begin total_days := total_days + days_in_month(m, end_y); m := m + 1; end;
    total_days := total_days + end_d;
  end;
  
  if total_days > 90 then result := 3;
end;

procedure check_date(s: string; var day: integer; var month: integer; var year: integer; var err: integer);
var
  i, code_d, code_y, slashpos1, slashpos2: integer;
  monthStr, dayStr, yearStr: string;
  maxdays: integer;
  valid: boolean;
  hasInvalidChar, hasEmptyField, foundSlash1, foundSlash2: boolean;
begin
  err := 0; day := 0; month := 0; year := 0;
  slashpos1 := 0; slashpos2 := 0;
  valid := true; hasInvalidChar := false; hasEmptyField := false;
  foundSlash1 := false; foundSlash2 := false;
  
  i := 1;
  while (i <= length(s)) and (not foundSlash2) do
  begin
    if s[i] = '/' then
    begin
      if not foundSlash1 then begin slashpos1 := i; foundSlash1 := true; end
      else if not foundSlash2 then begin slashpos2 := i; foundSlash2 := true; end;
    end;
    i := i + 1;
  end;
  
  i := 1;
  while (i <= length(s)) and (not hasInvalidChar) do
  begin
    if s[i] <> '/' then
      if not (s[i] in ['0'..'9', 'a'..'z', 'A'..'Z']) then hasInvalidChar := true;
    i := i + 1;
  end;
  
  if hasInvalidChar then begin err := 1; valid := false; end;
  
  if valid and ((slashpos1 = 0) or (slashpos2 = 0)) then begin err := 2; valid := false; end;
  
  if valid then
  begin
    dayStr := copy(s, 1, slashpos1 - 1);
    monthStr := copy(s, slashpos1 + 1, slashpos2 - slashpos1 - 1);
    yearStr := copy(s, slashpos2 + 1, length(s) - slashpos2);
    
    if (dayStr = '') or (monthStr = '') or (yearStr = '') then begin err := 2; valid := false; end;
  end;

  // ================= НОВЫЕ ПРОВЕРКИ ДЛИНЫ И ФОРМАТА ДАТЫ =================
  if valid then
  begin
    // 1. Проверка общей длины строки (8 для 1/Jan/00 или 9 для 12/Dec/12)
    if (length(s) <> 8) and (length(s) <> 9) then
    begin err := 1; valid := false; end
    // 2. Позиция первого слэша (день может занимать 1 или 2 символа)
    else if (slashpos1 < 2) or (slashpos1 > 3) then
    begin err := 1; valid := false; end
    // 3. Позиция второго слэша (месяц всегда 3 буквы + 1 слэш = сдвиг на 4)
    else if (slashpos2 <> slashpos1 + 4) then
    begin err := 1; valid := false; end
    // 4. Длина года (всегда строго 2 символа в конце)
    else if (length(s) - slashpos2 <> 2) then
    begin err := 1; valid := false; end
    // 5. Запрет на ведущий ноль в дне (чтобы 01/Jan/00 улетало в некорректные)
    else if (length(dayStr) > 0) and (dayStr[1] = '0') then
    begin err := 1; valid := false; end;
  end;
  // =======================================================================
  
  if valid then begin val(dayStr, day, code_d); if code_d <> 0 then begin err := 1; valid := false; end; end;
  if valid then begin month := monthNameToNumber(monthStr); if month = 0 then begin err := 3; valid := false; end; end;
  if valid then begin val(yearStr, year, code_y); if code_y <> 0 then begin err := 1; valid := false; end; end;
  
  if valid then
  begin
    if year <= 25 then year := year + 2000 else year := year + 1900;
    
    if (year < 1900) or (year > 2026) then err := 3
    else if (month < 1) or (month > 12) then err := 3
    else if (day < 1) or (day > 31) then err := 3
    else
    begin
      case month of
        1, 3, 5, 7, 8, 10, 12: maxdays := 31;
        4, 6, 9, 11: maxdays := 30;
        2: maxdays := days_in_month(month, year);
      else maxdays := 0;
      end;
      if day > maxdays then err := 3;
    end;
  end;
end;

procedure check_2date(sd, sm, sy: integer; fd, fm, fy: integer; var err: integer);
var
  startDate, finishDate: longint;
  duration_err: integer;
begin
  err := 0;
  startDate := sy * 10000 + sm * 100 + sd;
  finishDate := fy * 10000 + fm * 100 + fd;
  
  if startDate >= finishDate then err := 4
  else
  begin
    duration_err := check_duration(sd, sm, sy, fd, fm, fy);
    if duration_err = 3 then err := 3;
  end;
end;

end.