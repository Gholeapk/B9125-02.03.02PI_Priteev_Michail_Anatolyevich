unit Types;

interface

const
  n = 10;  // Максимальное количество записей

type
  // Структура для хранения даты
  data = record
    dd, mm, yy: integer;    // день, месяц, год
    month_name: string;     // название месяца (не используется)
  end;
  
  // Структура для хранения информации о человеке и больничном
  human = record
    snils, pol, kod: string;  // СНИЛС, пол, код (ФИО)
    birth, start, finish: data;  // дата рождения, начала и окончания больничного
  end;
  
  // Массив записей (максимум n элементов)
  rhuman = array[1..n] of human;
  
  // Массив ошибок (5 типов ошибок)
  erroring = array[1..5] of integer;

implementation

end.