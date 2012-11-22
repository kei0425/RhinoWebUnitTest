VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Json"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
 
Private Const DEFAULT_INDENT As Integer = 4

'Private m_Dictionary As Object
Private m_Dictionary As Dictionary
Private m_Array()   As Variant
Private isUseArray  As Boolean

' ������
Private Sub Class_Initialize()
    isUseArray = False
End Sub

' �z��
Public Property Get IsArray() As Boolean
    IsArray = isUseArray
End Property

' �v�f���擾�i����v���p�e�B�j
Public Property Get item(key) As Variant
Attribute item.VB_UserMemId = 0
    If m_Dictionary Is Nothing And isUseArray And IsNumeric(key) Then
        If LBound(m_Array) <= key And key <= UBound(m_Array) Then
            ' �z��̏ꍇ
            If IsObject(m_Array(key)) Then
                Set item = m_Array(key)
            Else
                item = m_Array(key)
            End If
            Exit Property
        End If
    End If
    If Not m_Dictionary Is Nothing Then
        ' �n�b�V��
        If m_Dictionary.Exists(key) Then
            If IsObject(m_Dictionary(key)) Then
                Set item = m_Dictionary(key)
            Else
                item = m_Dictionary(key)
            End If
            Exit Property
        End If
    End If
    ' ������Ȃ��ꍇ
    item = Nothing
End Property

' �v�f��ݒ�i����v���p�e�B�j
'  key �v�f�ԍ�
'  Value �ǉ�����l�i������̉E�Ӂj
Public Property Let item(key, value)
Attribute item.VB_UserMemId = 0
    setItem key, value
End Property
Public Property Set item(key, value)
Attribute item.VB_UserMemId = 0
    setItem key, value
End Property

Private Sub setItem(key, value)
    If m_Dictionary Is Nothing And IsNumeric(key) Then
        If Not isUseArray Then
            ' ���߂Ĕz��Ƃ��ė��p����ꍇ
            ReDim m_Array(0)
            isUseArray = True
        End If
        If LBound(m_Array) <= key Then
            ' �z��̏ꍇ
            If UBound(m_Array) < key Then
                ' �g������
                ReDim Preserve m_Array(key)
            End If
            If IsObject(value) Then
                Set m_Array(key) = value
            Else
                m_Array(key) = value
            End If
            Exit Sub
        End If
    End If
        
    If m_Dictionary Is Nothing Then
        ' �z����n�b�V����
        Set m_Dictionary = CreateObject("Scripting.Dictionary")
        If isUseArray Then
            ' �z��Ƃ��ė��p���Ă����ꍇ
            Dim i As Integer
            For i = LBound(m_Array) To UBound(m_Array)
                m_Dictionary(i) = m_Array(i)
            Next
            ' ���
            ReDim m_Array(0)
            isUseArray = False
        End If
    End If
    
    ' �n�b�V���ݒ�
    If IsObject(value) Then
        Set m_Dictionary(key) = value
    Else
        m_Dictionary(key) = value
    End If
End Sub


' �v�f�����擾
Public Property Get count() As Long
    If m_Dictionary Is Nothing Then
        If isUseArray Then
            count = UBound(m_Array) - LBound(m_Array) + 1
        Else
            count = 0
        End If
    Else
        count = m_Dictionary.count
    End If
End Property

' �l�̃R���N�V�������擾
Public Property Get Items()
    If m_Dictionary Is Nothing Then
        If isUseArray Then
            Items = m_Array
        Else
            Items = New Collection
        End If
    Else
        Items = m_Dictionary.Items()
    End If
End Property

' �L�[�̃R���N�V�������擾
Public Property Get Keys()
    If m_Dictionary Is Nothing Then
        If isUseArray Then
            Dim arrayKeys As New Collection
            Dim i As Integer
            For i = LBound(m_Array) To UBound(m_Array)
                arrayKeys.Add i
            Next
            Keys = arrayKeys
        Else
            Keys = New Collection
        End If
    Else
        Keys = m_Dictionary.Keys()
    End If
End Property

' ����ʒu�̗v�f���폜
Public Function RemoveKey(key) As Boolean
    If m_Dictionary Is Nothing And IsNumeric(key) Then
        If Not isUserArray Then
            RemoveKey = False
            Exit Function
        End If
        If LBound(m_Array) <= key And key <= UBound(m_Array) Then
            ' �z��̏ꍇ
            Delete key
            RemoveKey = True
            Exit Function
        End If
    End If
    If Not m_Dictionary Is Nothing Then
        ' �n�b�V��
        If m_Dictionary.Exists(key) Then
            m_Dictionary.Remove (key)
            RemoveKey = True
            Exit Function
        End If
    End If
    RemoveKey = False
