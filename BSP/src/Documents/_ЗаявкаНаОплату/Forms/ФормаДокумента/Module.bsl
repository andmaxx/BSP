

#Область ОписаниеПеременных

// СтандартныеПодсистемы.ОценкаПроизводительности
&НаКлиенте
Перем ИдентификаторЗамераПроведение;
// Конец СтандартныеПодсистемы.ОценкаПроизводительности

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.ЗначениеКопирования.Пустая() Тогда
		Отказ = Истина; СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.РаботаСФайлами
	ГиперссылкаФайлов = РаботаСФайлами.ГиперссылкаФайлов();
	ГиперссылкаФайлов.Размещение = "КоманднаяПанель";
	РаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ГиперссылкаФайлов);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.Дата.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.Номер.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		//Элементы.ЗарплатаНомерСтроки.Видимость = Ложь;
		//Элементы.Комментарий.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
	КонецЕсли;
	Если не Значениезаполнено(Объект.Ссылка) Тогда
		// Этио новый
		Объект.Инициатор = Пользователи.ТекущийПользователь();
		//Если не Значениезаполнено(Объект.Основание) Тогда
		//	Объект.Основание = _ОбщийМодульВызовСервера.ПолучитьПоследнийКП();
		//	
		//КонецЕсли;
	КонецЕсли;
	ПроверкаРедактирования();
	ОбновитьОстаткиНасервере();
	ОбновитьВлажения();
	
	//BSP-1 Форма для разбивки платежа на этапы
	РазбивкаНаЭтапыОплаты.Загрузить(ПолучитьТаблицуЭтаповОплат());
	ОбновитьСсылкуЭтапыОплатыНаСервере();
	ОбновитьВидимостьЭтапыОплаты();
	//--
	//BSP-9
	Элементы.ПояснениеНДС.Видимость = Объект.ПрименяетсяНДС И Объект.ПрименяетсяНДС <> ПрименяетсяНДС(Объект.Плательщик);
	//--
	
КонецПроцедуры

