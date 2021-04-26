///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Формирует имя файла подписи по шаблону.
//
Функция ИмяФайлаПодписи(ИмяБезРасширения, КомуВыданСертификат, РасширениеДляФайловПодписи, ТребуетсяРазделитель = Истина) Экспорт
	
	Разделитель = ?(ТребуетсяРазделитель, " - ", " ");
	
	ИмяФайлаПодписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1%2%3.%4",
		ИмяБезРасширения, Разделитель, КомуВыданСертификат, РасширениеДляФайловПодписи);
		
	Возврат ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайлаПодписи);
	
КонецФункции

// Формирует имя файла сертификата по шаблону.
//
Функция ИмяФайлаСертификата(ИмяБезРасширения, КомуВыданСертификат, РасширениеДляФайловСертификата, ТребуетсяРазделитель = Истина) Экспорт
	
	Разделитель = ?(ТребуетсяРазделитель, " - ", " ");
	
	ИмяФайлаСертификата = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1%2%3.%4",
		ИмяБезРасширения, Разделитель, КомуВыданСертификат, РасширениеДляФайловСертификата);
		
	Возврат ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайлаСертификата);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОписаниеПрограммыПоИмениКриптопровайдера(ИмяКриптопровайдера, ОписанияПрограмм) Экспорт
	
	ПрограммаНайдена = Ложь;
	Для Каждого ОписаниеПрограммы Из ОписанияПрограмм Цикл
		Если ОписаниеПрограммы.ИмяПрограммы = ИмяКриптопровайдера Тогда
			ПрограммаНайдена = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПрограммаНайдена Тогда
		Возврат ОписаниеПрограммы;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ИнтерактивныйРежимДоступен() Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Возврат ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СистемнаяИнформация.ВерсияПриложения, "8.3.13.1549") >= 0;
	
КонецФункции

// Только для внутреннего использования.
Функция МенеджерКриптографииОписанияПрограмм(Программа, Ошибки, Знач ОписанияПрограмм) Экспорт
	
	Если Программа <> Неопределено Тогда
		ПрограммаНеНайдена = Истина;
		Для каждого ОписаниеПрограммы Из ОписанияПрограмм Цикл
			Если ОписаниеПрограммы.Ссылка = Программа Тогда
				ПрограммаНеНайдена = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ПрограммаНеНайдена Тогда
			МенеджерКриптографииДобавитьОшибку(Ошибки, Программа,
				НСтр("ru = 'Не предусмотрена для использования.'"), Истина);
			Возврат Неопределено;
		КонецЕсли;
		ОписанияПрограмм = Новый Массив;
		ОписанияПрограмм.Добавить(ОписаниеПрограммы);
	КонецЕсли;
	
	Возврат ОписанияПрограмм;
	
КонецФункции

// Только для внутреннего использования.
Функция МенеджерКриптографииСвойстваПрограммы(ОписаниеПрограммы, ЭтоLinux, Ошибки, ЭтоСервер,
			ПутиКПрограммамНаСерверахLinux) Экспорт
	
	Если Не ЗначениеЗаполнено(ОписаниеПрограммы.ИмяПрограммы) Тогда
		МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка,
			НСтр("ru = 'Не указано имя программы.'"), Истина);
		Возврат Неопределено;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ОписаниеПрограммы.ТипПрограммы) Тогда
		МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка,
			НСтр("ru = 'Не указан тип программы.'"), Истина);
		Возврат Неопределено;
	КонецЕсли;
	
	СвойстваПрограммы = Новый Структура("ИмяПрограммы, ПутьКПрограмме, ТипПрограммы");
	
	Если ЭтоLinux Тогда
		ПутьКПрограмме = ПутиКПрограммамНаСерверахLinux.Получить(ОписаниеПрограммы.Ссылка);
		
		Если Не ЗначениеЗаполнено(ПутьКПрограмме) Тогда
			МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка,
				НСтр("ru = 'Не предусмотрена для использования.'"), ЭтоСервер, , , Истина);
			Возврат Неопределено;
		КонецЕсли;
	Иначе
		ПутьКПрограмме = "";
	КонецЕсли;
	
	СвойстваПрограммы = Новый Структура;
	СвойстваПрограммы.Вставить("ИмяПрограммы",   ОписаниеПрограммы.ИмяПрограммы);
	СвойстваПрограммы.Вставить("ПутьКПрограмме", ПутьКПрограмме);
	СвойстваПрограммы.Вставить("ТипПрограммы",   ОписаниеПрограммы.ТипПрограммы);
	
	Возврат СвойстваПрограммы;
	
КонецФункции

// Только для внутреннего использования.
Функция МенеджерКриптографииАлгоритмыУстановлены(ОписаниеПрограммы, Менеджер, Ошибки) Экспорт
	
	АлгоритмПодписи = Строка(ОписаниеПрограммы.АлгоритмПодписи);
	Попытка
		Менеджер.АлгоритмПодписи = АлгоритмПодписи;
	Исключение
		Менеджер = Неопределено;
		// Платформа использует обобщенное сообщение "Неизвестный алгоритм криптографии". Требуется более конкретное.
		МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выбран неизвестный алгоритм подписи ""%1"".'"), АлгоритмПодписи), Истина);
		Возврат Ложь;
	КонецПопытки;
	
	АлгоритмХеширования = Строка(ОписаниеПрограммы.АлгоритмХеширования);
	Попытка
		Менеджер.АлгоритмХеширования = АлгоритмХеширования;
	Исключение
		Менеджер = Неопределено;
		// Платформа использует обобщенное сообщение "Неизвестный алгоритм криптографии". Требуется более конкретное.
		МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выбран неизвестный алгоритм хеширования ""%1"".'"), АлгоритмХеширования), Истина);
		Возврат Ложь;
	КонецПопытки;
	
	АлгоритмШифрования = Строка(ОписаниеПрограммы.АлгоритмШифрования);
	Попытка
		Менеджер.АлгоритмШифрования = АлгоритмШифрования;
	Исключение
		Менеджер = Неопределено;
		// Платформа использует обобщенное сообщение "Неизвестный алгоритм криптографии". Требуется более конкретное.
		МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выбран неизвестный алгоритм шифрования ""%1"".'"), АлгоритмШифрования), Истина);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

// Только для внутреннего использования.
Процедура МенеджерКриптографииПрограммаНеНайдена(ОписаниеПрограммы, Ошибки, ЭтоСервер) Экспорт
	
	МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка,
		НСтр("ru = 'Программа не найдена на компьютере.'"), ЭтоСервер, Истина);
	
КонецПроцедуры

// Только для внутреннего использования.
Функция МенеджерКриптографииИмяПрограммыСовпадает(ОписаниеПрограммы, ИмяПрограммыПолученное, Ошибки, ЭтоСервер) Экспорт
	
	Если ИмяПрограммыПолученное <> ОписаниеПрограммы.ИмяПрограммы Тогда
		МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Получена другая программа с именем ""%1"".'"), ИмяПрограммыПолученное), ЭтоСервер, Истина);
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Только для внутреннего использования.
Процедура МенеджерКриптографииДобавитьОшибку(Ошибки, Программа, Описание,
			КАдминистратору, Инструкция = Ложь, ИзИсключения = Ложь, НеУказанПуть = Ложь) Экспорт
	
	СвойстваОшибки = Новый Структура;
	СвойстваОшибки.Вставить("Программа",         Программа);
	СвойстваОшибки.Вставить("Описание",          Описание);
	СвойстваОшибки.Вставить("КАдминистратору",   КАдминистратору);
	СвойстваОшибки.Вставить("Инструкция",        Инструкция);
	СвойстваОшибки.Вставить("ИзИсключения",      ИзИсключения);
	СвойстваОшибки.Вставить("НеУказанПуть",      НеУказанПуть);
	СвойстваОшибки.Вставить("НастройкаПрограмм", Истина);
	
	Ошибки.Добавить(СвойстваОшибки);
	
КонецПроцедуры

// Только для внутреннего использования.
Функция РежимыПроверкиСертификата(ИгнорироватьВремяДействия = Ложь) Экспорт
	
	МассивРежимовПроверки = Новый Массив;
	МассивРежимовПроверки.Добавить(РежимПроверкиСертификатаКриптографии.РазрешитьТестовыеСертификаты);
	
	Если ИгнорироватьВремяДействия Тогда
		МассивРежимовПроверки.Добавить(РежимПроверкиСертификатаКриптографии.ИгнорироватьВремяДействия);
	КонецЕсли;
	
	Возврат МассивРежимовПроверки;
	
