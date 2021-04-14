///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ПоставляемыеДанныеПереопределяемый.ПолучитьОбработчикиПоставляемыхДанных.
Процедура ПриОпределенииОбработчиковПоставляемыхДанных(Обработчики) Экспорт
	
	ЗарегистрироватьОбработчикиПоставляемыхДанных(Обработчики);
	
КонецПроцедуры

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	
	Типы.Добавить(Метаданные.Константы.ИсточникДанныхАдресногоКлассификатора);
	
	МетаданныеРегистров = Метаданные.РегистрыСведений;
	
	Типы.Добавить(МетаданныеРегистров.АдресныеОбъекты);
	Типы.Добавить(МетаданныеРегистров.ДомаЗданияСтроения);
	Типы.Добавить(МетаданныеРегистров.ДополнительныеАдресныеСведения);
	Типы.Добавить(МетаданныеРегистров.ЗагруженныеВерсииАдресныхСведений);
	Типы.Добавить(МетаданныеРегистров.ИсторияАдресныхОбъектов);
	Типы.Добавить(МетаданныеРегистров.ОриентирыАдресныхОбъектов);
	Типы.Добавить(МетаданныеРегистров.ПричиныИзмененияАдресныхСведений);
	Типы.Добавить(МетаданныеРегистров.СлужебныеАдресныеСведения);
	Типы.Добавить(МетаданныеРегистров.УровниСокращенийАдресныхСведений);
	
КонецПроцедуры

// Вызывается при получении уведомления о новых данных.
// В теле следует проверить, необходимы ли эти данные приложению, 
// и если да - установить флажок Загружать.
// 
// Параметры:
//   Дескриптор - ОбъектXDTO - Дескриптор.
//   Загружать - Булево - Истина, если загружать, Ложь - иначе.
//
Процедура ДоступныНовыеДанные(Знач Дескриптор, Загружать) Экспорт
	
	Если Дескриптор.DataType = "ФИАС30" Тогда
		
		Загружать = ПроверитьНаличиеНовыхДанных(Дескриптор);
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается после вызова ДоступныНовыеДанные, позволяет разобрать данные.
//
// Параметры:
//   Дескриптор - ОбъектXDTO - Дескриптор.
//   ПутьКФайлу - Строка - полное имя извлеченного файла. Файл будет автоматически удален 
//                  после завершения процедуры. Если в менеджере сервиса не был
//                  указан файл - значение аргумента равно Неопределено.
//
Процедура ОбработатьНовыеДанные(Знач Дескриптор, Знач ПутьКФайлу) Экспорт
	
	Если Дескриптор.DataType = "ФИАС30" Тогда
		ОбработатьФИАС(Дескриптор, ПутьКФайлу);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при отмене обработки данных в случае сбоя.
//
// Параметры:
//   Дескриптор - ОбъектXDTO - Дескриптор.
//
Процедура ОбработкаДанныхОтменена(Знач Дескриптор) Экспорт 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Регистрирует обработчики поставляемых данных за день и за все время.
//
// Параметры:
//     Обработчики - ТаблицаЗначений - таблица для добавления обработчиков. Содержит колонки.
//       * ВидДанных - Строка - код вида данных, обрабатываемый обработчиком.
//       * КодОбработчика - Строка - будет использоваться при восстановлении обработки данных после сбоя.
//       * Обработчик - ОбщийМодуль - модуль, содержащий экспортные  процедуры:
//                                          ДоступныНовыеДанные(Дескриптор, Загружать) Экспорт  
//                                          ОбработатьНовыеДанные(Дескриптор, ПутьКФайлу) Экспорт
//                                          ОбработкаДанныхОтменена(Дескриптор) Экспорт
//
Процедура ЗарегистрироватьОбработчикиПоставляемыхДанных(Знач Обработчики)
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ВидДанных = "ФИАС30";
	Обработчик.КодОбработчика = "ФИАС30";
	Обработчик.Обработчик = АдресныйКлассификаторВМоделиСервисаСлужебный;
	
КонецПроцедуры

Функция ПараметрыФИАС()
	
	Возврат Новый Структура("Версия, Регион");
	
КонецФункции

