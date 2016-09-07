Return-Path: <subratndash@gmail.com>
MIME-Version: 1.0
From: subrat dash <subratndash@gmail.com>
Date: Wed, 7 Sep 2016 16:24:14 -0700
Message-ID: <CAFrY4nSUSOVDc=WmFGSANVGR0heSnUH5osDQkAPCG3euqz54Lg@mail.gmail.com>
Subject: Need help with issuing time based commands
Content-Type: multipart/alternative; boundary=94eb2c08a4fe23820a053bf3362b
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

--94eb2c08a4fe23820a053bf3362b
Content-Type: text/plain; charset=UTF-8

Hello,

I am trying to do this in FIO:

Queued Random 16K block transerfers Write/(read) commands ( 5 min)
Idle for 3 seconds
Queued  32k block transfers Write/(read) commands ( 5 min)
Queued sync command
Idle for 2 Seconds
Queued  128K Write/read commands ( 10 Min)
Idle for a 5 seconds
Queued  1 meg file size Write/(read) commands ( 5 min)
Queued sync command
Idle for 5 seconds
Queued Seq Reads OD ( 10 Min)
Idle for 4 seconds
Queued Seq Reads ID (5 Min)
Idle for 3 seconds
Queued Seq Reads MD ( 5min)
Idle for 3 seconds

Keep repeating until test is stopped.

Can someone tell me how to implement this in FIO? I am fairly new and hence
not sure how to run this. How can we issue time based commands in FIO?

Thanks,
Dash

