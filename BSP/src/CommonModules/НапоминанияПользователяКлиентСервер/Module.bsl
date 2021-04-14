///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает ежегодное расписание для события на указанную дату.
//
// Параметры:
//  ДатаСобытия - Дата - произвольная дата.
//
// Возвращаемое значение:
//  РасписаниеРегламентногоЗадания - расписание.
//
Функция ЕжегодноеРасписание(ДатаСобытия) Экспорт
	Месяцы = Новый Массив;
	Месяцы.Добавить(Месяц(ДатаСобытия));
	ДеньВМесяце = День(ДатаСобытия);
	
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.ПериодПовтораДней = 1;
	Расписание.ПериодНедель = 1;
	Расписание.Месяцы = Месяцы;
	Расписание.ДеньВМесяце = ДеньВМесяце;
	Расписание.ВремяНачала = '000101010000' + (ДатаСобытия - НачалоДня(ДатаСобытия));
	
	Возврат Расписание;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает текстовое представление интервала времени, заданного в секундах.
//
// Параметры:
//
//  Время - Число - интервал времени в секундах.
//
//  ПолноеПредставление	- Булево - кратное или полное представление времени.
//		Например, интервал 1 000 000 секунд:
//		- полное представление:  11 дней 13 часов 46 минут 40 секунд;
//		- краткое представление: 11 дней 13 часов.
//
// Возвращаемое значение:
//   Строка - представление интервала времени.
//
Функция ПредставлениеВремени(Знач Время, ПолноеПредставление = Истина, ВыводитьСекунды = Истина) Экспорт
	Результат = "";
	
	// Представление единиц измерения времени в винительном падеже для количеств: 1, 2-4, 5-20.
	ПредставлениеНедель = НСтр("ru = ';%1 неделю;;%1 недели;%1 недель;%1 недели'");
	ПредставлениеДней   = НСтр("ru = ';%1 день;;%1 дня;%1 дней;%1 дня'");
	ПредставлениеЧасов  = НСтр("ru = ';%1 час;;%1 часа;%1 часов;%1 часа'");
	ПредставлениеМинут  = НСтр("ru = ';%1 минуту;;%1 минуты;%1 минут;%1 минуты'");
	ПредставлениеСекунд = НСтр("ru = ';%1 секунду;;%1 секунды;%1 секунд;%1 секунды'");
	
	Время = Число(Время);
	
	Если Время < 0 Тогда
		Время = -Время;
	КонецЕсли;
	
	КоличествоНедель = Цел(Время / 60/60/24/7);
	КоличествоДней   = Цел(Время / 60/60/24);
	КоличествоЧасов  = Цел(Время / 60/60);
	КоличествоМинут  = Цел(Время / 60);
	КоличествоСекунд = Цел(Время);
	
	КоличествоСекунд = КоличествоСекунд - КоличествоМинут * 60;
	КоличествоМинут  = КоличествоМинут - КоличествоЧасов * 60;
	КоличествоЧасов  = КоличествоЧасов - КоличествоДней * 24;
	КоличествоДней   = КоличествоДней - КоличествоНедель * 7;
	
	Если Не ВыводитьСекунды Тогда
		КоличествоСекунд = 0;
	КонецЕсли;
	
	Если КоличествоНедель > 0 И КоличествоДней+КоличествоЧасов+КоличествоМинут+КоличествоСекунд=0 Тогда
		Результат = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ПредставлениеНедель, КоличествоНедель);
	Иначе
		КоличествоДней = КоличествоДней + КоличествоНедель * 7;
		
		Счетчик = 0;
		Если КоличествоДней > 0 Тогда
			Результат = Результат + СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ПредставлениеДней, КоличествоДней) + " ";
			Счетчик = Счетчик + 1;
		КонецЕсли;
		
		Если КоличествоЧасов > 0 Тогда
			Результат = Результат + СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ПредставлениеЧасов, КоличествоЧасов) + " ";
			Счетчик = Счетчик + 1;
		КонецЕсли;
		
		Если (ПолноеПредставление Или Счетчик < 2) И КоличествоМинут > 0 Тогда
			Результат = Результат + СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ПредставлениеМинут, КоличествоМинут) + " ";
			Счетчик = Счетчик + 1;
		КонецЕсли;
		
		Если (ПолноеПредставление Или Счетчик < 2) И (КоличествоСекунд > 0 Или КоличествоНедель+КоличествоДней+КоличествоЧасов+КоличествоМинут = 0) Тогда
			Результат = Результат + СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ПредставлениеСекунд, КоличествоСекунд);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СокрП(Результат);
	
