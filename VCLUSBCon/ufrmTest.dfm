object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 433
  ClientWidth = 622
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 15
  object Memo1: TMemo
    Left = 8
    Top = 232
    Width = 606
    Height = 185
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object VCLUSBCon1: TVCLUSBCon
    OnUsbDeviceArrival = VCLUSBCon1UsbDeviceArrival
    OnUsbDeviceRemove = VCLUSBCon1UsbDeviceRemove
    Left = 48
    Top = 48
  end
end
