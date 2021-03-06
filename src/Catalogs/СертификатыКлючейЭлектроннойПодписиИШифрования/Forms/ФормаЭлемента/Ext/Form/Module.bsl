﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	ПриСозданииНаСервереПриЧтенииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Отказ = Истина;
		ПодключитьОбработчикОжидания("ОбработчикОжиданияДобавитьСертификат", 0.1, Истина);
		Возврат;
		
	ИначеЕсли ЗначениеЗаполнено(Объект.СостояниеЗаявления)
	        И Объект.СостояниеЗаявления
	           <> ПредопределенноеЗначение("Перечисление.СостоянияЗаявленияНаВыпускСертификата.Исполнено") Тогда
		
		Отказ = Истина;
		ПодключитьОбработчикОжидания("ОбработчикОжиданияОткрытьЗаявление", 0.1, Истина);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если АдресСертификата <> Неопределено Тогда
		ПриСозданииНаСервереПриЧтенииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_СертификатыКлючейЭлектроннойПодписиИШифрования", Новый Структура, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// Проверка уникальности наименования.
	Если Не Элементы.Наименование.ТолькоПросмотр Тогда
		ЭлектроннаяПодписьСлужебный.ПроверитьУникальностьПредставления(
			Объект.Наименование, Объект.Ссылка, "Объект.Наименование", Отказ);
	КонецЕсли;
	
	Если ТипЗнч(ПараметрыРеквизитов) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого КлючИЗначение Из ПараметрыРеквизитов Цикл
		ИмяРеквизита = КлючИЗначение.Ключ;
		Свойства     = КлючИЗначение.Значение;
		
		Если Не Свойства.ТолькоПросмотр.ПроверкаЗаполнения
		 Или ЗначениеЗаполнено(Объект[ИмяРеквизита]) Тогда
			
			Продолжить;
		КонецЕсли;
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Поле %1 не заполнено.'"),
			Элементы[ИмяРеквизита].Заголовок);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, ИмяРеквизита,, Отказ);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьАвтозаполняемыеРеквизиты(Команда)
	
	Показать = Не Элементы.ФормаПоказатьАвтозаполняемыеРеквизиты.Пометка;
	
	Элементы.ФормаПоказатьАвтозаполняемыеРеквизиты.Пометка = Показать;
	Элементы.ЗаголовкиАвтоПолейИзДанныхСертификата.Видимость = Показать;
	Элементы.АвтоПоляИзДанныхСертификата.Видимость = Показать;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Организации") Тогда
		Элементы.ОрганизацияЗаголовок.Видимость = Показать;
		Элементы.Организация.Видимость = Показать;
	КонецЕсли;
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДанныеСертификата(Команда)
	
	ЭлектроннаяПодписьКлиент.ОткрытьСертификат(АдресСертификата, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьЗаявлениеПоКоторомуБылПолученСертификат(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СертификатСсылка", Объект.Ссылка);
	ОткрытьФорму("Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.Форма.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата",
		ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСертификат(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Сертификат еще не записан.'"));
		Возврат;
	КонецЕсли;
	
	Если Модифицированность И Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	ЭлектроннаяПодписьКлиент.ПроверитьСертификатСправочника(Объект.Ссылка,
		Новый Структура("БезПодтверждения", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДанныеСертификатаВФайл(Команда)
	
	ЭлектроннаяПодписьСлужебныйКлиент.СохранитьСертификат(Неопределено, АдресСертификата);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатОтозван(Команда)
	
	Объект.Отозван = Не Объект.Отозван;
	Элементы.ФормаСертификатОтозван.Пометка = Объект.Отозван;
	
	Если Объект.Отозван Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'После записи отменить отзыв будет невозможно.'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииНаСервереПриЧтенииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.СостояниеЗаявления) Тогда
		Если Объект.СостояниеЗаявления = Перечисления.СостоянияЗаявленияНаВыпускСертификата.Исполнено Тогда
			Элементы.ФормаПоказатьЗаявлениеПоКоторомуБылПолученСертификат.Доступность = Истина;
			Элементы.ПоказатьЗаявлениеПоКоторомуБылПолученСертификат.Доступность = Истина;
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ДвоичныеДанныеСертификата = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		Объект.Ссылка, "ДанныеСертификата").Получить();
	
	Если ТипЗнч(ДвоичныеДанныеСертификата) = Тип("ДвоичныеДанные") Тогда
		Сертификат = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
		Если ЗначениеЗаполнено(АдресСертификата) Тогда
			ПоместитьВоВременноеХранилище(ДвоичныеДанныеСертификата, АдресСертификата);
		Иначе
			АдресСертификата = ПоместитьВоВременноеХранилище(ДвоичныеДанныеСертификата, УникальныйИдентификатор);
		КонецЕсли;
		ЭлектроннаяПодписьКлиентСервер.ЗаполнитьОписаниеДанныхСертификата(ОписаниеДанныхСертификата, Сертификат);
	Иначе
		АдресСертификата = "";
		Элементы.ПоказатьДанныеСертификата.Доступность  = Ложь;
		Элементы.ФормаПроверитьСертификат.Доступность = Ложь;
		Элементы.ФормаСохранитьДанныеСертификатаВФайл.Доступность = Ложь;
		Элементы.АвтоПоляИзДанныхСертификата.Видимость = Истина;
		Элементы.ЗаголовкиАвтоПолейИзДанныхСертификата.Видимость = Истина;
		Элементы.ФормаПоказатьАвтозаполняемыеРеквизиты.Пометка = Истина;
	КонецЕсли;
	
	Элементы.ФормаСертификатОтозван.Пометка = Объект.Отозван;
	Если Объект.Отозван Тогда
		Элементы.ФормаСертификатОтозван.Доступность = Ложь;
	КонецЕсли;
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		Если Объект.Добавил      <> Пользователи.ТекущийПользователь()
		   И Объект.Пользователь <> Пользователи.ТекущийПользователь() Тогда
			// Обычный пользователь может изменять только свои сертификаты.
			ТолькоПросмотр = Истина;
		Иначе
			// Обычный пользователь не может изменить права доступа.
			Элементы.Добавил.ТолькоПросмотр = Истина;
			Если Объект.Добавил <> Пользователи.ТекущийПользователь() Тогда
				// Обычный пользователь не может изменять реквизит Пользователь,
				// если не он добавил сертификат.
				Элементы.Пользователь.ТолькоПросмотр = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Организации") Тогда
		МодульОрганизацииСлужебный = ОбщегоНазначения.ОбщийМодуль("ОрганизацииСлужебный");
		ОрганизацияПоУмолчанию = МодульОрганизацииСлужебный.ОрганизацияПоУмолчанию();
		
		Если ЗначениеЗаполнено(ОрганизацияПоУмолчанию)
		   И Объект.Организация = ОрганизацияПоУмолчанию
		   И Не МодульОрганизацииСлужебный.ИспользуетсяНесколькоОрганизаций() Тогда
			
			Элементы.ОрганизацияЗаголовок.Видимость = Ложь;
			Элементы.Организация.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Организации") Тогда
		Элементы.ОрганизацияЗаголовок.Видимость = Ложь;
		Элементы.Организация.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(АдресСертификата) Тогда
		Возврат; // Сертификат = Неопределено.
	КонецЕсли;
	
	СвойстваСубъекта = ЭлектроннаяПодписьКлиентСервер.СвойстваСубъектаСертификата(Сертификат);
	Если СвойстваСубъекта.Фамилия <> Неопределено Тогда
		Элементы.Фамилия.ТолькоПросмотр = Истина;
	КонецЕсли;
	Если СвойстваСубъекта.Имя <> Неопределено Тогда
		Элементы.Имя.ТолькоПросмотр = Истина;
	КонецЕсли;
	Если СвойстваСубъекта.Отчество <> Неопределено Тогда
		Элементы.Отчество.ТолькоПросмотр = Истина;
	КонецЕсли;
	Если СвойстваСубъекта.Организация <> Неопределено Тогда
		Элементы.Фирма.ТолькоПросмотр = Истина;
	КонецЕсли;
	Если СвойстваСубъекта.Должность <> Неопределено Тогда
		Элементы.Должность.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ПараметрыРеквизитов = Неопределено;
	ЭлектроннаяПодписьСлужебный.ПередНачаломРедактированияСертификатаКлюча(
		Объект.Ссылка, Сертификат, ПараметрыРеквизитов);
	
	Для каждого КлючИЗначение Из ПараметрыРеквизитов Цикл
		ИмяРеквизита = КлючИЗначение.Ключ;
		Свойства     = КлючИЗначение.Значение;
		
		Если Не Свойства.Видимость Тогда
			Элементы[ИмяРеквизита].Видимость = Ложь;
			
		ИначеЕсли Свойства.ТолькоПросмотр Тогда
			Элементы[ИмяРеквизита].ТолькоПросмотр = Истина
		КонецЕсли;
		Если Свойства.ТолькоПросмотр.ПроверкаЗаполнения Тогда
			Элементы[ИмяРеквизита].АвтоОтметкаНезаполненного = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Элементы.АвтоПоляИзДанныхСертификата.Видимость =
		    Не Элементы.Фамилия.ТолькоПросмотр   И Не ЗначениеЗаполнено(Объект.Фамилия)
		Или Не Элементы.Имя.ТолькоПросмотр       И Не ЗначениеЗаполнено(Объект.Имя)
		Или Не Элементы.Отчество.ТолькоПросмотр  И Не ЗначениеЗаполнено(Объект.Отчество);
	
	Элементы.НаименованиеЗаголовок.Видимость = Элементы.Наименование.Видимость;
	Элементы.ОрганизацияЗаголовок.Видимость  = Элементы.Организация.Видимость;
	Элементы.ПользовательЗаголовок.Видимость = Элементы.Пользователь.Видимость;
	
	Элементы.ЗаголовкиАвтоПолейИзДанныхСертификата.Видимость =
		Элементы.АвтоПоляИзДанныхСертификата.Видимость;
	
	Элементы.ФормаПоказатьАвтозаполняемыеРеквизиты.Пометка =
		Элементы.АвтоПоляИзДанныхСертификата.Видимость;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияДобавитьСертификат()
	
	ПараметрыСоздания = Новый Структура;
	ПараметрыСоздания.Вставить("ВЛичныйСписок", Истина);
	ПараметрыСоздания.Вставить("Организация", Объект.Организация);
	ПараметрыСоздания.Вставить("СкрытьЗаявление", Ложь);
	
	ЭлектроннаяПодписьСлужебныйКлиент.ДобавитьСертификат(ПараметрыСоздания);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияОткрытьЗаявление()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СертификатСсылка", Объект.Ссылка);
	ОткрытьФорму("Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.Форма.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата",
		ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти
