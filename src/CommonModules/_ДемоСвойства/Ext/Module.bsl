﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Демо: Свойства".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Отключает использование наборов свойств внешних пользователей
//
Процедура _ДемоОбновитьИспользованиеВнешнихПользователейПриЗаписи(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыНабора = УправлениеСвойствами.СтруктураПараметровНабораСвойств();
	ПараметрыНабора.Используется = Источник.Значение;
	УправлениеСвойствами.УстановитьПараметрыНабораСвойств("Справочник_ВнешниеПользователи", ПараметрыНабора);
	
КонецПроцедуры

#КонецОбласти