End Function

' �L�[���܂܂�Ă��邩�`�F�b�N
Public Function ContainsKey(key) As Boolean
    If m_Dictionary Is Nothing And IsNumeric(key) Then
        If Not isUseArray Then
            ContainsKey = False
            Exit Function
        End If
        If LBound(m_Array) <= key And key <= UBound(m_Array) Then
            ' �z��̏ꍇ
            ContainsKey = True
            Exit Function
        End If
    End If
    If Not m_Dictionary Is Nothing Then
        ' �n�b�V��
        If m_Dictionary.Exists(key) Then
            ContainsKey = True
            Exit Function
        End If
    End If
    ContainsKey = False
End Function

' �z��Ƃ��Ė����ɒǉ�
Public Sub Push(value)
    If m_Dictionary Is Nothing Then
        If isUseArray Then
            item(UBound(m_Array) + 1) = value
        Else
            ReDim m_Array(0)
            item(LBound(m_Array)) = value
        End If
    Else
        Err.Raise 5
    End If
End Sub

' �z��Ƃ��Ė������폜
Public Function Pop()
    If m_Dictionary Is Nothing Then
        If LBound(m_Array) <= UBound(m_Array) Then
            Pop = m_Array(UBound(m_Array))
            Delete UBound(m_Array)
            Exit Function
        End If
    End If
        
    Err.Raise 5
End Function

' �z��Ƃ��Đ擪�ɒǉ�
Public Sub Unshift(value)
    If isUseArray Then
        Insert LBound(m_Array), value
    Else
        ReDim m_Array(0)
        item(LBound(m_Array)) = value
    End If
End Sub

' �z��Ƃ��Đ擪���폜
Public Function Shift()
    If isUseArray Then
        Shift = m_Array(LBound(m_Array))
        Delete LBound(m_Array)
    Else
        Err.Raise 5
    End If
End Function

' �v�f�̍폜
Public Sub Delete(start As Integer, Optional count As Integer = 1)
    If Not isUseArray Then
        Err.Raise 5
    End If
    If start + count < UBound(m_Array) Then
        Dim i As Integer
        For i = start To UBound(m_Array) - count
            item(i) = item(i + count)
        Next
    End If
    ReDim Preserve m_Array(UBound(m_Array) - count)
End Sub

' �v�f�̒ǉ�
Public Sub Insert(start As Integer, ParamArray values() As Variant)
    If isUseArray Then
        Dim count As Integer
        count = UBound(values) - LBound(values) + 1
        
        ' �g�����ăR�s�[
        Dim i As Integer
        For i = UBound(m_Array) To start Step -1
            item(i + count) = item(i)
        Next
    End If
    
    ' �ǉ��̒l��ݒ�
    Dim insertIndex As Integer
    insertIndex = start
    For i = LBound(values) To UBound(values)
        item(insertIndex) = values(i)
        insertIndex = insertIndex + 1
    Next
End Sub

' �����ɒǉ�
Public Sub Concat(concatJson As Json)
    If m_Dictionary Is Nothing And concatJson.IsArray Then
        ' �z��̏ꍇ�͖����ɒǉ�
        Dim i As Integer
        For i = LBound(concatJson.Items) To UBound(concatJson.Items)
            Push concatJson(i)
        Next
    Else
        ' �n�b�V���̏ꍇ�͏㏑��
        Dim key
        For Each key In concatJson.Keys
            item(key) = concatJson(key)
        Next
    End If
End Sub

' JSON������g�[�N���ɕϊ�
Public Function ToJsonToken() As Json
    Dim outBuffer As New Json
    If isUseArray Then
        ' �z��̏ꍇ
        outBuffer.Push "["
        Dim i As Integer
        For i = LBound(m_Array) To UBound(m_Array)
            ' �f�[�^���g�[�N���ɕϊ�
            outBuffer.Concat objectToJsonToken(m_Array(i))
            outBuffer.Push ","
        Next
        ' �Ō�̃J���}���폜
        outBuffer.Pop
        outBuffer.Push "]"
    ElseIf Not m_Dictionary Is Nothing Then
        ' �n�b�V���̏ꍇ
        outBuffer.Push "{"
        Dim key
        For Each key In Keys
            outBuffer.Push escapeString(CStr(key), True)
            outBuffer.Push ":"
            ' Item���g�[�N���ɕϊ�
            outBuffer.Concat objectToJsonToken(item(key))
            outBuffer.Push ","
        Next
        ' �Ō�̃J���}���폜
        outBuffer.Pop
        outBuffer.Push "}"
    Else
        ' �f�[�^���Ȃ��ꍇ
        outBuffer.Push "~"
    End If
    
    Set ToJsonToken = outBuffer
