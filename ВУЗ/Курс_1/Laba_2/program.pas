program DataProcessor;

uses Main, Types, dateutils;

var
  int_f, normal_f, skip_f, dub_f, abnormal_f, incor_f, con_f: text;
  rh: rhuman;
  h: human;
  c: boolean;
  error: erroring;
  count: integer;
  line: string;
  i: integer;
  
begin
  assign(int_f, 'input_test1.txt');
  reset(int_f);
  assign(normal_f, 'normal.txt');
  assign(skip_f, 'skip.txt');
  assign(dub_f, 'dublicate.txt');
  assign(abnormal_f, 'abnormal.txt');
  assign(incor_f, 'incorrect.txt');
  assign(con_f, 'conflict.txt');
  rewrite(normal_f);
  rewrite(skip_f);
  rewrite(dub_f);
  rewrite(abnormal_f);
  rewrite(incor_f);
  rewrite(con_f);
  count := 0;
  
  while (not eof(int_f)) and (count < n) do
  begin
    readln(int_f, line);
    if line <> '' then
    begin
      for i := 1 to 5 do 
        error[i] := 0;
      
      parse_full(line, h, error);
      
      c := true;
      
      // Проверка на некорректные данные
      if error[1] = 1 then 
      begin 
        writeln(incor_f, line); 
        c := false 
      end;
      
      // Проверка на пропуски
      if (error[2] = 1) and c then 
      begin 
        writeln(skip_f, line); 
        c := false 
      end;
      
      // Проверка на аномальные данные
      if (error[3] = 1) and c then 
      begin 
        writeln(abnormal_f, line); 
        c := false 
      end;
      
      // СНАЧАЛА ПРОВЕРКА НА КОНФЛИКТЫ
      if c then
      begin
        check_identity_conflict(rh, h, count, error);
        
        if error[1] = 1 then 
        begin 
          writeln(con_f, line); 
          c := false 
        end;
      end;
      
      // Проверка пересечения периодов больничных
      if c then
      begin
        check_con(rh, h, count, error);
        
        if error[1] = 1 then 
        begin 
          writeln(con_f, line); 
          c := false 
        end;
      end;
      
      // ЗАТЕМ ПРОВЕРКА НА ДУБЛИКАТЫ
      if c then
      begin
        check_dub(rh, h, count, error);
        
        if error[5] = 1 then 
        begin 
          writeln(dub_f, line); 
          c := false 
        end;
      end;
      
      if c then 
      begin 
        count := count + 1;  
        rh[count] := h;
      end;
    end;
  end;
  
  sort_records(rh, count);
  write_h(count, rh, normal_f);
  
  close(int_f);
  close(normal_f);
  close(skip_f);
  close(dub_f);
  close(abnormal_f);
  close(incor_f);
  close(con_f);
end.