КонецФункции

// Получает из текстового описания интервал времени в секундах.
//
// Параметры:
//  СтрокаСоВременем - Строка - текстовое описание времени, где числа записаны цифрами,
//								а единицы измерения - строкой. 
//
// Возвращаемое значение
//  Число - интервал времени в секундах.
Функция ПолучитьИнтервалВремениИзСтроки(Знач СтрокаСоВременем) Экспорт
	
	Если ПустаяСтрока(СтрокаСоВременем) Тогда
		Возврат 0;
	КонецЕсли;
	
	СтрокаСоВременем = НРег(СтрокаСоВременем);
	СтрокаСоВременем = СтрЗаменить(СтрокаСоВременем, Символы.НПП," ");
	СтрокаСоВременем = СтрЗаменить(СтрокаСоВременем, ".",",");
	СтрокаСоВременем = СтрЗаменить(СтрокаСоВременем, "+","");
	
	ПодстрокаСЦифрами = "";
	ПодстрокаСБуквами = "";
	
	ПредыдущийСимволЭтоЦифра = Ложь;
	ЕстьДробнаяЧасть = Ложь;
	
	Результат = 0;
	Для Позиция = 1 По СтрДлина(СтрокаСоВременем) Цикл
		ТекущийКодСимвола = КодСимвола(СтрокаСоВременем,Позиция);
		Символ = Сред(СтрокаСоВременем,Позиция,1);
		Если (ТекущийКодСимвола >= КодСимвола("0") И ТекущийКодСимвола <= КодСимвола("9"))
			ИЛИ (Символ="," И ПредыдущийСимволЭтоЦифра И Не ЕстьДробнаяЧасть) Тогда
			Если Не ПустаяСтрока(ПодстрокаСБуквами) Тогда
				ПодстрокаСЦифрами = СтрЗаменить(ПодстрокаСЦифрами,",",".");
				Результат = Результат + ?(ПустаяСтрока(ПодстрокаСЦифрами), 1, Число(ПодстрокаСЦифрами))
					* ЗаменитьЕдиницуИзмеренияНаМножитель(ПодстрокаСБуквами);
					
				ПодстрокаСЦифрами = "";
				ПодстрокаСБуквами = "";
				
				ПредыдущийСимволЭтоЦифра = Ложь;
				ЕстьДробнаяЧасть = Ложь;
			КонецЕсли;
			
			ПодстрокаСЦифрами = ПодстрокаСЦифрами + Сред(СтрокаСоВременем,Позиция,1);
			
			ПредыдущийСимволЭтоЦифра = Истина;
			Если Символ = "," Тогда
				ЕстьДробнаяЧасть = Истина;
			КонецЕсли;
		Иначе
			Если Символ = " " И ЗаменитьЕдиницуИзмеренияНаМножитель(ПодстрокаСБуквами) = "0" Тогда
				ПодстрокаСБуквами = "";
			КонецЕсли;
			
			ПодстрокаСБуквами = ПодстрокаСБуквами + Сред(СтрокаСоВременем,Позиция,1);
			ПредыдущийСимволЭтоЦифра = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ПустаяСтрока(ПодстрокаСБуквами) Тогда
		ПодстрокаСЦифрами = СтрЗаменить(ПодстрокаСЦифрами,",",".");
		Результат = Результат + ?(ПустаяСтрока(ПодстрокаСЦифрами), 1, Число(ПодстрокаСЦифрами))
			* ЗаменитьЕдиницуИзмеренияНаМножитель(ПодстрокаСБуквами);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Анализирует слово на предмет соответствия единице времени и, если соответствие установлено,
