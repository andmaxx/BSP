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
	
	ЗаполнитьЗначенияСвойств(Объект, Параметры);
	ОбновитьСостояниеЭлементовУправления(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПолеКаталогРезервнойКопииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.Каталог = Объект.ИмяКаталогаРезервнойКопииИБ;
	Диалог.ПроверятьСуществованиеФайла = Истина;
	Диалог.Заголовок = НСтр("ru = 'Выбор каталога резервной копии ИБ'");
	Если Диалог.Выбрать() Тогда
		Объект.ИмяКаталогаРезервнойКопииИБ = Диалог.Каталог;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздаватьРезервнуюКопиюПриИзменении(Элемент)
	ОбновитьСостояниеЭлементовУправления(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ВосстанавливатьИнформационнуюБазуПриИзменении(Элемент)
	ОбновитьНадписьРучногоОтката(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	Отказ = Ложь;
	Если Объект.СоздаватьРезервнуюКопию = 2 Тогда
		Файл = Новый Файл(Объект.ИмяКаталогаРезервнойКопииИБ);
		Отказ = Не Файл.Существует() Или Не Файл.ЭтоКаталог();
		Если Отказ Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Укажите существующий каталог для сохранения резервной копии ИБ.'"));
			ТекущийЭлемент = Элементы.ПолеКаталогРезервнойКопии;
		КонецЕсли;
	КонецЕсли;
	Если Не Отказ Тогда
		РезультатВыбора = Новый Структура;
		РезультатВыбора.Вставить("СоздаватьРезервнуюКопию",           Объект.СоздаватьРезервнуюКопию);
		РезультатВыбора.Вставить("ИмяКаталогаРезервнойКопииИБ",       Объект.ИмяКаталогаРезервнойКопииИБ);
		РезультатВыбора.Вставить("ВосстанавливатьИнформационнуюБазу", Объект.ВосстанавливатьИнформационнуюБазу);
		Закрыть(РезультатВыбора);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСостояниеЭлементовУправления(Форма)
	
	Форма.Элементы.ПолеКаталогРезервнойКопии.АвтоОтметкаНезаполненного = (Форма.Объект.СоздаватьРезервнуюКопию = 2);
	Форма.Элементы.ПолеКаталогРезервнойКопии.Доступность = (Форма.Объект.СоздаватьРезервнуюКопию = 2);
	ИнфоСтраницы = Форма.Элементы.ПанельИнформация.ПодчиненныеЭлементы;
	СоздаватьРезервнуюКопию = Форма.Объект.СоздаватьРезервнуюКопию;
	ПанельИнформация = Форма.Элементы.ПанельИнформация;
	Если СоздаватьРезервнуюКопию = 0 Тогда // не создавать
		Форма.Объект.ВосстанавливатьИнформационнуюБазу = Ложь;
		ПанельИнформация.ТекущаяСтраница = ИнфоСтраницы.БезОтката;
	ИначеЕсли СоздаватьРезервнуюКопию = 1 Тогда // создавать временную
		ПанельИнформация.ТекущаяСтраница = ИнфоСтраницы.РучнойОткат;
		ОбновитьНадписьРучногоОтката(Форма);
	ИначеЕсли СоздаватьРезервнуюКопию = 2 Тогда // Создавать в указанном каталоге.
		Форма.Объект.ВосстанавливатьИнформационнуюБазу = Истина;
		ПанельИнформация.ТекущаяСтраница = ИнфоСтраницы.АвтоматическийОткат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьНадписьРучногоОтката(Форма)
	СтраницыНадписи = Форма.Элементы.СтраницыНадписиРучногоОтката.ПодчиненныеЭлементы;
	Форма.Элементы.СтраницыНадписиРучногоОтката.ТекущаяСтраница = ?(Форма.Объект.ВосстанавливатьИнформационнуюБазу,
		СтраницыНадписи.Восстанавливать, СтраницыНадписи.НеВосстанавливать);
КонецПроцедуры

#КонецОбласти
