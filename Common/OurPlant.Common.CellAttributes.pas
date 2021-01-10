{*******************************************************************************

                            OurPlant OS
                       Micro Cell Architecture
                             for Delphi
                            2019 / 2020

  Copyright (c) 2019-2020 Gerrit Häcker
  Copyright (c) 2019-2020 Häcker Automation GmbH

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.

  Authors History:
     Gerrit Häcker (2019 - 2020)
*******************************************************************************}

{-------------------------------------------------------------------------------
The Unit is the general part of the micro cell architecture for Delphi.

It contains:
  * the cell type register and setup attributes
  * the add sub cell attributes
  * the value setting attributes
  * the field setting attributes

Attributes will be used to provide the compiler with RTTI types at run time
automated actions and settings. They are used to make presets and structures.
The TCellObject calls as the base cell object asks the attributes in the implentation
of AfterConstruction and reacts accordingly. Thus, a more reluctant and
individual code.
-------------------------------------------------------------------------------}
unit OurPlant.Common.CellAttributes;

interface

{$REGION 'uses'}
uses
  System.SysUtils,
  OurPlant.Common.TypesAndConst;
{$ENDREGION}

type
  //TCustomAttributeClass = class of TCustomAttribute;


  {$REGION 'Language Manager Attributes'}
  {
  Beispiele / Ideen für LingueeAttribute
    [Linguee('Test')]                - Identifier = Deutsch = english
    [Linguee('Test','test')]         - Identifier = Deutsch / english
    [Linguee('TEST','Test','test')]  - Identifier / Deutsch / englich
  }

  LingueeAttribute = class(TCustomAttribute)
    Text : string;
    FullText : string;
    constructor create(const aText : string); overload;
    constructor create(const aText, aFullText : string); overload;
  end;
  {$ENDREGION}

implementation

{$REGION 'Language Manager Attributes'}
constructor LingueeAttribute.create(const aText : string);
begin
  Text := aText;
end;

constructor LingueeAttribute.create(const aText, aFullText : string);
begin
  Text := aText;
  FullText := aFullText;
end;

{$ENDREGION}


end.
