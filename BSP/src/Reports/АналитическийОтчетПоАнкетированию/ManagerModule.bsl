///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	МодульВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПросмотрОтветовПростыеВопросы");
	НастройкиВарианта.Описание = НСтр("ru = 'Информация о том, как отвечали респонденты на простые вопросы.'");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПросмотрТабличныхВопросовПлоскийВид");
	НастройкиВарианта.Описание = 
		НСтр("ru = 'Информация о том, как отвечали респонденты на табличные вопросы.
		|Выводится в виде списка с группировками.'");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПросмотрТабличныхВопросовТабличныйВид");
	НастройкиВарианта.Описание = 
		НСтр("ru = 'Информация о том, как  отвечали респонденты на табличные вопросы.
		|Каждый ответ респондента представлен в виде таблицы.'");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПростыеВопросыКоличествоОтветов");
	НастройкиВарианта.Описание = НСтр("ru = 'Информация о том, сколько раз был дан вариант ответа на простой вопрос.'");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПростыеВопросыАгрегируемыеПоказатели");
	НастройкиВарианта.Описание = 
		НСтр("ru = 'Информация о среднем, минимальном, максимальном ответе на простой вопрос,
		|который требует числового ответа.'");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ТабличныеВопросыКоличествоОтветов");
	НастройкиВарианта.Описание = 
		НСтр("ru = 'Информация о том, сколько раз был дан варианта ответа для табличных вопросов,
		|который требует указания числового значения.'");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ТабличныеВопросыАгрегируемыеПоказатели");
	НастройкиВарианта.Описание = 
		НСтр("ru = 'Информация о среднем, минимальном, максимальном ответе в ячейке табличного вопроса,
		|который требует указания числового значения.'");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПростыеВопросыКоличествоОтветовСравнениеПоОпросам");
	НастройкиВарианта.Описание = 
		НСтр("ru = 'Сравнительный анализ количества данных вариантов ответов 
		|на простые вопросы в разных опросах.'");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ТабличныеВопросыАгрегируемыеПоказателиСравнениеПоОпросам");
	НастройкиВарианта.Описание = 
		НСтр("ru = 'Сравнительный анализ агрегируемых показателей ответов в ячейках
		|табличных вопросов разных опросов.'");
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли