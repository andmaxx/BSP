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
	
	СписокПолейСопоставления = Параметры.СписокПолейСопоставления;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстПоясняющейНадписи();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокПолейСопоставленияПриИзменении(Элемент)
	
	ОбновитьТекстПоясняющейНадписи();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьСопоставление(Команда)
	
	ОповеститьОВыборе(СписокПолейСопоставления.Скопировать());
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ОповеститьОВыборе(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьТекстПоясняющейНадписи()
	
	МассивОтмеченныхЭлементовСписка = ОбщегоНазначенияКлиентСервер.ОтмеченныеЭлементы(СписокПолейСопоставления);
	
	Если МассивОтмеченныхЭлементовСписка.Количество() = 0 Тогда
		
		ПоясняющаяНадпись = НСтр("ru = 'Сопоставление будет выполнено только по внутренним идентификаторам объектов.'");
		
	Иначе
		
		ПоясняющаяНадпись = НСтр("ru = 'Сопоставление будет выполнено по внутренним идентификаторам объектов и по выбранным полям.'");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