КонецФункции

// Только для внутреннего использования.
Функция СертификатПросрочен(Сертификат, НаДату, ДобавкаВремени) Экспорт
	
	Если Не ЗначениеЗаполнено(НаДату) Тогда
		Возврат "";
	КонецЕсли;
	
	ДатыСертификата = ДатыСертификата(Сертификат, ДобавкаВремени);
	
	Если ДатыСертификата.ДатаОкончания > НачалоДня(НаДату) Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'На %1 просрочен сертификат.'"), Формат(НачалоДня(НаДату), "ДЛФ=D"));
	
КонецФункции

// Только для внутреннего использования.
Функция ТипХранилищаДляПоискаСертификата(ТолькоВЛичномХранилище) Экспорт
	
	Если ТипЗнч(ТолькоВЛичномХранилище) = Тип("ТипХранилищаСертификатовКриптографии") Тогда
		ТипХранилища = ТолькоВЛичномХранилище;
	ИначеЕсли ТолькоВЛичномХранилище Тогда
		ТипХранилища = ТипХранилищаСертификатовКриптографии.ПерсональныеСертификаты;
	Иначе
		ТипХранилища = Неопределено; // Хранилище, содержащее сертификаты всех доступных типов.
	КонецЕсли;
	
	Возврат ТипХранилища;
	
КонецФункции

// Только для внутреннего использования.
Процедура ДобавитьСвойстваСертификатов(Таблица, МассивСертификатов, БезОтбора,
			ДобавкаВремени, ТекущаяДатаСеанса, ТолькоОтпечатки = Ложь, ВОблачномСервисе = Ложь) Экспорт
	
	Если ТолькоОтпечатки Тогда
		ОтпечаткиУжеДобавленныхСертификатов = Таблица;
		НаСервере = Ложь;
	Иначе
		ОтпечаткиУжеДобавленныхСертификатов = Новый Соответствие; // Для пропуска дублей.
		НаСервере = ТипЗнч(Таблица) <> Тип("Массив");
	КонецЕсли;
	
	МодульЛокализации = МодульЛокализации();
	
	Для Каждого ТекущийСертификат Из МассивСертификатов Цикл
		Отпечаток = Base64Строка(ТекущийСертификат.Отпечаток);
		ДатыСертификата = ДатыСертификата(ТекущийСертификат, ДобавкаВремени);
		
		Если ДатыСертификата.ДатаОкончания <= ТекущаяДатаСеанса Тогда
			Если Не БезОтбора Тогда
				Продолжить; // Пропуск просроченных сертификатов.
			КонецЕсли;
		КонецЕсли;
		
		Если ОтпечаткиУжеДобавленныхСертификатов.Получить(Отпечаток) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ОтпечаткиУжеДобавленныхСертификатов.Вставить(Отпечаток, Истина);
		
		Если ТолькоОтпечатки Тогда
			Продолжить;
		КонецЕсли;
		
		Если НаСервере Тогда
			Строка = Таблица.Найти(Отпечаток, "Отпечаток");
			Если Строка <> Неопределено Тогда
				Если ВОблачномСервисе Тогда
					Строка.ВОблачномСервисе = Истина;
				КонецЕсли;
				Продолжить; // Пропуск уже добавленных на клиенте.
			КонецЕсли;
		КонецЕсли;
		
		СвойстваСертификата = Новый Структура;
		СвойстваСертификата.Вставить("Отпечаток", Отпечаток);
		
		СвойстваСертификата.Вставить("Представление",
			ПредставлениеСертификата(ТекущийСертификат, ДобавкаВремени, МодульЛокализации));
		
		СвойстваСертификата.Вставить("КемВыдан", ПредставлениеИздателя(ТекущийСертификат, МодульЛокализации));
		
		Если ТипЗнч(Таблица) = Тип("Массив") Тогда
			Таблица.Добавить(СвойстваСертификата);
		Иначе
			Если ВОблачномСервисе Тогда
				СвойстваСертификата.Вставить("ВОблачномСервисе", Истина);
			ИначеЕсли НаСервере Тогда
				СвойстваСертификата.Вставить("НаСервере", Истина);
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(Таблица.Добавить(), СвойстваСертификата);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция МодульЛокализации()
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Если ЭлектроннаяПодписьСлужебныйПовтИсп.ОбщиеНастройки().ЗаявлениеНаВыпускСертификатаДоступно Тогда
		Возврат ОбщегоНазначения.ОбщийМодуль("ЭлектроннаяПодписьЛокализацияКлиентСервер");
	КонецЕсли;
#Иначе
	Если СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ЭлектроннаяПодпись.ОбщиеНастройки.ЗаявлениеНаВыпускСертификатаДоступно Тогда
		Возврат ОбщегоНазначенияКлиент.ОбщийМодуль("ЭлектроннаяПодписьЛокализацияКлиентСервер");
	КонецЕсли;
#КонецЕсли
	Возврат Неопределено;

КонецФункции

// Только для внутреннего использования.
Процедура ДобавитьОтпечаткиСертификатов(Массив, МассивСертификатов, ДобавкаВремени, ТекущаяДатаСеанса) Экспорт
	
	Для Каждого ТекущийСертификат Из МассивСертификатов Цикл
		Отпечаток = Base64Строка(ТекущийСертификат.Отпечаток);
		ДатыСертификата = ДатыСертификата(ТекущийСертификат, ДобавкаВремени);
		
		Если ДатыСертификата.ДатаОкончания <= ТекущаяДатаСеанса Тогда
			Продолжить; // Пропуск просроченных сертификатов.
		КонецЕсли;
		
		Массив.Добавить(Отпечаток);
	КонецЦикла;
	
КонецПроцедуры

// Только для внутреннего использования.
Функция СвойстваПодписи(ДвоичныеДанныеПодписи, СвойстваСертификата, Комментарий,
			АвторизованныйПользователь, ИмяФайлаПодписи = "") Экспорт
	
	СвойстваПодписи = Новый Структура;
	СвойстваПодписи.Вставить("Подпись",             ДвоичныеДанныеПодписи);
	СвойстваПодписи.Вставить("УстановившийПодпись", АвторизованныйПользователь);
	СвойстваПодписи.Вставить("Комментарий",         Комментарий);
	СвойстваПодписи.Вставить("ИмяФайлаПодписи",     ИмяФайлаПодписи);
	СвойстваПодписи.Вставить("ДатаПодписи",         Дата('00010101')); // Устанавливается перед записью.
	СвойстваПодписи.Вставить("ДатаПроверкиПодписи", Дата('00010101')); // Дата последней проверки подписи.
	СвойстваПодписи.Вставить("ПодписьВерна",        Ложь);             // Результат последней проверки подписи.
	// Производные свойства:
	СвойстваПодписи.Вставить("Сертификат",          СвойстваСертификата.ДвоичныеДанные);
	СвойстваПодписи.Вставить("Отпечаток",           СвойстваСертификата.Отпечаток);
	СвойстваПодписи.Вставить("КомуВыданСертификат", СвойстваСертификата.КомуВыдан);
	
	Возврат СвойстваПодписи;
	
КонецФункции

// Только для внутреннего использования.
Функция ЗаголовокОшибкиПолученияДанных(Операция) Экспорт
	
	Если Операция = "Подписание" Тогда
		Возврат НСтр("ru = 'При получении данных для подписания возникла ошибка:'");
		
	ИначеЕсли Операция = "Шифрование" Тогда
		Возврат НСтр("ru = 'При получении данных для шифрования возникла ошибка:'");
	Иначе
		Возврат НСтр("ru = 'При получении данных для расшифровки возникла ошибка:'");
	КонецЕсли;
	
КонецФункции

// Только для внутреннего использования.
Функция ПустыеДанныеПодписи(ДанныеПодписи, ОписаниеОшибки) Экспорт
	
	Если Не ЗначениеЗаполнено(ДанныеПодписи) Тогда
		ОписаниеОшибки = НСтр("ru = 'Сформирована пустая подпись.'");
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Только для внутреннего использования.
Функция ПустыеЗашифрованныеДанные(ЗашифрованныеДанные, ОписаниеОшибки) Экспорт
	
	Если Не ЗначениеЗаполнено(ЗашифрованныеДанные) Тогда
		ОписаниеОшибки = НСтр("ru = 'Сформированы пустые данные.'");
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Только для внутреннего использования.
Функция ПустыеРасшифрованныеДанные(РасшифрованныеДанные, ОписаниеОшибки) Экспорт
	
	Если Не ЗначениеЗаполнено(РасшифрованныеДанные) Тогда
		ОписаниеОшибки = НСтр("ru = 'Сформированы пустые данные.'");
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Только для внутреннего использования.
Функция ДатаПодписанияУниверсальная(БуферДвоичныхДанныхПодписи) Экспорт
	
	ДатаПодписания = Неопределено;
	
	Позиция = 0;
	Для Каждого Байт Из БуферДвоичныхДанныхПодписи Цикл
		Если Байт = 15 И ЭтоЗаголовокДаты(БуферДвоичныхДанныхПодписи, Позиция) Тогда
			ДатаСтрокой = ДатаСтрокой(БуферДвоичныхДанныхПодписи, Позиция);
			Если ЭтоЦифры(ДатаСтрокой) Тогда
				Попытка
					ДатаПодписания = Дата("20" + ДатаСтрокой); // Универсальное время.
					Прервать;
				Исключение
					ДатаПодписания = Неопределено;
				КонецПопытки;
			КонецЕсли;
		КонецЕсли;
		Позиция = Позиция + 1;
	КонецЦикла;
	
	Возврат ДатаПодписания;
	
КонецФункции

// Находит в XML содержимое находящееся в теге.
//
// Параметры:
//  Текст                             - Строка - текст XML, в котором выполняется поиск.
//  ИмяТега                           - Строка - тег, содержимое которого необходимо найти.
//  ВключатьОткрывающийЗакрывающийТег - Булево - признак необходимости найденного тегом,
//                                               по которому выполнялся поиск, по умолчанию Ложь.
//  НомерПоПорядку                    - Число  - позиция, с которой начинается поиск, по умолчанию 1.
// 
// Возвращаемое значение:
//   Строка - строка, из которой удалены символы перевода строки и возврата каретки.
//
Функция НайтиВXML(Текст, ИмяТега, ВключатьОткрывающийЗакрывающийТег = Ложь, НомерПоПорядку = 1) Экспорт
	
	Результат = Неопределено;
	
	Начало    = "<"  + ИмяТега;
	Окончание = "</" + ИмяТега + ">";
	
	Содержимое = Сред(
		Текст,
		СтрНайти(Текст, Начало, НаправлениеПоиска.СНачала, 1, НомерПоПорядку),
		СтрНайти(Текст, Окончание, НаправлениеПоиска.СНачала, 1, НомерПоПорядку) + СтрДлина(Окончание) - СтрНайти(Текст, Начало, НаправлениеПоиска.СНачала, 1, НомерПоПорядку));
		
	Если ВключатьОткрывающийЗакрывающийТег Тогда
		
		Результат = СокрЛП(Содержимое);
		
	Иначе
		
		ОткрывающийТег = Лев(Содержимое, СтрНайти(Содержимое, ">"));
		Содержимое = СтрЗаменить(Содержимое, ОткрывающийТег, "");
		
		ЗакрывающийТег = Прав(Содержимое, СтрДлина(Содержимое) - СтрНайти(Содержимое, "<", НаправлениеПоиска.СКонца) + 1);
		Содержимое = СтрЗаменить(Содержимое, ЗакрывающийТег, "");
		
		Результат = СокрЛП(Содержимое);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// См. ЭлектроннаяПодписьКлиент.ПредставлениеСертификата.
Функция ПредставлениеСертификата(Сертификат, ДобавкаВремени, МодульЛокализации) Экспорт
	
	Представление = "";
	Если МодульЛокализации <> Неопределено Тогда
		Представление = МодульЛокализации.ПредставлениеСертификата(Сертификат, ДобавкаВремени);
	КонецЕсли;	
	Если ПустаяСтрока(Представление) Тогда
		ДатыСертификата = ДатыСертификата(Сертификат, ДобавкаВремени);
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1, до %2'"),
			ПредставлениеСубъекта(Сертификат, МодульЛокализации),
			Формат(ДатыСертификата.ДатаОкончания, "ДФ=MM.yyyy"));
	КонецЕсли;	
	Возврат Представление;
	
КонецФункции

// См. ЭлектроннаяПодписьКлиент.ПредставлениеСубъекта.
Функция ПредставлениеСубъекта(Сертификат, МодульЛокализации) Экспорт 
	
	Представление = "";
	Если МодульЛокализации <> Неопределено Тогда
		Представление = МодульЛокализации.ПредставлениеСубъекта(Сертификат);
	КонецЕсли;	
	Если ПустаяСтрока(Представление) Тогда
		Субъект = СвойстваСубъектаСертификата(Сертификат, МодульЛокализации);
		Если ЗначениеЗаполнено(Субъект.ОбщееИмя) Тогда
			Представление = Субъект.ОбщееИмя;
		КонецЕсли;
	КонецЕсли;	
	Возврат Представление;
	
КонецФункции

// См. ЭлектроннаяПодписьКлиент.ПредставлениеИздателя.
Функция ПредставлениеИздателя(Сертификат, МодульЛокализации) Экспорт
	
	Издатель = СвойстваИздателяСертификата(Сертификат, МодульЛокализации);
	
	Представление = "";
	
	Если ЗначениеЗаполнено(Издатель.ОбщееИмя) Тогда
		Представление = Издатель.ОбщееИмя;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Издатель.ОбщееИмя)
	   И ЗначениеЗаполнено(Издатель.Организация)
	   И СтрНайти(Издатель.ОбщееИмя, Издатель.Организация) = 0 Тогда
		
		Представление = Издатель.ОбщееИмя + ", " + Издатель.Организация;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Издатель.Подразделение) Тогда
		Представление = Представление + ", " + Издатель.Подразделение;
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

// См. ЭлектроннаяПодписьКлиент.СвойстваСертификата.
Функция СвойстваСертификата(Сертификат, ДобавкаВремени, МодульЛокализации) Экспорт
	
	ДатыСертификата = ДатыСертификата(Сертификат, ДобавкаВремени);
	
	Свойства = Новый Структура;
	Свойства.Вставить("Отпечаток",      Base64Строка(Сертификат.Отпечаток));
	Свойства.Вставить("СерийныйНомер",  Сертификат.СерийныйНомер);
	Свойства.Вставить("Представление",  ПредставлениеСертификата(Сертификат, ДобавкаВремени, МодульЛокализации));
	Свойства.Вставить("КомуВыдан",      ПредставлениеСубъекта(Сертификат, МодульЛокализации));
	Свойства.Вставить("КемВыдан",       ПредставлениеИздателя(Сертификат, МодульЛокализации));
	Свойства.Вставить("ДатаНачала",     ДатыСертификата.ДатаНачала);
	Свойства.Вставить("ДатаОкончания",  ДатыСертификата.ДатаОкончания);
	Свойства.Вставить("ДействителенДо", ДатыСертификата.ДатаОкончания);
	Свойства.Вставить("Назначение",     ПолучитьНазначение(Сертификат));
	Свойства.Вставить("Подписание",     Сертификат.ИспользоватьДляПодписи);
	Свойства.Вставить("Шифрование",     Сертификат.ИспользоватьДляШифрования);
	
	Возврат Свойства;
	
КонецФункции

// Заполняет таблицу описания сертификата из четырех полей: КомуВыдан, КемВыдан, ДействуетДо, Назначение.
Процедура ЗаполнитьОписаниеДанныхСертификата(Таблица, СвойстваСертификата) Экспорт
	
	Если СвойстваСертификата.Подписание И СвойстваСертификата.Шифрование Тогда
		Назначение = НСтр("ru = 'Подписание данных, Шифрование данных'");
		
	ИначеЕсли СвойстваСертификата.Подписание Тогда
		Назначение = НСтр("ru = 'Подписание данных'");
	Иначе
		Назначение = НСтр("ru = 'Шифрование данных'");
	КонецЕсли;
	
	Таблица.Очистить();
	Строка = Таблица.Добавить();
	Строка.Свойство = НСтр("ru = 'Кому выдан:'");
	Строка.Значение = СокрЛП(СвойстваСертификата.КомуВыдан);
	
	Строка = Таблица.Добавить();
	Строка.Свойство = НСтр("ru = 'Кем выдан:'");
	Строка.Значение = СокрЛП(СвойстваСертификата.КемВыдан);
	
	Строка = Таблица.Добавить();
	Строка.Свойство = НСтр("ru = 'Действителен до:'");
	Строка.Значение = Формат(СвойстваСертификата.ДатаОкончания, "ДЛФ=D");
	
	Строка = Таблица.Добавить();
	Строка.Свойство = НСтр("ru = 'Назначение:'");
	Строка.Значение = Назначение;
	
КонецПроцедуры

// См. ЭлектроннаяПодписьКлиент.СвойстваСубъектаСертификата.
Функция СвойстваСубъектаСертификата(Сертификат, МодульЛокализации) Экспорт
	
	Субъект = Сертификат.Субъект;
	
	Свойства = Новый Структура;
	Свойства.Вставить("ОбщееИмя");
	Свойства.Вставить("Страна");
	Свойства.Вставить("Регион");
	Свойства.Вставить("НаселенныйПункт");
	Свойства.Вставить("Улица");
	Свойства.Вставить("Организация");
	Свойства.Вставить("Подразделение");
	Свойства.Вставить("ЭлектроннаяПочта");
	Свойства.Вставить("Фамилия");
	Свойства.Вставить("Имя");
	
	Если Субъект.Свойство("CN") Тогда
		Свойства.ОбщееИмя = ПодготовитьСтроку(Субъект.CN);
	КонецЕсли;
	
	Если Субъект.Свойство("C") Тогда
		Свойства.Страна = ПодготовитьСтроку(Субъект.C);
	КонецЕсли;
	
	Если Субъект.Свойство("ST") Тогда
		Свойства.Регион = ПодготовитьСтроку(Субъект.ST);
	КонецЕсли;
	
	Если Субъект.Свойство("L") Тогда
		Свойства.НаселенныйПункт = ПодготовитьСтроку(Субъект.L);
	КонецЕсли;
	
	Если Субъект.Свойство("Street") Тогда
		Свойства.Улица = ПодготовитьСтроку(Субъект.Street);
	КонецЕсли;
	
	Если Субъект.Свойство("O") Тогда
		Свойства.Организация = ПодготовитьСтроку(Субъект.O);
	КонецЕсли;
	
	Если Субъект.Свойство("OU") Тогда
		Свойства.Подразделение = ПодготовитьСтроку(Субъект.OU);
	КонецЕсли;
	
	Если Субъект.Свойство("E") Тогда
		Свойства.ЭлектроннаяПочта = ПодготовитьСтроку(Субъект.E);
	КонецЕсли;
	
	Если МодульЛокализации <> Неопределено Тогда
		РасширенныеСвойства = МодульЛокализации.РасширенныеСвойстваСубъектаСертификата(Субъект);
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(Свойства, РасширенныеСвойства, Истина);
	КонецЕсли;
	
	Возврат Свойства;
	
КонецФункции

// См. ЭлектроннаяПодписьКлиент.СвойстваИздателяСертификата.
Функция СвойстваИздателяСертификата(Сертификат, МодульЛокализации) Экспорт
	
	Издатель = Сертификат.Издатель;
	
	Свойства = Новый Структура;
	Свойства.Вставить("ОбщееИмя");
	Свойства.Вставить("Страна");
	Свойства.Вставить("Регион");
	Свойства.Вставить("НаселенныйПункт");
	Свойства.Вставить("Улица");
	Свойства.Вставить("Организация");
	Свойства.Вставить("Подразделение");
	Свойства.Вставить("ЭлектроннаяПочта");
	
	Если Издатель.Свойство("CN") Тогда
		Свойства.ОбщееИмя = ПодготовитьСтроку(Издатель.CN);
	КонецЕсли;
	
	Если Издатель.Свойство("C") Тогда
		Свойства.Страна = ПодготовитьСтроку(Издатель.C);
	КонецЕсли;
	
	Если Издатель.Свойство("ST") Тогда
		Свойства.Регион = ПодготовитьСтроку(Издатель.ST);
	КонецЕсли;
	
	Если Издатель.Свойство("L") Тогда
		Свойства.НаселенныйПункт = ПодготовитьСтроку(Издатель.L);
	КонецЕсли;
	
	Если Издатель.Свойство("Street") Тогда
		Свойства.Улица = ПодготовитьСтроку(Издатель.Street);
	КонецЕсли;
	
	Если Издатель.Свойство("O") Тогда
		Свойства.Организация = ПодготовитьСтроку(Издатель.O);
	КонецЕсли;
	
	Если Издатель.Свойство("OU") Тогда
		Свойства.Подразделение = ПодготовитьСтроку(Издатель.OU);
	КонецЕсли;
	
	Если Издатель.Свойство("E") Тогда
		Свойства.ЭлектроннаяПочта = ПодготовитьСтроку(Издатель.E);
	КонецЕсли;
	
	Если МодульЛокализации <> Неопределено Тогда
		РасширенныеСвойства = МодульЛокализации.РасширенныеСвойстваИздателяСертификата(Издатель);
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(Свойства, РасширенныеСвойства, Истина);
	КонецЕсли;
	
	Возврат Свойства;
	
