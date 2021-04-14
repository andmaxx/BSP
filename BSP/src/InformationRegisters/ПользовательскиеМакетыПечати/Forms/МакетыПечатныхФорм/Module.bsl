///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстВыбора;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТаблицуМакетовПечатныхФорм();
	Если Параметры.Свойство("ПоказыватьТолькоПользовательскиеИзмененные") Тогда
		ОтборПоИспользованиюМакета = "ИспользуемыеИзмененные";
	Иначе
		ОтборПоИспользованиюМакета = Элементы.ОтборПоИспользованиюМакета.СписокВыбора[0].Значение;
	КонецЕсли;
	
	ЕстьПравоИзменения = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ПользовательскиеМакетыПечати);
	ТолькоПросмотр = Не ЕстьПравоИзменения;
	Элементы.МакетыПечатныхФормИзменитьМакет.Видимость = ЕстьПравоИзменения;
	Элементы.МакетыПечатныхФормГруппаПереключениеИспользуемогоМакета.Видимость = ЕстьПравоИзменения;
	Элементы.МакетыПечатныхФормУдалитьИзмененныйМакет.Видимость = ЕстьПравоИзменения;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		СпрашиватьРежимОткрытияМакета = Ложь;
		РежимОткрытияМакетаПросмотр = Истина;
		
	Иначе
		
		СпрашиватьРежимОткрытияМакета = ЕстьПравоИзменения;
		РежимОткрытияМакетаПросмотр = Не ЕстьПравоИзменения;
		
		Если ЕстьПравоИзменения Тогда
			СпрашиватьРежимОткрытияМакета = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
				"НастройкаОткрытияМакетов", "СпрашиватьРежимОткрытияМакета", Истина);
			РежимОткрытияМакетаПросмотр = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
				"НастройкаОткрытияМакетов", "РежимОткрытияМакетаПросмотр", Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПользовательскиеМакетыПечати" Тогда
		ОбновитьОтображениеМакетов();
	ИначеЕсли ИмяСобытия = "Запись_ТабличныйДокумент" И Источник.ВладелецФормы = ЭтотОбъект Тогда
		Если Не ТолькоПросмотр Тогда
			Макет = Параметр.ТабличныйДокумент;
			АдресМакетаВоВременномХранилище = ПоместитьВоВременноеХранилище(Макет);
			ЗаписатьМакет(Параметр.ИмяОбъектаМетаданныхМакета, АдресМакетаВоВременномХранилище);
		КонецЕсли;
		ОбновитьОтображениеМакетов()
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("РегистрСведений.ПользовательскиеМакетыПечати.Форма.ВыбораРежимаОткрытияМакета") Тогда
		
		Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
			Возврат;
		КонецЕсли;
		
		РежимОткрытияМакетаПросмотр = ВыбранноеЗначение.РежимОткрытияПросмотр;
		СпрашиватьРежимОткрытияМакета = НЕ ВыбранноеЗначение.БольшеНеСпрашивать;
		
		Если КонтекстВыбора = "ОткрытьМакетПечатнойФормы" Тогда
			
			Если ВыбранноеЗначение.БольшеНеСпрашивать Тогда
				СохранитьНастройкиРежимаОткрытияМакета(СпрашиватьРежимОткрытияМакета, РежимОткрытияМакетаПросмотр);
			КонецЕсли;
			
			Если РежимОткрытияМакетаПросмотр Тогда
				ОткрытьМакетПечатнойФормыДляПросмотра();
			Иначе
				ОткрытьМакетПечатнойФормыДляРедактирования();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Параметр = Новый Структура("Отказ", Ложь);
	Оповестить("ЗакрытиеФормыВладельца", Параметр, ЭтотОбъект);
	
	Если Параметр.Отказ Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьОтборМакетов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыМакетыПечатныхФорм

&НаКлиенте
Процедура МакетыПечатныхФормВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьМакетПечатнойФормы();
КонецПроцедуры

