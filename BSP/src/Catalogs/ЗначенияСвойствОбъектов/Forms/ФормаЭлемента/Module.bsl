///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка)
	   И Параметры.ЗначенияЗаполнения.Свойство("Наименование") Тогда
		
		Объект.Наименование = Параметры.ЗначенияЗаполнения.Наименование;
	КонецЕсли;
	
	Если НЕ Параметры.СкрытьВладельца Тогда
		Элементы.Владелец.Видимость = Истина;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.ПоказатьВес) = Тип("Булево") Тогда
		ПоказатьВес = Параметры.ПоказатьВес;
	Иначе
		ПоказатьВес = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Владелец, "ДополнительныеЗначенияСВесом");
	КонецЕсли;
	
	Если ПоказатьВес = Истина Тогда
		Элементы.Вес.Видимость = Истина;
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "ЗначенияСВесом");
	Иначе
		Элементы.Вес.Видимость = Ложь;
		Объект.Вес = 0;
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "ЗначенияБезВеса");
	КонецЕсли;
	
	УстановитьЗаголовок();
	
	ЛокализуемыеЭлементы = Новый Массив;
	ЛокализуемыеЭлементы.Добавить(Элементы.Наименование);
	ЛокализацияСервер.ПриСозданииНаСервере(ЛокализуемыеЭлементы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Изменение_ЗначениеХарактеризуетсяВесовымКоэффициентом"
	   И Источник = Объект.Владелец Тогда
		
		Если Параметр = Истина Тогда
			Элементы.Вес.Видимость = Истина;
		Иначе
			Элементы.Вес.Видимость = Ложь;
			Объект.Вес = 0;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ЛокализацияСервер.ПередЗаписьюНаСервере(ТекущийОбъект);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьЗаголовок();
	ЛокализацияСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ЗначенияСвойствОбъектов",
		Новый Структура("Ссылка", Объект.Ссылка), Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ЛокализацияСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеОткрытие(Элемент, СтандартнаяОбработка)
	ЛокализацияКлиент.ПриОткрытии(Объект, Элемент, "Наименование", СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЗаголовок()
	
	Если ТекущийЯзык() = Метаданные.ОсновнойЯзык Тогда
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Объект.Владелец, "Заголовок, ЗаголовокФормыЗначения");
	Иначе
		Реквизиты = Новый Массив;
		Реквизиты.Добавить("Заголовок");
		Реквизиты.Добавить("ЗаголовокФормыЗначения");
		ЗначенияРеквизитов = УправлениеСвойствамиСлужебный.ЛокализованныеЗначенияРеквизитов(Объект.Владелец, Реквизиты);
	КонецЕсли;
	
	ИмяСвойства = СокрЛП(ЗначенияРеквизитов.ЗаголовокФормыЗначения);
	
	Если НЕ ПустаяСтрока(ИмяСвойства) Тогда
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (%2)'"),
				Объект.Наименование,
				ИмяСвойства);
		Иначе
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (Создание)'"), ИмяСвойства);
		КонецЕсли;
	Иначе
		ИмяСвойства = Строка(ЗначенияРеквизитов.Заголовок);
		
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (Значение свойства %2)'"),
				Объект.Наименование,
				ИмяСвойства);
		Иначе
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Значение свойства %1 (Создание)'"), ИмяСвойства);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