КонецФункции

// См. ЭлектроннаяПодписьКлиент.ПараметрыXMLDSig.
Функция ПараметрыXMLDSig() Экспорт
	
	ДанныеАлгоритмаПодписания = Новый Структура;
	
	ДанныеАлгоритмаПодписания.Вставить("XPathSignedInfo",       "");
	ДанныеАлгоритмаПодписания.Вставить("XPathПодписываемыйТег", "");
	
	ДанныеАлгоритмаПодписания.Вставить("ИмяАлгоритмаПодписи", "");
	ДанныеАлгоритмаПодписания.Вставить("OIDАлгоритмаПодписи", "");
	
	ДанныеАлгоритмаПодписания.Вставить("ИмяАлгоритмаХеширования", "");
	ДанныеАлгоритмаПодписания.Вставить("OIDАлгоритмаХеширования", "");
	
	Возврат ДанныеАлгоритмаПодписания;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

// Для функций СертификатПросрочен, ПредставлениеСертификата, СвойстваСертификата.
Функция ДатыСертификата(Сертификат, ДобавкаВремени) Экспорт
	
	ДатыСертификата = Новый Структура;
	ДатыСертификата.Вставить("ДатаНачала",    Сертификат.ДатаНачала    + ДобавкаВремени);
	ДатыСертификата.Вставить("ДатаОкончания", Сертификат.ДатаОкончания + ДобавкаВремени);
	
	Возврат ДатыСертификата;
	
КонецФункции

// Для функции СвойстваСертификата.
Функция ПолучитьНазначение(Сертификат)
	
	Если Не Сертификат.РасширенныеСвойства.Свойство("EKU") Тогда
		Возврат "";
	КонецЕсли;
	
	ФиксированныйМассивСвойств = Сертификат.РасширенныеСвойства.EKU;
	
	Назначение = "";
	
	Для Индекс = 0 По ФиксированныйМассивСвойств.Количество() - 1 Цикл
		Назначение = Назначение + ФиксированныйМассивСвойств.Получить(Индекс);
		Назначение = Назначение + Символы.ПС;
	КонецЦикла;
	
	Возврат ПодготовитьСтроку(Назначение);
	
КонецФункции

// Для функций СвойстваСубъектаСертификата, СвойстваИздателяСертификата.
Функция ПодготовитьСтроку(СтрокаИзСертификата)
	
	Возврат СокрЛП(ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(СтрокаИзСертификата));
	
КонецФункции

// Для процедуры ДатаПодписанияУниверсальная.
Функция ЭтоЦифры(Строка)
	
	Для НомерСимвола = 1 По СтрДлина(Строка) Цикл
		ТекущийСимвол = Сред(Строка, НомерСимвола, 1);
		Если ТекущийСимвол < "0" Или ТекущийСимвол > "9" Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Для процедуры ДатаПодписанияУниверсальная.
Функция ЭтоЗаголовокДаты(БуферДвоичныхДанных, Позиция)
	
	Если БуферДвоичныхДанных.Размер - Позиция < 3 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	БуферЗаголовка = БуферДвоичныхДанных.Прочитать(Позиция, 3);
	
	Если БуферЗаголовка.Размер = 3
	   И БуферЗаголовка[1] = 23
	   И БуферЗаголовка[2] = 13 Тогда
		
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Для процедуры ДатаПодписанияУниверсальная.
Функция ДатаСтрокой(БуферДвоичныхДанных, Позиция)
	
	ПредставлениеДаты = "";
	
	Если БуферДвоичныхДанных.Размер - (Позиция + 3) < 12 Тогда
		Возврат ПредставлениеДаты;
	КонецЕсли;
	
	БуферДаты = БуферДвоичныхДанных.Прочитать(Позиция + 3, 12);
	
	Для Каждого Байт Из БуферДаты Цикл
		ПредставлениеДаты = ПредставлениеДаты + Символ(Байт);
	КонецЦикла;
	
	Возврат ПредставлениеДаты;
	
КонецФункции

#КонецОбласти