//BSP-1 Форма для разбивки платежа на этапы
&НаСервере
Процедура ОбновитьСсылкуЭтапыОплатыНаСервере()
	
	ТекстСсылки = "";
	Если ЗначениеЗаполнено(Объект.ОсновнаяЗаявка) Тогда
		ТекстСсылки = "Основная заявка: " + Объект.ОсновнаяЗаявка;
	ИначеЕсли Объект.ЭтапыОплаты Тогда
		ТекстСсылки = "Есть этапы оплаты " + "("+ РазбивкаНаЭтапыОплаты.Количество()+"), общая сумма " + Формат(РазбивкаНаЭтапыОплаты.Итог("СуммаПлатежа"), "ЧЦ=15; ЧДЦ=2");
	Иначе
		ТекстСсылки = "Создать этапы оплаты";
	КонецЕсли;
	
	Элементы.ЭтапыОплатыРазбивка.Заголовок = ТекстСсылки;
	Элементы.ЭтапыОплатыРазбивка.Доступность = НЕ Объект.ЭтапыОплаты;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВидимостьЭтапыОплаты()
	Элементы.Группа13.Видимость = Объект.ЭтапыОплаты И РазбивкаНаЭтапыОплаты.Количество() > 1;
	Элементы.РазбивкаНаЭтапыОплаты.Видимость = Объект.ЭтапыОплаты И РазбивкаНаЭтапыОплаты.Количество() > 1;
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОплатыРазбивкаНажатие(Элемент)
	Если Модифицированность Тогда
		Сообщить("Необходимо предварительно записать документ");
		Возврат;
	КонецЕсли;
	Если ЭтаФорма.ТолькоПросмотр Тогда
		Возврат;
	КонецЕсли;
		
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("Ссылка", Объект.Ссылка);
	ОповещениеПриЗакрытииФормы = Новый ОписаниеОповещения("ФормаЭтаповОплатыЗакрытие", ЭтотОбъект);
	ОткрытьФорму("Документ._ЗаявкаНаОплату.Форма.ФормаЭтаповОплаты", СтруктураПараметров, ЭтаФорма,,,,ОповещениеПриЗакрытииФормы ,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ФормаЭтаповОплатыЗакрытие(СтруктураПараметров, Источник) Экспорт
	Отказ = Ложь;
	СоздатьДокументыЭтаповОплатНаСервере(СтруктураПараметров, Отказ);
	Если Отказ Тогда
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СоздатьДокументыЭтаповОплатНаСервере(СтруктураПараметров, Отказ)
	Если 
		СтруктураПараметров.Свойство("СоздаватьДокументы") = Неопределено 
	ИЛИ 
		СтруктураПараметров.СоздаватьДокументы = Ложь 
	Тогда
		Возврат;
	КонецЕсли;
	
	//РазбивкаНаЭтапыОплаты.Загрузить(СтруктураПараметров.РазбивкаНаЭтапыОплаты.Выгрузить());
	
	ТЗЭтапы = СтруктураПараметров.РазбивкаНаЭтапыОплаты.Выгрузить();
	НачатьТранзакцию();
	Попытка
		Для Каждого СтрЭтап ИЗ ТЗЭтапы Цикл
			Если СтрЭтап.НомерСтроки = 1 Тогда
				//правим сумму основного документа	
				ЗаявкаЭтапаОбъект = Объект.Ссылка.ПолучитьОбъект();
				ЗаявкаЭтапаОбъект.ЭтапыОплаты = Истина;
				//разбивка по статьям
				Для Каждого СтрРазбивкаПоСтатьям Из ЗаявкаЭтапаОбъект.РазбивкаПоСтатьям Цикл
					Если СтрРазбивкаПоСтатьям.Сумма = ЗаявкаЭтапаОбъект.СуммаПлатежа Тогда
						СтрРазбивкаПоСтатьям.Сумма = СтрЭтап.Сумма;
					Иначе
						СтрРазбивкаПоСтатьям.Сумма = ?(ЗаявкаЭтапаОбъект.СуммаПлатежа = 0, 0, СтрРазбивкаПоСтатьям.Сумма/ЗаявкаЭтапаОбъект.СуммаПлатежа * СтрЭтап.Сумма);
					КонецЕсли;
				КонецЦикла;
				ЗаявкаЭтапаОбъект.СуммаПлатежа = СтрЭтап.Сумма;
				ЗаявкаЭтапаОбъект.Записать(РежимЗаписиДокумента.Проведение);
				ЭтаФорма.Прочитать();
			Иначе
				ЗаявкаЭтапаОбъект = Документы._ЗаявкаНаОплату.СоздатьДокумент();
				ЗаполнитьЗначенияСвойств(ЗаявкаЭтапаОбъект, Объект, , "Номер, Статус, Дата, ДатаОплаты");
				ЗаявкаЭтапаОбъект.Участники.Загрузить(Объект.Участники.Выгрузить());
				ЗаявкаЭтапаОбъект.РазбивкаПоСтатьям.Загрузить(Объект.РазбивкаПоСтатьям.Выгрузить());
				ЗаявкаЭтапаОбъект.Дата = ТекущаяДата();
				ЗаявкаЭтапаОбъект.ДатаОплаты = СтрЭтап.ДатаОплаты;
				//разбивка по статьям
				Для Каждого СтрРазбивкаПоСтатьям Из ЗаявкаЭтапаОбъект.РазбивкаПоСтатьям Цикл
					Если СтрРазбивкаПоСтатьям.Сумма = ЗаявкаЭтапаОбъект.СуммаПлатежа Тогда
						СтрРазбивкаПоСтатьям.Сумма = СтрЭтап.Сумма;
					Иначе
						СтрРазбивкаПоСтатьям.Сумма = ?(ЗаявкаЭтапаОбъект.СуммаПлатежа = 0, 0, СтрРазбивкаПоСтатьям.Сумма/ЗаявкаЭтапаОбъект.СуммаПлатежа * СтрЭтап.Сумма);
					КонецЕсли;
				КонецЦикла;
				ЗаявкаЭтапаОбъект.СуммаПлатежа = СтрЭтап.Сумма;
				ЗаявкаЭтапаОбъект.ОсновнаяЗаявка = Объект.Ссылка;
				ЗаявкаЭтапаОбъект.Записать(РежимЗаписиДокумента.Проведение);
				//создать документ
			КонецЕсли;
		КонецЦикла;
		ЗафиксироватьТранзакцию();	
	Исключение
		Отказ = Истина;
		Сообщить(ОписаниеОшибки());
	    ОтменитьТранзакцию();
	КонецПопытки;
	
	//BSP-1 Форма для разбивки платежа на этапы
	РазбивкаНаЭтапыОплаты.Загрузить(ПолучитьТаблицуЭтаповОплат());
	ОбновитьСсылкуЭтапыОплатыНаСервере();
	ОбновитьВидимостьЭтапыОплаты();
	//--
КонецПроцедуры

&НаСервере
Функция ПолучитьТаблицуЭтаповОплат()
	
	Возврат _ОбщийМодульВызовСервера.ПолучитьТаблицуЭтаповОплат(Объект.Ссылка);

КонецФункции	
//--BSP-1 Форма для разбивки платежа на этапы


&НаСервере
Процедура ПроверкаРедактирования()

	//BSP-8	Механизм редактирования заявок
	Если Объект.Статус = Перечисления._СтатусыЗаявок.Оплачено Тогда
		ЭтотОбъект.ТолькоПросмотр = Истина;
		Элементы.ПровестиИОтправить.Доступность   =  Ложь;
 
	ИначеЕсли ЗначениеЗаполнено(Объект.Статус) Тогда
		
		ЭтотОбъект.ТолькоПросмотр = Истина;
		Элементы.ПровестиИОтправить.Заголовок = "Редактировать";
	
	Иначе
		;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.СтатусСогласования) Тогда
		Если Объект.Статус = Перечисления._СтатусыЗаявок.Отправлен Тогда
			Статус = "Отправлен" + " (" + Объект.СтатусСогласования +")";	
		ИначеЕсли Объект.Статус = Перечисления._СтатусыЗаявок.НаСогласовании Тогда
			Статус = "На согласовании" + " (" + Объект.СтатусСогласования +")";
		КонецЕсли;
	Иначе
		Статус = Объект.Статус;
	КонецЕсли;
	