--94eb2c08a4fe23820a053bf3362b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hello,<br><br></div>I am trying to do this in FIO:<br=
><br><div style=3D"color:rgb(34,34,34);font-family:arial,sans-serif;font-si=
ze:12.8px;font-style:normal;font-variant-ligatures:normal;font-variant-caps=
:normal;font-weight:normal;letter-spacing:normal;line-height:normal;text-al=
ign:start;text-indent:0px;text-transform:none;white-space:normal;word-spaci=
ng:0px;background-color:rgb(255,255,255)">Queued Random 16K block transerfe=
rs Write/(read) commands ( 5 min)</div><div style=3D"color:rgb(34,34,34);fo=
nt-family:arial,sans-serif;font-size:12.8px;font-style:normal;font-variant-=
ligatures:normal;font-variant-caps:normal;font-weight:normal;letter-spacing=
:normal;line-height:normal;text-align:start;text-indent:0px;text-transform:=
none;white-space:normal;word-spacing:0px;background-color:rgb(255,255,255)"=
>Idle for 3 seconds</div><div style=3D"color:rgb(34,34,34);font-family:aria=
l,sans-serif;font-size:12.8px;font-style:normal;font-variant-ligatures:norm=
al;font-variant-caps:normal;font-weight:normal;letter-spacing:normal;line-h=
eight:normal;text-align:start;text-indent:0px;text-transform:none;white-spa=
ce:normal;word-spacing:0px;background-color:rgb(255,255,255)"><span style=
=3D"font-size:12.8px">Queued =C2=A032k block transfers Write/(read) command=
s ( 5 min)</span><br>Queued sync command</div><div style=3D"color:rgb(34,34=
,34);font-family:arial,sans-serif;font-size:12.8px;font-style:normal;font-v=
ariant-ligatures:normal;font-variant-caps:normal;font-weight:normal;letter-=
spacing:normal;line-height:normal;text-align:start;text-indent:0px;text-tra=
nsform:none;white-space:normal;word-spacing:0px;background-color:rgb(255,25=
5,255)">Idle for 2 Seconds<br>Queued =C2=A0128K Write/read commands ( 10 Mi=
n)<br>Idle for a 5 seconds</div><div style=3D"color:rgb(34,34,34);font-fami=
ly:arial,sans-serif;font-size:12.8px;font-style:normal;font-variant-ligatur=
es:normal;font-variant-caps:normal;font-weight:normal;letter-spacing:normal=
;line-height:normal;text-align:start;text-indent:0px;text-transform:none;wh=
ite-space:normal;word-spacing:0px;background-color:rgb(255,255,255)"><span =
style=3D"font-size:12.8px">Queued =C2=A01 meg file size Write/(read) comman=
ds ( 5 min)</span><br style=3D"font-size:12.8px"><span style=3D"font-size:1=
2.8px">Queued sync command</span></div><div style=3D"color:rgb(34,34,34);fo=
nt-family:arial,sans-serif;font-size:12.8px;font-style:normal;font-variant-=
ligatures:normal;font-variant-caps:normal;font-weight:normal;letter-spacing=
:normal;line-height:normal;text-align:start;text-indent:0px;text-transform:=
none;white-space:normal;word-spacing:0px;background-color:rgb(255,255,255)"=
>Idle for 5 seconds</div><div style=3D"color:rgb(34,34,34);font-family:aria=
l,sans-serif;font-size:12.8px;font-style:normal;font-variant-ligatures:norm=
al;font-variant-caps:normal;font-weight:normal;letter-spacing:normal;line-h=
eight:normal;text-align:start;text-indent:0px;text-transform:none;white-spa=
ce:normal;word-spacing:0px;background-color:rgb(255,255,255)">Queued Seq Re=
ads OD ( 10 Min)</div><div style=3D"color:rgb(34,34,34);font-family:arial,s=
ans-serif;font-size:12.8px;font-style:normal;font-variant-ligatures:normal;=
font-variant-caps:normal;font-weight:normal;letter-spacing:normal;line-heig=
ht:normal;text-align:start;text-indent:0px;text-transform:none;white-space:=
normal;word-spacing:0px;background-color:rgb(255,255,255)">Idle for 4 secon=
ds</div><div style=3D"color:rgb(34,34,34);font-family:arial,sans-serif;font=
-size:12.8px;font-style:normal;font-variant-ligatures:normal;font-variant-c=
aps:normal;font-weight:normal;letter-spacing:normal;line-height:normal;text=
-align:start;text-indent:0px;text-transform:none;white-space:normal;word-sp=
acing:0px;background-color:rgb(255,255,255)">Queued Seq Reads ID (5 Min)</d=
iv><div style=3D"color:rgb(34,34,34);font-family:arial,sans-serif;font-size=
:12.8px;font-style:normal;font-variant-ligatures:normal;font-variant-caps:n=
ormal;font-weight:normal;letter-spacing:normal;line-height:normal;text-alig=
n:start;text-indent:0px;text-transform:none;white-space:normal;word-spacing=
:0px;background-color:rgb(255,255,255)">Idle for 3 seconds</div><div style=
=3D"color:rgb(34,34,34);font-family:arial,sans-serif;font-size:12.8px;font-=
style:normal;font-variant-ligatures:normal;font-variant-caps:normal;font-we=
ight:normal;letter-spacing:normal;line-height:normal;text-align:start;text-=
indent:0px;text-transform:none;white-space:normal;word-spacing:0px;backgrou=
nd-color:rgb(255,255,255)">Queued Seq Reads MD ( 5min)</div><div style=3D"c=
olor:rgb(34,34,34);font-family:arial,sans-serif;font-size:12.8px;font-style=
:normal;font-variant-ligatures:normal;font-variant-caps:normal;font-weight:=
normal;letter-spacing:normal;line-height:normal;text-align:start;text-inden=
t:0px;text-transform:none;white-space:normal;word-spacing:0px;background-co=
lor:rgb(255,255,255)">Idle for 3 seconds</div><div style=3D"color:rgb(34,34=
,34);font-family:arial,sans-serif;font-size:12.8px;font-style:normal;font-v=
ariant-ligatures:normal;font-variant-caps:normal;font-weight:normal;letter-=
spacing:normal;line-height:normal;text-align:start;text-indent:0px;text-tra=
nsform:none;white-space:normal;word-spacing:0px;background-color:rgb(255,25=
5,255)"><br></div><div style=3D"color:rgb(34,34,34);font-family:arial,sans-=
serif;font-size:12.8px;font-style:normal;font-variant-ligatures:normal;font=
-variant-caps:normal;font-weight:normal;letter-spacing:normal;line-height:n=
ormal;text-align:start;text-indent:0px;text-transform:none;white-space:norm=
al;word-spacing:0px;background-color:rgb(255,255,255)">Keep repeating until=
 test is stopped.<br><br></div><div style=3D"color:rgb(34,34,34);font-famil=
y:arial,sans-serif;font-size:12.8px;font-style:normal;font-variant-ligature=
s:normal;font-variant-caps:normal;font-weight:normal;letter-spacing:normal;=
line-height:normal;text-align:start;text-indent:0px;text-transform:none;whi=
te-space:normal;word-spacing:0px;background-color:rgb(255,255,255)">Can som=
eone tell me how to implement this in FIO? I am fairly new and hence not su=
re how to run this. How can we issue time based commands in FIO?<br><br></d=
iv><div style=3D"color:rgb(34,34,34);font-family:arial,sans-serif;font-size=
:12.8px;font-style:normal;font-variant-ligatures:normal;font-variant-caps:n=
ormal;font-weight:normal;letter-spacing:normal;line-height:normal;text-alig=
n:start;text-indent:0px;text-transform:none;white-space:normal;word-spacing=
:0px;background-color:rgb(255,255,255)">Thanks,<br></div><div style=3D"colo=
r:rgb(34,34,34);font-family:arial,sans-serif;font-size:12.8px;font-style:no=
rmal;font-variant-ligatures:normal;font-variant-caps:normal;font-weight:nor=
mal;letter-spacing:normal;line-height:normal;text-align:start;text-indent:0=
px;text-transform:none;white-space:normal;word-spacing:0px;background-color=
:rgb(255,255,255)">Dash<br></div><br></div>

--94eb2c08a4fe23820a053bf3362b--

