﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интеграция с 1С:Бухфон".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Процедура устанавливает свойства элемента кнопки при встраивании в другие подсистемы.
//
Процедура ПриСозданииНаСервере(Элемент) Экспорт
	
	НастройкиПользователя = Интеграция1СБухфонВызовСервера.НастройкиУчетнойЗаписиПользователя();
	Элемент.Видимость = НастройкиПользователя.ВидимостьКнопки1СБухфон;
	
	НастройкиКлиентскогоПриложения = ХранилищеСистемныхНастроек.Загрузить("Общее/НастройкиКлиентскогоПриложения");
	Если НастройкиКлиентскогоПриложения = Неопределено Тогда
		ВариантМасштаба = ВариантМасштабаФормКлиентскогоПриложения.Обычный;
	Иначе
		ВариантМасштаба = НастройкиКлиентскогоПриложения.ВариантМасштабаФормКлиентскогоПриложения;
	КонецЕсли;
	
	Если ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2
		Или ВариантМасштаба = ВариантМасштабаФормКлиентскогоПриложения.Компактный Тогда
		Элемент.Ширина = 20;
		Элемент.Высота = 3;
	Иначе
		Элемент.Ширина = 16;
		Элемент.Высота = 3;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
//
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	СерверныеОбработчики["СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"].Добавить(
	"Интеграция1СБухфон");
	
КонецПроцедуры

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Процедура = "Интеграция1СБухфон.ПервоначальноеЗаполнение";		
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Записывает в регистр сведений путь исполняемого файла 1С-Бухфон. 
// Хранение путей до исполняемых файлов ведется в разрезе ПК, для определения ПК используется идентификатор клиента
// т.к. невозможно использование функции ИмяКомпьютера в веб клиенте.
//
// Параметры:
//		ИдентификаторКлиента	- УникальныйИдентификатор - Идентификатор клиента (программы) 1С.
//		НовоеРасположениеФайла 	- Строка - Расположение исполняемого файла для ПК на котором запущен клиент 1С.
Процедура СохранитьРасположениеИсполняемогоФайла1СБухфон(ИдентификаторКлиента, НовоеРасположениеФайла) Экспорт 
	
	ТекущееРасположениеФайла = Интеграция1СБухфонВызовСервера.РасположениеИсполняемогоФайла(ИдентификаторКлиента);

	Если ТекущееРасположениеФайла = НовоеРасположениеФайла Тогда
		Возврат;	
	КонецЕсли;

	ХранилищеОбщихНастроек.Сохранить("ПутиИсполняемыхФайлов1СБухфон", ИдентификаторКлиента, НовоеРасположениеФайла);
	
КонецПроцедуры

// Записывает в регистр сведений настройки учетных записей пользователей для запуска программы 1С-Бухфон.
//
// Параметры:
// 		Пользователь            - УникальныйИдентификатор - Текущий пользователь информационной базы.
// 		Логин					- Строка - Данные учетной записи программы 1С-Бухфон.
// 		Пароль		    		- Строка - Данные учетной записи программы 1С-Бухфон.
//		ИспользоватьЛП  		- Булево - Если значение Ложь Параметры Логин, Пароль не доступны.
//		ВидимостьКнопки1СБухфон - Булево - Отображение Кнопки запуска 1С-Бухфон на Начальной странице.
//
Процедура СохранитьНастройкиПользователяВХранилище(Логин, 
										 Пароль, 
										 ИспользоватьЛП, 
										 ВидимостьКнопки1СБухфон) Экспорт
		
	НастройкиПользователя = НастройкиПользователя();
	НастройкиПользователя.Логин 					= Логин;
	НастройкиПользователя.Пароль 					= Пароль;
	НастройкиПользователя.ИспользоватьЛП 			= ИспользоватьЛП;
	НастройкиПользователя.ВидимостьКнопки1СБухфон 	= ВидимостьКнопки1СБухфон;		
	
	ХранилищеОбщихНастроек.Сохранить("УчетныеЗаписиПользователей1СБухфон", "НастройкиУчетныхДанных", НастройкиПользователя);
	
КонецПроцедуры

Функция НастройкиПользователя() Экспорт
	
	НастройкиПользователя = Новый Структура();
	НастройкиПользователя.Вставить("Логин", "");
	НастройкиПользователя.Вставить("Пароль","");
	НастройкиПользователя.Вставить("ИспользоватьЛП",Ложь);
	НастройкиПользователя.Вставить("ВидимостьКнопки1СБухфон",Ложь);	
	
	Возврат НастройкиПользователя;
	
КонецФункции

Процедура ПервоначальноеЗаполнение() Экспорт
	Константы.ИспользоватьИнтеграцию1СБухфон.Установить(Истина);	
КонецПроцедуры
	
#КонецОбласти



