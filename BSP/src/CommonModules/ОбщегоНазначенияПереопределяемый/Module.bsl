///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Позволяет настроить общие параметры подсистемы.
//
// Параметры:
//  ОбщиеПараметры - Структура - структура со свойствами:
//      * ИмяФормыПерсональныхНастроек            - Строка - имя формы для редактирования персональных настроек.
//                                                           Ранее определялись в
//                                                           ОбщегоНазначенияПереопределяемый.ИмяФормыПерсональныхНастроек.
//      * ЗапрашиватьПодтверждениеПриЗавершенииПрограммы - Булево - по умолчанию Истина. Если установить в Ложь, то 
//                                                                  подтверждение при завершении работы программы не
//                                                                  будет запрашиваться,  если явно не разрешить в
//                                                                  персональных настройках программы.
//      * МинимальнаяВерсияПлатформы              - Строка - минимальная версии платформы, требуемая для запуска программы.
//                                                           Запуск программы на версии платформы ниже указанной будет невозможен.
//                                                           Например, "8.3.6.1650".
//      * РекомендуемаяВерсияПлатформы            - Строка - рекомендуемая версия платформы для запуска программы.
//                                                           Например, "8.3.8.2137".
//      * ОтключитьИдентификаторыОбъектовМетаданных - Булево - отключает заполнение справочников ИдентификаторыОбъектовМетаданных
//              и ИдентификаторыОбъектовРасширений, процедуру выгрузки и загрузки в узлах РИБ.
//              Для частичного встраивания отдельных функций библиотеки в конфигурации без постановки на поддержку.
//      * РекомендуемыйОбъемОперативнойПамяти - Число - объем памяти в гигабайтах, рекомендуемый для комфортной работы в
//                                                      программе.
//
//    Устарели, следует использовать свойства МинимальнаяВерсияПлатформы и РекомендуемаяВерсияПлатформы:
//      * МинимальноНеобходимаяВерсияПлатформы    - Строка - полный номер версии платформы для запуска программы.
//                                                           Например, "8.3.4.365".
//                                                           Ранее определялись в
//                                                           ОбщегоНазначенияПереопределяемый.ПолучитьМинимальноНеобходимуюВерсиюПлатформы.
//      * РаботаВПрограммеЗапрещена               - Булево - начальное значение Ложь.
//
Процедура ПриОпределенииОбщихПараметровБазовойФункциональности(ОбщиеПараметры) Экспорт
	
	
	
КонецПроцедуры

// Определяет соответствие имен параметров сеанса и обработчиков для их установки.
// Вызывается для инициализации параметров сеанса из обработчика события модуля сеанса УстановкаПараметровСеанса
// (подробнее о нем см. синтакс-помощник).
//
// В указанных модулях должна быть размещена процедура обработчика, в которую передаются параметры:
//  ИмяПараметра           - Строка - имя параметра сеанса, который требуется установить.
//  УстановленныеПараметры - Массив - имена параметров, которые уже установлены.
// 
// Далее пример процедуры обработчика для копирования в указанные модули.
//
//// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииОбработчиковУстановкиПараметровСеанса.
//Процедура УстановкаПараметровСеанса(ИмяПараметра, УстановленныеПараметры) Экспорт
//	
//	Если ИмяПараметра = "ТекущийПользователь" Тогда
//		ПараметрыСеанса.ТекущийПользователь = Значение;
//		УстановленныеПараметры.Добавить("ТекущийПользователь");
//	КонецЕсли;
//	
//КонецПроцедуры
//
// Параметры:
//  Обработчики - Соответствие - со свойствами:
//    * Ключ     - Строка - в формате "<ИмяПараметраСеанса>|<НачалоИмениПараметраСеанса*>".
//                   Символ '*'используется в конце имени параметра сеанса и обозначает,
//                   что один обработчик будет вызван для инициализации всех параметров сеанса
//                   с именем, начинающимся на слово НачалоИмениПараметраСеанса.
//
//    * Значение - Строка - в формате "<ИмяМодуля>.УстановкаПараметровСеанса".
//
//  Пример:
//   Обработчики.Вставить("ТекущийПользователь", "ПользователиСлужебный.УстановкаПараметровСеанса");
//
Процедура ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики) Экспорт
	
	
	
	
	
КонецПроцедуры

