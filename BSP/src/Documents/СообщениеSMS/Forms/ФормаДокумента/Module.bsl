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

	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Состояние = Перечисления.СостоянияДокументаСообщениеSMS.Черновик;
		Рассмотрено = Истина;
		ПриСозданииЧтенииНаСервере();
		Взаимодействия.УстановитьПредметПоДаннымЗаполнения(Параметры, Предмет);
		ИзменилисьКонтакты = Истина;
	КонецЕсли;
	
	Если НЕ ИнформационнаяБазаФайловая Тогда
		Элементы.АдресатыПроверитьСтатусыДоставки.Видимость = Ложь;
	КонецЕсли;
	
	Взаимодействия.ЗаполнитьСписокВыбораДляРассмотретьПосле(Элементы.РассмотретьПосле.СписокВыбора);
	
	// Определим типы контактов, которые можно создать.
	СписокИнтерактивноСоздаваемыхКонтактов = Взаимодействия.СоздатьСписокЗначенийИнтерактивноСоздаваемыхКонтактов();
	Элементы.СоздатьКонтакт.Видимость      = СписокИнтерактивноСоздаваемыхКонтактов.Количество() > 0;
	
	// Подготовить оповещения взаимодействий.
	Взаимодействия.ПодготовитьОповещения(ЭтотОбъект, Параметры);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
		МодульПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "СтраницаДополнительныеРеквизиты");
		ДополнительныеПараметры.Вставить("ОтложеннаяИнициализация", Истина);
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайлами = ОбщегоНазначения.ОбщийМодуль("РаботаСФайлами");
		ГиперссылкаФайлов = МодульРаботаСФайлами.ГиперссылкаФайлов();
		ГиперссылкаФайлов.Размещение = "КоманднаяПанель";
		МодульРаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ГиперссылкаФайлов);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.ШаблоныСообщений
	ОпределитьВозможностьЗаполненияПисьмаПоШаблону();
	// Конец СтандартныеПодсистемы.ШаблоныСообщений
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Взаимодействия.ПриЗаписиВзаимодействияИзФормы(ТекущийОбъект, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);

