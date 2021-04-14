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
	
	ДоступныеТипы = РеквизитФормыВЗначение("Объект").Метаданные().Реквизиты.ТипРеспондентов.Тип.Типы();
	
	Для каждого ДоступныйТип Из ДоступныеТипы Цикл
		
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ДоступныйТип);
		Элементы.ТипРеспондентов.СписокВыбора.Добавить(Новый ОписаниеТипов(МассивТипов),Строка(ДоступныйТип));
		
	КонецЦикла;
	
	ИспользоватьВнешнихПользователей = ПолучитьФункциональнуюОпцию("ИспользоватьВнешнихПользователей");
	Если Объект.Ссылка.Пустая() И Не ИспользоватьВнешнихПользователей Тогда
		Объект.ТипРеспондентов = Новый ("СправочникСсылка.Пользователи");
	КонецЕсли; 
	Элементы.ТипРеспондентов.Видимость = ИспользоватьВнешнихПользователей;
	
	Если Объект.ТипРеспондентов = Неопределено Тогда
		Если ДоступныеТипы.Количество() > 0 Тогда
			 Объект.ТипРеспондентов = Новый(ДоступныеТипы[0]);
			 ТипРеспондентов = Элементы.ТипРеспондентов.СписокВыбора[0].Значение;
		 КонецЕсли;
	 Иначе
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ТипЗнч(Объект.ТипРеспондентов));
		ТипРеспондентов = Новый ОписаниеТипов(МассивТипов);
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
		МодульПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбработатьИзменениеТипаРеспондента();
	УправлениеДоступностью();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если (Объект.ДатаНачала > Объект.ДатаОкончания) И (Объект.ДатаОкончания <> Дата(1,1,1)) Тогда
	
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Дата начала не может быть больше чем дата окончания.'"),,"Объект.ДатаНачала");
		Отказ = Истина;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ВыборРеспондентов" Тогда
		
		Для каждого ЭлементМассива Из Параметр.ОтобранныеРеспонденты Цикл
			
			Если Объект.Респонденты.НайтиСтроки(Новый Структура("Респондент", ЭлементМассива)).Количество() = 0 Тогда
				
				НоваяСтрока = Объект.Респонденты.Добавить();
				НоваяСтрока.Респондент = ЭлементМассива;
				
			КонецЕсли;
			
		КонецЦикла;
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
		МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипРеспондентовПриИзменении(Элемент)
	
	ОбработатьИзменениеТипаРеспондента();
	УправлениеДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура СвободныйОпросПриИзменении(Элемент)
	
	УправлениеДоступностью();
	Если Объект.Респонденты.Количество() > 0 Тогда
		Объект.Респонденты.Очистить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРеспонденты

&НаКлиенте
Процедура РеспондентыРеспондентНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Респонденты.ТекущиеДанные;
	
	Значение                 = ТекущиеДанные.Респондент;
	ТекущиеДанные.Респондент = ТипРеспондентов.ПривестиЗначение(Значение);
	Элемент.ВыбиратьТип      = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура РеспондентыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элементы.Респонденты.ТекущиеДанные;
	
	Значение                  = ТекущиеДанные.Респондент;
	ТекущиеДанные.Респондент  = ТипРеспондентов.ПривестиЗначение(Значение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Открывает форму подбора респондентов.
&НаКлиенте
Процедура ПодборРеспондентов(Команда)
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ТипРеспондента",Объект.ТипРеспондентов);
	СтруктураОтбора.Вставить("Респонденты",Объект.Респонденты);
	
	ОткрытьФорму("Документ.НазначениеОпросов.Форма.ФормаПодбораРеспондентов",СтруктураОтбора,ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обрабатывает изменение типа респондента.
&НаКлиенте
Процедура ОбработатьИзменениеТипаРеспондента()
	
	Элементы.РеспондентыРеспондент.ОграничениеТипа  = ТипРеспондентов;
	Элементы.РеспондентыРеспондент.ДоступныеТипы	= ТипРеспондентов;
	
	Если Объект.ТипРеспондентов <> Неопределено Тогда
		Объект.ТипРеспондентов = Новый(ТипРеспондентов.Типы()[0]);
	КонецЕсли;
	
	Для каждого СтрокаРеспонденты Из Объект.Респонденты Цикл
		
		Если Не ТипРеспондентов.СодержитТип(ТипЗнч(СтрокаРеспонденты.Респондент)) Тогда
			Объект.Респонденты.Очистить();
			Элементы.Респонденты.Обновить();
		КонецЕсли;
		
		Прервать;
		
	КонецЦикла;
	
КонецПроцедуры

// Управляет доступностью элементов формы.
&НаКлиенте
Процедура УправлениеДоступностью()

	Элементы.Респонденты.ТолькоПросмотр           = Объект.СвободныйОпрос;
	Элементы.КнопкаПодборРеспондентов.Доступность = НЕ Объект.СвободныйОпрос;

КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()

	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);

КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
	МодульПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
	МодульПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
	МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
