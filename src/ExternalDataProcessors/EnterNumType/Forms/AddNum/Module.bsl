
&AtClient
Procedure PathToFileStartChoice(Item, ChoiceData, StandardProcessing)
	Explorer = new FileDialog(FileDialogMode.Open);
	notifi = new NotifyDescription("AfterSelectFile",ThisObject);
	Explorer.Show(notifi);
EndProcedure

&AtClient
Procedure AfterSelectFile(SelectedFile,additionaParameter) Export
	If SelectedFile=Undefined Then
		Return;
	EndIf;
	Object.PathToFile=SelectedFile[0];
//	workFL();
EndProcedure

//reading TabB
&AtServer
Function ReadTB ()
	tableDoc = new SpreadsheetDocument;
		Try
			tableDoc.Read(Object.PathToFile,SpreadsheetDocumentValuesReadingMode.Value);
		Except
			messedj=new UserMessage();
			messedj.Text="NOOOO "+ErrorDescription();
		EndTry;
EndFunction

&AtClient
Procedure Command1(Command)

	ИзменитьФорму();

EndProcedure

&НаСервере
Процедура ИзменитьФорму()
        
    НовыйЭлемент1 = Элементы.Добавить("НоваяСтраница",Тип("ГруппаФормы"),Элементы.ГруппаСтраницы);
    НовыйЭлемент1.Вид = ВидГруппыФормы.Страница;
    НовыйЭлемент1.Заголовок = "НоваяСтраница";
        
    НовыйЭлемент2 = Элементы.Добавить("НоваяНадпись",Тип("ДекорацияФормы"),НовыйЭлемент1);
    НовыйЭлемент2.Заголовок = "НоваяНадпись";
    
КонецПроцедуры