// возвращает количество секунд, содержащееся в единице времени.
//
// Параметры:
//  Единица - Строка - анализируемое слово.
//
// Возвращаемое значение
//  Число - количество секунд в Единице. Если единица не определена или пустая, то возвращается 0.
Функция ЗаменитьЕдиницуИзмеренияНаМножитель(Знач Единица)
	
	Результат = 0;
	
	Единица = СтрЗаменить(Единица, " ","");
	Единица = СтрЗаменить(Единица, ",","");
	Единица = СтрЗаменить(Единица, ".","");
	
	// Единицу измерения времени будем определять по первым трем символам.
	ПервыеТриСимвола = Лев(Единица,3);
	Если ПервыеТриСимвола = НСтр("ru = 'нед'") Или ПервыеТриСимвола = НСтр("ru = 'н'") Тогда
		Результат = 60*60*24*7;
	ИначеЕсли ПервыеТриСимвола = НСтр("ru = 'ден'") 
		  Или ПервыеТриСимвола = НСтр("ru = 'дне'")
		  Или ПервыеТриСимвола = НСтр("ru = 'дня'")
		  Или ПервыеТриСимвола = НСтр("ru = 'дн'")
		  Или ПервыеТриСимвола = НСтр("ru = 'д'") Тогда
		Результат = 60*60*24;
	ИначеЕсли ПервыеТриСимвола = НСтр("ru = 'час'") Или ПервыеТриСимвола = НСтр("ru = 'ч'") Тогда
		Результат = 60*60;
	ИначеЕсли ПервыеТриСимвола = НСтр("ru = 'мин'") Или ПервыеТриСимвола = НСтр("ru = 'м'") Тогда
		Результат = 60;
	ИначеЕсли ПервыеТриСимвола = НСтр("ru = 'сек'") Или ПервыеТриСимвола = НСтр("ru = 'с'") Тогда
		Результат = 1;
	КонецЕсли;
	
	Возврат Формат(Результат,"ЧН=0; ЧГ=0");
	
КонецФункции

// Получает из строки интервал времени и возвращает его текстовое представление.
//
// Параметры:
//  ВремяСтрокой - Строка - текстовое описание времени, где числа записаны цифрами,
//							а единицы измерения - строкой.
//
// Возвращаемое значение
//  Строка - оформленное представление времени.
Функция ОформитьВремя(ВремяСтрокой) Экспорт
	Возврат ПредставлениеВремени(ПолучитьИнтервалВремениИзСтроки(ВремяСтрокой));
КонецФункции

// Возвращает структуру напоминания с заполненными значениями.
//
// Параметры:
//  ДанныеДляЗаполнения - Структура - значения для заполнения параметров напоминания.
//  ВсеРеквизиты - Булево - если истина, то возвращает также реквизиты, связанные с настройкой
//                          времени напоминания.
Функция ОписаниеНапоминания(ДанныеДляЗаполнения = Неопределено, ВсеРеквизиты = Ложь) Экспорт
	Результат = Новый Структура("Пользователь,ВремяСобытия,Источник,СрокНапоминания,Описание,Идентификатор");
	Если ВсеРеквизиты Тогда 
		Результат.Вставить("СпособУстановкиВремениНапоминания");
		Результат.Вставить("ИнтервалВремениНапоминания", 0);
		Результат.Вставить("ИмяРеквизитаИсточника");
		Результат.Вставить("Расписание");
		Результат.Вставить("ИндексКартинки", 2);
		Результат.Вставить("ПовторятьЕжегодно", Ложь);
	КонецЕсли;
	Если ДанныеДляЗаполнения <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Результат, ДанныеДляЗаполнения);
	КонецЕсли;
	Возврат Результат;
КонецФункции

#КонецОбласти
