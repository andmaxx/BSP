///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ, Замещение)
	
	// Проверка значения свойства ОбменДанными.Загрузка отсутствует по причине того, что ограничения,
	// накладываемые данным кодом, не должны обходить установкой этого свойства равным Истина
	// (на стороне кода, который выполняет попытку записи в данный регистр).
	//
	// Данный регистр не должен входить в любые обмены или операции выгрузки / загрузки данных при включенном
	// разделении по областям данных.
	
	Если Не РаботаВМоделиСервиса.СеансЗапущенБезРазделителей() Тогда
		
		ВызватьИсключение НСтр("ru = 'Нарушение прав доступа.'");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли