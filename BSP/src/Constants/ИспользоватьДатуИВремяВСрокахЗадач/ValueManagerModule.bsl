///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Использование = Константы.ИспользоватьБизнесПроцессыИЗадачи.Получить();
	
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("Метаданные", Метаданные.РегламентныеЗадания.СтартОтложенныхПроцессов);
	СписокЗаданий = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыПоиска);
	
	Если СписокЗаданий.Количество() = 0 Тогда
		ПараметрыЗадания = Новый Структура("Использование", Использование);
		ПараметрыЗадания.Вставить("Метаданные", Метаданные.РегламентныеЗадания.СтартОтложенныхПроцессов);
		УстановитьРасписание(Значение, ПараметрыЗадания);
		РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
		Возврат;
	КонецЕсли;
	
	Для Каждого Задание Из СписокЗаданий Цикл
		
		ПараметрыЗадания = Новый Структура("Использование", Использование);
		Если Использование Тогда
			Если Значение Тогда
				Если Задание.Расписание.ВремяНачала = Дата("00010101070000")
					ИЛИ Задание.Расписание.ВремяНачала = Дата("00010101000000") Тогда
					УстановитьРасписание(Значение, ПараметрыЗадания);
				КонецЕсли;
			Иначе
				Если Задание.Расписание.ПериодПовтораВТечениеДня = 900
					ИЛИ Задание.Расписание.ВремяНачала = Дата("00010101000000") Тогда
					УстановитьРасписание(Значение, ПараметрыЗадания);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		РегламентныеЗаданияСервер.ИзменитьЗадание(Задание, ПараметрыЗадания);
	КонецЦикла;
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьРасписание(ИспользоватьВремяВСрокахЗадач, ПараметрыЗадания)
	
	Расписание = Новый РасписаниеРегламентногоЗадания;
	
	Если ИспользоватьВремяВСрокахЗадач Тогда
		Расписание.ПериодПовтораВТечениеДня = 900;
		Расписание.ВремяНачала              = Дата("00000000");
		Расписание.ПериодПовтораДней        = 1;
	Иначе
		Расписание.ПериодПовтораВТечениеДня = 0;
		Расписание.ВремяНачала              = Дата("00010101070000");
		Расписание.ПериодПовтораДней        = 1;
	КонецЕсли;
	
	ПараметрыЗадания.Вставить("Расписание", Расписание);

КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли