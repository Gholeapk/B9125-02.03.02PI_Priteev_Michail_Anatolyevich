program LabMultiSet;

uses
    MultiSetUnit;

// Ввод одной точки
procedure Vvod(var t: TPoint);
begin
    write('x = '); readln(t.x);
    write('y = '); readln(t.y);
end;

// Ввод множества с клавиатуры
procedure VvodSet(var s: TMultiSet; name: string);
var
    n, i: integer;
    p: TPoint;
begin
    Init(s);
    write('Введите мощность множества ', name, ': ');
    readln(n);
    
    writeln('Введите ', n, ' элементов:');
    i := 1;
    while i <= n do
    begin
        writeln('Точка ', i, ':');
        Vvod(p);
        Add(s, p);
        i := i + 1;
    end;
    
    writeln('Множество ', name, ':');
    Print(s);
end;

var
    A, B, C: TMultiSet;
    p: TPoint;
    k, cnt: integer;

begin
    Init(A);
    Init(B);
    Init(C);
    
    VvodSet(A, 'A');
    VvodSet(B, 'B');
    
    Union(A, B, C);
    writeln('Объединение A и B:');
    Print(C);
    
    writeln;
    writeln('Добавление точки в A:');
    Vvod(p);
    Add(A, p);
    writeln('Точка добавлена');
    Print(A);
    
    writeln;
    writeln('Удаление точки из A:');
    Vvod(p);
    write('Сколько удалить (0 - все): ');
    readln(k);
    Del(A, p, k);
    Print(A);
    
    writeln;
    writeln('Поиск точки в A:');
    Vvod(p);
    cnt := Find(A, p);
    writeln('Точка (', p.x, ',', p.y, ') встречается ', cnt, ' раз');
    
    writeln;
    writeln('Общая мощность A: ', GetSize(A));
    writeln('Уникальных элементов: ', GetUniq(A));
    
    writeln;
    Clear(A);
    Print(A);
    
    writeln;
    Print(B);
    
    Clear(A);
    Clear(B);
    Clear(C);
end.