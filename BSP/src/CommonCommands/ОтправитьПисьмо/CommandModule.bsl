///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДополнительныеПараметры = Новый Структура("ИмяФормыИсточникаСообщения", "");
	Если ТипЗнч(ПараметрыВыполненияКоманды.Источник) = Тип("УправляемаяФорма") Тогда
		ДополнительныеПараметры.ИмяФормыИсточникаСообщения = ПараметрыВыполненияКоманды.Источник.ИмяФормы;
	КонецЕсли;
	
	Если   ТипЗнч(ПараметрКоманды) =Тип("ДокументСсылка._ЗаявкаНаОплату") Тогда
	СформироватьСообщениеПоВыбранномШаблону(ПараметрКоманды);	
	
	Иначе
	ШаблоныСообщенийКлиент.СформироватьСообщение(ПараметрКоманды, "Письмо",,, ДополнительныеПараметры);
	
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Функция ПолучитьПараметрШаблонаНаСервере(Заявка)
ПараметрШаблона = Новый Структура("Шаблон, УникальныйИдентификатор");
ПараметрШаблона.Шаблон = Документы._ЗаявкаНаОплату.ПолучитьШаблон(Заявка);
ПараметрШаблона.УникальныйИдентификатор = Новый УникальныйИдентификатор;

Возврат ПараметрШаблона; 	

КонецФункции // ()


&НаКлиенте
Процедура СформироватьСообщениеПоВыбранномШаблону(Заявка)
	ПараметрШаблона  = ПолучитьПараметрШаблонаНаСервере(Заявка);
	Предмет = Заявка;
	ВидСообщения = "Письмо";
	УникальныйИдентификатор = ПараметрШаблона.УникальныйИдентификатор; 
	ПараметрыСообщения=  Новый Структура();
	ПараметрыСообщения.Вставить("ИмяФормыИсточникаСообщения","Документ._ЗаявкаНаОплату.Форма.ФормаДокумента");
	ПараметрыОтправки = ШаблоныСообщенийКлиентСервер.КонструкторПараметровОтправки(ПараметрШаблона.Шаблон, Предмет, ПараметрШаблона.УникальныйИдентификатор);
	ПараметрыОтправки.ДополнительныеПараметры.ВидСообщения       = ВидСообщения;
	ПараметрыОтправки.ДополнительныеПараметры.ПараметрыСообщения = ПараметрыСообщения;

    ПараметрыОтправки.ДополнительныеПараметры.ПреобразовыватьHTMLДляФорматированногоДокумента = Истина;
	АдресВременногоХранилища = Неопределено;
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	АдресРезультата = СформироватьСообщениеНаСервере(АдресВременногоХранилища, ПараметрыОтправки, ВидСообщения);
	
	Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
	
	Результат.Вставить("Предмет", Предмет);
	Результат.Вставить("Шаблон",  ПараметрыОтправки.Шаблон);
	Если ПараметрыОтправки.ДополнительныеПараметры.Свойство("ПараметрыСообщения")
		И ТипЗнч(ПараметрыОтправки.ДополнительныеПараметры.ПараметрыСообщения) = Тип("Структура") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(Результат, ПараметрыСообщения, Ложь);
	КонецЕсли;
	
	Если ПараметрыОтправки.ДополнительныеПараметры.ОтправитьСразу Тогда
		//ПослеФормированияИОтправкиСообщения(Результат, ПараметрыОтправки);
	Иначе
			
		ПоказатьФормуСообщения(Результат);
	
	КонецЕсли;
	


	
КонецПроцедуры



&НаСервере
Функция СформироватьСообщениеНаСервере(АдресВременногоХранилища, ПараметрыОтправки, ВидСообщения)
	
	ПараметрыВызоваСервера = Новый Структура();
	ПараметрыВызоваСервера.Вставить("ПараметрыОтправки", ПараметрыОтправки);
	ПараметрыВызоваСервера.Вставить("ВидСообщения",      ВидСообщения);
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия") Тогда
		МодульВзаимодействия = ОбщегоНазначения.ОбщийМодуль("Взаимодействия");
		ПараметрыОтправки.ДополнительныеПараметры.Вставить("РасширенныйСписокПолучателей", МодульВзаимодействия.ИспользуетсяПрочиеВзаимодействия());
	КонецЕсли;
	
	ШаблоныСообщенийСлужебный.СформироватьСообщениеВФоне(ПараметрыВызоваСервера, АдресВременногоХранилища);
	
	Возврат АдресВременногоХранилища;
	
КонецФункции



&НаКлиенте
Процедура ПоказатьФормуСообщения(Сообщение)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
			МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
			МодульРаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(Сообщение);
		КонецЕсли;
	
	
	Если Сообщение.Свойство("СообщенияПользователю")
		И Сообщение.СообщенияПользователю <> Неопределено
		И Сообщение.СообщенияПользователю.Количество() > 0 Тогда
			Для каждого СообщенияПользователю Из Сообщение.СообщенияПользователю Цикл
				ОбщегоНазначенияКлиент.СообщитьПользователю(СообщенияПользователю.Текст,
					СообщенияПользователю.КлючДанных, СообщенияПользователю.Поле, СообщенияПользователю.ПутьКДанным);
			КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти
