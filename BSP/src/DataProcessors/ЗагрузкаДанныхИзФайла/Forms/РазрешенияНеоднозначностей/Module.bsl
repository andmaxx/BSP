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
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьОформлениеДанных();
	
	Если Параметры.ТипЗагрузки = "ТабличнаяЧасть" И ЗначениеЗаполнено(Параметры.ПолноеИмяТабличнойЧасти) Тогда 
		СписокНеоднозначностей = Новый Массив;
		
		МассивОбъекта = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивСлов(Параметры.ПолноеИмяТабличнойЧасти);
		Если МассивОбъекта[0] = "Документ" Тогда
			МенеджерОбъекта = Документы[МассивОбъекта[1]];
		ИначеЕсли МассивОбъекта[0] = "Справочник" Тогда
			МенеджерОбъекта = Справочники[МассивОбъекта[1]];
		Иначе
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		МенеджерОбъекта.ЗаполнитьСписокНеоднозначностей(Параметры.ПолноеИмяТабличнойЧасти, СписокНеоднозначностей, Параметры.Имя, Параметры.ЗначенияЗагружаемыхКолонок, Параметры.ДополнительныеПараметры);
		
		Элементы.ВариантРазрешенияНеоднозначности.Видимость = Ложь;
		Элементы.ДекорацияЗаголовок.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.ДекорацияЗаголовок.Заголовок, Параметры.Имя);
		Элементы.ДекорацияЗаголовок.Видимость = Истина;
		Элементы.ДекорацияЗагрузкаИзФайла.Видимость = Ложь;
		Элементы.ЭлементыСправочника.КоманднаяПанель.ПодчиненныеЭлементы.ЭлементыСправочникаНовыйЭлемент.Видимость = Ложь;
		Для каждого Колонка Из Параметры.ЗначенияЗагружаемыхКолонок Цикл 
			КолонкиСопоставления.Добавить(Колонка.Ключ);
		КонецЦикла;
		Элементы.ДекорацияЗаголовокПоискСсылок.Видимость = Ложь;
		
	ИначеЕсли Параметры.ТипЗагрузки = "ВставкаИзБуфераОбмена" Тогда
		Элементы.ГруппаДанныеИзФайла.Видимость = Ложь;
		Элементы.ДекорацияЗаголовок.Видимость = Ложь;
		Элементы.ДекорацияЗагрузкаИзФайла.Видимость = Ложь;
		Элементы.ДекорацияЗаголовокПоискСсылок.Видимость = Истина;
		СписокНеоднозначностей = Параметры.СписокНеоднозначностей.ВыгрузитьЗначения();
		КолонкиСопоставления = Параметры.КолонкиСопоставления;
	Иначе
		СписокНеоднозначностей = Параметры.СписокНеоднозначностей.ВыгрузитьЗначения();
		КолонкиСопоставления = Параметры.КолонкиСопоставления;
		Элементы.ДекорацияЗаголовок.Видимость = Ложь;
		Элементы.ДекорацияЗагрузкаИзФайла.Видимость = Истина;
		Элементы.ДекорацияЗаголовокПоискСсылок.Видимость = Ложь;
	КонецЕсли;
	Индекс = 0;
	
	Если СписокНеоднозначностей.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ВременнаяТЗ = РеквизитФормыВЗначение("ЭлементыСправочника");
	ВременнаяТЗ.Колонки.Очистить();
	МассивРеквизитов = Новый Массив;

	ПервыйЭлемент = СписокНеоднозначностей.Получить(0);
	МетаданныеОбъект = ПервыйЭлемент.Метаданные();
	
	Для каждого Реквизит Из ПервыйЭлемент.Метаданные().Реквизиты Цикл
		Если Реквизит.Тип.Типы().Найти(Тип("ХранилищеЗначения")) = Неопределено Тогда
			ВременнаяТЗ.Колонки.Добавить(Реквизит.Имя, Реквизит.Тип, Реквизит.Представление());
			МассивРеквизитов.Добавить(Новый РеквизитФормы(Реквизит.Имя, Реквизит.Тип, "ЭлементыСправочника", Реквизит.Представление()));
		КонецЕсли;
	КонецЦикла;
	
	Для каждого Реквизит Из МетаданныеОбъект.СтандартныеРеквизиты Цикл
		ВременнаяТЗ.Колонки.Добавить(Реквизит.Имя, Реквизит.Тип, Реквизит.Представление());
		МассивРеквизитов.Добавить(Новый РеквизитФормы(Реквизит.Имя, Реквизит.Тип, "ЭлементыСправочника", Реквизит.Представление()));
	КонецЦикла;
	
	Для каждого Элемент Из Параметры.СтрокаИзТаблицы Цикл
		МассивРеквизитов.Добавить(Новый РеквизитФормы("ФЛ_" + Элемент[Индекс], Новый ОписаниеТипов("Строка"),, Элемент[1]));
	КонецЦикла;
	
	ИзменитьРеквизиты(МассивРеквизитов);
	
	Элементы.ЭлементыСправочника.Высота = СписокНеоднозначностей.Количество() + 3;
	
	Для каждого Элемент Из СписокНеоднозначностей Цикл
		Строка = ВариантыВыбора.ПолучитьЭлементы().Добавить();
		Строка.Представление = Строка(Элемент);
		Строка.Ссылка = Элемент.Ссылка;
		МетаданныеОбъект = Элемент.Метаданные();
		
		Для каждого Реквизит Из МетаданныеОбъект.СтандартныеРеквизиты Цикл
			Если Реквизит.Имя = "Код" ИЛИ Реквизит.Имя = "Наименование" Тогда
				ПодСтрока = Строка.ПолучитьЭлементы().Добавить();
				ПодСтрока.Представление = Реквизит.Представление() + ":";
				ПодСтрока.Значение = Элемент[Реквизит.Имя];
				ПодСтрока.Ссылка = Элемент.Ссылка;
			КонецЕсли;
		КонецЦикла;
		
		Для каждого Реквизит Из МетаданныеОбъект.Реквизиты Цикл
			ПодСтрока = Строка.ПолучитьЭлементы().Добавить();
			ПодСтрока.Представление = Реквизит.Представление() + ":";
			ПодСтрока.Значение = Элемент[Реквизит.Имя];
			ПодСтрока.Ссылка = Элемент.Ссылка;
		КонецЦикла;
	
	КонецЦикла;
	
	Для каждого Элемент Из СписокНеоднозначностей Цикл
		МетаданныеОбъект = Элемент.Метаданные();
		
		Строка = ЭлементыСправочника.Добавить();
		Строка.Представление = Строка(Элемент);
		Для Каждого Колонка Из ВременнаяТЗ.Колонки Цикл
			Если МетаданныеОбъект.Реквизиты.Найти(Колонка.Имя) <> Неопределено Тогда
				Типы = Новый Массив;
				Типы.Добавить(ТипЗнч(Строка[Колонка.Имя]));
				ОписаниеТипа = Новый ОписаниеТипов(Типы);
				Строка[Колонка.Имя] = ОписаниеТипа.ПривестиЗначение(Элемент[Колонка.Имя]);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого Колонка Из ВременнаяТЗ.Колонки Цикл
		НовыйЭлемент = Элементы.Добавить(Колонка.Имя, Тип("ПолеФормы"), Элементы.ЭлементыСправочника);
		НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
		НовыйЭлемент.ПутьКДанным = "ЭлементыСправочника." + Колонка.Имя;
		НовыйЭлемент.Заголовок = Колонка.Заголовок;
	КонецЦикла;
	
	Если Параметры.ТипЗагрузки = "ВставкаИзБуфераОбмена" Тогда
		Разделитель = "";
		СтрокаСоЗначениями = "";
		Для каждого Элемент Из Параметры.СтрокаИзТаблицы Цикл
			СтрокаСоЗначениями = СтрокаСоЗначениями + Разделитель + Элемент[2];
			Разделитель = ", ";
		КонецЦикла;
		Если СтрДлина(СтрокаСоЗначениями) > 70 Тогда
			СтрокаСоЗначениями = Лев(СтрокаСоЗначениями, 70) + "...";
		КонецЕсли;
		Элементы.ДекорацияЗаголовокПоискСсылок.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.ДекорацияЗаголовокПоискСсылок.Заголовок,
				СтрокаСоЗначениями);
	Иначе
		КоличествоСвернутыхЭлементов = 0;
		Для каждого Элемент Из Параметры.СтрокаИзТаблицы Цикл
			
			Если Параметры.СтрокаИзТаблицы.Количество() > 3 Тогда 
				Если КолонкиСопоставления.НайтиПоЗначению(Элемент[Индекс]) = Неопределено Тогда
					ГруппаЭлементов = Элементы.ПрочиеДанныеИзФайла;
					КоличествоСвернутыхЭлементов = КоличествоСвернутыхЭлементов + 1;
				Иначе
					ГруппаЭлементов = Элементы.ОсновныеДанныеИзФайла;
				КонецЕсли;
			Иначе
				ГруппаЭлементов = Элементы.ОсновныеДанныеИзФайла;
			КонецЕсли;
			
			НовыйЭлемент2 = Элементы.Добавить(Элемент[Индекс] + "_знач", Тип("ПолеФормы"), ГруппаЭлементов);
			НовыйЭлемент2.ПутьКДанным = "ФЛ_"+Элемент[Индекс];
			НовыйЭлемент2.Заголовок = Элемент[1];
			НовыйЭлемент2.Вид = ВидПоляФормы.ПолеВвода;
			НовыйЭлемент2.ТолькоПросмотр = Истина;
			ЭтотОбъект["ФЛ_" + Элемент[Индекс]] = Элемент[2];
		КонецЦикла;
	КонецЕсли;
	
	Элементы.ПрочиеДанныеИзФайла.Заголовок = Элементы.ПрочиеДанныеИзФайла.Заголовок + " (" +Строка(КоличествоСвернутыхЭлементов) + ")";
	ЭтотОбъект.Высота = Параметры.СтрокаИзТаблицы.Количество() + СписокНеоднозначностей.Количество() + 7;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЭлементыСправочникаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Закрыть(Элементы.ЭлементыСправочника.ТекущиеДанные.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ВариантРазрешенияНеоднозначностиПриИзменении(Элемент)
	Элементы.ЭлементыСправочника.ТолькоПросмотр = Не ВариантРазрешенияНеоднозначности;
КонецПроцедуры

&НаКлиенте
Процедура ВариантыВыбораВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.Ссылка) И Поле.Имя="ВариантыВыбораЗначение" Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, Элемент.ТекущиеДанные.Ссылка);
	ИначеЕсли ЗначениеЗаполнено(Элемент.ТекущиеДанные.Ссылка) И Поле.Имя="ВариантыВыбораПредставление" Тогда
		СтандартнаяОбработка = Ложь;
		Закрыть(Элементы.ВариантыВыбора.ТекущиеДанные.Ссылка);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	Закрыть(Элементы.ВариантыВыбора.ТекущиеДанные.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура НовыйЭлемент(Команда)
	Закрыть(Неопределено);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОформлениеДанных()
	
	УсловноеОформление.Элементы.Очистить();
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("ВариантыВыбораЗначение");
	ПолеОформления.Использование = Истина;
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВариантыВыбора.Значение"); 
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено; 
	ЭлементОтбора.Использование = Истина;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

#КонецОбласти