//ЭтотОбъект.ТолькоПросмотр = (Объект.Статус = Перечисления._СтатусыЗаявок.НаСогласовании или 
// Объект.Статус = Перечисления._СтатусыЗаявок.Оплачено или Объект.Статус = Перечисления._СтатусыЗаявок.Отправлен или Объект.Статус =Перечисления._СтатусыЗаявок.Согласован);
//--

	Элементы.ВыборПлатежа.Доступность = Не ЭтотОбъект.ТолькоПросмотр;	
	Элементы.ВыборПолучателя.Доступность = не ЭтотОбъект.ТолькоПросмотр;
	Элементы.ВыбратьСогласователь.Доступность = не ЭтотОбъект.ТолькоПросмотр;
	Элементы.УстановитьСтатусНеСогласован.Доступность   =_ОбщийМодульВызовСервера.ЕстьДоступУстановитьСтатус(Перечисления._СтатусыЗаявок.НеСогласован);
	Элементы.УстановитьСтатусОплачено.Доступность       =_ОбщийМодульВызовСервера.ЕстьДоступУстановитьСтатус(Перечисления._СтатусыЗаявок.Оплачено);
	//Элементы.ПровестиИОтправить.Доступность   =  (Не ЗначениеЗаполнено(Объект.Статус)) ;
	Элементы.УстановитьСтатусСогласован.Доступность     = _ОбщийМодульВызовСервера.ЕстьДоступУстановитьСтатус(Перечисления._СтатусыЗаявок.Согласован);
	//BSP-8	Механизм редактирования заявок
	Элементы.УстановитьСтатусПерезвонить.Доступность     = _ОбщийМодульВызовСервера.ЕстьДоступУстановитьСтатус(Перечисления._СтатусыЗаявок.Согласован);
	Элементы.УстановитьСтатусДоработать.Доступность     = _ОбщийМодульВызовСервера.ЕстьДоступУстановитьСтатус(Перечисления._СтатусыЗаявок.Согласован);
	//--

	//BSP-1 Форма для разбивки платежа на этапы
	Элементы.ЭтапыОплатыРазбивка.Доступность = Не ЭтотОбъект.ТолькоПросмотр;	
	//--BSP-1 Форма для разбивки платежа на этапы
КонецПроцедуры

&НаКлиенте
Процедура ОригиналПолученНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	_ОбщийМодульВызовСервера.ИзменитьОригиналПолучен(Объект.Ссылка);
	Прочитать();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчета.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	Если НЕ Объект.ПервыйСогласован Тогда
		Элементы.Декорация1.Видимость = Ложь;
	КонецЕсли;
	
	////++НК
	УстановитьВидимостьВЗависимостиОтКоличестваСтатей();	
	////--НК
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьВЗависимостиОтКоличестваСтатей()
	Если объект.РазбивкаПоСтатьям.Количество() <= 1 тогда
		элементы.Группа9.Видимость = истина;
		элементы.РазбивкаПоСтатьямГруппа2.Видимость = ложь;
		элементы.РазбивкаПоСтатьямГруппа3.Видимость = ложь;
	Иначе
		элементы.Группа9.Видимость = ложь;
		элементы.РазбивкаПоСтатьямГруппа2.Видимость = истина;
		элементы.РазбивкаПоСтатьямГруппа3.Видимость = истина;
		элементы.РазбивкаПоСтатьямНомерВСчете.АвтоОтметкаНезаполненного = истина;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбновитьОстаткиНасервере();	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции


// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)
	
	РаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	РаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент,
	ПараметрыПеретаскивания, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	РаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент,
	ПараметрыПеретаскивания, СтандартнаяОбработка);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами



&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьОтчетПоПроблемам(ЭлементИлиКоманда, НавигационнаяСсылка, СтандартнаяОбработка)
	КонтрольВеденияУчетаКлиент.ОткрытьОтчетПоПроблемамОбъекта(ЭтотОбъект, Объект.Ссылка, СтандартнаяОбработка);
КонецПроцедуры



#КонецОбласти

&НаКлиенте
Процедура УстановитьСтатусНеСогласован(Команда)
	
	ВыделенныеСтроки  = Новый Массив;
	ВыделенныеСтроки.Добавить(Объект.Ссылка);
	
	ТекстВопроса = НСтр("ru='У заявки будет установлен статус ""Не согласован"". Продолжить?'");
	Ответ = Неопределено;
	
	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусНеСогласованаЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусОплачено(Команда)
	ВыделенныеСтроки  = Новый Массив;
	ВыделенныеСтроки.Добавить(Объект.Ссылка);
	
	
	ТекстВопроса = НСтр("ru='У заявки  будет установлен статус ""Оплачено"". Продолжить?'");
	Ответ = Неопределено;
	
	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусКОплатеЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
	
КонецПроцедуры


&НаКлиенте
Процедура УстановитьСтатусСогласован(Команда)
	ВыделенныеСтроки  = Новый Массив;
	ВыделенныеСтроки.Добавить(Объект.Ссылка);
	
	ТекстВопроса = НСтр("ru='У заявки будет установлен статус ""Согласован"". Продолжить?'");
	Ответ = Неопределено;
	
	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусСогласованЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусПерезвонить(Команда)
	ВыделенныеСтроки  = Новый Массив;
	ВыделенныеСтроки.Добавить(Объект.Ссылка);
	
	ТекстВопроса = НСтр("ru='У заявки будет установлен статус ""Перезвонить"". Продолжить?'");
	Ответ = Неопределено;
	
	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусПерезвонитьЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусДоработать(Команда)
	ВыделенныеСтроки  = Новый Массив;
	ВыделенныеСтроки.Добавить(Объект.Ссылка);
	
	ТекстВопроса = НСтр("ru='У заявки будет установлен статус ""Доработать"". Продолжить?'");
	Ответ = Неопределено;
	
	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусДоработатьЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);

КонецПроцедуры




&НаКлиенте
Процедура УстановитьСтатусОтправленЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
	
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	//BSP-8 Редактирование заявки
	ДопПараметры = Новый Структура("ЗаблокироватьДляРедактирования",Ложь) ;
	Если ЭтоПовторно Тогда
		ДопПараметры.Вставить("СтатусСогласования", "Повторно")		
	КонецЕсли;
	//--
	
	Отказ = Ложь;
	ПроверитьОтправкиБезсогласованияНаСервере(Отказ);
	
	Если Отказ Тогда 
		УстановитьСтатусНаСогласовании();
	Иначе 
		СтатусПриОтправки = "Отправлен";
		ОбработанныеДокументы = _ОбщийМодульВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, СтатусПриОтправки,ДопПараметры);
		_ОбщийМодульКлиент.ОповеститьПользователяОбУстановкеСтатуса(Неопределено, ОбработанныеДокументы, ВыделенныеСтроки.Количество(), НСтр("ru='Отправлен'"));
		ОбновитьФормуНаСервере();
	КонецЕсли;
	
	
	Элементы.ПровестиИОтправить.Доступность   =  (Не ЗначениеЗаполнено(Объект.Статус)) ;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьОтправкиБезсогласованияНаСервере(Отказ)
	
	ТекстОшибки= "";
	Отказ = Документы._ЗаявкаНаОплату.ПроверитьОтправкиБезсогласования(Объект.Ссылка,ТекстОшибки) ;
	Если  Отказ Тогда
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", Объект.Ссылка);
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Статус%", " Отправлен ");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура УстановитьСтатусНаСогласовании()
	ВыделенныеСтроки  = Новый Массив;
	ВыделенныеСтроки.Добавить(Объект.Ссылка);
	
	ТекстВопроса = НСтр("ru='Ваша заявка требует согласования. Отправить на согласование?'");
	Ответ = Неопределено;
	
	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусНаСогласованииЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
	
КонецПроцедуры




&НаКлиенте
Процедура УстановитьСтатусСогласованЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
	
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	ОбработанныеДокументы = _ОбщийМодульВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "Согласован");
	
	_ОбщийМодульКлиент.ОповеститьПользователяОбУстановкеСтатуса(Неопределено, ОбработанныеДокументы, ВыделенныеСтроки.Количество(), НСтр("ru='Согласован'"));
	ОбновитьФормуНаСервере();
КонецПроцедуры


&НаКлиенте
Процедура УстановитьСтатусНаСогласованииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
	
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	Если  не ЗначениеЗаполнено(Объект.Согласователь) Тогда
		
		Успешно = ЗаполнитьСогласовательНаСервере();
		
		Если  Успешно Тогда
			
			Попытка
				ПараметрвЗаписи =Новый Структура("РежимЗаписи",РежимЗаписиДокумента.Проведение);
				Записать(ПараметрвЗаписи);	
				
			Исключение
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось записать Согласователь. Заявка не отправлена");
				
				Возврат;
			КонецПопытки;
			
		КонецЕсли;	 
		
		
	КонецЕсли;	
	
	
	ОчиститьСообщения();
	ДопПараметры = Новый Структура("ЗаблокироватьДляРедактирования",Ложь) ;
	//BSP-8 Редактирование заявки
	Если ЭтоПовторно Тогда
		ДопПараметры.Вставить("СтатусСогласования", "Повторно")		
	КонецЕсли;
	//--
    ОбработанныеДокументы = _ОбщийМодульВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "НаСогласовании",ДопПараметры);
    
    _ОбщийМодульКлиент.ОповеститьПользователяОбУстановкеСтатуса(Неопределено, ОбработанныеДокументы, ВыделенныеСтроки.Количество(), НСтр("ru='На Согласовании'"));
   ОбновитьФормуНаСервере();
   
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусПерезвонитьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    Если Объект.Статус = ПредопределенноеЗначение("Перечисление._СтатусыЗаявок.НаСогласовании") Тогда
    	НовыйСтатус = "НаСогласовании";	
    ИначеЕсли Объект.Статус = ПредопределенноеЗначение("Перечисление._СтатусыЗаявок.Отправлен") Тогда
    	НовыйСтатус = "Отправлен";    
    Иначе
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", Объект.Ссылка);
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Статус%", Объект.Статус);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Объект.Ссылка);
		Возврат;		    	
    КонецЕсли;
        
    ОчиститьСообщения();
	
	ДопПараметры = Новый Структура("ЗаблокироватьДляРедактирования, СтатусСогласования", Ложь, "Перезвонить");	
    
    ОбработанныеДокументы = _ОбщийМодульВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, НовыйСтатус, ДопПараметры);
    
    _ОбщийМодульКлиент.ОповеститьПользователяОбУстановкеСтатуса(Неопределено, ОбработанныеДокументы, ВыделенныеСтроки.Количество(), НСтр("ru='Перезвонить'"));
   	ОбновитьФормуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусДоработатьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    Если Объект.Статус = ПредопределенноеЗначение("Перечисление._СтатусыЗаявок.НаСогласовании") Тогда
    	НовыйСтатус = "НаСогласовании";	
    ИначеЕсли Объект.Статус = ПредопределенноеЗначение("Перечисление._СтатусыЗаявок.Отправлен") Тогда
    	НовыйСтатус = "Отправлен";    
    Иначе
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", Объект.Ссылка);
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Статус%", Объект.Статус);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Объект.Ссылка);
		Возврат;		    	
    КонецЕсли;
    
    ОчиститьСообщения();
	
	ДопПараметры = Новый Структура("ЗаблокироватьДляРедактирования, СтатусСогласования", Ложь, "Доработать");
		
    ОбработанныеДокументы = _ОбщийМодульВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, НовыйСтатус, ДопПараметры);
    
    _ОбщийМодульКлиент.ОповеститьПользователяОбУстановкеСтатуса(Неопределено, ОбработанныеДокументы, ВыделенныеСтроки.Количество(), НСтр("ru='Доработать'"));
   	ОбновитьФормуНаСервере();
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСогласовательНаСервере()
	
	Если Объект.РазбивкаПоСтатьям.Количество() = 1 тогда	   		
		Если не ЗначениеЗаполнено(Объект.Согласователь) Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			|	_СогласователиОрганизации.Пользователь КАК Пользователь,
			|	_СогласователиОрганизации.Пользователь2 КАК Пользователь2
			|ИЗ
			|	РегистрСведений._СогласователиОрганизации КАК _СогласователиОрганизации
			|ГДЕ
			|	_СогласователиОрганизации.Организация = &Организация
			|	И _СогласователиОрганизации.СтатьяДДС = &СтатьяДДС";
			Запрос.УстановитьПараметр("Организация", Объект.Плательщик);
			Запрос.УстановитьПараметр("СтатьяДДС", Объект.РазбивкаПоСтатьям[0].СтатьяДДС);
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Количество() Тогда
				Выборка.Следующий();
				Объект.Согласователь = Выборка.Пользователь;
				Объект.ВторойСогласователь = Выборка.Пользователь2;
				Возврат истина;
			Иначе
				Возврат ложь;
			КонецЕсли;
			
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			|	_СогласователиОрганизации.Пользователь КАК Пользователь,
			|	_СогласователиОрганизации.Пользователь2 КАК Пользователь2
			|ИЗ
			|	РегистрСведений._СогласователиОрганизации КАК _СогласователиОрганизации
			|ГДЕ
			|	_СогласователиОрганизации.Организация = &Организация
			|	И _СогласователиОрганизации.СтатьяДДС = &СтатьяДДС";
			Запрос.УстановитьПараметр("Организация", Объект.Плательщик);
			Запрос.УстановитьПараметр("СтатьяДДС", Справочники._СтаьтяДДС.ПустаяСсылка());
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Количество() Тогда
				Выборка.Следующий();
				Объект.Согласователь = Выборка.Пользователь;
				Объект.ВторойСогласователь = Выборка.Пользователь2;
				Возврат истина;
			Иначе
				Возврат ложь;
			КонецЕсли;
			
		КонецЕсли;	
	Иначе ////НК
		ТЗ = Объект.РазбивкаПоСтатьям.Выгрузить();
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ТЗ.СтатьяДДС КАК СтатьяДДС,
		|	ТЗ.Комментарий КАК Комментарий,
		|	ТЗ.Сумма КАК Сумма,
		|	ТЗ.ЦФО КАК ЦФО,
		|	ТЗ.Подразделение КАК Подразделение,
		|	ТЗ.НомерВСчете КАК НомерВСчете
		|ПОМЕСТИТЬ ТЗ
		|ИЗ
		|	&ТЗ КАК ТЗ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	_СогласователиОрганизации.Пользователь КАК Согласователь,
		|	_СогласователиОрганизации.Пользователь2 КАК ВторойСогласователь,
		|	ТЗ.СтатьяДДС КАК СтатьяДДС,
		|	ТЗ.Комментарий КАК Комментарий,
		|	ТЗ.Сумма КАК Сумма,
		|	ТЗ.ЦФО КАК ЦФО,
		|	ТЗ.Подразделение КАК Подразделение,
		|	ТЗ.НомерВСчете КАК НомерВСчете
		|ИЗ
		|	ТЗ КАК ТЗ
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений._СогласователиОрганизации КАК _СогласователиОрганизации
		|		ПО (_СогласователиОрганизации.СтатьяДДС = ТЗ.СтатьяДДС)
		|			И (_СогласователиОрганизации.Организация = &Организация)";
		Запрос.УстановитьПараметр("Организация", Объект.Плательщик);
		Запрос.УстановитьПараметр("ТЗ", ТЗ);
		ТАбл =  Запрос.Выполнить().Выгрузить();
		Объект.РазбивкаПоСтатьям.Загрузить(ТАбл);
		Возврат истина;				
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура УстановитьСтатусНеСогласованаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
	
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	
	
	ОчиститьСообщения();
	ОбработанныеДокументы = _ОбщийМодульВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "НеСогласован");
	
	_ОбщийМодульКлиент.ОповеститьПользователяОбУстановкеСтатуса(Неопределено, ОбработанныеДокументы, ВыделенныеСтроки.Количество(), НСтр("ru='Не согласован'"));
	ОбновитьФормуНаСервере();