Функция ПараметрыВерсииИзФайла(Знач Дескриптор)
	
	ПараметрыВерсии =  ПараметрыФИАС();
	
	ОписаниеТипаЧисло = Новый ОписаниеТипов("Число");
	Для Каждого Характеристика Из Дескриптор.Properties.Property Цикл
		Если Характеристика.Code = "Регион" Тогда
			ПараметрыВерсии.Регион = ОписаниеТипаЧисло.ПривестиЗначение(Характеристика.Value);
		ИначеЕсли Характеристика.Code = "Версия" Тогда
			ПараметрыВерсии.Версия = ОписаниеТипаЧисло.ПривестиЗначение(Характеристика.Value);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПараметрыВерсии;
	
КонецФункции

Функция ОписаниеПоследнейЗагрузкиФИАС(Знач КодРегиона)
	
	ОписаниеТипаЧисло = Новый ОписаниеТипов("Число");
	Результат = ПараметрыФИАС();
	Запрос = Новый Запрос();
	
	Запрос.УстановитьПараметр("КодСубъектаРФ", КодРегиона);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗагруженныеВерсииАдресныхСведений.Версия,
		|	ЗагруженныеВерсииАдресныхСведений.КодСубъектаРФ КАК Регион
		|ИЗ
		|	РегистрСведений.ЗагруженныеВерсииАдресныхСведений КАК ЗагруженныеВерсииАдресныхСведений
		|ГДЕ
		|	ЗагруженныеВерсииАдресныхСведений.КодСубъектаРФ = &КодСубъектаРФ";
		
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат.Версия = ОписаниеТипаЧисло.ПривестиЗначение(Выборка.Версия);
		Результат.Регион = Выборка.Регион;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПроверитьНаличиеНовыхДанных(Знач Дескриптор)
	
	ПараметрыНовыхДанных = ПараметрыВерсииИзФайла(Дескриптор);
	Если ПараметрыНовыхДанных.Версия = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПараметрыНовыхДанных.Регион) Тогда
		Возврат Истина;
	КонецЕсли;
	
	ПараметрыТекущихДанных = ОписаниеПоследнейЗагрузкиФИАС(ПараметрыНовыхДанных.Регион);
	Если ПараметрыТекущихДанных.Версия = Неопределено
		ИЛИ ПараметрыНовыхДанных.Версия > ПараметрыТекущихДанных.Версия Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Процедура ОбработатьФИАС(Знач Дескриптор, Знач ПутьКФайлу)
	
	КаталогФайлов = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПолучитьИмяВременногоФайла());
	
	Попытка
		ЧтениеZIP = Новый ЧтениеZipФайла(ПутьКФайлу);
		ЧтениеZIP.ИзвлечьВсе(КаталогФайлов, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
		ЧтениеZIP.Закрыть();
		
		// Загружаем только то, что передано в файлах.
		СубъектыРФ = Новый Массив;
		ТипЧисло   = Новый ОписаниеТипов("Число");
		ОписаниеФайлов = Новый Массив;
		
		Для Каждого Файл Из НайтиФайлы(КаталогФайлов, "??.ZIP") Цикл
			КодРегиона = ТипЧисло.ПривестиЗначение(Лев(Файл.Имя, 2));
			Если КодРегиона > 0 Тогда
				СубъектыРФ.Добавить(КодРегиона);
			КонецЕсли;
			ОписаниеФайлов.Добавить( Новый Структура("Имя, Хранение", Файл.ПолноеИмя, Файл.ПолноеИмя));
		КонецЦикла;
		
		Если СубъектыРФ.Количество() > 0 Тогда
			
			ПараметрыЗагрузки = АдресныйКлассификаторСлужебный.ПараметрыЗагрузкиКлассификатораАдресов();
			ПараметрыЗагрузки.ЗагружатьИсториюАдресов = Истина;
			ПараметрыЗагрузки.ЗагружатьПорциями = Истина;
			ПараметрыЗагрузки.ОповещатьОПрогрессе = Ложь;
			
			АдресныйКлассификаторСлужебный.ЗагрузитьКлассификаторАдресов(СубъектыРФ, ОписаниеФайлов, ПараметрыЗагрузки);
			
		КонецЕсли;
		
	Исключение
		ФайловаяСистема.УдалитьВременныйФайл(КаталогФайлов);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти
