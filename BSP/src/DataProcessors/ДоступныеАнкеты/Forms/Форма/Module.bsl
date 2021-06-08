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
	
	Объект.РежимАнкетирования = Перечисления.РежимыАнкетирования.Анкета;
	Если Параметры.Свойство("РежимАнкетирования") Тогда
		Объект.РежимАнкетирования = Параметры.РежимАнкетирования;
		Объект.Респондент = Параметры.Респондент;
	Иначе
		ТекущийПользователь = Пользователи.АвторизованныйПользователь();
		Если ТипЗнч(ТекущийПользователь) <> Тип("СправочникСсылка.ВнешниеПользователи") Тогда 
			Объект.Респондент = ТекущийПользователь;
		Иначе	
			Объект.Респондент = ВнешниеПользователи.ПолучитьОбъектАвторизацииВнешнегоПользователя(ТекущийПользователь);
		КонецЕсли;
	КонецЕсли;
	
	ТаблицаАнкетРеспондента();
	 
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Анкета" ИЛИ ИмяСобытия = "Проведение_Анкета" Тогда
		ТаблицаАнкетРеспондента();
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДеревоАнкетПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.ТаблицаАнкет.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеДанные.АнкетаОпрос) = Тип("ДокументСсылка.Анкета") Тогда
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Ключ",ТекущиеДанные.АнкетаОпрос);
		СтруктураПараметров.Вставить("ТолькоФормаЗаполнения",Истина);
		СтруктураПараметров.Вставить("РежимАнкетирования", Объект.РежимАнкетирования);
		ОткрытьФорму("Документ.Анкета.Форма.ФормаДокумента",СтруктураПараметров,Элемент);
	ИначеЕсли ТипЗнч(ТекущиеДанные.АнкетаОпрос) = Тип("ДокументСсылка.НазначениеОпросов") Тогда
		СтруктураПараметров = Новый Структура;
		ЗначенияЗаполнения 	= Новый Структура;
		ЗначенияЗаполнения.Вставить("Респондент",Объект.Респондент);
		ЗначенияЗаполнения.Вставить("Опрос",ТекущиеДанные.АнкетаОпрос);
		ЗначенияЗаполнения.Вставить("РежимАнкетирования", Объект.РежимАнкетирования);
		СтруктураПараметров.Вставить("ЗначенияЗаполнения",ЗначенияЗаполнения);
		СтруктураПараметров.Вставить("ТолькоФормаЗаполнения",Истина);
		ОткрытьФорму("Документ.Анкета.Форма.ФормаДокумента",СтруктураПараметров,Элемент);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура АрхивАнкет(Команда)
	
	ОткрытьФорму("Обработка.ДоступныеАнкеты.Форма.АрхивАнкет",Новый Структура("Респондент",Объект.Респондент),ЭтотОбъект);
	
КонецПроцедуры 

&НаКлиенте
Процедура Обновить(Команда)
	
	ТаблицаАнкетРеспондента();
	
КонецПроцедуры 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ТаблицаАнкетРеспондента()
	
	ТаблицаАнкет.Очистить();
	
	ПолученнаяТаблицаАнкет = Анкетирование.ТаблицаДоступныхРеспондентуАнкет(Объект.Респондент);
	
	Если ПолученнаяТаблицаАнкет <> Неопределено Тогда
		
		Для каждого СтрокаТаблицы Из ПолученнаяТаблицаАнкет Цикл
			
			НоваяСтрока = ТаблицаАнкет.Добавить();
			Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.АнкетаОпрос) Тогда
				
				НоваяСтрока.Представление = СтрокаТаблицы.Статус;
				НоваяСтрока.Статус        = СтрокаТаблицы.Статус;
				
			Иначе
				
				НоваяСтрока.Статус        = СтрокаТаблицы.Статус;
				НоваяСтрока.АнкетаОпрос   = СтрокаТаблицы.АнкетаОпрос;
				НоваяСтрока.Представление = ПолучитьПредставлениеСтрокиДереваАнкеты(СтрокаТаблицы);
				
			КонецЕсли;
			
		КонецЦикла;
		
		НоваяСтрока.КодКартинки = ?(СтрокаТаблицы.Статус = "Опросы",0,1);
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует представление строки для дерева анкет.
//
// Параметры:
//  СтрокаДерева  - СтрокаДереваЗначений - на основании ее формируется представление 
//                 анкет и опросов в дереве.
&НаСервере
Функция ПолучитьПредставлениеСтрокиДереваАнкеты(СтрокаДерева)
	
	СтрокаВозврата = "";
	
	ЕстьОграниченияПоСроку = ЗначениеЗаполнено(СтрокаДерева.ДатаОкончания);
	
	Если ТипЗнч(СтрокаДерева.АнкетаОпрос) = Тип("ДокументСсылка.НазначениеОпросов") Тогда
		СтрокаВозврата = СтрокаВозврата + НСтр("ru = 'Анкета'") + " '" + СтрокаДерева.Наименование + "'";
	ИначеЕсли ТипЗнч(СтрокаДерева.АнкетаОпрос) = Тип("ДокументСсылка.Анкета") Тогда
		СтрокаВозврата = СтрокаВозврата + НСтр("ru = 'Анкета'") + " '" + СтрокаДерева.Наименование 
		+ "', " + НСтр("ru = 'последний раз редактировавшаяся'") + " " + Формат(СтрокаДерева.ДатаАнкеты, "ДЛФ=D");
	Иначе	
		Возврат СтрокаВозврата;
	КонецЕсли;
	
	Если ЕстьОграниченияПоСроку Тогда
			СтрокаВозврата = СтрокаВозврата + ", " + НСтр("ru = 'к заполнению до'") + " " + Формат(НачалоДня(КонецДня(СтрокаДерева.ДатаОкончания) + 1),"ДЛФ=D");
	КонецЕсли;
		
	СтрокаВозврата = СтрокаВозврата + ".";
	
	Возврат СтрокаВозврата;
	
КонецФункции

#КонецОбласти
