///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция СтатусДоставки(ИдентификаторСообщения) Экспорт
	
	ОтправкаSMS.ПроверитьПрава();
	
	Если ПустаяСтрока(ИдентификаторСообщения) Тогда
		Возврат "НеОтправлялось";
	КонецЕсли;
	
	Результат = Неопределено;
	НастройкиОтправкиSMS = НастройкиОтправкиSMS();
	
	МодульОтправкаSMSЧерезПровайдера = ОтправкаSMS.МодульОтправкаSMSЧерезПровайдера(НастройкиОтправкиSMS.Провайдер);
	Если МодульОтправкаSMSЧерезПровайдера <> Неопределено Тогда
		Результат = МодульОтправкаSMSЧерезПровайдера.СтатусДоставки(ИдентификаторСообщения, НастройкиОтправкиSMS);
	ИначеЕсли ЗначениеЗаполнено(НастройкиОтправкиSMS.Провайдер) Тогда
		ОтправкаSMSПереопределяемый.СтатусДоставки(ИдентификаторСообщения, НастройкиОтправкиSMS.Провайдер,
			НастройкиОтправкиSMS.Логин, НастройкиОтправкиSMS.Пароль, Результат);
	Иначе // провайдер не выбран
		Результат = "Ошибка";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция НастройкиОтправкиSMS() Экспорт
	Результат = Новый Структура("Логин, Пароль, Провайдер, ИмяОтправителя");
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Константа.ПровайдерSMS");
		УстановитьПривилегированныйРежим(Истина);
		НастройкиПровайдера = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "Пароль,Логин,ИмяОтправителя");
		УстановитьПривилегированныйРежим(Ложь);
		Результат.Логин = НастройкиПровайдера.Логин;
		Результат.Пароль = НастройкиПровайдера.Пароль;
		Результат.ИмяОтправителя = НастройкиПровайдера.ИмяОтправителя;
		Результат.Провайдер =Константы.ПровайдерSMS.Получить();
	КонецЕсли;
	Возврат Новый ФиксированнаяСтруктура(Результат);
КонецФункции

#КонецОбласти