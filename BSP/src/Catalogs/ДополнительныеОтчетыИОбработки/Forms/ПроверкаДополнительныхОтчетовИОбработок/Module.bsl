///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиКСписку(Команда)
	Закрыть();
	
	Отборы = Новый Структура;
	Отборы.Вставить("Публикация", ПредопределенноеЗначение("Перечисление.ВариантыПубликацииДополнительныхОтчетовИОбработок.Используется"));
	Отборы.Вставить("ПометкаУдаления", Ложь);
	Отборы.Вставить("ЭтоГруппа", Ложь);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Отборы);
	ПараметрыФормы.Вставить("Отображение", "Список");
	ПараметрыФормы.Вставить("ПроверкаДополнительныхОтчетовИОбработок", Истина);
	
	ОткрытьФорму("Справочник.ДополнительныеОтчетыИОбработки.Форма.ФормаСписка", ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Проверено(Команда)
	ОтметитьВыполнениеДела();
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтметитьВыполнениеДела()
	
	ВерсияМассив  = СтрРазделить(Метаданные.Версия, ".", Ложь);
	ТекущаяВерсия = ВерсияМассив[0] + ВерсияМассив[1] + ВерсияМассив[2];
	ХранилищеОбщихНастроек.Сохранить("ТекущиеДела", "ДополнительныеОтчетыИОбработки", ТекущаяВерсия);
	
КонецПроцедуры

#КонецОбласти