КонецПроцедуры 

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Взаимодействия.УстановитьРеквизитыФормыВзаимодействияПоДаннымРегистра(ЭтотОбъект);
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	ПриСозданииЧтенииНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
		МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.ТекстСообщения.ОбновитьТекстРедактирования();
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	ПроверитьДоступностьСозданияКонтакта();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		Если МодульУправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
			ОбновитьЭлементыДополнительныхРеквизитов();
			МодульУправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	ВзаимодействияКлиент.ОтработатьОповещение(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Объект, ЭтотОбъект, "СообщениеSMS");
	ПроверитьДоступностьСозданияКонтакта();
	КоличествоАдресатов = Объект.Адресаты.Количество();
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.ШаблоныСообщений
	Если ИмяСобытия = "Запись_ШаблоныСообщений" Тогда
		ОпределитьВозможностьЗаполненияПисьмаПоШаблону();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ШаблоныСообщений
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, РежимЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	Взаимодействия.ПередЗаписьюВзаимодействияИзФормы(ЭтотОбъект, ТекущийОбъект, ИзменилисьКонтакты);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	ВзаимодействияКлиент.ВзаимодействиеПредметПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи, "СообщениеSMS");
	ПроверитьДоступностьСозданияКонтакта();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	ПроверитьЗаполнениеСпискаАдресатов(Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияДокументаСообщениеSMS.Черновик")
		ИЛИ Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияДокументаСообщениеSMS.Исходящее") Тогда
		ВзаимодействияКлиент.ПроверкаЗаполненностиРеквизитовОтложеннойОтправки(Объект, Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ВзаимодействияКлиент.ФормаОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, ИсточникВыбора, КонтекстВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтраницыКонтактыДопРеквизитыКомментарийПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства")
		И ТекущаяСтраница.Имя = "СтраницаДополнительныеРеквизиты"
		И Не ЭтотОбъект.ПараметрыСвойств.ВыполненаОтложеннаяИнициализация Тогда
		
		СвойстваВыполнитьОтложеннуюИнициализацию();
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура РассмотретьПослеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВзаимодействияКлиент.ОбработатьВыборВПолеРассмотретьПосле(
		РассмотретьПосле, ВыбранноеЗначение, СтандартнаяОбработка, Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура НаКонтролеПриИзменении()
	
	Рассмотрено = НЕ НаКонтроле;
	УправлениеДоступностью(ЭтотОбъект);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстСообщенияИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	ОсталосьСимволов = ВзаимодействияКлиентСервер.СформироватьИнформационнуюНадписьКоличествоСимволовСообщений(
	                   Объект.ОтправлятьВТранслите,
	                   Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправлятьВТранслитеПриИзменении(Элемент)
	
	ОсталосьСимволов = ВзаимодействияКлиентСервер.СформироватьИнформационнуюНадписьКоличествоСимволовСообщений(
	                        Объект.ОтправлятьВТранслите,
	                        Объект.ТекстСообщения)
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВзаимодействияКлиент.ПредметНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент,
			ПараметрыПеретаскивания, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент,
			ПараметрыПеретаскивания, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыАдресаты

&НаКлиенте
Процедура АдресатыПриИзменении(Элемент)
	
	ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Объект, ЭтотОбъект, "СообщениеSMS");
	КоличествоАдресатов = Объект.Адресаты.Количество();
	ИзменилисьКонтакты = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресатыПриАктивизацииСтроки(Элемент)
	
	ПроверитьДоступностьСозданияКонтакта();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	текДанные = Элементы.Адресаты.ТекущиеДанные;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ТолькоEmail",                       Ложь);
	ПараметрыОткрытия.Вставить("ТолькоТелефон",                     Истина);
	ПараметрыОткрытия.Вставить("ЗаменятьПустыеАдресИПредставление", Истина);
	ПараметрыОткрытия.Вставить("ДляФормыУточненияКонтактов",        Ложь);
	ПараметрыОткрытия.Вставить("ИдентификаторФормы",                УникальныйИдентификатор);
	
	ВзаимодействияКлиент.ВыбратьКонтакт(Предмет, текДанные.КакСвязаться, текДанные.ПредставлениеКонтакта,
	                                    текДанные.Контакт, ПараметрыОткрытия); 
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеКонтактаПриИзменении(Элемент)
	
	ПроверитьДоступностьСозданияКонтакта();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактПриИзменении(Элемент)
	
	ПроверитьДоступностьСозданияКонтакта();
	ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Объект, ЭтотОбъект, "СообщениеSMS");
	
КонецПроцедуры

&НаКлиенте
Процедура АдресатыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ТекущиеДанные = Элементы.Адресаты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТекущиеДанные.СостояниеСообщения) Тогда
		ТекущиеДанные.СостояниеСообщения = ПредопределенноеЗначение("Перечисление.СостоянияСообщенияSMS.Черновик");
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьКонтактВыполнить()
	
	текДанные = Элементы.Адресаты.ТекущиеДанные;
	Если текДанные <> Неопределено Тогда
		ВзаимодействияКлиент.СоздатьКонтакт(
			текДанные.ПредставлениеКонтакта, текДанные.КакСвязаться, Объект.Ссылка, СписокИнтерактивноСоздаваемыхКонтактов);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	
	ОчиститьСообщения();
	
	Если ПроверитьЗаполнение() Тогда
		ОтправитьВыполнить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСтатусыДоставки(Команда)
	
	ОчиститьСообщения();
	ПроверитьСтатусыДоставкиСервер();
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.ШаблоныСообщений

&НаКлиенте
Процедура СформироватьПоШаблону(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ШаблоныСообщений") Тогда
		МодульШаблоныСообщенийКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ШаблоныСообщенийКлиент");
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьПоШаблонуПослеВыбораШаблона", ЭтотОбъект);
		ПредметСообщения = ?(ЗначениеЗаполнено(Предмет), Предмет, "Общий");
		МодульШаблоныСообщенийКлиент.ПодготовитьСообщениеПоШаблону(ПредметСообщения, "СообщениеSMS", Оповещение);
	КонецЕсли
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ШаблоныСообщений

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

КонецПроцедуры

// СтандартныеПодсистемы.Свойства

&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства


///////////////////////////////////////////////////////////////////////////////
// Прочее

&НаКлиенте
Процедура ПроверитьДоступностьСозданияКонтакта()
	
	ТекДанные = Элементы.Адресаты.ТекущиеДанные;
	Элементы.СоздатьКонтакт.Доступность = (Не Объект.Ссылка.Пустая())
	                                       И ((ТекДанные <> Неопределено) 
	                                       И (НЕ ЗначениеЗаполнено(ТекДанные.Контакт)));
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ИнформационнаяБазаФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	ОбработатьПереданныеПараметры(Параметры);
	ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Объект, ЭтотОбъект, "СообщениеSMS");
	Элементы.РассмотретьПосле.Доступность = НЕ Рассмотрено;
	ОсталосьСимволов = ВзаимодействияКлиентСервер.СформироватьИнформационнуюНадписьКоличествоСимволовСообщений(
	                     Объект.ОтправлятьВТранслите,
	                     Объект.ТекстСообщения);
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	НаКонтроле = НЕ Рассмотрено;
	УправлениеДоступностью(ЭтотОбъект);
	КоличествоАдресатов = Объект.Адресаты.Количество();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВыполнить()
	
	ОчиститьСообщения();
	
	Если ИнформационнаяБазаФайловая 
		И (Объект.ДатаКогдаОтправить = Дата(1,1,1) ИЛИ Объект.ДатаКогдаОтправить < ОбщегоНазначенияКлиент.ДатаСеанса())
		И (Объект.ДатаАктуальностиОтправки = Дата(1,1,1) ИЛИ Объект.ДатаАктуальностиОтправки > ОбщегоНазначенияКлиент.ДатаСеанса()) Тогда
			КоличествоОтправленных = ВыполнитьОтправкуНаСервере();
			Если НЕ КоличествоОтправленных > 0 Тогда
				Возврат;
			КонецЕсли;
	Иначе
		ВзаимодействияКлиентСервер.УстановитьСостояниеИсходящееДокументСообщениеSMS(Объект);
	КонецЕсли;
	
	Записать();
	Закрыть();

КонецПроцедуры

&НаСервере
Процедура ПроверитьЗаполнениеСпискаАдресатов(Отказ)

	Для Каждого Адресат Из Объект.Адресаты Цикл
		ПроверитьЗаполнениеТелефона(Адресат, Отказ);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьЗаполнениеТелефона(Адресат, Отказ)
	
	Если ПустаяСтрока(Адресат.КакСвязаться) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Поле ""Номер телефона"" не заполнено.'"),
			,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Адресаты", Адресат.НомерСтроки, "КакСвязаться"),
			,
			Отказ);
			Возврат;
	КонецЕсли;
		
	Если СтрРазделить(Адресат.КакСвязаться, ";", Ложь).Количество() > 1 Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Должен быть указан только один номер телефона'"),
			,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Адресаты", Адресат.НомерСтроки, "КакСвязаться"),
			,
			Отказ);
			Возврат;
	КонецЕсли;
		
	Если Не Взаимодействия.КорректноВведенНомерТелефона(Адресат.КакСвязаться) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Введите номер телефона в международном формате.
			|Допускается использовать в номере пробелы, скобки и дефисы.
			|Например, ""+7 (123) 456-78-90"".'"),
			,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Адресаты", Адресат.НомерСтроки, "КакСвязаться"),
			,
			Отказ);
			Возврат;
	КонецЕсли;
	
	Адресат.НомерДляОтправки = ФорматироватьНомер(Адресат.КакСвязаться);
	