// Позволяет задать значения параметров, необходимых для работы клиентского кода
// при запуске конфигурации (в обработчиках событий ПередНачаломРаботыСистемы и ПриНачалеРаботыСистемы) 
// без дополнительных серверных вызовов. 
// Для получения значений этих параметров из клиентского кода
// см. СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске.
//
// Важно: недопустимо использовать команды сброса кэша повторно используемых модулей, 
// иначе запуск может привести к непредсказуемым ошибкам и лишним серверным вызовам.
//
// Параметры:
//   Параметры - Структура - имена и значения параметров работы клиента при запуске, которые необходимо задать.
//                           Для установки параметров работы клиента при запуске:
//                           Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	
	
	
	
КонецПроцедуры

// Позволяет задать значения параметров, необходимых для работы клиентского кода
// конфигурации без дополнительных серверных вызовов.
// Для получения этих параметров из клиентского кода
// см. СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента.
//
// Параметры:
//   Параметры - Структура - имена и значения параметров работы клиента, которые необходимо задать.
//                           Для установки параметров работы клиента:
//                           Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
Процедура ПриДобавленииПараметровРаботыКлиента(Параметры) Экспорт
	
	
	
	
	
КонецПроцедуры

// Определяет объекты метаданных и отдельные реквизиты, которые исключаются из результатов поиска ссылок,
// не учитываются при монопольном удалении помеченных, замене ссылок и в отчете по местам использования.
// См. также ОбщегоНазначения.ИсключенияПоискаСсылок.
//
// Пример задачи: к документу "Реализация товаров и услуг" подключены подсистемы "Версионирование объектов" и "Свойства".
// Также этот документ может быть указан в других объектах метаданных - документах или регистрах.
// Часть ссылок имеют значение для бизнес-логики (например движения по регистрам) и должны выводиться пользователю.
// Другая часть ссылок - "техногенные" (ссылки на документ из данных подсистем "Версионирование объектов" и "Свойства")
// и должны скрываться от пользователя при удалении, анализе мест использования или запретов редактирования ключевых реквизитов.
// Список таких "техногенных" объектов нужно перечислить в этой процедуре.
//
// При этом для избежания появления ссылок на несуществующие объекты
// рекомендуется предусмотреть процедуру очистки указанных объектов метаданных.
//   * Для измерений регистров сведений - с помощью установки флажка "Ведущее",
//     тогда запись регистра сведений будет удалена вместе с удалением ссылки, указанной в измерении.
//   * Для других реквизитов указанных объектов - с помощью подписки на событие ПередУдалением всех типов объектов
//     метаданных, которые могут быть записаны в реквизиты указанных объектов метаданных.
//     В обработчике необходимо найти "техногенные" объекты, в реквизитах которых указана ссылка удаляемого объекта,
//     и выбрать, как именно очищать ссылку: очищать значение реквизита, удалять строку таблицы или удалять весь объект.
// Подробнее см. в документации к подсистеме "Удаление помеченных объектов".
//
// При исключении регистров допустимо исключать только Измерения.
// При необходимости исключить из поиска значения в ресурсах
// или в реквизитах регистров требуется исключить регистр целиком.
//
// Параметры:
//   ИсключенияПоискаСсылок - Массив - объекты метаданных или их реквизиты (ОбъектМетаданных, Строка),
//       которые не должно учитываться в бизнес-логике.
//       Стандартные реквизиты и табличные части могут быть указаны только в виде строковых имен (см. пример ниже).
//
// Пример:
//   ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ВерсииОбъектов);
//   ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ВерсииОбъектов.Измерения.Объект);
//   ИсключенияПоискаСсылок.Добавить("ПланВидовРасчета._ДемоОсновныеНачисления.СтандартнаяТабличнаяЧасть.БазовыеВидыРасчета.СтандартныйРеквизит.ВидРасчета");
//
Процедура ПриДобавленииИсключенийПоискаСсылок(ИсключенияПоискаСсылок) Экспорт
	
	
	
КонецПроцедуры

// Вызывается при обновлении информационной базы для учета переименований подсистем и ролей в конфигурации.
// В противном случае, возникнет рассинхронизация между метаданными конфигурации и 
// элементами справочника ИдентификаторыОбъектовМетаданных, что приведет к различным ошибкам при работе конфигурации.
//
// В этой процедуре последовательно для каждой версии конфигурации задаются переименования только подсистем и ролей, 
// а переименования остальных объектов метаданных задавать не следует, т.к. они обрабатываются автоматически.
//
// Параметры:
//  Итог - ТаблицаЗначений - таблица переименований, которую требуется заполнить.
//                           См. ОбщегоНазначения.ДобавитьПереименование.
//
// Пример:
//	ОбщегоНазначения.ДобавитьПереименование(Итог, "2.1.2.14",
//		"Подсистема._ДемоПодсистемы",
//		"Подсистема._ДемоСервисныеПодсистемы");
//
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт
	
	
	
	
	
КонецПроцедуры

// Позволяет виртуально отключать подсистемы для целей тестирования.
// Если подсистема отключена, то функция ОбщегоНазначения.ПодсистемаСуществует вернет Ложь.
// В этой процедуре нельзя использовать функцию ОбщегоНазначения.ПодсистемСуществует, т.к. это приводит к рекурсии.
//
// Параметры:
//   ОтключенныеПодсистемы - Соответствие - в ключе указывается имя отключаемой подсистемы, 
//                                          в значении - установить в Истина.
//
Процедура ПриОпределенииОтключенныхПодсистем(ОтключенныеПодсистемы) Экспорт
	
	
	
КонецПроцедуры

// Вызывается перед загрузкой приоритетных данных в подчиненном узле РИБ
// и предназначена для заполнения настроек размещения сообщения обмена данными или
// для реализации нестандартной загрузки приоритетных данных из главного узла РИБ.
//
// К приоритетным данным относятся предопределенные элементы, а также
// элементы справочника ИдентификаторыОбъектовМетаданных.
//
// Параметры:
//  СтандартнаяОбработка - Булево - начальное значение Истина; если установить Ложь, 
//                то стандартная загрузка приоритетных данных с помощью подсистемы
//                ОбменДанными будет пропущена (так же будет и в том случае,
//                если подсистемы ОбменДанными нет в конфигурации).
//
Процедура ПередЗагрузкойПриоритетныхДанныхВПодчиненномРИБУзле(СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

// Определяет список версий программных интерфейсов, доступных через web-сервис InterfaceVersion.
// См. также ОбщегоНазначения.ВерсииИнтерфейса.
//
// Параметры:
//  ПоддерживаемыеВерсии - Структура - в ключе указывается имя программного интерфейса,
//                                     а в значениях - массив строк с поддерживаемыми версиями этого интерфейса.
//
// Пример:
//
//  // СервисПередачиФайлов
//  Версии = Новый Массив;
//  Версии.Добавить("1.0.1.1");
//  Версии.Добавить("1.0.2.1"); 
//  ПоддерживаемыеВерсии.Вставить("СервисПередачиФайлов", Версии);
//  // Конец СервисПередачиФайлов
//
Процедура ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(ПоддерживаемыеВерсии) Экспорт
	
КонецПроцедуры

// Задает параметры функциональных опций, действие которых распространяется на командный интерфейс и рабочий стол.
// Например, если значения функциональной опции хранятся в ресурсах регистра сведений,
// то параметры функциональных опций могут определять условия отборов по измерениям регистра,
// которые будут применяться при чтении значения этой функциональной опции.
//
// См. в синтакс-помощнике методы ПолучитьФункциональнуюОпциюИнтерфейса,
// УстановитьПараметрыФункциональныхОпцийИнтерфейса и ПолучитьПараметрыФункциональныхОпцийИнтерфейса.
//
// Параметры:
//   ОпцииИнтерфейса - Структура - значения параметров функциональных опций, установленных для командного интерфейса.
//       Ключ элемента структуры определяет имя параметра, а значение элемента - текущее значение параметра.
//
Процедура ПриОпределенииПараметровФункциональныхОпцийИнтерфейса(ОпцииИнтерфейса) Экспорт
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики отправки и получения данных для обмена в распределенной информационной базе.

// Дополнительный обработчик одноименного события, возникающего при обмене данными в распределенной информационной базе.
// Выполняется после выполнения базовых алгоритмов библиотеки.
// Не выполняется, если отправка элемента данных была проигнорирована ранее.
//
// Параметры:
//  Источник                  - ПланОбменаОбъект - узел, для которого выполняется обмен.
//  ЭлементДанных             - Произвольный - см. описание одноименного обработчика в синтакс-помощнике.
//  ОтправкаЭлемента          - ОтправкаЭлементаДанных - см. описание одноименного обработчика в синтакс-помощнике.
//  СозданиеНачальногоОбраза  - Булево - см. описание одноименного обработчика в синтакс-помощнике.
//
Процедура ПриОтправкеДанныхПодчиненному(Источник, ЭлементДанных, ОтправкаЭлемента, СозданиеНачальногоОбраза) Экспорт
	
КонецПроцедуры

// Дополнительный обработчик одноименного события, возникающего при обмене данными в распределенной информационной базе.
// Выполняется после выполнения базовых алгоритмов библиотеки.
// Не выполняется, если отправка элемента данных была проигнорирована ранее.
//
// Параметры:
//  Источник          - ПланОбменаОбъект - узел, для которого выполняется обмен.
//  ЭлементДанных     - Произвольный - см. описание одноименного обработчика в синтакс-помощнике.
//  ОтправкаЭлемента  - ОтправкаЭлементаДанных - см. описание одноименного обработчика в синтакс-помощнике.
//
Процедура ПриОтправкеДанныхГлавному(Источник, ЭлементДанных, ОтправкаЭлемента) Экспорт
	
КонецПроцедуры

// Дополнительный обработчик одноименного события, возникающего при обмене данными в распределенной информационной базе.
// Выполняется после выполнения базовых алгоритмов библиотеки.
// Не выполняется, если получение элемента данных было проигнорировано ранее.
//
// Параметры:
//  Источник          - ПланОбменаОбъект - узел, для которого выполняется обмен.
//  ЭлементДанных     - Произвольный - см. описание одноименного обработчика в синтакс-помощнике.
//  ПолучениеЭлемента - ПолучениеЭлементаДанных - см. описание одноименного обработчика в синтакс-помощнике.
//  ОтправкаНазад     - Булево - см. описание одноименного обработчика в синтакс-помощнике.
//
Процедура ПриПолученииДанныхОтПодчиненного(Источник, ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад) Экспорт
	
КонецПроцедуры

// Дополнительный обработчик одноименного события, возникающего при обмене данными в распределенной информационной базе.
// Выполняется после выполнения базовых алгоритмов библиотеки.
// Не выполняется, если получение элемента данных было проигнорировано ранее.
//
// Параметры:
//  Источник          - ПланОбменаОбъект - узел, для которого выполняется обмен.
//  ЭлементДанных     - Произвольный - см. описание одноименного обработчика в синтакс-помощнике.
//  ПолучениеЭлемента - ПолучениеЭлементаДанных - см. описание одноименного обработчика в синтакс-помощнике.
//  ОтправкаНазад     - Булево - см. описание одноименного обработчика в синтакс-помощнике.
//
Процедура ПриПолученииДанныхОтГлавного(Источник, ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад) Экспорт
	
КонецПроцедуры

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать ПриДобавленииПараметровРаботыКлиентаПриЗапуске.
//
// Позволяет задать значения параметров, необходимых для работы клиентского кода
// при запуске конфигурации (в обработчиках событий ПередНачаломРаботыСистемы и ПриНачалеРаботыСистемы) 
// без дополнительных серверных вызовов. 
// Для получения значений этих параметров из клиентского кода
// см. СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске.
//
// Важно: недопустимо использовать команды сброса кэша повторно используемых модулей, 
// иначе запуск может привести к непредсказуемым ошибкам и лишним серверным вызовам.
//
// Параметры:
//   Параметры - Структура - имена и значения параметров работы клиента при запуске, которые необходимо задать.
//                           Для установки параметров работы клиента при запуске:
//                           Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
Процедура ПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
КонецПроцедуры

// Устарела. Следует использовать ПриДобавленииПараметровРаботыКлиента.
//
// Позволяет задать значения параметров, необходимых для работы клиентского кода
// конфигурации без дополнительных серверных вызовов.
// Для получения этих параметров из клиентского кода
// см. СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента.
//
// Параметры:
//   Параметры - Структура - имена и значения параметров работы клиента, которые необходимо задать.
//                           Для установки параметров работы клиента:
//                           Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
Процедура ПараметрыРаботыКлиента(Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
