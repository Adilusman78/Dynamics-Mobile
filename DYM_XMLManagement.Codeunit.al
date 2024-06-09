codeunit 84004 DYM_XMLManagement
{
    trigger OnRun()
    begin
    end;
    var ConstMgt: Codeunit DYM_ConstManagement;
    procedure CreateRootXML(var RootNode: XmlNode; var XMLDoc: XmlDocument; PullType: enum DYM_PullType)
    var
        RootElement: XmlElement;
    begin
        XMLDoc:=XmlDocument.Create();
        XmlDocument.ReadFrom((ConstMgt.SYN_PullInit + '<' + ConstMgt.SYN_PrimaryTag + '/>'), XMLDoc);
        XMLDoc.GetRoot(RootElement);
        RootNode:=RootElement.AsXmlNode();
    end;
    procedure GetRootNode(var PacketDoc: XmlDocument; var RootNode: XmlNode)
    var
        RootElement: XmlElement;
    begin
        PacketDoc.GetRoot(RootElement);
        RootNode:=RootElement.AsXmlNode();
    end;
    procedure GetNodeValue(_Node: XmlNode; _NodeName: Text[250]; Nested: Boolean)Result: Text[250]var
        ResultNode: XmlNode;
    begin
        Clear(Result);
        case Nested of true: begin
            _Node.SelectSingleNode(_NodeName, ResultNode);
            if ResultNode.IsXmlElement then exit(ResultNode.AsXmlElement().InnerText);
        end;
        false: begin
            _Node.SelectSingleNode('@' + _NodeName, ResultNode);
            if ResultNode.IsXmlAttribute then exit(ResultNode.AsXmlAttribute().Value);
        end;
        end;
    end;
    procedure TryGetNodeValue(Node: XmlNode; Name: Text; Nested: Boolean)Result: Text[250]var
        _NodeList: XmlNodeList;
        _ResultNode: XmlNode;
    begin
        Clear(Result);
        if node.AsXmlElement().IsEmpty then exit;
        if not Nested then Name:='@' + Name;
        Node.SelectNodes(Name, _NodeList);
        if(_NodeList.Count() > 0)then Node.SelectSingleNode(Name, _ResultNode);
        if not _ResultNode.AsXmlElement().IsEmpty then exit(_ResultNode.AsXmlElement().InnerText());
    end;
    procedure AddElementNS(var Node: XmlNode; NamespacePrefix: Text; NamespaceURI: Text; NodeName: Text; Value: Text; var CreatedXMLNode: XmlNode)
    var
        NodeDocument: XmlDocument;
        NewChildNode: XmlNode;
        NewChildElement: XmlElement;
    begin
        case(value = '')of true: NewChildNode:=XmlElement.Create(NodeName, NamespaceURI).AsXmlNode();
        false: NewChildNode:=XmlElement.Create(NodeName, NamespaceURI, Value).AsXmlNode();
        end;
        if((NamespacePrefix <> '') AND (NamespaceURI <> ''))then begin
            NewChildNode.AsXmlElement().Add(XmlAttribute.CreateNamespaceDeclaration(NamespacePrefix, NamespaceURI));
        end;
        node.AsXmlElement().Add(NewChildNode);
        CreatedXMLNode:=NewChildNode;
    end;
    procedure AddElement(var Node: XmlNode; NodeName: Text; Value: Text; var CreatedXMLNode: XmlNode)
    var
        NodeDocument: XmlDocument;
        NewChildNode: XmlNode;
        NewChildElement: XmlElement;
    begin
        case(value = '')of true: NewChildNode:=XmlElement.Create(NodeName, '').AsXmlNode();
        false: NewChildNode:=XmlElement.Create(NodeName, '', Value).AsXmlNode();
        end;
        node.AsXmlElement().Add(NewChildNode);
        CreatedXMLNode:=NewChildNode;
    end;
    procedure AddAttribute(var Node: XmlNode; Name: Text[250]; NodeValue: Text[250])
    begin
        if(NodeValue <> '')then begin
            Node.AsXmlElement().SetAttribute(Name, NodeValue);
        end;
    end;
    procedure AddAttributeE(var Node: XmlNode; Name: Text[250]; NodeValue: Text[250])
    begin
        Node.AsXmlElement().SetAttribute(Name, NodeValue);
    end;
    procedure AddBinary(var Node: XmlNode; Name: Text[250]; var BlobData: InStream; var CreatedNode: XmlNode)Status: Integer var
        Base64Convert: Codeunit "Base64 Convert";
    begin
        AddElement(Node, Name, Base64Convert.ToBase64(BlobData), CreatedNode);
    end;
    procedure GetBinary(ParentNode: XmlNode; Name: Text[250]; var BlobData: Codeunit "Temp Blob")Result: Text;
    var
        Node: XmlNode;
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        StreamMgt: Codeunit DYM_StreamManagement;
        OutS: OutStream;
        ContentText: Text;
        DelimiterPos: Integer;
        BlobLength: Integer;
    begin
        ParentNode.SelectSingleNode(Name, Node);
        ContentText:=node.AsXmlElement().InnerText;
        DelimiterPos:=STRPOS(ContentText, ',');
        IF(DelimiterPos > 0)THEN BEGIN
            Result:=COPYSTR(ContentText, 1, DelimiterPos - 1);
            ContentText:=COPYSTR(ContentText, DelimiterPos + 1, STRLEN(ContentText) - DelimiterPos);
        END;
        case(ContentText = '')of true: begin
            Clear(BlobData);
        end;
        false: begin
            BlobData.CreateOutStream(OutS, TextEncoding::UTF8);
            Base64Convert.FromBase64(ContentText, OutS);
        end;
        end;
    end;
    procedure GetXPathFilter("Filter": Text[250]; Value: Text[250]): Text[250]begin
        exit('[@' + Filter + '="' + Value + '"]');
    end;
    procedure GetXPathMissingFilter("Filter": Text[250]): Text[250]begin
        exit('[not(@' + Filter + ')]');
    end;
}