КонецПроцедуры

&НаСервере
Функция ФорматироватьНомер(Номер)
	Результат = "";
	ДопустимыеСимволы = "+1234567890";
	Для Позиция = 1 По СтрДлина(Номер) Цикл
		Символ = Сред(Номер,Позиция,1);
		Если СтрНайти(ДопустимыеСимволы, Символ) > 0 Тогда
			Результат = Результат + Символ;
		КонецЕсли;
	КонецЦикла;
	
	Если СтрДлина(Результат) > 10 Тогда
		ПервыйСимвол = Лев(Результат, 1);
		Если ПервыйСимвол = "8" Тогда
			Результат = "+7" + Сред(Результат, 2);
		ИначеЕсли ПервыйСимвол <> "+" Тогда
			Результат = "+" + Результат;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

&НаСервере
Функция ВыполнитьОтправкуНаСервере()
	
	Возврат Взаимодействия.ОтправкаSMSПоДокументу(Объект);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеДоступностью(Форма)

	СообщениеОтправлено = СообщениеОтправлено(Форма.Объект.Состояние);
	СтатусВышеИсходящее = Форма.Объект.Состояние <> ПредопределенноеЗначение("Перечисление.СостоянияДокументаСообщениеSMS.Черновик")
	                      И Форма.Объект.Состояние <> ПредопределенноеЗначение("Перечисление.СостоянияДокументаСообщениеSMS.Исходящее");
	
	ОтправкаДоступна = Истина;
	Если Форма.ИнформационнаяБазаФайловая Тогда
		Если СообщениеОтправлено Тогда
			ОтправкаДоступна = Ложь;
		ИначеЕсли Форма.Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияДокументаСообщениеSMS.Исходящее") Тогда
			#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
				ДатаСеанса = ТекущаяДатаСеанса();
			#Иначе
				ДатаСеанса = ОбщегоНазначенияКлиент.ДатаСеанса();
			#КонецЕсли
			Если (Форма.Объект.ДатаКогдаОтправить) <> Дата(1,1,1)
				И Форма.Объект.ДатаКогдаОтправить > ДатаСеанса Тогда
				ОтправкаДоступна = Ложь;
			КонецЕсли;
			Если (Форма.Объект.ДатаАктуальностиОтправки) <> Дата(1,1,1)
				И Форма.Объект.ДатаАктуальностиОтправки < ДатаСеанса Тогда
				ОтправкаДоступна = Ложь;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Если Форма.Объект.Состояние <> ПредопределенноеЗначение("Перечисление.СостоянияДокументаСообщениеSMS.Черновик") Тогда
			ОтправкаДоступна = Ложь;
		КонецЕсли
	КонецЕсли;
	
	Форма.Элементы.ФормаОтправить.Доступность                 = ОтправкаДоступна;
	Форма.Элементы.Адресаты.ТолькоПросмотр                    = СтатусВышеИсходящее;
	Форма.Элементы.ОтправлятьВТранслите.Доступность           = НЕ СтатусВышеИсходящее;
	Форма.Элементы.ТекстСообщения.ТолькоПросмотр              = СтатусВышеИсходящее;
	Форма.Элементы.РассмотретьПосле.Доступность               = Форма.НаКонтроле;
	Форма.Элементы.ГруппаДатаОтправкиАктуальность.Доступность = НЕ СтатусВышеИсходящее;
	
	Форма.Элементы.АдресатыПроверитьСтатусыДоставки.Доступность =
	                 Форма.ИнформационнаяБазаФайловая
	                 И СообщениеОтправлено
	                 И Форма.Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияДокументаСообщениеSMS.Доставляется");

КонецПроцедуры

&НаСервере
Процедура ПроверитьСтатусыДоставкиСервер()

	УстановитьПривилегированныйРежим(Истина);
	Если Не ОтправкаSMS.НастройкаОтправкиSMSВыполнена() Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не выполнены настройки отправки SMS.'"),,"Объект");
		Возврат;
	КонецЕсли;
	
	Взаимодействия.ПроверитьСтатусыДоставкиSMS(Объект, Модифицированность);
	УправлениеДоступностью(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ОбработатьПереданныеПараметры(ПереданныеПараметры)
	
	Если Объект.Ссылка.Пустая() Тогда
		
		Если ПереданныеПараметры.Свойство("Текст") И НЕ ПустаяСтрока(ПереданныеПараметры.Текст) Тогда
			
			Объект.ТекстСообщения = ПереданныеПараметры.Текст;
			
		КонецЕсли;
		
		Если ПереданныеПараметры.Адресаты <> Неопределено Тогда
			
			Если ТипЗнч(ПереданныеПараметры.Адресаты) = Тип("Строка") И НЕ ПустаяСтрока(ПереданныеПараметры.Адресаты) Тогда
				
				НоваяСтрока = Объект.Адресаты.Добавить();
				НоваяСтрока.Адрес = ПереданныеПараметры.Кому;
				НоваяСтрока.СостояниеСообщения = Перечисления.СостоянияСообщенияSMS.Черновик;
				
			ИначеЕсли ТипЗнч(ПереданныеПараметры.Адресаты) = Тип("СписокЗначений") Тогда
				
				Для Каждого ЭлементСписка Из ПереданныеПараметры.Адресаты Цикл
					НоваяСтрока = Объект.Адресаты.Добавить();
					НоваяСтрока.КакСвязаться  = ЭлементСписка.Значение;
					НоваяСтрока.Представление = ЭлементСписка.Представление;
					НоваяСтрока.СостояниеСообщения = Перечисления.СостоянияСообщенияSMS.Черновик;
				КонецЦикла;
				
			ИначеЕсли ТипЗнч(ПереданныеПараметры.Адресаты) = Тип("Массив") Тогда
				
				Для Каждого ЭлементМассива Из ПереданныеПараметры.Адресаты Цикл
					
					НоваяСтрока = Объект.Адресаты.Добавить();
					НоваяСтрока.КакСвязаться          = ЭлементМассива.Телефон;
					НоваяСтрока.ПредставлениеКонтакта = ЭлементМассива.Представление;
					НоваяСтрока.Контакт               = ЭлементМассива.ИсточникКонтактнойИнформации;
					НоваяСтрока.СостояниеСообщения = Перечисления.СостоянияСообщенияSMS.Черновик;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ПереданныеПараметры.Свойство("Предмет") Тогда
			Предмет = ПереданныеПараметры.Предмет;
		КонецЕсли;
		
		Если ПереданныеПараметры.Свойство("ОтправлятьВТранслите") Тогда
			Объект.ОтправлятьВТранслите = ПереданныеПараметры.ОтправлятьВТранслите;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СообщениеОтправлено(Состояние)
	
	Возврат Состояние <> ПредопределенноеЗначение("Перечисление.СостоянияДокументаСообщениеSMS.Черновик")
	        И Состояние <> ПредопределенноеЗначение("Перечисление.СостоянияДокументаСообщениеSMS.Исходящее");
	
КонецФункции

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

// СтандартныеПодсистемы.ШаблоныСообщений

&НаКлиенте
Процедура ЗаполнитьПоШаблонуПослеВыбораШаблона(Результат, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ЗаполнитьШаблонПослеВыбора(Результат.Шаблон);
		Элементы.ТекстСообщения.ОбновитьТекстРедактирования();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьШаблонПослеВыбора(ШаблонСсылка)
	
	ОбъектСообщение = РеквизитФормыВЗначение("Объект");
	ОбъектСообщение.Заполнить(ШаблонСсылка);
	ЗначениеВРеквизитФормы(ОбъектСообщение, "Объект");
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьВозможностьЗаполненияПисьмаПоШаблону()
	
	ИспользуютсяШаблоныСообщений = Ложь;
	Если Объект.Состояние = Перечисления.СостоянияДокументаСообщениеSMS.Черновик
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ШаблоныСообщений") Тогда
		МодульШаблоныСообщенийСлужебный = ОбщегоНазначения.ОбщийМодуль("ШаблоныСообщенийСлужебный");
		Если МодульШаблоныСообщенийСлужебный.ИспользуютсяШаблоныСообщений() Тогда
			ИспользуютсяШаблоныСообщений = МодульШаблоныСообщенийСлужебный.ЕстьДоступныеШаблоны("SMS");
		КонецЕсли;
	КонецЕсли;
	Элементы.ФормаСформироватьПоШаблону.Видимость = ИспользуютсяШаблоныСообщений;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ШаблоныСообщений

#КонецОбласти
