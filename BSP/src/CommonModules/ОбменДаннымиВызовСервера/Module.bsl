///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен данными"
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Устанавливает значение константы ДатаОбновленияПовторноИспользуемыхЗначенийМРО.
// В качестве устанавливаемого значения используется текущая дата компьютера (сервера).
// В момент изменения значения этой константы повторно-используемые значения 
// для подсистемы обмена данными становятся неактуальными и требуют повторной инициализации.
// 
Процедура СброситьКэшМеханизмаРегистрацииОбъектов() Экспорт
	
	ОбменДаннымиСлужебный.СброситьКэшМеханизмаРегистрацииОбъектов();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает состояние выполнения фонового задания.
// Используется для реализации логики длительных операций.
//
// Параметры:
//  ИдентификаторЗадания - УникальныйИдентификатор - идентификатор фонового задания, для которого необходимо получить
//                                                   состояние.
// 
// Возвращаемое значение:
//  Строка - состояние выполнения фонового задания:
// "Активно" - задание выполняется;
// "Завершено" - задание выполнено успешно;
// "ЗавершеноАварийно" - задание завершено аварийно или отменено пользователем.
//
Функция СостояниеЗадания(Знач ИдентификаторЗадания) Экспорт
	
	Попытка
		Результат = ?(ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания), "Завершено", "Активно");
	Исключение
		Результат = "ЗавершеноАварийно";
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииОбменДанными(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет процесс обмена данными отдельно для каждой строки настройки обмена.
// Процесс обмена данными состоит из двух стадий:
// - инициализация обмена - подготовка подсистемы обмена данными к процессу обмена
// - обмен данными        - процесс зачитывания файла сообщения с последующей загрузкой этих данных в ИБ 
//                          или выгрузки изменений в файл сообщения.
// Стадия инициализации выполняется один раз за сеанс и сохраняется в кэше сеанса на сервере 
// до перезапуска сеанса или сброса повторно-используемых значений подсистемы обмена данными.
// Сброс повторно-используемых значений происходит при изменении данных, влияющих на процесс обмена данными
// (настройки транспорта, настройка выполнения обмена, настройка отборов на узлах планов обмена).
//
// Обмен может быть выполнен полностью для всех строк сценария,
// а может быть выполнен для отдельной строки ТЧ сценария обмена.
//
// Параметры:
//  Отказ                     - Булево - флаг отказа; поднимается в случае возникновения ошибки при выполнении сценария.
//  НастройкаВыполненияОбмена - СправочникСсылка.СценарииОбменовДанными - элемент справочника,
//                              по значениям реквизитов которого будет выполнен обмен данными.
//  НомерСтроки               - Число - Номер строки по которой будет выполнен обмен данными.
//                              Если не указан, то обмен данными будет выполнен для всех строк.
// 
Процедура ВыполнитьОбменДаннымиПоСценариюОбменаДанными(Отказ, НастройкаВыполненияОбмена, НомерСтроки = Неопределено) Экспорт
	
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиПоСценариюОбменаДанными(Отказ, НастройкаВыполненияОбмена, НомерСтроки);
	
КонецПроцедуры

// Фиксирует успешное выполнение обмена данными в системе.
//
Процедура ЗафиксироватьВыполнениеВыгрузкиДанныхВРежимеДлительнойОперации(Знач УзелИнформационнойБазы, Знач ДатаНачала) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДействиеПриОбмене = Перечисления.ДействияПриОбмене.ВыгрузкаДанных;
	
	СтруктураНастроекОбмена = Новый Структура;
	СтруктураНастроекОбмена.Вставить("УзелИнформационнойБазы", УзелИнформационнойБазы);
	СтруктураНастроекОбмена.Вставить("РезультатВыполненияОбмена", Перечисления.РезультатыВыполненияОбмена.Выполнено);
	СтруктураНастроекОбмена.Вставить("ДействиеПриОбмене", ДействиеПриОбмене);
	СтруктураНастроекОбмена.Вставить("КоличествоОбъектовОбработано", 0);
	СтруктураНастроекОбмена.Вставить("КлючСообщенияЖурналаРегистрации", ОбменДаннымиСервер.КлючСообщенияЖурналаРегистрации(УзелИнформационнойБазы, ДействиеПриОбмене));
	СтруктураНастроекОбмена.Вставить("ДатаНачала", ДатаНачала);
	СтруктураНастроекОбмена.Вставить("ДатаОкончания", ТекущаяДатаСеанса());
	СтруктураНастроекОбмена.Вставить("ЭтоОбменВРИБ", ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(УзелИнформационнойБазы));
	
	ОбменДаннымиСервер.ЗафиксироватьЗавершениеОбмена(СтруктураНастроекОбмена);
	
КонецПроцедуры

// Фиксирует аварийное завершение обмена данными.
//
Процедура ЗафиксироватьЗавершениеОбменаСОшибкой(Знач УзелИнформационнойБазы,
												Знач ДействиеПриОбмене,
												Знач ДатаНачала,
												Знач СтрокаСообщенияОбОшибке) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбменДаннымиСервер.ЗафиксироватьЗавершениеОбменаСОшибкой(УзелИнформационнойБазы,
											ДействиеПриОбмене,
											ДатаНачала,
											СтрокаСообщенияОбОшибке);
КонецПроцедуры

// Возвращает признак того, что набора записей регистра не содержит данных.
//
Функция НаборЗаписейРегистраПустой(СтруктураЗаписи, ИмяРегистра) Экспорт
	
	МетаданныеРегистра = Метаданные.РегистрыСведений[ИмяРегистра];
	
	// Создаем набор записей регистра.
	НаборЗаписей = РегистрыСведений[ИмяРегистра].СоздатьНаборЗаписей();
	
	// Устанавливаем отбор по измерениям регистра.
	Для Каждого Измерение Из МетаданныеРегистра.Измерения Цикл
		
		// Если задано значение в структуре, то отбор устанавливаем.
		Если СтруктураЗаписи.Свойство(Измерение.Имя) Тогда
			
			НаборЗаписей.Отбор[Измерение.Имя].Установить(СтруктураЗаписи[Измерение.Имя]);
			
		КонецЕсли;
		
	КонецЦикла;
	
	НаборЗаписей.Прочитать();
	
	Возврат НаборЗаписей.Количество() = 0;
	
КонецФункции

// Возвращает ключ сообщения журнала регистрации по строке действия.
//
Функция КлючСообщенияЖурналаРегистрацииПоСтрокеДействия(УзелИнформационнойБазы, ДействиеПриОбменеСтрокой) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиСервер.КлючСообщенияЖурналаРегистрации(УзелИнформационнойБазы, Перечисления.ДействияПриОбмене[ДействиеПриОбменеСтрокой]);
	
КонецФункции

// Возвращает структуру с данными отбора для журнала регистрации.
//
Функция ДанныеОтбораЖурналаРегистрации(УзелИнформационнойБазы, Знач ДействиеПриОбмене) Экспорт
	
	Если ТипЗнч(ДействиеПриОбмене) = Тип("Строка") Тогда
		
		ДействиеПриОбмене = Перечисления.ДействияПриОбмене[ДействиеПриОбмене];
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СостоянияОбменовДанными = ОбменДаннымиСервер.СостоянияОбменовДанными(УзелИнформационнойБазы, ДействиеПриОбмене);
	
	Отбор = Новый Структура;
	Отбор.Вставить("СобытиеЖурналаРегистрации", ОбменДаннымиСервер.КлючСообщенияЖурналаРегистрации(УзелИнформационнойБазы, ДействиеПриОбмене));
	Отбор.Вставить("ДатаНачала",                СостоянияОбменовДанными.ДатаНачала);
	Отбор.Вставить("ДатаОкончания",             СостоянияОбменовДанными.ДатаОкончания);
	
	Возврат Отбор;
	
КонецФункции

// Возвращает массив всех ссылочных типов, определенных в конфигурации.
//
Функция ВсеСсылочныеТипыКонфигурации() Экспорт
	
	Возврат ОбменДаннымиПовтИсп.ВсеСсылочныеТипыКонфигурации();
	
КонецФункции

// Получает состояние длительной операции (фонового задания), выполняемой в базе-корреспонденте для узла информационной
// базы.
//
Функция СостояниеДлительнойОперацииДляУзлаИнформационнойБазы(Знач ИдентификаторОперации,
									Знач УзелИнформационнойБазы,
									Знач ПараметрыАутентификации = Неопределено,
									СтрокаСообщенияОбОшибке = "") Экспорт
	
	Попытка
		УстановитьПривилегированныйРежим(Истина);
		
		ПараметрыПодключения = РегистрыСведений.НастройкиТранспортаОбменаДанными.НастройкиТранспортаWS(
			УзелИнформационнойБазы, ПараметрыАутентификации);
		
		WSПрокси = ОбменДаннымиСервер.ПолучитьWSПрокси(ПараметрыПодключения, СтрокаСообщенияОбОшибке);
		
		Если WSПрокси = Неопределено Тогда
			ВызватьИсключение СтрокаСообщенияОбОшибке;
		КонецЕсли;
		
		Результат = WSПрокси.GetContinuousOperationStatus(ИдентификаторОперации, СтрокаСообщенияОбОшибке);
		
	Исключение
		Результат = "Failed";
		СтрокаСообщенияОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
			+ ?(ЗначениеЗаполнено(СтрокаСообщенияОбОшибке), Символы.ПС + СтрокаСообщенияОбОшибке, "");
	КонецПопытки;
	
	Если Результат = "Failed" Тогда
		СтрокаСообщения = НСтр("ru = 'Ошибка в базе-корреспонденте: %1'");
		СтрокаСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, СтрокаСообщенияОбОшибке);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Выполняет удаление настройки синхронизации данных.
