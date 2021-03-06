///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Удаляет либо одну, либо все записи из регистра.
//
// Параметры:
//  Контакт  - СправочникСсылка, Неопределено - контакт, для которого удаляется запись.
//             Если указано значение Неопределено, то регистр будет очищен полностью.
//
Процедура УдалитьЗаписьИзРегистра(Контакт = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = СоздатьНаборЗаписей();
	Если Контакт <> Неопределено Тогда
		НаборЗаписей.Отбор.Контакт.Установить(Контакт);
	КонецЕсли;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Выполняет запись в регистр сведений для указанного предмета.
//
// Параметры:
//  Контакт  - СправочникСсылка - контакт, для которого выполняется запись.
//  КоличествоНеРассмотрено       - Число - количество не рассмотренных взаимодействий для контакта.
//  ДатаПоследнегоВзаимодействия  - ДатаВремя - дата последнего взаимодействия по контакту.
//
Процедура ВыполнитьЗаписьВРегистр(Контакт,
	                              КоличествоНеРассмотрено = Неопределено,
	                              ДатаПоследнегоВзаимодействия = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если КоличествоНеРассмотрено = Неопределено И ДатаПоследнегоВзаимодействия = Неопределено Тогда
		
		Возврат;
		
	ИначеЕсли КоличествоНеРассмотрено = Неопределено ИЛИ ДатаПоследнегоВзаимодействия = Неопределено Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	СостоянияКонтактовВзаимодействий.Контакт,
		|	СостоянияКонтактовВзаимодействий.КоличествоНеРассмотрено,
		|	СостоянияКонтактовВзаимодействий.ДатаПоследнегоВзаимодействия
		|ИЗ
		|	РегистрСведений.СостоянияКонтактовВзаимодействий КАК СостоянияКонтактовВзаимодействий
		|ГДЕ
		|	СостоянияКонтактовВзаимодействий.Контакт = &Контакт";
		
		Запрос.УстановитьПараметр("Контакт",Контакт);
		
		Результат = Запрос.Выполнить();
		Если НЕ Результат.Пустой() Тогда
			
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			
			Если КоличествоНеРассмотрено = Неопределено Тогда
				КоличествоНеРассмотрено = Выборка.КоличествоНеРассмотрено;
			КонецЕсли;
			
			Если ДатаПоследнегоВзаимодействия = Неопределено Тогда
				ДатаПоследнегоВзаимодействия = ДатаПоследнегоВзаимодействия.Предмет;
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;

	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Контакт.Установить(Контакт);
	
	Запись = НаборЗаписей.Добавить();
	Запись.Контакт                      = Контакт;
	Запись.КоличествоНеРассмотрено      = КоличествоНеРассмотрено;
	Запись.ДатаПоследнегоВзаимодействия = ДатаПоследнегоВзаимодействия;
	НаборЗаписей.Записать();

КонецПроцедуры

#Область ОбработчикиОбновления

// Процедура обновления ИБ для версии БСП 2.2.
// Выполняет первоначальный расчет состояний контактов взаимодействий.
//
Процедура РассчитатьСостоянияКонтактовВзаимодействий_2_2_0_0(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
	|	КонтактыВзаимодействий.Контакт
	|ПОМЕСТИТЬ КонтактыДляРасчета
	|ИЗ
	|	РегистрСведений.КонтактыВзаимодействий КАК КонтактыВзаимодействий
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияКонтактовВзаимодействий КАК СостоянияКонтактовВзаимодействий
	|		ПО КонтактыВзаимодействий.Контакт = СостоянияКонтактовВзаимодействий.Контакт
	|ГДЕ
	|	СостоянияКонтактовВзаимодействий.Контакт ЕСТЬ NULL 
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	КонтактыВзаимодействий.Контакт,
	|	МАКСИМУМ(Взаимодействия.Дата) КАК ДатаПоследнегоВзаимодействия,
	|	СУММА(ВЫБОР
	|			КОГДА ПредметыПапкиВзаимодействий.Рассмотрено
	|				ТОГДА 0
	|			ИНАЧЕ 1
	|		КОНЕЦ) КАК КоличествоНеРассмотрено
	|ИЗ
	|	КонтактыДляРасчета КАК КонтактыДляРасчета
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КонтактыВзаимодействий КАК КонтактыВзаимодействий
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ЖурналДокументов.Взаимодействия КАК Взаимодействия
	|			ПО КонтактыВзаимодействий.Взаимодействие = Взаимодействия.Ссылка
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
	|			ПО КонтактыВзаимодействий.Взаимодействие = ПредметыПапкиВзаимодействий.Взаимодействие
	|		ПО КонтактыДляРасчета.Контакт = КонтактыВзаимодействий.Контакт
	|
	|СГРУППИРОВАТЬ ПО
	|	КонтактыВзаимодействий.Контакт";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ВыполнитьЗаписьВРегистр(Выборка.Контакт, Выборка.КоличествоНеРассмотрено, Выборка.ДатаПоследнегоВзаимодействия);
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = (Выборка.Количество() = 0);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли