unit MultiSetUnit;

interface

type
    TPoint = record
        x, y: integer;
    end;
    
    PNode = ^TNode;
    TNode = record
        point: TPoint;
        cnt: integer;
        next: PNode;
    end;
    
    TMultiSet = record
        head: PNode;
    end;

procedure Init(var ms: TMultiSet);
procedure Add(var ms: TMultiSet; p: TPoint);
procedure Del(var ms: TMultiSet; p: TPoint; k: integer);
function Find(ms: TMultiSet; p: TPoint): integer;
function GetSize(ms: TMultiSet): integer;
function GetUniq(ms: TMultiSet): integer;
procedure Clear(var ms: TMultiSet);
procedure Print(ms: TMultiSet);
function Equal(p1, p2: TPoint): boolean;
procedure Union(const a, b: TMultiSet; var res: TMultiSet);

implementation

// Инициализация - просто обнуляем голову списка
procedure Init(var ms: TMultiSet);
begin
    ms.head := nil;
end;

// Сравнение двух точек
function Equal(p1, p2: TPoint): boolean;
begin
    Equal := (p1.x = p2.x) and (p1.y = p2.y);
end;

// Сравнение для сортировки (p1 < p2)
function Less(p1, p2: TPoint): boolean;
begin
    if p1.x < p2.x then
        Less := true
    else if p1.x > p2.x then
        Less := false
    else
        Less := p1.y < p2.y;
end;

// Добавление точки
procedure Add(var ms: TMultiSet; p: TPoint);
var
    cur, prev, newNode: PNode;
begin
    cur := ms.head;
    prev := nil;
    
    // Поиск места для вставки
    while (cur <> nil) and Less(cur^.point, p) do
    begin
        prev := cur;
        cur := cur^.next;
    end;
    
    // Если точка уже есть - увеличиваем счётчик
    if (cur <> nil) and Equal(cur^.point, p) then
    begin
        cur^.cnt := cur^.cnt + 1;
    end
    else
    begin
        // Создаём новый узел
        new(newNode);
        newNode^.point := p;
        newNode^.cnt := 1;
        newNode^.next := cur;
        
        if prev = nil then
            ms.head := newNode
        else
            prev^.next := newNode;
    end;
end;

// Удаление точки
procedure Del(var ms: TMultiSet; p: TPoint; k: integer);
var
    cur, prev: PNode;
    toDelete: integer;
begin
    cur := ms.head;
    prev := nil;
    
    // Поиск точки
    while (cur <> nil) and (not Equal(cur^.point, p)) do
    begin
        prev := cur;
        cur := cur^.next;
    end;
    
    // Если нашли
    if cur <> nil then
    begin
        if k = 0 then
            toDelete := cur^.cnt
        else if k >= cur^.cnt then
            toDelete := cur^.cnt
        else
            toDelete := k;
        
        cur^.cnt := cur^.cnt - toDelete;
        
        if cur^.cnt = 0 then
        begin
            if prev = nil then
                ms.head := cur^.next
            else
                prev^.next := cur^.next;
            dispose(cur);
        end;
    end;
end;

// Поиск количества вхождений
function Find(ms: TMultiSet; p: TPoint): integer;
var
    cur: PNode;
begin
    cur := ms.head;
    Find := 0;
    
    while cur <> nil do
    begin
        if Equal(cur^.point, p) then
            Find := cur^.cnt;
        cur := cur^.next;
    end;
end;

// Общая мощность (сумма всех cnt)
function GetSize(ms: TMultiSet): integer;
var
    cur: PNode;
    sum: integer;
begin
    cur := ms.head;
    sum := 0;
    
    while cur <> nil do
    begin
        sum := sum + cur^.cnt;
        cur := cur^.next;
    end;
    
    GetSize := sum;
end;

// Количество уникальных элементов
function GetUniq(ms: TMultiSet): integer;
var
    cur: PNode;
    count: integer;
begin
    cur := ms.head;
    count := 0;
    
    while cur <> nil do
    begin
        count := count + 1;
        cur := cur^.next;
    end;
    
    GetUniq := count;
end;

// Очистка всего множества
procedure Clear(var ms: TMultiSet);
var
    cur, tmp: PNode;
begin
    cur := ms.head;
    
    while cur <> nil do
    begin
        tmp := cur;
        cur := cur^.next;
        dispose(tmp);
    end;
    
    ms.head := nil;
end;

// Вывод множества
procedure Print(ms: TMultiSet);
var
    cur: PNode;
begin
    if ms.head = nil then
    begin
        writeln('Множество пусто');
    end
    else
    begin
        cur := ms.head;
        while cur <> nil do
        begin
            write('(', cur^.point.x, ',', cur^.point.y, ',', cur^.cnt, ')');
            if cur^.next <> nil then
                write(' ');
            cur := cur^.next;
        end;
        writeln;
        writeln('Общая мощность: ', GetSize(ms));
        writeln('Уникальных: ', GetUniq(ms));
    end;
end;

// Объединение двух множеств
procedure Union(const a, b: TMultiSet; var res: TMultiSet);
var
    cur: PNode;
    i: integer;
begin
    Init(res);
    
    // 1. Берём всё из A и кладём в C
    cur := a.head;
    while cur <> nil do
    begin
        for i := 1 to cur^.cnt do
            Add(res, cur^.point);
        cur := cur^.next;
    end;
    
    // 2. Берём всё из B и тоже кладём в C
    cur := b.head;
    while cur <> nil do
    begin
        for i := 1 to cur^.cnt do
            Add(res, cur^.point);
        cur := cur^.next;
    end;
end;

end.