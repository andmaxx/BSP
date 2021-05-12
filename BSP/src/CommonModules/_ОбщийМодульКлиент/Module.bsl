

// Проверяет наличие выделенных в списке строк и возвращает массив их ссылок.
//
// Параметры:
//	Список - ДинамическийСписок - список, в котором осуществляется проверка на наличие выделенных строк.
//
// Возвращаемое значение:
//	Массив - массив ссылок выделенных в списке строк.
//
Функция ПроверитьПолучитьВыделенныеВСпискеСсылки(Список) Экспорт
	
	МассивСсылок = Новый Массив;
	
	Для Итератор = 0 По Список.ВыделенныеСтроки.Количество() - 1 Цикл
		Если ТипЗнч(Список.ВыделенныеСтроки[Итератор]) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			МассивСсылок.Добавить(Список.ВыделенныеСтроки[Итератор]);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивСсылок.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru='Команда не может быть выполнена для указанного объекта!'"));
	КонецЕсли;
	
	Возврат МассивСсылок;
	
КонецФункции


// Процедура показывает оповещение после обработки статусов выделенных в списке документов.
//
// Параметры:
//	СписокДокументов       - ДинамическийСписок - элемент формы
//	КоличествоОбработанных - Число - количество успешно обработанных документов
//	КоличествоВсего 	   - Число - количество выделенных в списке документов
//	Статус                 - Строка - устанавливаемый статус.
//
Процедура ОповеститьПользователяОбУстановкеСтатуса(СписокДокументов,ОбработанныеДокументы , КоличествоВсего, Статус) Экспорт
	Если ОбработанныеДокументы <>Неопределено тогда
		КоличествоОбработанных =ОбработанныеДокументы.Количество();
		
		Если КоличествоОбработанных > 0 Тогда
			
			Если _ОбщийМодульВызовСервера.СоздатьИсходящееПисьмоПриИзмененииСтатуса()  Тогда
				ОтправитьСразу = _ОбщийМодульВызовСервера.ОтправитьПисьмаСразу();
				ОтправитьПриОткрытии  =_ОбщийМодульВызовСервера.ОтправитьПисьмоПриОткрытииПослеИзменениияСтатуса(); 

				
				Для х = 0  По ОбработанныеДокументы.Количество()-1  Цикл
					
					Заявка=	 ОбработанныеДокументы[х];
					КоличествоСтатей = _ОбщийМодульВызовСервера.СообщитьКоличествоСтрокВТаблице(Заявка);
					Если КоличествоСтатей = 1 тогда
						Попытка
							СформироватьСообщениеПоВыбранномШаблону(Заявка,ОтправитьСразу,ОтправитьПриОткрытии);
							_ОбщийМодульВызовСервера.СделатьЗаписьВМониторинг(Заявка, ложь, "Сообщение отправлено"); ////НК
						Исключение
							_ОбщийМодульВызовСервера.СделатьЗаписьВМониторинг(Заявка, ложь, ОписаниеОшибки()); ////НК
						КонецПопытки;
					Иначе
						//++Нужно отпраивть письма построчно согласователям.
						ТаблицаКонтактов = _ОбщийМодульВызовСервера.ПолучитьСтруктуруПисемПриНесколькихСтатей(Заявка);
						Для каждого контакт из ТаблицаКонтактов Цикл
							Попытка
								СформироватьСообщениеПоВыбранномШаблону(Заявка,ОтправитьСразу,ОтправитьПриОткрытии, контакт);
								_ОбщийМодульВызовСервера.СделатьЗаписьВМониторинг(Заявка, ложь, "Сообщение отправлено"); ////НК
							Исключение
								_ОбщийМодульВызовСервера.СделатьЗаписьВМониторинг(Заявка, ложь, ОписаниеОшибки()); ////НК
							КонецПопытки;
						КонецЦикла;
					КонецЕсли;
				КонецЦикла; 		
			
				
			КонецЕсли;	

			Если СписокДокументов <> Неопределено Тогда
				СписокДокументов.Обновить();
			КонецЕсли;
			
			ТекстСообщения = НСтр("ru='Для %КоличествоОбработанных% из %КоличествоВсего% выделенных в списке документов установлен статус ""%Статус%""'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КоличествоОбработанных%", КоличествоОбработанных);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КоличествоВсего%",        КоличествоВсего);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Статус%",                 Статус);
			ТекстЗаголовка = НСтр("ru='Статус ""%Статус%"" установлен'");
			ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Статус%", Статус);
			ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Информация32);

		Иначе
			
			ТекстСообщения = НСтр("ru='Статус ""%Статус%"" не установлен ни для одного документа.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Статус%", Статус);
			ТекстЗаголовка = НСтр("ru='Статус ""%Статус%"" не установлен'");
			ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Статус%", Статус);
			ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Информация32);
			
		КонецЕсли;
	 КонецЕсли;
КонецПроцедуры


// Отправка сообщения 

Процедура СформироватьСообщениеПоВыбранномШаблону(Заявка,ОтправитьСразу = Ложь, ОтправитьПриОткрытии = Ложь, Контакт = неопределено)  Экспорт
	ПараметрШаблона  = _ОбщийМодульВызовСервера.ПолучитьПараметрШаблонаНаСервере(Заявка);
	Предмет = Заявка;
	ВидСообщения = "Письмо";
	ПараметрыСообщения=  Новый Структура();
	ПараметрыСообщения.Вставить("ИмяФормыИсточникаСообщения","Документ._ЗаявкаНаОплату.Форма.ФормаДокумента");
	ПараметрыОтправки = ШаблоныСообщенийКлиентСервер.КонструкторПараметровОтправки(ПараметрШаблона.Шаблон, Предмет, ПараметрШаблона.УникальныйИдентификатор);
	ПараметрыОтправки.ДополнительныеПараметры.ВидСообщения       = ВидСообщения;
	ПараметрыОтправки.ДополнительныеПараметры.ПараметрыСообщения = ПараметрыСообщения;
	//++
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("Контакт",Контакт);
	//--
    ПараметрыОтправки.ДополнительныеПараметры.ПреобразовыватьHTMLДляФорматированногоДокумента = Истина;
	АдресВременногоХранилища = Неопределено;
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(Неопределено, ПараметрШаблона.УникальныйИдентификатор);
	
	АдресРезультата = _ОбщийМодульВызовСервера.СформироватьСообщениеНаСервере(АдресВременногоХранилища, ПараметрыОтправки, ВидСообщения);
	
	Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
	
	
	Результат.Вставить("Предмет", Предмет);
	Результат.Вставить("Шаблон",  ПараметрыОтправки.Шаблон);
	Результат.Вставить("ОтправитьПриОткрытии",ОтправитьПриОткрытии);
	
	
	
	ПараметрыОтправки.ДополнительныеПараметры.ОтправитьСразу = ОтправитьСразу;
		
	Если ПараметрыОтправки.ДополнительныеПараметры.Свойство("ПараметрыСообщения")
		И ТипЗнч(ПараметрыОтправки.ДополнительныеПараметры.ПараметрыСообщения) = Тип("Структура") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(Результат, ПараметрыСообщения, Ложь);
	КонецЕсли;
	
	ПоказатьФормуСообщения(Результат);
	
КонецПроцедуры

//++Гаранин
Процедура СформироватьСообщениеПоВыбранномШаблонуВторойСогласователь(Заявка,ОтправитьСразу = Ложь, ОтправитьПриОткрытии = Ложь)  Экспорт
	ПараметрШаблона  = _ОбщийМодульВызовСервера.ПолучитьПараметрШаблонаНаСервере(Заявка);
	Предмет = Заявка;
	ВидСообщения = "Письмо";
	ПараметрыСообщения=  Новый Структура();
	ПараметрыСообщения.Вставить("ИмяФормыИсточникаСообщения","Документ._ЗаявкаНаОплату.Форма.ФормаДокумента");
	ПараметрыОтправки = ШаблоныСообщенийКлиентСервер.КонструкторПараметровОтправки(ПараметрШаблона.Шаблон, Предмет, ПараметрШаблона.УникальныйИдентификатор);
	ПараметрыОтправки.ДополнительныеПараметры.ВидСообщения       = ВидСообщения;
	ПараметрыОтправки.ДополнительныеПараметры.ПараметрыСообщения = ПараметрыСообщения;

    ПараметрыОтправки.ДополнительныеПараметры.ПреобразовыватьHTMLДляФорматированногоДокумента = Истина;
	АдресВременногоХранилища = Неопределено;
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(Неопределено, ПараметрШаблона.УникальныйИдентификатор);
	
	АдресРезультата = _ОбщийМодульВызовСервера.СформироватьСообщениеНаСервереВторойСогласователь(АдресВременногоХранилища, ПараметрыОтправки, ВидСообщения);
	
	Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
	
	
	Результат.Вставить("Предмет", Предмет);
	Результат.Вставить("Шаблон",  ПараметрыОтправки.Шаблон);
	Результат.Вставить("ОтправитьПриОткрытии",ОтправитьПриОткрытии);
	
	
	
	ПараметрыОтправки.ДополнительныеПараметры.ОтправитьСразу = ОтправитьСразу;
		
	Если ПараметрыОтправки.ДополнительныеПараметры.Свойство("ПараметрыСообщения")
		И ТипЗнч(ПараметрыОтправки.ДополнительныеПараметры.ПараметрыСообщения) = Тип("Структура") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(Результат, ПараметрыСообщения, Ложь);
	КонецЕсли;
	
	ПоказатьФормуСообщения(Результат);
	
КонецПроцедуры
//--Гаранин

Процедура ПослеФормированияИОтправкиСообщения(ПараметрыОтправки)
//	
//ПараметрыОтправки.ДополнительныеПараметры.ОтправитьСразу  = Ложь;
//		ПараметрыОтправки.ДополнительныеПараметры.ПреобразовыватьHTMLДляФорматированногоДокумента = Истина;
//		СформироватьСообщениеДляОтправки(ПараметрыОтправки);
//	
КонецПроцедуры



Процедура ПоказатьФормуСообщения(Сообщение)
	
	РаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(Сообщение);	
	
	Если Сообщение.Свойство("СообщенияПользователю")
		И Сообщение.СообщенияПользователю <> Неопределено
		И Сообщение.СообщенияПользователю.Количество() > 0 Тогда
			Для каждого СообщенияПользователю Из Сообщение.СообщенияПользователю Цикл
				ОбщегоНазначенияКлиент.СообщитьПользователю(СообщенияПользователю.Текст,
					СообщенияПользователю.КлючДанных, СообщенияПользователю.Поле, СообщенияПользователю.ПутьКДанным);
			КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры


