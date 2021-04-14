///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Определяет конечные точки (подписчиков) для широковещательного канала
// типа "Публикация/Подписка".
//
// Параметры:
//  КаналСообщений - Строка - Идентификатор широковещательного канала сообщений.
//
// Возвращаемое значение:
//  Массив - Массив элементов конечных точек, содержит элементы типа ПланОбменаСсылка.ОбменСообщениями.
//
Функция ПодписчикиКаналаСообщений(Знач КаналСообщений) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ПодпискиПолучателей.Получатель КАК Получатель
	|ИЗ
	|	РегистрСведений.ПодпискиПолучателей КАК ПодпискиПолучателей
	|ГДЕ
	|	ПодпискиПолучателей.КаналСообщений = &КаналСообщений";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КаналСообщений", КаналСообщений);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Получатель");
КонецФункции

#КонецОбласти

#КонецЕсли