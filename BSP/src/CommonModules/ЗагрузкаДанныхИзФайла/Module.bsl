///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает описание колонок табличной части или таблицы значений.
//
// Параметры:
//  Таблица - Строка, ТаблицаЗначений - таблица с колонками. Для получения списка колонок табличной части
//            необходимо указать его полное имя строкой, как в метаданных, например "Документы.СчетНаОплату.ТабличныеЧасти.Товары".
//  Колонки - Строка - Список извлекаемых колонок, разделенный запятыми. Например: "Номер, Товар, Количество".
// 
// Возвращаемое значение:
//  Массив - Структура с описание колонок для макета. См. ЗагрузкаДанныхИзФайлаКлиентСервер.ОписаниеКолонкиМакета.
//
Функция СформироватьОписаниеКолонок(Таблица, Колонки = Неопределено) Экспорт
	
	ИзвлекатьНеВсеКолонки = Ложь;
	Если Колонки <> Неопределено Тогда
		СписокКолонокДляИзвлечения = СтрРазделить(Колонки, ",", Ложь);
		ИзвлекатьНеВсеКолонки = Истина;
	КонецЕсли;
	
	СписокКолонок = Новый Массив;
	Если ТипЗнч(Таблица) = Тип("ДанныеФормыКоллекция") Тогда
		КопияТаблицы = Таблица;
		ВнутренняяТаблица = КопияТаблицы.Выгрузить();
		ВнутренняяТаблица.Колонки.Удалить("ИсходныйНомерСтроки");
		ВнутренняяТаблица.Колонки.Удалить("НомерСтроки");
	Иначе
		ВнутренняяТаблица= Таблица;
	КонецЕсли;
	
	Если ТипЗнч(ВнутренняяТаблица) = Тип("ТаблицаЗначений") Тогда
		Для каждого Колонка Из ВнутренняяТаблица.Колонки Цикл
			Если ИзвлекатьНеВсеКолонки И СписокКолонокДляИзвлечения.Найти(Колонка.Имя) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			НоваяКолонка = ЗагрузкаДанныхИзФайлаКлиентСервер.ОписаниеКолонкиМакета(Колонка.Имя, Колонка.ТипЗначения, Колонка.Заголовок, Колонка.Ширина);
			СписокКолонок.Добавить(НоваяКолонка);
		КонецЦикла;
	ИначеЕсли ТипЗнч(ВнутренняяТаблица) = Тип("Строка") Тогда
		Объект = Метаданные.НайтиПоПолномуИмени(ВнутренняяТаблица);
		Для каждого Колонка Из Объект.Реквизиты Цикл
			Если ИзвлекатьНеВсеКолонки И СписокКолонокДляИзвлечения.Найти(Колонка.Имя) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			НоваяКолонка = ЗагрузкаДанныхИзФайлаКлиентСервер.ОписаниеКолонкиМакета(Колонка.Имя, Колонка.Тип, Колонка.Представление());
			НоваяКолонка.Подсказка = Колонка.Подсказка;
			НоваяКолонка.Ширина = 30;
			СписокКолонок.Добавить(НоваяКолонка);
		КонецЦикла;
	КонецЕсли;
	Возврат СписокКолонок;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьСтатистическуюИнформацию(ИмяОперации, Значение = 1, Комментарий = "") Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга") Тогда
		МодульЦентрМониторинга = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторинга");
		ИмяОперации = "ЗагрузкаДанныхИзФайла." + ИмяОперации;
		МодульЦентрМониторинга.ЗаписатьОперациюБизнесСтатистики(ИмяОперации, Значение, Комментарий);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
