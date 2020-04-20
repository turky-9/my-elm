npm install elm --saveDev

そしたらコケた

-- ERROR -----------------------------------------------------------------------

Something went wrong while fetching the following URL:

https://github.com/elm/compiler/releases/download/0.19.1/binary-for-windows-64-bit.gz

It is saying:

Error: read ECONNRESET

NOTE: You can avoid npm entirely by downloading directly from:
https://github.com/elm/compiler/releases/download/0.19.1/binary-for-windows-64-bit.gz
All this package does is download that file and put it somewhere.

--------------------------------------------------------------------------------

言われた通りダウンロードした
解凍すると拡張子がないファイルだった。


linuxのfileコマンドで調べるとPEだったのでウィンルススキャンした
問題なかったので「elm.exe」にrenameした

replの実行に以下が必要だった
set HTTP_PROXY=http://nmoc%5C8010973:CatsVer312@10.111.1.200:8080/
set HTTPS_PROXY=http://nmoc%5C8010973:CatsVer312@10.111.1.200:8080/