End Function

' data��JSON������g�[�N���ɕϊ�
Private Function objectToJsonToken(data) As Json
    Dim outBuffer As New Json
    Dim childJson As Json
    On Error Resume Next
    Set childJson = data
    On Error GoTo 0
    If Not childJson Is Nothing Then
        ' �l�X�g���Ă���ꍇ�͍ċA
        outBuffer.Concat childJson.ToJsonToken
    ElseIf VarType(data) = vbString Then
        ' ������̏ꍇ�̓G�X�P�[�v
        outBuffer.Push escapeString(CStr(data))
    Else
        ' ���̑����l�͕�����
        outBuffer.Push CStr(data)
    End If
    
    Set objectToJsonToken = outBuffer
End Function

' ���]
Public Sub Reverse()
    Dim i As Integer
    Dim lowIndex As Integer
    Dim upIndex As Integer
    Dim temp
    For i = 0 To (UBound(m_Array) - LBound(m_Array) + 1) / 2 - 1
        lowIndex = i + LBound(m_Array)
        upIndex = UBound(m_Array) - i
        If IsObject(m_Array(lowIndex)) Then
            Set temp = m_Array(lowIndex)
        Else
            temp = m_Array(lowIndex)
        End If
        
        If IsObject(m_Array(upIndex)) Then
            Set m_Array(lowIndex) = m_Array(upIndex)
        Else
            m_Array(lowIndex) = m_Array(upIndex)
        End If
        
        If IsObject(temp) Then
            Set m_Array(upIndex) = temp
        Else
            m_Array(upIndex) = temp
        End If
    Next
End Sub

' �t�@�C����������
Public Sub SaveFile(fileName As String)
    ' �g�[�N���ɕϊ�
    Dim jsonToken As Json
    Set jsonToken = ToJsonToken
    
    Dim fileNo As Integer
    fileNo = FreeFile
    
    Open fileName For Output As #fileNo
    Dim indentLevel As Integer
    indentLevel = 0
    Dim token As Variant
    For Each token In jsonToken.Items
        If token = "}" Or token = "]" Then
            ' ���s
            Print #fileNo, ""
            ' �C���f���g
            indentLevel = indentLevel - 1
            Print #fileNo, String(indentLevel * DEFAULT_INDENT, " ");
        End If
        
        Print #fileNo, token;
        
        If token = "{" Or token = "[" Then
            ' ���s
            Print #fileNo, ""
            ' �C���f���g
            indentLevel = indentLevel + 1
            Print #fileNo, String(indentLevel * DEFAULT_INDENT, " ");
        ElseIf token = "," Then
            ' ���s
            Print #fileNo, ""
            ' �C���f���g
            Print #fileNo, String(indentLevel * DEFAULT_INDENT, " ");
        End If
    Next
    Close #fileNo

End Sub

' ������o�͗p�ϊ�
Public Function escapeString(data As String, Optional key As Boolean = False) As String
    Dim regExp
    Set regExp = CreateObject("VBScript.RegExp")
    
    If key Then
        ' �L�[�̏ꍇ
        regExp.Pattern = "^[A-Za-z_][A-Za-z0-9_]*$"
        regExp.IgnoreCase = True
        If regExp.test(data) Then
            escapeString = data
            Exit Function
        End If
    End If
    
    ' �V���O���N�I�[�g�`�F�b�N
    regExp.Pattern = "'"
    If Not regExp.test(data) Then
        escapeString = "'" + data + "'"
        Exit Function
    End If
    
    ' �_�u���N�I�[�g�`�F�b�N
    regExp.Pattern = """"
    If Not regExp.test(data) Then
        escapeString = """" + data + """"
        Exit Function
    End If
    
    ' �ǂ�������݂���ꍇ�̓G�X�P�[�v
    escapeString = """" + regExp.Replace(data, "\""") + """"
End Function