//
Процедура УдалитьНастройкуСинхронизации(Знач УзелИнформационнойБазы) Экспорт
	
	ОбменДаннымиСервер.УдалитьНастройкуСинхронизации(УзелИнформационнойБазы);
	
КонецПроцедуры

Функция ВариантОбменаДанными(Знач Корреспондент) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиСервер.ВариантОбменаДанными(Корреспондент);
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обмен данными под полными правами.

// Получает список метаданных объектов узла, для которых не разрешена выгрузка.
// Выгрузка не разрешена, если в правилах регистрации объектов плана обмена таблица отмечена как НеВыгружать.
//
// Параметры:
//     УзелИнформационнойБазы - ПланОбменаСсылка - ссылка на анализируемый узел плана обмена.
//
// Возвращаемое значение:
//     Массив, содержащий полные имена объектов метаданных.
//
Функция ИменаМетаданныхНеВыгружаемыхОбъектовУзла(Знач УзелИнформационнойБазы) Экспорт
	Результат = Новый Массив;
	
	РежимНеВыгружать = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
	РежимыВыгрузки   = ОбменДаннымиПовтИсп.ПользовательскийСоставПланаОбмена(УзелИнформационнойБазы);
	Для Каждого КлючЗначение Из РежимыВыгрузки Цикл
		Если КлючЗначение.Значение=РежимНеВыгружать Тогда
			Результат.Добавить(КлючЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// Проверяет, является ли главным указанный узел обмена.
//
// Параметры:
//   УзелИнформационнойБазы - ПланОбменаСсылка - ссылка на узел плана обмена,
//       который надо проверить является он главным или нет.
//
// Возвращаемое значение:
//   Булево.
//
Функция УзелЯвляетсяГлавным(Знач УзелИнформационнойБазы) Экспорт
	
	Возврат ПланыОбмена.ГлавныйУзел() = УзелИнформационнойБазы;
	
КонецФункции

// Создает запрос на очистку разрешений для узла (при удалении).
//
Функция ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов(Знач УзелИнформационнойБазы) Экспорт
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	Запрос = МодульРаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов(УзелИнформационнойБазы);
	Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Запрос);
	
КонецФункции

#КонецОбласти