﻿;   Description: Some String Functions
;            OS: Windows, Linux, Mac
;        Author: Heribert Füchtenhans
;       Version: 3.0
; -----------------------------------------------------------------------------

; MIT License
; 
; Copyright (c) 2018 Heribert Füchtenhans
; 
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
; 
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
; 
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.



DeclareModule HF_String
  ; String functions
  
  Declare.b fnmatch(text.s, pattern.s, ignoreCase.b=#True)
  ; Test if a filename or other string matches a pattern that contains * and/or ?
  
  Declare   splitString(List StringParts.s(), ToSplit.s, Delimiter.s, MaxSplits.i=-1, WithSpaceTrim.b=#True)
  ; Splits a string using Delimter into parts an stores them in StringParts()
  
EndDeclareModule



Module HF_String
  
  EnableExplicit

  ;---------- String Routinen.
  ; Attention, if you use fnmatch you have to display the License unter getRegExLicense somewhre in your help system
  ; see regex function in PureBasic help
  
  Procedure.b fnmatch(text.s, pattern.s, ignoreCase.b=#True)
    Protected *text.Character
    Protected *pattern.Character
    Protected *match.Character
    Protected *current.Character=#Null
    
    If ignoreCase
      text = LCase(text)
      pattern = LCase(pattern)
    EndIf
    *text = @text
    *pattern = @pattern
    While *text\c <> #Null
      Select *pattern\c
        Case '*'
          *pattern + SizeOf(Character)
          If *pattern\c = #Null 
            ProcedureReturn #True
          EndIf
          *match = *pattern
          *current = *text + SizeOf(Character)
        Case '?', *text\c
          *text + SizeOf(Character)
          *pattern + SizeOf(Character)
        Default
          If *current = #Null
            ProcedureReturn #False
          Else
            *pattern = *match
            *text = *current
            *current + SizeOf(Character)
          EndIf
      EndSelect
    Wend
    While *pattern\c = '*'
      *pattern + SizeOf(Character)
    Wend
    If *pattern\c = #Null
      ProcedureReturn #True
    EndIf
    ProcedureReturn #False
  EndProcedure
  
  
  Procedure splitString(List StringParts.s(), ToSplit.s, Delimiter.s, MaxSplits.i=-1, WithSpaceTrim.b=#True)
    Protected count.i, StartPos.i, Pos.i, Part.s, Ende.b=#False
    
    ClearList(StringParts())
    count = 0
    StartPos = 1
    If MaxSplits < 1 : MaxSplits = 2147483646 : EndIf
    While Not Ende
      count + 1
      Pos = FindString(ToSplit, Delimiter, StartPos)
      If Pos = 0 Or count >= MaxSplits
        ; Add the remainig string and end the loop
        Part = Mid(ToSplit, StartPos)
        Ende = #True
      Else
        ; atatch the part and caclulacte the next start position
        Part = Mid(ToSplit, StartPos, Pos-StartPos)
        StartPos = Pos + Len(Delimiter)
      EndIf
      If WithSpaceTrim : Part = Trim(Part) : EndIf
      AddElement(StringParts()) : StringParts() = Part
    Wend
  EndProcedure
  
EndModule

; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 32
; Folding = -
; EnableXP