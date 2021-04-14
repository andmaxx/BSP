
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	УсловияОтбора = ПолучитьУсловиеОтвораНасервере(ПараметрКоманды);
 	ПараметрыФормы = Новый Структура("Отбор, СформироватьПриОткрытии,КлючВарианта", УсловияОтбора, Истина,"ПлатежиИнициатора");
	ОткрытьФорму("Отчет._Бюджет.ФормаОбъекта",ПараметрыФормы,ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьУсловиеОтвораНасервере(ПараметрКоманды)
	
	
	Период = Новый СтандартныйПериод;
	Если ЗначениеЗаполнено(ПараметрКоманды.Основание) Тогда
	
	Период.ДатаНачала  = НачалоМесяца(ПараметрКоманды.Основание.ПериодРегистрации);
	Период.ДатаОкончания  = КонецМесяца(ПараметрКоманды.Основание.ПериодРегистрации);
	Иначе
	Период.ДатаНачала  = НачалоМесяца(ПараметрКоманды.ДатаОплаты);
	Период.ДатаОкончания  = КонецМесяца(ПараметрКоманды.ДатаОплаты);

	КонецЕсли;

УсловияОтбора = Новый Структура("КалендарныйПлатеж,Инициатор,Период",
	ПараметрКоманды.Основание, ПараметрКоманды.Инициатор,Период );

Возврат	УсловияОтбора;

КонецФункции // ПолучитьУсловиеОтвораНасервере()
