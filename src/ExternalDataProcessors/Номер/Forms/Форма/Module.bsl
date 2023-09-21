
&AtClient
Procedure OnOpen(Cancel)
	Объект.Date =ТекущаяДата();
EndProcedure



&AtServer
Процедура СоздатьДокументПриходаНаСервере()

	NewElement = Документы.AddRoom.СоздатьДокумент();
	
	NewElement.Date = Объект.Date;
	NewElement.RoomNumber = Объект.Number;
	NewElement.SortCode = Объект.Sort;
	NewElement.RoomType = Объект.TypeN;
	NewElement.Hotel=SessionParameters.CurrentHotel;
	
	NumberOfBed = catalogs.RoomTypes.Select();
		While NumberOfBed.Next() do
			if NumberOfBed.Description=NewElement.RoomType.Description Then
				NewElement.NumberOfBedsPerRoom=NumberOfBed.NumberOfBedsPerRoom;	
				NewElement.NumberOfPersonsPerRoom=NumberOfBed.NumberOfPersonsPerRoom;
			Else 
				Continue;	
			EndIf;
		EndDo;
	
	NewElement.Write(DocumentWriteMode.Posting);
	                   
КонецПроцедуры





&наСервере
Процедура промежуточнаяИнфорамцияНаСервере()
	
КонецПроцедуры


&НаКлиенте
Процедура ПромежуточнаяИнфа(Команда)
	промежуточнаяИнфорамцияНаСервере();	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьНомер(Команда)
	СоздатьДокументПриходаНаСервере();
	 
КонецПроцедуры


&AtClient
Procedure AddType(Command)
	AddTypeAtServer();
	
EndProcedure

&AtServer
Procedure AddTypeAtServer()
	RTNew = Catalogs.RoomTypes.CreateItem();
	RTNew.Code = Объект.RTCode;
	RTNew.SortCode = Объект.RTSort;
	RTNew.Description = Объект.RTDescroption;
	RTNew.NumberOfBedsPerRoom = Объект.RTMNOPIR;
	RTNew.NumberOfPersonsPerRoom = Объект.RTNOMBITR;
	RTNew.Owner =SessionParameters.CurrentHotel;
	RTNew.Write();
EndProcedure