КонецПроцедуры


&НаКлиенте
Процедура УстановитьСтатусКОплатеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
	
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	ОбработанныеДокументы = _ОбщийМодульВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "Оплачено");
	
	_ОбщийМодульКлиент.ОповеститьПользователяОбУстановкеСтатуса(Неопределено, ОбработанныеДокументы, ВыделенныеСтроки.Количество(), НСтр("ru='Оплачено'"));
	ОбновитьФормуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВыборПлатежа(Команда)
	
	Парам = Новый Структура("КП,Инициатор",Объект.Основание,Объект.Инициатор);
	Открытьформу("Документ._КалендарныеПлатежи.Форма.ФормаВыбораПлатежа",Парам,ЭтотОбъект,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	ЗаполнитьЗаявку(ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗаявку(ВыбранноеЗначение)
	
	Если  ВыбранноеЗначение <> НЕопределено Тогда
		Объект.Основание = ВыбранноеЗначение.КП;
		//Объект.Инициатор  = ВыбранноеЗначение.Инициатор;
		ВыбранноеЗначение.Свойство("ДатаПлатежа", Объект.ДатаОплаты);  
		Объект.Плательщик = ВыбранноеЗначение.Плательщик;
		Объект.СтатьяДДС   = ВыбранноеЗначение.СтатьяДДС;
		Объект.СуммаПлатежа = ВыбранноеЗначение.СуммаПлатежа;
		Объект.ЦФО  = ВыбранноеЗначение.ЦФО;
		Объект.Согласователь= ВыбранноеЗначение.ТребованиеКСогласованию;
		Объект.Примечание =  ВыбранноеЗначение.Примечание;
		СписокПолучателей = _ОбщийМодульВызовСервера.ПолучитьСписокПолучателейСтатьиБюджета(Объект.Основание,Объект.СтатьяДДС);
		Если  СписокПолучателей.Количество()> 0 тогда 
			Объект.Получатель  = СписокПолучателей[0].Значение;
		КонецЕсли; 
		ОбновитьОстаткиНасервере();
		
		
	КонецЕсли;  
	
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьФормуНаСервере()
	
	ЭтотОбъект.Прочитать();
	ПроверкаРедактирования();
	ОбновитьОстаткиНасервере();
КонецПроцедуры

&НаСервере
Процедура ОбновитьОстаткиНасервере()
	
	Струк =	_ОбщийМодульВызовСервера.ПолучитьЛимитыПоСтаьтиВЗаявке(объект);
	СуммаПоБюджету =Струк.СуммаПоБюджету;
	ВнеБюджета = Струк.СуммаВнеБюджета;
	Лимит =  Струк.Лимит;
	Элементы.ДекорацияИнфо.Заголовок = Струк.Инфо;
	Объект.ПричинаСогласования =Элементы.ДекорацияИнфо.Заголовок;
	
КонецПроцедуры


&НаСервереБезКонтекста
Функция ПрименяетсяНДС(Плательщик)
//BSP-9 НДС

	Возврат Плательщик.ПрименяетсяНДС;

КонецФункции


//&НаКлиенте
//Процедура ПолучательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
//	Если СписокПолучателей.Количество() = 0 Тогда 	
//		СтандартнаяОбработка = Истина
//	ИначеЕсли СписокПолучателей.Количество() = 1 Тогда
//		Объект.Получатель  = СписокПолучателей[0].Значение;
//		СтандартнаяОбработка = Ложь;
//	иначе
//		СтандартнаяОбработка = Ложь;
//		ВыбЭлемент = СписокПолучателей.ВыбратьЭлемент("Выбор контрагента" );
//		Если ВыбЭлемент <> Неопределено Тогда 
//			Объект.Получатель = ВыбЭлемент.Значение;
//		КонецЕсли;
//		
//	КонецЕсли;

//	
//	
//КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	Если ИмяСобытия = "Запись_Файл" Тогда
		ОбновитьВлажения();
		
	КонецЕсли;
	
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры


// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)
	
	ЭтотОбъект.Записать();
	
	РаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЛимит(Команда)
	ОбновитьОстаткиНасервере();
	
КонецПроцедуры


/// Процедуры при изменении


&НаСервере
Функция ПолучитьПлатежНасервере()
	
	ПараметрыЗакрытия = Неопределено;
	Тз= _ОбщийМодульВызовСервера.ПолучитьПлатежСтатьиБюджета(Объект);
	Если Тз.Количество()>0 ТОгда	
		ВыбранноеЗначение = Тз[0];
		
		ПараметрыЗакрытия = Новый Структура();
		ПараметрыЗакрытия.Вставить("КП",ВыбранноеЗначение.КП);
		ПараметрыЗакрытия.Вставить("СтатьяДДС",ВыбранноеЗначение.СтатьяДДС);
		ПараметрыЗакрытия.Вставить("Плательщик",ВыбранноеЗначение.Плательщик);
		ПараметрыЗакрытия.Вставить("Инициатор",ВыбранноеЗначение.Инициатор);
		ПараметрыЗакрытия.Вставить("СуммаПлатежа",ВыбранноеЗначение.СуммаПлатежа);
		ПараметрыЗакрытия.Вставить("ДатаПлатежа",ВыбранноеЗначение.ДатаПлатежа);
		ПараметрыЗакрытия.Вставить("ЦФО",ВыбранноеЗначение.ЦФО);
		ПараметрыЗакрытия.Вставить("Примечание",ВыбранноеЗначение.Примечание);
		ПараметрыЗакрытия.Вставить("ТребованиеКСогласованию",ВыбранноеЗначение.ТребованиеКСогласованию);
		
		
	КонецЕсли;
	Возврат ПараметрыЗакрытия;
КонецФункции // ()



&НаКлиенте
Процедура ДатаОплатыПриИзменении(Элемент)
	Если НачалоДня(Объект.ДатаОплаты)<НачалоДня(ТекущаяДата()) ТОгда
		Объект.ДатаОплаты = "";
		Вопрос("Дата оплаты не может быть меньше текущего дня!!!", РежимДиалогаВопрос.ОК);
		Возврат;
	КонецЕсли;
	Объект.Основание = _ОбщийМодульВызовСервера.ПолучитьКП(Объект.ДатаОплаты,Объект.Плательщик);
	ОбновитьОстаткиНасервере();
КонецПроцедуры

&НаКлиенте
Процедура ПлательщикПриИзменении(Элемент)
	Объект.Основание = _ОбщийМодульВызовСервера.ПолучитьКП(Объект.ДатаОплаты,Объект.Плательщик); 
	Объект.ПрименяетсяНДС = ПрименяетсяНДС(Объект.Плательщик);
	Элементы.ПояснениеНДС.Видимость = Ложь;
	ОбновитьОстаткиНасервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименяетсяНДСПриИзменении1(Элемент)
	Элементы.ПояснениеНДС.Видимость = Объект.ПрименяетсяНДС И Объект.ПрименяетсяНДС <> ПрименяетсяНДС(Объект.Плательщик);
КонецПроцедуры


&НаКлиенте
Процедура СуммаПлатежаПриИзменении(Элемент)
	ОбновитьОстаткиНасервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИОтправить(Команда)
	
	//BSP-8 Кнопка Редактирование заявки
	Если ЭтотОбъект.ТолькоПросмотр Тогда
		ЭтоПовторно = Истина;
		ЭтотОбъект.ТолькоПросмотр = Ложь;
		Элементы.ПровестиИОтправить.Заголовок = "Отправить (Повторно)";
		Возврат;
	КонецЕсли;
	
	Попытка
		ПараметрвЗаписи =Новый Структура("РежимЗаписи",РежимЗаписиДокумента.Проведение);
		Записать(ПараметрвЗаписи);	
		
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось провести документ. Заявка не отправлена");
		
		Возврат;
	КонецПопытки;	
	
	
	//++Гаранин, проверка на файл
	Если НетФайлаВложения() Тогда
		Вопрос("Внимание. Вы не прикрепили файл. Отправить заявку не получится.", РежимДиалогаВопрос.ОК);
		Возврат;
	КонецЕсли;
	
	
	
	
	Если _ОбщийМодульВызовСервера.МожноОтправитьЗаявку(Объект.Ссылка) Тогда
		
		ВыделенныеСтроки  = Новый Массив;
		ВыделенныеСтроки.Добавить(Объект.Ссылка);
		
		ТекстВопроса = "Отправить заявку на выполнение ?";
		
		ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусОтправленЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
	
	
КонецПроцедуры


&НаСервере
Функция НетФайлаВложения()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	_ЗаявкаНаОплатуПрисоединенныеФайлы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник._ЗаявкаНаОплатуПрисоединенныеФайлы КАК _ЗаявкаНаОплатуПрисоединенныеФайлы
	|ГДЕ
	|	_ЗаявкаНаОплатуПрисоединенныеФайлы.ПометкаУдаления = ЛОЖЬ
	|	И _ЗаявкаНаОплатуПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла";
	Запрос.УстановитьПараметр("ВладелецФайла", Объект.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
	
КонецФункции


&НаКлиенте
Процедура ВложенияНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка =  Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВладелецФайла",  Объект.Ссылка);
	ПараметрыФормы.Вставить("ТолькоПросмотр", Этаформа.ТолькоПросмотр);
	
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы",
	ПараметрыФормы,ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВлажения()
	
	Если не Параметры.Ключ.Пустая() Тогда
		СписокФайлов = Документы._ЗаявкаНаОплату.ПолучитьМассивОписанияПрисоединенныхФайлов(Объект.Ссылка);
		Вложения = "";
		Для Каждого ОписаниеФайла Из СписокФайлов Цикл
			
			Вложения =   Вложения + ?(ЗначениеЗаполнено(Вложения), "; ","")+  ОписаниеФайла.ИмяФайла ; 
			
		КонецЦикла;
	КонецЕсли;		
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка =  Ложь;	
	Парам =Новый Структура("Ключ,СтатьяДДС,ЦфО,Инициатор",Объект.Основание,Объект.СтатьяДДС,Объект.ЦФО,Объект.Инициатор);
	Открытьформу("Документ._КалендарныеПлатежи.ФормаОбъекта",Парам,ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСогласователь(Команда)
	
	Список = ПолучитьСписокСогласователейНаСервере();
	Если  Список.Количество() >0  тогда 
		
		Оповещение = Новый ОписаниеОповещения("ПослеВыбораЭлемента", ЭтотОбъект,"Согласователь");
		ВыбЗначение =   Объект.Согласователь;
		ВыбЭлемент = Список.НайтиПоЗначению(ВыбЗначение);
		Список.ПоказатьВыборЭлемента(Оповещение,"Выбор согласователя организации ", ВыбЭлемент);
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Список выбора пустой");
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборПолучателя(Команда)
	
	Список = ПолучитьСписокПолучателейНаСервере();
	
	Если  Список.Количество() >0  тогда 
		
		Оповещение = Новый ОписаниеОповещения("ПослеВыбораЭлемента", ЭтотОбъект,"Покупатель");
		
		ВыбЗначение =   Объект.Получатель;
		ВыбЭлемент = Список.НайтиПоЗначению(ВыбЗначение);
		Список.ПоказатьВыборЭлемента(Оповещение,"Выбор покупателя из утвержденных в платеже ", ВыбЭлемент);
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Список выбора пустой");
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПослеВыбораЭлемента(ВыбранныйЭлемент, СписокПараметров) Экспорт
	Если ВыбранныйЭлемент <> Неопределено Тогда
		Если  СписокПараметров =  "Покупатель" Тогда
			
			Объект.Получатель = ВыбранныйЭлемент.Значение;
		Иначе
			
			Объект.Согласователь = ВыбранныйЭлемент.Значение;
			
		КонецЕсли;	
		
	КонецЕсли;
КонецПроцедуры


&НаСервере
Функция ПолучитьСписокПолучателейНаСервере()
	Список = _ОбщийМодульВызовСервера.ПолучитьСписокУтвержденныхПолучателейПлатажа(Объект);
	
	Возврат Список;
КонецФункции


&НаСервере
Функция ПолучитьСписокСогласователейНаСервере()
	
	Список = _ОбщийМодульВызовСервера.ПолучитьСогласователиОрганизации(Объект.Плательщик); 
	
	Возврат Список;
КонецФункции

&НаКлиенте
Процедура ИнициаторПриИзменении(Элемент)
	ОбновитьОстаткиНасервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЦФОПриИзменении(Элемент)
	ОбновитьОстаткиНасервере();
	
КонецПроцедуры


&НаКлиенте
Процедура СтатьяДДСПриИзменении(Элемент)
	ОбновитьОстаткиНасервере();
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Объект.Основание = _ОбщийМодульВызовСервера.ПолучитьКП(Объект.ДатаОплаты,Объект.Плательщик);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Параметры.Ключ.Пустая() Тогда
		Если не ЗначениеЗаполнено(Объект.КрайняяДатаПолученияОригинала) Тогда
			Сообщить("Необходимо заполнить дату получения оригиналов");
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	
КонецПроцедуры

//++Ковалев 18.02.2021
&НаКлиенте
Процедура РазбивкаПоСтатьямСуммаПриИзменении(Элемент)
	Объект.СуммаПлатежа = объект.РазбивкаПоСтатьям.Итог("Сумма");
КонецПроцедуры

&НаКлиенте
Процедура РазбивкаПоСтатьямПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	Объект.СуммаПлатежа = объект.РазбивкаПоСтатьям.Итог("Сумма");
	////++НК
	УстановитьВидимостьВЗависимостиОтКоличестваСтатей();	
	////--НК
КонецПроцедуры
//--


