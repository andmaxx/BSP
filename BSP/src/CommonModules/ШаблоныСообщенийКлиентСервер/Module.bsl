///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Описывает параметр шаблона для использования их во внешних обработках.
//
// Параметры:
//  ТаблицаПараметров           - ТаблицаЗначений - Таблица с параметрами.
//  ИмяПараметра                - Строка - Имя используемого параметра.
//  ОписаниеТипа                - ОписаниеТипов - Тип параметра.
//  ЭтоПредопределенныйПараметр - Булево - Если Ложь, то это произвольный параметр, иначе основной.
//  ПредставлениеПараметра      - Строка - Выводимое представление параметра.
//
Процедура ДобавитьПараметрШаблона(ТаблицаПараметров, ИмяПараметра, ОписаниеТипа, ЭтоПредопределенныйПараметр, ПредставлениеПараметра = "") Экспорт

	НоваяСтрока                             = ТаблицаПараметров.Добавить();
	НоваяСтрока.ИмяПараметра                = ИмяПараметра;
	НоваяСтрока.ОписаниеТипа                = ОписаниеТипа;
	НоваяСтрока.ЭтоПредопределенныйПараметр = ЭтоПредопределенныйПараметр;
	НоваяСтрока.ПредставлениеПараметра      = ?(ПустаяСтрока(ПредставлениеПараметра),ИмяПараметра, ПредставлениеПараметра);
	
КонецПроцедуры

// Инициализирует структуру сообщения по шаблону, которую должна вернуть внешняя обработка.
//
// Возвращаемое значение:
//   Структура - созданная структура.
//
Функция ИнициализироватьСтруктуруСообщения() Экспорт
	
	СтруктураСообщения = Новый Структура;
	СтруктураСообщения.Вставить("ТекстСообщенияSMS", "");
	СтруктураСообщения.Вставить("ТемаПисьма", "");
	СтруктураСообщения.Вставить("ТекстПисьма", "");
	СтруктураСообщения.Вставить("СтруктураВложений", Новый Структура);
	СтруктураСообщения.Вставить("ТекстПисьмаHTML", "<HTML></HTML>");
	
	Возврат СтруктураСообщения;
	
КонецФункции

// Инициализирует структуру Получатели для заполнения возможных получателей сообщения.
//
// Возвращаемое значение:
//   Структура - созданная структура.
//
Функция ИнициализироватьСтруктуруПолучатели() Экспорт
	
	Возврат Новый Структура("Получатель", Новый Массив);
	
КонецФункции

// Конструктор параметров шаблона.
// 
// Возвращаемое значение:
//  Структура - список параметров шаблона. 
//
Функция ОписаниеПараметровШаблона() Экспорт
	Результат = Новый Структура;
	
	Результат.Вставить("Текст", "");
	Результат.Вставить("Тема", "");
	Результат.Вставить("ТипШаблона", "Письмо");
	Результат.Вставить("Назначение", "");
	Результат.Вставить("ПолноеИмяТипаНазначения", "");
	Результат.Вставить("ФорматПисьма", ПредопределенноеЗначение("Перечисление.СпособыРедактированияЭлектронныхПисем.HTML"));
	Результат.Вставить("УпаковатьВАрхив", Ложь);
	Результат.Вставить("ТранслитерироватьИменаФайлов", Ложь);
	Результат.Вставить("ПеревестиВТранслит", Ложь);
	Результат.Вставить("Отправитель", "");
	Результат.Вставить("ВнешняяОбработка", Неопределено);
	Результат.Вставить("ШаблонПоВнешнейОбработке", Ложь);
	Результат.Вставить("РазворачиватьСсылочныеРеквизиты", Истина);
	Результат.Вставить("ФорматыВложений", Новый СписокЗначений);
	Результат.Вставить("ВыбранныеВложения", Новый Соответствие);
	Результат.Вставить("Макет", "");
	Результат.Вставить("Параметры", Новый Соответствие);
	Результат.Вставить("ПараметрыСКД", Новый Соответствие);
	Результат.Вставить("ВладелецШаблона", Неопределено);
	Результат.Вставить("Ссылка", Неопределено);
	Результат.Вставить("Наименование", "");
	Результат.Вставить("ПараметрыСообщения", Новый Структура);
	Результат.Вставить("ПодписьИПечать", Ложь);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КонструкторПараметровОтправки(Шаблон, Предмет, УникальныйИдентификатор) Экспорт
	
	ПараметрыОтправки = Новый Структура();
	ПараметрыОтправки.Вставить("Шаблон", Шаблон);
	ПараметрыОтправки.Вставить("Предмет", Предмет);
	ПараметрыОтправки.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	ПараметрыОтправки.Вставить("ДополнительныеПараметры", Новый Структура);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ПреобразовыватьHTMLДляФорматированногоДокумента", Ложь);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ВидСообщения", "");
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ПроизвольныеПараметры", Новый Соответствие);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ОтправитьСразу", _ОбщийМодульВызовСервера.ОтправитьПисьмаСразу());
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ПараметрыСообщения", Новый Структура);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("УчетнаяЗапись", Неопределено);
	
	Возврат ПараметрыОтправки;
	
КонецФункции

Функция ЗаголовокПроизвольныхПараметров() Экспорт
	Возврат НСтр("ru = 'Произвольные'");
КонецФункции

#КонецОбласти
