
&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
 УстановитьОтбор();

КонецПроцедуры


	&НаКлиенте
Процедура УстановитьОтбор()
    
    ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
	КИ, "Ссылка",ТекущаяСтрока, ВидСравненияКомпоновкиДанных.Равно,, Истина);

  КонецПроцедуры	

&НаКлиенте
  Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	  
	  Если ВРег(ИмяСобытия) = ВРег("Запись_ГруппыПользователей")
	   И Источник = Элементы.ГруппыПользователей.ТекущаяСтрока Тогда
		
		Элементы.Список.Обновить();
		
			
	ИначеЕсли ВРег(ИмяСобытия) = ВРег("РазмещениеПользователейВГруппах") Тогда
		
		Элементы.ПользователиСписок.Обновить();
		
	КонецЕсли;
	

  КонецПроцедуры
