
    uses Classes, SysUtils, Windows;

    .
    .

    procedure UpdateIcon(ExeFileNameAndPath, IcoFileNameAndPath: string);

    var   i,j: integer;
          vResHandle: THandle;
          Icon: TMemoryStream;
          ImageCount: Word;
          ImageSize: DWord;
          Header, Image: TMemoryStream;

    const HeaderSize = 6;
          IcoEntrySize = 16;
          ResEntrySize = 14;

        begin
        vResHandle := BeginUpdateResource(PChar(ExeFileNameAndPath), False);
        // Load the icon data.
        Icon := TMemoryStream.Create;
        Icon.LoadFromFile(IcoFileNameAndPath);
        // Get the number of images in the icon from the header of the .ico file.
        Icon.Seek(4,soFromBeginning);
        ImageCount:=Icon.ReadWord;
        Icon.Seek(0,soFromBeginning);

        // We split the .ico file into the main header and the rest.
        // The header in the .exe file has a slightly different format
        // from the header in the .ico file so we convert as we go.
        Header := TMemoryStream.Create;
        for j:=1 to HeaderSize do Header.WriteByte(Icon.ReadByte);
            for i:=1 to ImageCount do
                begin
                for j:=1 to IcoEntrySize - 4 do Header.WriteByte(Icon.ReadByte);
                Icon.ReadDWord;  // To skip over it.
                Header.WriteWord(i);
                end;
        // We yeet the reformatted header into the .exe file.
        UpdateResource(vResHandle
                      , RT_GROUP_ICON
                      , PChar('MAINICON')
                      , LANG_NEUTRAL
                      , Header.Memory
                      , Header.Size);

        for i := 1 to ImageCount do
            begin
            // We get the information about the image from the header.
            Image := TMemoryStream.Create;
            Header.Seek(HeaderSize+(i-1)*ResEntrySize+8,soFromBeginning);
            ImageSize:=Header.ReadDWord;
            // Pull the image into Image.
            for j:=1 to ImageSize do Image.WriteByte(Icon.ReadByte);
            // And then yeet it into the .exe file.
            UpdateResource(vResHandle
                          , RT_ICON
                          , MAKEINTRESOURCE(i)
                          , LANG_NEUTRAL
                          , Image.Memory
                          , Image.Size);
            Image.Free;
            end;

        Icon.Free;
        Header.Free;
        EndUpDateResource(vResHandle,False);
        end;         