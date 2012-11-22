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

' 初期化
Private Sub Class_Initialize()
    isUseArray = False
End Sub

' 配列か
Public Property Get IsArray() As Boolean
    IsArray = isUseArray
End Property

' 要素を取得（既定プロパティ）
Public Property Get item(key) As Variant
Attribute item.VB_UserMemId = 0
    If m_Dictionary Is Nothing And isUseArray And IsNumeric(key) Then
        If LBound(m_Array) <= key And key <= UBound(m_Array) Then
            ' 配列の場合
            If IsObject(m_Array(key)) Then
                Set item = m_Array(key)
            Else
                item = m_Array(key)
            End If
            Exit Property
        End If
    End If
    If Not m_Dictionary Is Nothing Then
        ' ハッシュ
        If m_Dictionary.Exists(key) Then
            If IsObject(m_Dictionary(key)) Then
                Set item = m_Dictionary(key)
            Else
                item = m_Dictionary(key)
            End If
            Exit Property
        End If
    End If
    ' 見つからない場合
    item = Nothing
End Property

' 要素を設定（既定プロパティ）
'  key 要素番号
'  Value 追加する値（代入式の右辺）
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
            ' 初めて配列として利用する場合
            ReDim m_Array(0)
            isUseArray = True
        End If
        If LBound(m_Array) <= key Then
            ' 配列の場合
            If UBound(m_Array) < key Then
                ' 拡張あり
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
        ' 配列をハッシュ化
        Set m_Dictionary = CreateObject("Scripting.Dictionary")
        If isUseArray Then
            ' 配列として利用していた場合
            Dim i As Integer
            For i = LBound(m_Array) To UBound(m_Array)
                m_Dictionary(i) = m_Array(i)
            Next
            ' 解放
            ReDim m_Array(0)
            isUseArray = False
        End If
    End If
    
    ' ハッシュ設定
    If IsObject(value) Then
        Set m_Dictionary(key) = value
    Else
        m_Dictionary(key) = value
    End If
End Sub


' 要素数を取得
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

' 値のコレクションを取得
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

' キーのコレクションを取得
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

' 特定位置の要素を削除
Public Function RemoveKey(key) As Boolean
    If m_Dictionary Is Nothing And IsNumeric(key) Then
        If Not isUserArray Then
            RemoveKey = False
            Exit Function
        End If
        If LBound(m_Array) <= key And key <= UBound(m_Array) Then
            ' 配列の場合
            Delete key
            RemoveKey = True
            Exit Function
        End If
    End If
    If Not m_Dictionary Is Nothing Then
        ' ハッシュ
        If m_Dictionary.Exists(key) Then
            m_Dictionary.Remove (key)
            RemoveKey = True
            Exit Function
        End If
    End If
    RemoveKey = False
End Function

' キーが含まれているかチェック
Public Function ContainsKey(key) As Boolean
    If m_Dictionary Is Nothing And IsNumeric(key) Then
        If Not isUseArray Then
            ContainsKey = False
            Exit Function
        End If
        If LBound(m_Array) <= key And key <= UBound(m_Array) Then
            ' 配列の場合
            ContainsKey = True
            Exit Function
        End If
    End If
    If Not m_Dictionary Is Nothing Then
        ' ハッシュ
        If m_Dictionary.Exists(key) Then
            ContainsKey = True
            Exit Function
        End If
    End If
    ContainsKey = False
End Function

' 配列として末尾に追加
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

' 配列として末尾を削除
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

' 配列として先頭に追加
Public Sub Unshift(value)
    If isUseArray Then
        Insert LBound(m_Array), value
    Else
        ReDim m_Array(0)
        item(LBound(m_Array)) = value
    End If
End Sub

' 配列として先頭を削除
Public Function Shift()
    If isUseArray Then
        Shift = m_Array(LBound(m_Array))
        Delete LBound(m_Array)
    Else
        Err.Raise 5
    End If
End Function

' 要素の削除
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

' 要素の追加
Public Sub Insert(start As Integer, ParamArray values() As Variant)
    If isUseArray Then
        Dim count As Integer
        count = UBound(values) - LBound(values) + 1
        
        ' 拡張してコピー
        Dim i As Integer
        For i = UBound(m_Array) To start Step -1
            item(i + count) = item(i)
        Next
    End If
    
    ' 追加の値を設定
    Dim insertIndex As Integer
    insertIndex = start
    For i = LBound(values) To UBound(values)
        item(insertIndex) = values(i)
        insertIndex = insertIndex + 1
    Next
End Sub

' 末尾に追加
Public Sub Concat(concatJson As Json)
    If m_Dictionary Is Nothing And concatJson.IsArray Then
        ' 配列の場合は末尾に追加
        Dim i As Integer
        For i = LBound(concatJson.Items) To UBound(concatJson.Items)
            Push concatJson(i)
        Next
    Else
        ' ハッシュの場合は上書き
        Dim key
        For Each key In concatJson.Keys
            item(key) = concatJson(key)
        Next
    End If
End Sub

' JSON文字列トークンに変換
Public Function ToJsonToken() As Json
    Dim outBuffer As New Json
    If isUseArray Then
        ' 配列の場合
        outBuffer.Push "["
        Dim i As Integer
        For i = LBound(m_Array) To UBound(m_Array)
            ' データをトークンに変換
            outBuffer.Concat objectToJsonToken(m_Array(i))
            outBuffer.Push ","
        Next
        ' 最後のカンマを削除
        outBuffer.Pop
        outBuffer.Push "]"
    ElseIf Not m_Dictionary Is Nothing Then
        ' ハッシュの場合
        outBuffer.Push "{"
        Dim key
        For Each key In Keys
            outBuffer.Push escapeString(CStr(key), True)
            outBuffer.Push ":"
            ' Itemをトークンに変換
            outBuffer.Concat objectToJsonToken(item(key))
            outBuffer.Push ","
        Next
        ' 最後のカンマを削除
        outBuffer.Pop
        outBuffer.Push "}"
    Else
        ' データがない場合
        outBuffer.Push "~"
    End If
    
    Set ToJsonToken = outBuffer
End Function

' dataをJSON文字列トークンに変換
Private Function objectToJsonToken(data) As Json
    Dim outBuffer As New Json
    Dim childJson As Json
    On Error Resume Next
    Set childJson = data
    On Error GoTo 0
    If Not childJson Is Nothing Then
        ' ネストしている場合は再帰
        outBuffer.Concat childJson.ToJsonToken
    ElseIf VarType(data) = vbString Then
        ' 文字列の場合はエスケープ
        outBuffer.Push escapeString(CStr(data))
    Else
        ' その他数値は文字列化
        outBuffer.Push CStr(data)
    End If
    
    Set objectToJsonToken = outBuffer
End Function

' 反転
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

' ファイル書き込み
Public Sub SaveFile(fileName As String)
    ' トークンに変換
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
            ' 改行
            Print #fileNo, ""
            ' インデント
            indentLevel = indentLevel - 1
            Print #fileNo, String(indentLevel * DEFAULT_INDENT, " ");
        End If
        
        Print #fileNo, token;
        
        If token = "{" Or token = "[" Then
            ' 改行
            Print #fileNo, ""
            ' インデント
            indentLevel = indentLevel + 1
            Print #fileNo, String(indentLevel * DEFAULT_INDENT, " ");
        ElseIf token = "," Then
            ' 改行
            Print #fileNo, ""
            ' インデント
            Print #fileNo, String(indentLevel * DEFAULT_INDENT, " ");
        End If
    Next
    Close #fileNo

End Sub

' 文字列出力用変換
Public Function escapeString(data As String, Optional key As Boolean = False) As String
    Dim regExp
    Set regExp = CreateObject("VBScript.RegExp")
    
    If key Then
        ' キーの場合
        regExp.Pattern = "^[A-Za-z_][A-Za-z0-9_]*$"
        regExp.IgnoreCase = True
        If regExp.test(data) Then
            escapeString = data
            Exit Function
        End If
    End If
    
    ' シングルクオートチェック
    regExp.Pattern = "'"
    If Not regExp.test(data) Then
        escapeString = "'" + data + "'"
        Exit Function
    End If
    
    ' ダブルクオートチェック
    regExp.Pattern = """"
    If Not regExp.test(data) Then
        escapeString = """" + data + """"
        Exit Function
    End If
    
    ' どちらも存在する場合はエスケープ
    escapeString = """" + regExp.Replace(data, "\""") + """"
End Function