&НаКлиенте
Процедура МакетыПечатныхФормПриАктивизацииСтроки(Элемент)
	УстановитьДоступностьКнопокКоманднойПанели();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьМакет(Команда)
	ОткрытьМакетПечатнойФормыДляРедактирования();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьМакет(Команда)
	ОткрытьМакетПечатнойФормыДляПросмотра();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьИзмененныйМакет(Команда)
	ПереключитьИспользованиеВыбранныхМакетов(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСтандартныйМакет(Команда)
	ПереключитьИспользованиеВыбранныхМакетов(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьДействиеПриВыбореМакетаПечатнойФормы(Команда)
	
	КонтекстВыбора = "ЗадатьДействиеПриВыбореМакетаПечатнойФормы";
	ОткрытьФорму("РегистрСведений.ПользовательскиеМакетыПечати.Форма.ВыбораРежимаОткрытияМакета", , ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Начальное заполнение

&НаСервере
Процедура ЗаполнитьТаблицуМакетовПечатныхФорм()
	
	Для Каждого ОписаниеМакета Из РегистрыСведений.ПоставляемыеМакетыПечати.ВсеМакетыПечатныхФормКонфигурации() Цикл
		Владелец = ОписаниеМакета.Значение;
		ИмяВладельца = ?(Метаданные.ОбщиеМакеты = Владелец, "ОбщийМакет", Владелец.ПолноеИмя());
		ПредставлениеВладельца = ?(Метаданные.ОбщиеМакеты = Владелец, НСтр("ru = 'Общий макет'"), Владелец.Представление());
		
		Макет = ОписаниеМакета.Ключ;
		ИмяМакета = ИмяВладельца + "." + Макет.Имя;
		ПредставлениеМакета = Макет.Представление();
		
		ТипМакета = ТипМакета(Макет.Имя, ИмяВладельца);
		
		ДобавитьОписаниеМакета(ИмяМакета, ПредставлениеМакета, ПредставлениеВладельца, ТипМакета);
	КонецЦикла;
	
	МакетыПечатныхФорм.Сортировать("ПредставлениеМакета Возр");
	УстановитьФлагиИспользованияИзмененныхМакетов();
КонецПроцедуры

&НаСервере
Функция ДобавитьОписаниеМакета(ИмяОбъектаМетаданныхМакета, ПредставлениеМакета, ПредставлениеВладельца, ТипМакета)
	ОписаниеМакета = МакетыПечатныхФорм.Добавить();
	ОписаниеМакета.ТипМакета = ТипМакета;
	ОписаниеМакета.ИмяОбъектаМетаданныхМакета = ИмяОбъектаМетаданныхМакета;
	ОписаниеМакета.ПредставлениеВладельца = ПредставлениеВладельца;
	ОписаниеМакета.ПредставлениеМакета = ПредставлениеМакета;
	ОписаниеМакета.Картинка = ИндексКартинки(ТипМакета);
	ОписаниеМакета.СтрокаПоиска = ИмяОбъектаМетаданныхМакета + " "
								+ ПредставлениеВладельца + " "
								+ ПредставлениеМакета + " "
								+ ТипМакета;
	Возврат ОписаниеМакета;
КонецФункции

&НаСервере
Процедура УстановитьФлагиИспользованияИзмененныхМакетов()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ИзмененныеМакеты.ИмяМакета,
	|	ИзмененныеМакеты.Объект,
	|	ИзмененныеМакеты.Использование
	|ИЗ
	|	РегистрСведений.ПользовательскиеМакетыПечати КАК ИзмененныеМакеты";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	ИзмененныеМакеты = Запрос.Выполнить().Выгрузить();
	Для Каждого Макет Из ИзмененныеМакеты Цикл
		ИмяОбъектаМетаданныхМакета = Макет.Объект + "." + Макет.ИмяМакета;
		НайденныеСтроки = МакетыПечатныхФорм.НайтиСтроки(Новый Структура("ИмяОбъектаМетаданныхМакета", ИмяОбъектаМетаданныхМакета));
		Для Каждого ОписаниеМакета Из НайденныеСтроки Цикл
			ОписаниеМакета.Изменен = Истина;
			ОписаниеМакета.ИспользуетсяИзмененный = Макет.Использование;
			ОписаниеМакета.КартинкаИспользования = Число(ОписаниеМакета.Изменен) + Число(ОписаниеМакета.ИспользуетсяИзмененный);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ТипМакета(ИмяОбъектаМетаданныхМакета, ИмяОбъекта = "ОбщийМакет")
	
	Позиция = СтрНайти(ИмяОбъектаМетаданныхМакета, "ПФ_");
	Если Позиция = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ИмяОбъекта = "ОбщийМакет" Тогда
		МакетПечатнойФормы = ПолучитьОбщийМакет(ИмяОбъектаМетаданныхМакета);
	Иначе
		УстановитьОтключениеБезопасногоРежима(Истина);
		УстановитьПривилегированныйРежим(Истина);
		
		МакетПечатнойФормы = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ИмяОбъекта).ПолучитьМакет(ИмяОбъектаМетаданныхМакета);
		
		УстановитьПривилегированныйРежим(Ложь);
		УстановитьОтключениеБезопасногоРежима(Ложь);
	КонецЕсли;
	
	ТипМакета = Неопределено;
	
	Если ТипЗнч(МакетПечатнойФормы) = Тип("ТабличныйДокумент") Тогда
		ТипМакета = "MXL";
	ИначеЕсли ТипЗнч(МакетПечатнойФормы) = Тип("ДвоичныеДанные") Тогда
		ТипМакета = ВРег(УправлениеПечатьюСлужебный.ОпределитьРасширениеФайлаДанныхПоСигнатуре(МакетПечатнойФормы));
	КонецЕсли;
	
	Возврат ТипМакета;
	
КонецФункции

&НаСервере
Функция ИндексКартинки(Знач ТипМакета)
	
	ТипыМакетов = Новый Соответствие;
	ТипыМакетов.Вставить("DOC", 0);
	ТипыМакетов.Вставить("ODT", 1);
	ТипыМакетов.Вставить("MXL", 2);
	
	Результат = ТипыМакетов[ВРег(ТипМакета)];
	Возврат ?(Результат = Неопределено, -1, Результат);
	
КонецФункции 

// Отборы

&НаКлиенте
Процедура УстановитьОтборМакетов(Текст = Неопределено);
	Если Текст = Неопределено Тогда
		Текст = СтрокаПоиска;
	КонецЕсли;
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("СтрокаПоиска", СокрЛП(Текст));
	Если ОтборПоИспользованиюМакета = "Измененные" Тогда
		СтруктураОтбора.Вставить("Изменен", Истина);
	ИначеЕсли ОтборПоИспользованиюМакета = "НеИзмененные" Тогда
		СтруктураОтбора.Вставить("Изменен", Ложь);
	ИначеЕсли ОтборПоИспользованиюМакета = "ИспользуемыеИзмененные" Тогда
		СтруктураОтбора.Вставить("ИспользуетсяИзмененный", Истина);
	ИначеЕсли ОтборПоИспользованиюМакета = "НеИспользуемыеИзмененные" Тогда
		СтруктураОтбора.Вставить("ИспользуетсяИзмененный", Ложь);
		СтруктураОтбора.Вставить("Изменен", Истина);
	КонецЕсли;
	
	Элементы.МакетыПечатныхФорм.ОтборСтрок = Новый ФиксированнаяСтруктура(СтруктураОтбора);
	УстановитьДоступностьКнопокКоманднойПанели();
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	УстановитьОтборМакетов(Текст);
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОчистка(Элемент, СтандартнаяОбработка)
	УстановитьОтборМакетов();
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	УстановитьОтборМакетов();
	Если Элементы.СтрокаПоиска.СписокВыбора.НайтиПоЗначению(СтрокаПоиска) = Неопределено Тогда
		Элементы.СтрокаПоиска.СписокВыбора.Добавить(СтрокаПоиска);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоВидуИспользуемогоМакетаПриИзменении(Элемент)
	УстановитьОтборМакетов();
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоИспользованиюМакетаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОтборПоИспользованиюМакета = Элементы.ОтборПоИспользованиюМакета.СписокВыбора[0].Значение;
	УстановитьОтборМакетов();
КонецПроцедуры

// Открытие макета

&НаКлиенте
Процедура ОткрытьМакетПечатнойФормы()
	
	Если СпрашиватьРежимОткрытияМакета Тогда
		КонтекстВыбора = "ОткрытьМакетПечатнойФормы";
		ОткрытьФорму("РегистрСведений.ПользовательскиеМакетыПечати.Форма.ВыбораРежимаОткрытияМакета", , ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
	Если РежимОткрытияМакетаПросмотр Тогда
		ОткрытьМакетПечатнойФормыДляПросмотра();
	Иначе
		ОткрытьМакетПечатнойФормыДляРедактирования();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьМакетПечатнойФормыДляПросмотра()
	
	ТекущиеДанные = Элементы.МакетыПечатныхФорм.ТекущиеДанные;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ИмяОбъектаМетаданныхМакета", ТекущиеДанные.ИмяОбъектаМетаданныхМакета);
	ПараметрыОткрытия.Вставить("ТипМакета", ТекущиеДанные.ТипМакета);
	ПараметрыОткрытия.Вставить("ТолькоОткрытие", Истина);
	
	Если ТекущиеДанные.ТипМакета = "MXL" Тогда
		ПараметрыОткрытия.Вставить("ИмяДокумента", ТекущиеДанные.ПредставлениеМакета);
		ОткрытьФорму("ОбщаяФорма.РедактированиеТабличногоДокумента", ПараметрыОткрытия, ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("РегистрСведений.ПользовательскиеМакетыПечати.Форма.РедактированиеМакета", ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьМакетПечатнойФормыДляРедактирования()
	
	ТекущиеДанные = Элементы.МакетыПечатныхФорм.ТекущиеДанные;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ИмяОбъектаМетаданныхМакета", ТекущиеДанные.ИмяОбъектаМетаданныхМакета);
	ПараметрыОткрытия.Вставить("ТипМакета", ТекущиеДанные.ТипМакета);
	
	Если ТекущиеДанные.ТипМакета = "MXL" Тогда
		ПараметрыОткрытия.Вставить("ИмяДокумента", ТекущиеДанные.ПредставлениеМакета);
		ПараметрыОткрытия.Вставить("Редактирование", Истина);
		ОткрытьФорму("ОбщаяФорма.РедактированиеТабличногоДокумента", ПараметрыОткрытия, ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("РегистрСведений.ПользовательскиеМакетыПечати.Форма.РедактированиеМакета", ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНастройкиРежимаОткрытияМакета(СпрашиватьРежимОткрытияМакета, РежимОткрытияМакетаПросмотр)
	
	Если НЕ ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкаОткрытияМакетов",
			"СпрашиватьРежимОткрытияМакета", СпрашиватьРежимОткрытияМакета);
		
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкаОткрытияМакетов",
			"РежимОткрытияМакетаПросмотр", РежимОткрытияМакетаПросмотр);
		
	КонецЕсли;
	
КонецПроцедуры

// Действия с макетами

&НаКлиенте
Процедура ПереключитьИспользованиеВыбранныхМакетов(ИспользуетсяИзмененный)
	ПереключаемыеМакеты = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из Элементы.МакетыПечатныхФорм.ВыделенныеСтроки Цикл
		ТекущиеДанные = Элементы.МакетыПечатныхФорм.ДанныеСтроки(ВыделеннаяСтрока);
		Если ТекущиеДанные.Изменен Тогда
			ТекущиеДанные.ИспользуетсяИзмененный = ИспользуетсяИзмененный;
			УстановитьКартинкуИспользования(ТекущиеДанные);
			ПереключаемыеМакеты.Добавить(ТекущиеДанные.ИмяОбъектаМетаданныхМакета);
		КонецЕсли;
	КонецЦикла;
	УстановитьИспользованиеИзмененныхМакетов(ПереключаемыеМакеты, ИспользуетсяИзмененный);
	УстановитьДоступностьКнопокКоманднойПанели();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьИспользованиеИзмененныхМакетов(Макеты, ИспользуетсяИзмененный)
	
	Для Каждого ИмяОбъектаМетаданныхМакета Из Макеты Цикл
		ЧастиИмени = СтрРазделить(ИмяОбъектаМетаданныхМакета, ".");
		ИмяМакета = ЧастиИмени[ЧастиИмени.ВГраница()];
		
		ИмяВладельца = "";
		Для НомерЧасти = 0 По ЧастиИмени.ВГраница()-1 Цикл
			Если Не ПустаяСтрока(ИмяВладельца) Тогда
				ИмяВладельца = ИмяВладельца + ".";
			КонецЕсли;
			ИмяВладельца = ИмяВладельца + ЧастиИмени[НомерЧасти];
		КонецЦикла;
		
		Запись = РегистрыСведений.ПользовательскиеМакетыПечати.СоздатьМенеджерЗаписи();
		Запись.Объект = ИмяВладельца;
		Запись.ИмяМакета = ИмяМакета;
		Запись.Прочитать();
		Если Запись.Выбран() Тогда
			Запись.Использование = ИспользуетсяИзмененный;
			Запись.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВыбранныеИзмененныеМакеты(Команда)
	УдаляемыеМакеты = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из Элементы.МакетыПечатныхФорм.ВыделенныеСтроки Цикл
		ТекущиеДанные = Элементы.МакетыПечатныхФорм.ДанныеСтроки(ВыделеннаяСтрока);
		ТекущиеДанные.ИспользуетсяИзмененный = Ложь;
		ТекущиеДанные.Изменен = Ложь;
		УстановитьКартинкуИспользования(ТекущиеДанные);
		УдаляемыеМакеты.Добавить(ТекущиеДанные.ИмяОбъектаМетаданныхМакета);
	КонецЦикла;
	УдалитьИзмененныеМакеты(УдаляемыеМакеты);
	УстановитьДоступностьКнопокКоманднойПанели();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьИзмененныеМакеты(УдаляемыеМакеты)
	
	Для Каждого ИмяОбъектаМетаданныхМакета Из УдаляемыеМакеты Цикл
		ЧастиИмени = СтрРазделить(ИмяОбъектаМетаданныхМакета, ".");
		ИмяМакета = ЧастиИмени[ЧастиИмени.ВГраница()];
		
		ИмяВладельца = "";
		Для НомерЧасти = 0 По ЧастиИмени.ВГраница()-1 Цикл
			Если Не ПустаяСтрока(ИмяВладельца) Тогда
				ИмяВладельца = ИмяВладельца + ".";
			КонецЕсли;
			ИмяВладельца = ИмяВладельца + ЧастиИмени[НомерЧасти];
		КонецЦикла;
		
		МенеджерЗаписи = РегистрыСведений.ПользовательскиеМакетыПечати.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Объект = ИмяВладельца;
		МенеджерЗаписи.ИмяМакета = ИмяМакета;
		МенеджерЗаписи.Удалить();
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьМакет(ИмяОбъектаМетаданныхМакета, АдресМакетаВоВременномХранилище)
	УправлениеПечатью.ЗаписатьМакет(ИмяОбъектаМетаданныхМакета, АдресМакетаВоВременномХранилище);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтображениеМакетов();
	
	УстановитьФлагиИспользованияИзмененныхМакетов();
	УстановитьДоступностьКнопокКоманднойПанели();
	
КонецПроцедуры

// Общие

&НаКлиенте
Процедура УстановитьКартинкуИспользования(ОписаниеМакета)
	ОписаниеМакета.КартинкаИспользования = Число(ОписаниеМакета.Изменен) + Число(ОписаниеМакета.ИспользуетсяИзмененный);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКнопокКоманднойПанели()
	
	ТекущийМакет = Элементы.МакетыПечатныхФорм.ТекущиеДанные;
	ТекущийМакетВыбран = ТекущийМакет <> Неопределено;
	ВыбраноНесколькоМакетов = Элементы.МакетыПечатныхФорм.ВыделенныеСтроки.Количество() > 1;
	
	Элементы.МакетыПечатныхФормОткрытьМакет.Доступность = ТекущийМакетВыбран И Не ВыбраноНесколькоМакетов;
	Элементы.МакетыПечатныхФормИзменитьМакет.Доступность = ТекущийМакетВыбран И Не ВыбраноНесколькоМакетов;
	
	ИспользоватьИзмененныйМакетДоступность = Ложь;
	ИспользоватьСтандартныйМакетДоступность = Ложь;
	УдалитьИзмененныйМакетДоступность = Ложь;
	
	Для Каждого ВыделеннаяСтрока Из Элементы.МакетыПечатныхФорм.ВыделенныеСтроки Цикл
		ТекущийМакет = Элементы.МакетыПечатныхФорм.ДанныеСтроки(ВыделеннаяСтрока);
		ИспользоватьИзмененныйМакетДоступность = ТекущийМакетВыбран И ТекущийМакет.Изменен И Не ТекущийМакет.ИспользуетсяИзмененный Или ВыбраноНесколькоМакетов И ИспользоватьИзмененныйМакетДоступность;
		ИспользоватьСтандартныйМакетДоступность = ТекущийМакетВыбран И ТекущийМакет.Изменен И ТекущийМакет.ИспользуетсяИзмененный Или ВыбраноНесколькоМакетов И ИспользоватьСтандартныйМакетДоступность;
		УдалитьИзмененныйМакетДоступность = ТекущийМакетВыбран И ТекущийМакет.Изменен Или ВыбраноНесколькоМакетов И УдалитьИзмененныйМакетДоступность;
	КонецЦикла;
	
	Элементы.МакетыПечатныхФормИспользоватьИзмененныйМакет.Доступность = ИспользоватьИзмененныйМакетДоступность;
	Элементы.МакетыПечатныхФормИспользоватьСтандартныйМакет.Доступность = ИспользоватьСтандартныйМакетДоступность;
	Элементы.МакетыПечатныхФормУдалитьИзмененныйМакет.Доступность = УдалитьИзмененныйМакетДоступность;
	
КонецПроцедуры

#КонецОбласти
