&НаСервере
функция ЧтениеТабЧасти()
	ТабДок = Новый ТабличныйДокумент;
	Попытка
		ТабДок.Прочитать(Объект.ПутьКФайлу,СпособЧтенияЗначенийТабличногоДокумента.Значение);	
	Исключение
		сообщение = новый СообщениеПользователю;
		сообщение.текст = "Нихуя не получилось, зацени что тута: " + ОписаниеОшибки();
		вызватьИсключение;
	КонецПопытки;
	возврат ТабДок;
конецфункции

&НаСервере
Функция Лист()
	TableDoc = ЧтениеТабЧасти();
	Для каждого наименование  из  TableDoc.Области цикл
		Если Объект.Листы= наименование.имя тогда 
			возврат TableDoc.ПолучитьОбласть(наименование.имя);
		КонецЕсли;	
	КонецЦикла;
КонецФункции

&НаСервере
Function sizeTab ()
	size = new Array;
	size.Add (Лист().TableWidth); //[0] ширина
	size.Add (Лист().TableHeight); //[1] Высота
	Return size;
EndFunction

&НаСервере
Процедура ПеречеслениеЛистовAtServer()
	НовыйЭлемент = Элементы.Листы;
	НовыйЭлемент.СписокВыбора.Clear();
	Для каждого наименование  из ЧтениеТабЧасти().Areas цикл
	НовыйЭлемент.СписокВыбора.добавить(наименование.Name);

	newElemet = Items.Add(наименование.Name, Type("ГруппаФормы"),Items.PageGP);
	newElemet.Type=FormGroupType.Page;
	newElemet.Title=наименование.Name;
	X="name" +наименование.Name;
	НовыйЭлемент2 = Элементы.Добавить(X,Тип("ДекорацияФормы"),newElemet);
	НовыйЭлемент2.Заголовок = "НоваяНадпись"+наименование.Name;
	КонецЦикла;
	
КонецПроцедуры


&НаСервере
Процедура Прочитать_XLS()
	ColumnN = sizeTab()[0];
	NString = sizeTab()[1];
	LIST = Лист();
	
//Create Farm element
	FTable = new Array;
	ТипРеквизита = Новый ОписаниеТипов("ТаблицаЗначений");
	РексизитТЗ = Новый РеквизитФормы ("Таблица", ТипРеквизита, "","Таблица");
	FTable.Add(РексизитТЗ);
//	add column
	TV = новый ValueTable;
	for columns= 1 to ColumnN Do
	  	nameCl = LIST.GetArea("R"+1+"C"+columns).CurrentArea.Text;	
		colStr ="column" +columns;
		tp = TV.Columns.Add(colStr, New TypeDescription("string"));
	  	tp.Title=nameCl;
	EndDo;
	For Each TableColums In TV.Columns Do
		NewAtr = new FormAttribute(TableColums.Name,TableColums.ValueType ,"Таблица");
		FTable.Add(NewAtr);
	EndDo;
//add Element
	ChangeAttributes(FTable);

// Add table to Form
	ElementTable = Items.Insert("Таблица", Type("ТаблицаФормы"));
	ElementTable.Representation = TableRepresentation.List;
	ElementTable.CommandBar.Visible=0;
	ElementTable.DataPath = "Таблица";
// Add Column to Form
	For Each ClnTbl In TV.Columns Do
		ItemsColumnsTab = Items.Add(ClnTbl.Name,Type("FormField"),ElementTable);
		ItemsColumnsTab.Title= ClnTbl.Title;
		ItemsColumnsTab.DataPath = "Таблица."+ ClnTbl.Name;		
	EndDo;
//fill to table
for StringT=2 To 	NString Do
		stl = ThisObject.Таблица.add(); 
		for Each CillT In TV.Columns Do
			n = TV.Columns.IndexOf(CillT)+1;
			stl[CillT.Name] =LIST.GetArea("R"+StringT+"C"+n).CurrentArea.Text;
		EndDo;
EndDo;
	
КонецПроцедуры


&AtServer
Procedure delete ()
	if Items.Find("Таблица") <> Неопределено  Then
		DelAtr = New Array;
		DelAtr.Add("Таблица");
		ChangeAttributes (,DelAtr);
	EndIf;
EndProcedure


&НаКлиенте
процедура ПутьКФайлуНачалоВыбора (Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = False;
	Проводник = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Проводник.Заголовок = "ну и что там загружать?";
	Проводник.Фильтр = "Табличка(*.xls;*.xlsx)|*.xls;*.xlsx|все (*)|*";
	Проводник.FilterIndex=0;
	Проводник.Preview=false; 
	Оповещение = Новый ОписаниеОповещения("ПослеВыбора", ThisObject); 
	Проводник.Multiselect=false;
	Проводник.Показать(Оповещение);
КонецПроцедуры


&НаКлиенте
Процедура ПослеВыбора (ВыбранныеФайлы,ДополнительныеПораметны) экспорт
	Если ВыбранныеФайлы = неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ПутьКФайлу = выбранныефайлы [0];
	ПеречеслениеЛистовAtServer();
	Объект.Листы=Элементы.Листы.СписокВыбора[0];
	read_XLSWWW();
КонецПроцедуры

&AtClient
Procedure read_XLSWWW()
		если Объект.ПутьКФайлу = "" тогда
		сообщить ("Нихуя нет пути");
	иначе
		if Items.Find("Таблица") <> Undefined  Then
			delete();
			Прочитать_XLS();
		Else
			Прочитать_XLS();
		EndIf;
	КонецЕсли;	
EndProcedure

&AtClient
Procedure ЛистыOnChange (Item)
	read_XLSWWW();
EndProcedure


&AtClient
Procedure Запись(Command)
	delete();
EndProcedure

