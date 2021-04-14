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
	
	ОтправлятьПисьмаВФорматеHTML = ПолучитьФункциональнуюОпцию("ОтправлятьПисьмаВФорматеHTML");
	НастройкиХранилище = Взаимодействия.ПолучитьНастройкуРаботаСПочтой();
	
	ВключатьПодписьДляНовыхСообщений             = ?(НастройкиХранилище.Свойство("ВключатьПодписьДляНовыхСообщений"),
		НастройкиХранилище.ВключатьПодписьДляНовыхСообщений,Истина);
	ФорматПодписиДляНовыхСообщений               = ?(НастройкиХранилище.Свойство("ФорматПодписиДляНовыхСообщений") И ОтправлятьПисьмаВФорматеHTML,
		НастройкиХранилище.ФорматПодписиДляНовыхСообщений,
		Перечисления.СпособыРедактированияЭлектронныхПисем.ОбычныйТекст);
	ВключатьПодписьПриОтветеПересылке            = ?(НастройкиХранилище.Свойство("ВключатьПодписьПриОтветеПересылке"),
		НастройкиХранилище.ВключатьПодписьПриОтветеПересылке,Истина);
	ФорматПодписиПриОтветеПересылке              = ?(НастройкиХранилище.Свойство("ФорматПодписиПриОтветеПересылке") И ОтправлятьПисьмаВФорматеHTML,
		НастройкиХранилище.ФорматПодписиПриОтветеПересылке,
		Перечисления.СпособыРедактированияЭлектронныхПисем.ОбычныйТекст);
	ПорядокОтветовНаЗапросыУведомленийОПрочтении = ?(НастройкиХранилище.Свойство("ПорядокОтветовНаЗапросыУведомленийОПрочтении"),
		НастройкиХранилище.ПорядокОтветовНаЗапросыУведомленийОПрочтении,
		Перечисления.ПорядокОтветовНаЗапросыУведомленийОПрочтении.ЗапрашиватьПередТемКакОтправитьУведомление);
	ВсегдаЗапрашиватьУведомлениеОПрочтении       = ?(НастройкиХранилище.Свойство("ВсегдаЗапрашиватьУведомлениеОПрочтении"),
		НастройкиХранилище.ВсегдаЗапрашиватьУведомлениеОПрочтении,Ложь);
	ВсегдаЗапрашиватьУведомленияОДоставке        = ?(НастройкиХранилище.Свойство("ВсегдаЗапрашиватьУведомленияОДоставке"),
		НастройкиХранилище.ВсегдаЗапрашиватьУведомленияОДоставке,Ложь);
	НовоеСообщениеФорматированныйДокумент        = ?(НастройкиХранилище.Свойство("НовоеСообщениеФорматированныйДокумент"),
		НастройкиХранилище.НовоеСообщениеФорматированныйДокумент,Неопределено);
	ПодписьДляНовыхСообщенийПростойТекст         = ?(НастройкиХранилище.Свойство("ПодписьДляНовыхСообщенийПростойТекст"),
		НастройкиХранилище.ПодписьДляНовыхСообщенийПростойТекст,Неопределено);
	ПодписьПриОтветеПересылкеПростойТекст        = ?(НастройкиХранилище.Свойство("ПодписьПриОтветеПересылкеПростойТекст"),
		НастройкиХранилище.ПодписьПриОтветеПересылкеПростойТекст,Неопределено);
	ПриОтветеПересылкеФорматированныйДокумент    = ?(НастройкиХранилище.Свойство("ПриОтветеПересылкеФорматированныйДокумент"),
		НастройкиХранилище.ПриОтветеПересылкеФорматированныйДокумент,Неопределено);
	ОтображатьТелоИсходногоПисьма                = ?(НастройкиХранилище.Свойство("ОтображатьТелоИсходногоПисьма"),
		НастройкиХранилище.ОтображатьТелоИсходногоПисьма,Ложь);
	ВключатьТелоИсходногоПисьма                  = ?(НастройкиХранилище.Свойство("ВключатьТелоИсходногоПисьма"),
		НастройкиХранилище.ВключатьТелоИсходногоПисьма,Ложь);
	ОтправлятьСообщенияСразу                     = ?(НастройкиХранилище.Свойство("ОтправлятьСообщенияСразу"),
		НастройкиХранилище.ОтправлятьСообщенияСразу,Ложь);
		
	Элементы.ОтправлятьСообщенияСразу.Видимость = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	Элементы.ПодписьПриОтвете.Картинка = Взаимодействия.КартинкаСтраницыПодписи(ВключатьПодписьПриОтветеПересылке);
	Элементы.ПодписьДляНового.Картинка = Взаимодействия.КартинкаСтраницыПодписи(ВключатьПодписьДляНовыхСообщений);
	УправлениеДоступностью(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВключатьПодписьДляНовыйСообщенийПриИзменении(Элемент)
	
	УправлениеДоступностью(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключатьПодписьПриОтветеПересылкеПриИзменении(Элемент)
	
	УправлениеДоступностью(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ФорматПодписиДляНовыхСообщенийПриИзменении(Элемент)
	
	Если ФорматПодписиДляНовыхСообщений = 
			ПредопределенноеЗначение("Перечисление.СпособыРедактированияЭлектронныхПисем.HTML") 
			И Элементы.СтраницыПодписьДляНовыхСообщений.ТекущаяСтраница = Элементы.СтраницаНовоеСообщениеФорматированныйТекст Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ФорматПодписиДляНовыхСообщений = 
			ПредопределенноеЗначение("Перечисление.СпособыРедактированияЭлектронныхПисем.ОбычныйТекст") 
			И Элементы.СтраницыПодписьДляНовыхСообщений.ТекущаяСтраница = Элементы.СтраницаНовоеСообщениеПростойТекст Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ФорматПодписиДляНовыхСообщений = 
			ПредопределенноеЗначение("Перечисление.СпособыРедактированияЭлектронныхПисем.HTML") Тогда
		
		Если Не ПустаяСтрока(ПодписьДляНовыхСообщенийПростойТекст) Тогда
			НовоеСообщениеФорматированныйДокумент.Удалить();
			НовоеСообщениеФорматированныйДокумент.Добавить(ПодписьДляНовыхСообщенийПростойТекст);
		КонецЕсли;
		
		УправлениеДоступностью(ЭтотОбъект);
		
	Иначе
		
		ДополнительныеПараметры = Новый Структура("КонтекстВызова", "ДляНовыхСообщений");
		ВзаимодействияКлиент.ВопросПриИзмененииФорматаСообщенияНаОбычныйТекст(ЭтотОбъект, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФорматПодписиПриОтветеПересылкеПриИзменении(Элемент)
	
	Если ФорматПодписиПриОтветеПересылке = 
			ПредопределенноеЗначение("Перечисление.СпособыРедактированияЭлектронныхПисем.HTML") 
			И Элементы.СтраницыПодписьПриОтветеПересылке.ТекущаяСтраница = Элементы.СтраницаПриОтветеПересылкеФорматированныйДокумент Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ФорматПодписиПриОтветеПересылке =
			ПредопределенноеЗначение("Перечисление.СпособыРедактированияЭлектронныхПисем.ОбычныйТекст") 
			И Элементы.СтраницыПодписьПриОтветеПересылке.ТекущаяСтраница = Элементы.СтраницаПриОтветеПересылкеПростойТекст Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ФорматПодписиПриОтветеПересылке = ПредопределенноеЗначение("Перечисление.СпособыРедактированияЭлектронныхПисем.HTML") Тогда
		
		Если Не ПустаяСтрока(ПодписьПриОтветеПересылкеПростойТекст) Тогда
			ПриОтветеПересылкеФорматированныйДокумент.Удалить();
			ПриОтветеПересылкеФорматированныйДокумент.Добавить(ПодписьПриОтветеПересылкеПростойТекст);
		КонецЕсли;
		
		УправлениеДоступностью(ЭтотОбъект);
		
	Иначе
		
		ДополнительныеПараметры = Новый Структура("КонтекстВызова", "ПриОтветеПересылке");
		ВзаимодействияКлиент.ВопросПриИзмененииФорматаСообщенияНаОбычныйТекст(ЭтотОбъект, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	СохранитьНастройки();
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеДоступностью(Форма)

	Если Форма.ФорматПодписиДляНовыхСообщений = 
			ПредопределенноеЗначение("Перечисление.СпособыРедактированияЭлектронныхПисем.HTML") Тогда
		
		Форма.Элементы.СтраницыПодписьДляНовыхСообщений.ТекущаяСтраница = Форма.Элементы.СтраницаНовоеСообщениеФорматированныйТекст;
		Форма.Элементы.НовоеСообщениеФорматированныйДокумент.Доступность = Форма.ВключатьПодписьДляНовыхСообщений;
		
	Иначе
		
		Форма.Элементы.СтраницыПодписьДляНовыхСообщений.ТекущаяСтраница = Форма.Элементы.СтраницаНовоеСообщениеПростойТекст;
		Форма.Элементы.ПодписьДляНовыхСообщенийПростойТекст.Доступность = Форма.ВключатьПодписьДляНовыхСообщений;
		
	КонецЕсли;
	
	Если Форма.ФорматПодписиПриОтветеПересылке = 
			ПредопределенноеЗначение("Перечисление.СпособыРедактированияЭлектронныхПисем.HTML") Тогда
		
		Форма.Элементы.СтраницыПодписьПриОтветеПересылке.ТекущаяСтраница = 
			Форма.Элементы.СтраницаПриОтветеПересылкеФорматированныйДокумент;
		Форма.Элементы.ПриОтветеПересылкеФорматированныйДокумент.Доступность  = Форма.ВключатьПодписьПриОтветеПересылке;
		
	Иначе
		
		Форма.Элементы.СтраницыПодписьПриОтветеПересылке.ТекущаяСтраница = Форма.Элементы.СтраницаПриОтветеПересылкеПростойТекст;
		Форма.Элементы.ПодписьПриОтветеПересылкеПростойТекст.Доступность = Форма.ВключатьПодписьПриОтветеПересылке;
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	Если ФорматПодписиДляНовыхСообщений = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML Тогда
		
		ПодписьДляНовыхСообщенийПростойТекст = НовоеСообщениеФорматированныйДокумент.ПолучитьТекст();
		
	КонецЕсли;
	
	Если ФорматПодписиПриОтветеПересылке = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML Тогда
		
		ПодписьПриОтветеПересылкеПростойТекст = ПриОтветеПересылкеФорматированныйДокумент.ПолучитьТекст();
		
	КонецЕсли;
	
	СтруктураНастройки = Новый Структура;
	СтруктураНастройки.Вставить("ВключатьПодписьДляНовыхСообщений", ВключатьПодписьДляНовыхСообщений);
	СтруктураНастройки.Вставить("ВключатьПодписьПриОтветеПересылке", ВключатьПодписьПриОтветеПересылке);
	СтруктураНастройки.Вставить("ВсегдаЗапрашиватьУведомлениеОПрочтении", ВсегдаЗапрашиватьУведомлениеОПрочтении);
	СтруктураНастройки.Вставить("ВсегдаЗапрашиватьУведомленияОДоставке", ВсегдаЗапрашиватьУведомленияОДоставке);
	СтруктураНастройки.Вставить("НовоеСообщениеФорматированныйДокумент", НовоеСообщениеФорматированныйДокумент);
	СтруктураНастройки.Вставить("ПодписьДляНовыхСообщенийПростойТекст", ПодписьДляНовыхСообщенийПростойТекст);
	СтруктураНастройки.Вставить("ПодписьПриОтветеПересылкеПростойТекст", ПодписьПриОтветеПересылкеПростойТекст);
	СтруктураНастройки.Вставить("ПорядокОтветовНаЗапросыУведомленийОПрочтении", ПорядокОтветовНаЗапросыУведомленийОПрочтении);
	СтруктураНастройки.Вставить("ПриОтветеПересылкеФорматированныйДокумент", ПриОтветеПересылкеФорматированныйДокумент);
	СтруктураНастройки.Вставить("ФорматПодписиДляНовыхСообщений", ФорматПодписиДляНовыхСообщений);
	СтруктураНастройки.Вставить("ФорматПодписиПриОтветеПересылке", ФорматПодписиПриОтветеПересылке);
	СтруктураНастройки.Вставить("ОтображатьТелоИсходногоПисьма", ОтображатьТелоИсходногоПисьма);
	СтруктураНастройки.Вставить("ВключатьТелоИсходногоПисьма", ВключатьТелоИсходногоПисьма);
	СтруктураНастройки.Вставить("ОтправлятьСообщенияСразу", ОтправлятьСообщенияСразу);

	Взаимодействия.СохранитьНастройкуРаботаСПочтой(СтруктураНастройки);

КонецПроцедуры

&НаКлиенте
Процедура ВопросПриИзмененииФорматаПриЗакрытии(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Если ДополнительныеПараметры.КонтекстВызова = "ДляНовыхСообщений" Тогда
			ФорматПодписиДляНовыхСообщений = ПредопределенноеЗначение("Перечисление.СпособыРедактированияЭлектронныхПисем.HTML");
		ИначеЕсли ДополнительныеПараметры.КонтекстВызова = "ПриОтветеПересылке" Тогда
			ФорматПодписиПриОтветеПересылке = ПредопределенноеЗначение("Перечисление.СпособыРедактированияЭлектронныхПисем.HTML");
		КонецЕсли;
		ФорматПодписиДляНовыхСообщений = ПредопределенноеЗначение("Перечисление.СпособыРедактированияЭлектронныхПисем.HTML");
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.КонтекстВызова = "ДляНовыхСообщений" Тогда
		
		ПодписьДляНовыхСообщенийПростойТекст = НовоеСообщениеФорматированныйДокумент.ПолучитьТекст();
		НовоеСообщениеФорматированныйДокумент.Удалить();
		
	ИначеЕсли ДополнительныеПараметры.КонтекстВызова = "ПриОтветеПересылке" Тогда
		
		ПодписьПриОтветеПересылкеПростойТекст = ПриОтветеПересылкеФорматированныйДокумент.ПолучитьТекст();
		ПриОтветеПересылкеФорматированныйДокумент.Удалить();
	
	КонецЕсли;
	
	УправлениеДоступностью(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
