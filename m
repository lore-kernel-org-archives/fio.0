Return-Path: <Martin.Steigerwald@proact.de>
From: Martin Steigerwald <Martin.Steigerwald@proact.de>
Subject: Fwd: Bug#929579: fio FTCBFS: builds for the build architecture
Date: Mon, 27 May 2019 08:06:59 +0000
Message-ID: <2555177.PyF0XoxEVR@merkaba>
Content-Language: en-US
Content-Type: multipart/mixed; boundary="_002_2555177PyF0XoxEVRmerkaba_"
MIME-Version: 1.0
Return-Path: Martin.Steigerwald@proact.de
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Helmut Grohne <helmut@subdivi.de>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.

--_002_2555177PyF0XoxEVRmerkaba_
Content-Type: multipart/related;
	boundary="----_=_NextPart_33d9de0a-d0c3-4a98-b4a7-04a0d923e67a"

------_=_NextPart_33d9de0a-d0c3-4a98-b4a7-04a0d923e67a
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_63c21a2b-4e62-46c8-9af5-dec6d7d5dfe0"

------_=_NextPart_63c21a2b-4e62-46c8-9af5-dec6d7d5dfe0
Content-Type: text/plain;
	charset=utf-8
Content-ID: <44F02810A6CB6B4EB6CB7A67CD6908CE@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable

Hi Jens, hi Helmut.=0A=0AJens, would the cross-build fixes contained in the=
 attached debdiff =0A(fio-3.12/debian/patches/cross.patch)  be something yo=
u would consider =0Aapplying upstream?=0A=0AI bet it could help other distr=
ibutions with cross-building capabilities =0Aas well.=0A=0AThank you,=0AMar=
tin=0A=0A----------  Weitergeleitete Nachricht  ----------=0A=0ABetreff: Bu=
g#929579: fio FTCBFS: builds for the build architecture=0ADatum: Sonntag, 2=
6. Mai 2019, 17:12:15 CEST=0AVon: Helmut Grohne <helmut@subdivi.de>=0AAn: D=
ebian Bug Tracking System <submit@bugs.debian.org>=0A=0ASource: fio=0AVersi=
on: 3.12-2=0ATags: patch=0AUser: helmutg@debian.org=0AUsertags: rebootstrap=
=0A=0Afio fails to cross build from source, because it configures for the=
=0Abuild architecture. fio's configure is very different from autotools and=
=0Arequires the user to export a variable called CROSS_COMPILE. Even then,=
=0Ait uses the wrong pkg-config and runs compiled executables. The attached=
=0Apatch makes fio cross buildable. Please consider applying it.=0A=0AHelmu=
t=0A=0A-------------------------------------------------------------
Mit freundlichen Gr=C3=BC=C3=9Fen / With kind regards
Martin Steigerwald =E2=80=A2 
Proact Deutschland GmbH
Trainer
Telefon: +49 911 30999 0 =E2=80=A2 
Fax: +49 911 30999 99
S=C3=BCdwestpark 43 =E2=80=A2 
90449 N=C3=BCrnberg =E2=80=A2 
Germany
Martin.Steigerwald@proact.de =E2=80=A2 
www.proact.de
Amtsgericht N=C3=BCrnberg
 =E2=80=A2 
HRB 18320
Gesch=C3=A4ftsf=C3=BChrer: 
Oliver K=C3=BCgow =E2=80=A2 
Richard M=C3=BCller =E2=80=A2 
Jakob H=C3=B8holdt
 =E2=80=A2 
Peter Mikael Javestad
=E2=80=93 Delivering Business Agility =E2=80=93

------_=_NextPart_63c21a2b-4e62-46c8-9af5-dec6d7d5dfe0
Content-Type: text/html;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html; charset=
=3Dutf-8" /></head><body><div>Hi Jens, hi Helmut.=0A=0AJens, would the cros=
s-build fixes contained in the attached debdiff =0A(fio-3.12/debian/patches=
/cross.patch)  be something you would consider =0Aapplying upstream?=0A=0AI=
 bet it could help other distributions with cross-building capabilities =
=0Aas well.=0A=0AThank you,=0AMartin=0A=0A----------  Weitergeleitete Nachr=
icht  ----------=0A=0ABetreff: Bug#929579: fio FTCBFS: builds for the build=
 architecture=0ADatum: Sonntag, 26. Mai 2019, 17:12:15 CEST=0AVon: Helmut G=
rohne &lt;helmut@subdivi.de&gt;=0AAn: Debian Bug Tracking System &lt;submit=
@bugs.debian.org&gt;=0A=0ASource: fio=0AVersion: 3.12-2=0ATags: patch=0AUse=
r: helmutg@debian.org=0AUsertags: rebootstrap=0A=0Afio fails to cross build=
 from source, because it configures for the=0Abuild architecture. fio&#39;s=
 configure is very different from autotools and=0Arequires the user to expo=
rt a variable called CROSS_COMPILE. Even then,=0Ait uses the wrong pkg-conf=
ig and runs compiled executables. The attached=0Apatch makes fio cross buil=
dable. Please consider applying it.=0A=0AHelmut=0A=0A----------------------=
---------------------------------------</div><div style=3D"mso-line-height-=
rule:exactly;-webkit-text-size-adjust:100%;"><table cellpadding=3D"0" cells=
pacing=3D"0" border=3D"0" style=3D"width:100%;"><tr style=3D"font-size:0;">=
<td align=3D"left" style=3D"vertical-align:top;"><table cellpadding=3D"0" c=
ellspacing=3D"0" border=3D"0" style=3D"font-size:0;"><tr style=3D"font-size=
:0;"><td align=3D"left" style=3D"padding:15px 0 0;vertical-align:top;"><tab=
le cellpadding=3D"0" cellspacing=3D"0" border=3D"0" style=3D"font-size:0;">=
<tr style=3D"font-size:0;"><td align=3D"left" style=3D"vertical-align:top;"=
><table cellpadding=3D"0" cellspacing=3D"0" border=3D"0" style=3D"font-size=
:0;color:#7D7D7D;font-style:normal;font-weight:400;white-space:nowrap;"><tr=
 style=3D"font-size:13.33px;"><td align=3D"left" style=3D"padding:0 0 15px;=
vertical-align:top;font-family:Arial;">Mit&nbsp;freundlichen&nbsp;Gr&#252;&=
#223;en&nbsp;/&nbsp;With&nbsp;kind&nbsp;regards<span style=3D"font-family:r=
emialcxesans;font-size:1px;color:#FFFFFF;line-height:1px;">&#8203;</span><b=
r /></td></tr></table></td></tr><tr style=3D"font-size:0;"><td align=3D"lef=
t" style=3D"vertical-align:top;"><table cellpadding=3D"0" cellspacing=3D"0"=
 border=3D"0" style=3D"height:1px;font-size:0;"><tr style=3D"font-size:0;">=
<td align=3D"left" style=3D"vertical-align:top;"><table cellpadding=3D"0" c=
ellspacing=3D"0" border=3D"0" style=3D"font-size:0;color:#7D7D7D;font-style=
:normal;font-weight:700;white-space:nowrap;"><tr style=3D"font-size:13.33px=
;"><td align=3D"left" style=3D"vertical-align:top;font-family:Arial;">Marti=
n&nbsp;Steigerwald</td><td align=3D"left" style=3D"vertical-align:top;font-=
family:Arial;font-weight:400;">&nbsp;=E2=80=A2&nbsp;<br /></td><td align=
=3D"left" style=3D"vertical-align:top;font-family:Arial;">Proact&nbsp;Deuts=
chland&nbsp;GmbH<br /></td></tr></table></td></tr><tr style=3D"font-size:0;=
"><td align=3D"left" style=3D"vertical-align:top;"><table cellpadding=3D"0"=
 cellspacing=3D"0" border=3D"0" style=3D"font-size:0;"><tr style=3D"font-si=
ze:0;"><td align=3D"left" style=3D"vertical-align:top;"><table cellpadding=
=3D"0" cellspacing=3D"0" border=3D"0" style=3D"font-size:0;color:#7D7D7D;fo=
nt-style:normal;font-weight:700;white-space:nowrap;"><tr style=3D"font-size=
:11px;"><td align=3D"left" style=3D"padding:0 0 10px;vertical-align:top;fon=
t-family:Arial;">Trainer</td></tr></table></td></tr></table></td></tr></tab=
le></td></tr></table></td></tr><tr style=3D"font-size:0;"><td align=3D"left=
" style=3D"padding:9px 0 0;vertical-align:top;"><table cellpadding=3D"0" ce=
llspacing=3D"0" border=3D"0" style=3D"font-size:0;"><tr style=3D"font-size:=
0;"><td align=3D"left" style=3D"vertical-align:top;"><table cellpadding=3D"=
0" cellspacing=3D"0" border=3D"0" style=3D"font-size:0;"><tr style=3D"font-=
size:0;"><td align=3D"left" style=3D"padding:0 0 2px;vertical-align:top;"><=
table cellpadding=3D"0" cellspacing=3D"0" border=3D"0" style=3D"font-size:0=
;color:#7D7D7D;font-style:normal;font-weight:400;white-space:nowrap;"><tr s=
tyle=3D"font-size:10.67px;"><td align=3D"left" style=3D"vertical-align:top;=
font-family:Arial;">Telefon:&nbsp;<a href=3D"tel:+49%20911%2030999%200" tar=
get=3D"_blank" id=3D"LPlnk689713" style=3D"text-decoration:none;color:#7D7D=
7D;"><strong style=3D"font-weight:400;">+49&nbsp;911&nbsp;30999&nbsp;0</str=
ong></a></td><td align=3D"left" style=3D"vertical-align:top;font-family:Ari=
al;">&nbsp;=E2=80=A2&nbsp;<br /></td><td align=3D"left" style=3D"vertical-a=
lign:top;font-family:Arial;">Fax:&nbsp;<a href=3D"tel:" target=3D"_blank" i=
d=3D"LPlnk689713" style=3D"text-decoration:none;color:#7D7D7D;"><strong sty=
le=3D"font-weight:400;">+49&nbsp;911&nbsp;30999&nbsp;99</strong></a></td></=
tr></table></td></tr></table></td></tr><tr style=3D"font-size:0;"><td align=
=3D"left" style=3D"vertical-align:top;"><table cellpadding=3D"0" cellspacin=
g=3D"0" border=3D"0" style=3D"font-size:0;"><tr style=3D"font-size:0;"><td =
align=3D"left" style=3D"padding:0 0 2px;vertical-align:top;"><table cellpad=
ding=3D"0" cellspacing=3D"0" border=3D"0" style=3D"font-size:0;color:#7D7D7=
D;font-style:normal;font-weight:400;white-space:nowrap;"><tr style=3D"font-=
size:10.67px;"><td align=3D"left" style=3D"vertical-align:top;font-family:A=
rial;">S&#252;dwestpark&nbsp;43</td><td align=3D"left" style=3D"vertical-al=
ign:top;font-family:Arial;">&nbsp;=E2=80=A2&nbsp;<br /></td><td align=3D"le=
ft" style=3D"vertical-align:top;font-family:Arial;">90449&nbsp;</td><td ali=
gn=3D"left" style=3D"vertical-align:top;font-family:Arial;">N&#252;rnberg</=
td><td align=3D"left" style=3D"vertical-align:top;font-family:Arial;">&nbsp=
;=E2=80=A2&nbsp;<br /></td><td align=3D"left" style=3D"vertical-align:top;f=
ont-family:Arial;">Germany</td></tr></table></td></tr></table></td></tr><tr=
 style=3D"font-size:0;"><td align=3D"left" style=3D"vertical-align:top;"><t=
able cellpadding=3D"0" cellspacing=3D"0" border=3D"0" style=3D"font-size:0;=
"><tr style=3D"font-size:0;"><td align=3D"left" style=3D"padding:0 0 2px;ve=
rtical-align:top;"><table cellpadding=3D"0" cellspacing=3D"0" border=3D"0" =
style=3D"font-size:0;color:#7D7D7D;font-style:normal;font-weight:400;white-=
space:nowrap;"><tr style=3D"font-size:10.67px;"><td align=3D"left" style=
=3D"vertical-align:top;font-family:Arial;"><a href=3D"mailto:Martin.Steiger=
wald@proact.de" target=3D"_blank" id=3D"LPlnk689713" style=3D"text-decorati=
on:none;color:#7D7D7D;"><strong style=3D"font-weight:400;">Martin.Steigerwa=
ld@proact.de</strong></a></td><td align=3D"left" style=3D"vertical-align:to=
p;font-family:Arial;">&nbsp;=E2=80=A2&nbsp;<br /></td><td align=3D"left" st=
yle=3D"vertical-align:top;font-family:Arial;"><a href=3D"https://www.proact=
=2Ede/" target=3D"_blank" id=3D"LPlnk689713" style=3D"text-decoration:none;=
color:#7D7D7D;"><strong style=3D"font-weight:400;">www.proact.de</strong></=
a></td></tr></table></td></tr></table></td></tr></table></td></tr><tr style=
=3D"font-size:0;"><td style=3D"padding:9px 0 0;">&nbsp;</td></tr><tr style=
=3D"font-size:0;"><td align=3D"left" style=3D"padding:0;vertical-align:top;=
"><table cellpadding=3D"0" cellspacing=3D"0" border=3D"0" style=3D"font-siz=
e:0;"><tr style=3D"font-size:0;"><td align=3D"left" style=3D"vertical-align=
:top;"><table cellpadding=3D"0" cellspacing=3D"0" border=3D"0" style=3D"fon=
t-size:0;"><tr style=3D"font-size:0;"><td align=3D"left" style=3D"padding:0=
 0 2px;vertical-align:top;"><table cellpadding=3D"0" cellspacing=3D"0" bord=
er=3D"0" style=3D"font-size:0;color:#C8C8C8;font-style:normal;font-weight:4=
00;white-space:nowrap;"><tr style=3D"font-size:10.67px;"><td align=3D"left"=
 style=3D"vertical-align:top;font-family:Arial;">Amtsgericht&nbsp;N&#252;rn=
berg<br /></td><td align=3D"left" style=3D"vertical-align:top;font-family:A=
rial;">&nbsp;=E2=80=A2&nbsp;<br /></td><td align=3D"left" style=3D"vertical=
-align:top;font-family:Arial;">HRB&nbsp;18320<br /></td></tr></table></td><=
/tr></table></td></tr><tr style=3D"font-size:0;"><td align=3D"left" style=
=3D"vertical-align:top;"><table cellpadding=3D"0" cellspacing=3D"0" border=
=3D"0" style=3D"font-size:0;color:#C8C8C8;font-style:normal;font-weight:400=
;white-space:nowrap;"><tr style=3D"font-size:10.67px;"><td align=3D"left" s=
tyle=3D"vertical-align:top;font-family:Arial;">Gesch&#228;ftsf&#252;hrer:&n=
bsp;<br /></td><td align=3D"left" style=3D"vertical-align:top;font-family:A=
rial;">Oliver&nbsp;K&#252;gow</td><td align=3D"left" style=3D"vertical-alig=
n:top;font-family:Arial;">&nbsp;=E2=80=A2&nbsp;<br /></td><td align=3D"left=
" style=3D"vertical-align:top;font-family:Arial;">Richard&nbsp;M&#252;ller<=
/td><td align=3D"left" style=3D"vertical-align:top;font-family:Arial;">&nbs=
p;=E2=80=A2&nbsp;<br /></td><td align=3D"left" style=3D"vertical-align:top;=
font-family:Arial;">Jakob&nbsp;H&#248;holdt<br /></td><td align=3D"left" st=
yle=3D"vertical-align:top;font-family:Arial;">&nbsp;=E2=80=A2&nbsp;<br /></=
td><td align=3D"left" style=3D"vertical-align:top;font-family:Arial;">Peter=
&nbsp;Mikael&nbsp;Javestad<br /></td></tr></table></td></tr></table></td></=
tr><tr style=3D"font-size:0;"><td style=3D"padding:0;">&nbsp;</td></tr><tr =
style=3D"font-size:0;"><td align=3D"left" style=3D"padding:0;vertical-align=
:top;"><table cellpadding=3D"0" cellspacing=3D"0" border=3D"0" style=3D"fon=
t-size:0;color:#7D7D7D;font-style:normal;font-weight:700;white-space:nowrap=
;"><tr style=3D"font-size:13.33px;"><td align=3D"left" style=3D"padding:20p=
x 0;vertical-align:top;font-family:Arial;">=E2=80=93&nbsp;Delivering&nbsp;B=
usiness&nbsp;Agility&nbsp;=E2=80=93<br /></td></tr></table></td></tr><tr st=
yle=3D"font-size:0;line-height:normal;"><td align=3D"left" style=3D"padding=
:0;vertical-align:top;"><a href=3D"https://go.proact.eu/Proact-Wissenstage-=
Anmeldung" target=3D"_blank" id=3D"LPlnk689713" style=3D"text-decoration:no=
ne;"><img src=3D"cid:image157690.png@50773EAD.DFC0DE67" border=3D"0" title=
=3D"Proact Wissenstag" alt=3D"Proact Wissenstag" style=3D"font-size:12px;" =
/></a></td></tr></table></td></tr></table></div></body></html>
------_=_NextPart_63c21a2b-4e62-46c8-9af5-dec6d7d5dfe0--

------_=_NextPart_33d9de0a-d0c3-4a98-b4a7-04a0d923e67a
Content-Type: image/png;
	name="image157690.png"
Content-Transfer-Encoding: base64
Content-ID: <image157690.png@50773EAD.DFC0DE67>
Content-Description: image157690.png
Content-Disposition: inline;
	creation-date="Mon, 27 May 2019 08:07:03 +0000";
	filename=image157690.png;
	modification-date="Mon, 27 May 2019 08:07:03 +0000";
	size=58737

iVBORw0KGgoAAAANSUhEUgAAAiYAAABZCAIAAACFR3gsAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJ
bWFnZVJlYWR5ccllPAAA5RNJREFUeNrMfQeAZFWZ7jnn3qoO09PdExhghgnkNDNgQnCIq6KS0dUl
h6f7BHVXeSu6LGJYRRBdXRTFsE+Q7O4qGRQlDwqIEoYkizDTE2AGmOncXVX3nvP+cP5zz62qHtAV
95W9s031rVvnnvDH7/9+/f6uLbRS8OPoX0X/GqXh31Rr+CXBd+AXlWj8PVW6Qu/zpzKlJp0ddtmw
zTfaxrDLR10+7uyEsw1na8rBv1b9cS8tI4lfboor6V/d9A7+gu/6QcqP5r8a/Cs+EfxnonSHNtN0
0meS2brSb9Jubbp1As+YOWdoEmD8m2w24fK6cjULD5sPumyjzWBIW5nKtmnXrmkXfMTQ3WhOHHwW
Lq47lysHk2a0TmVojh7FyGDgZWWEjsYGvyYa57mKv/gPwuBpOfAreC3gDqlfFF3BB1LwdTg2HJjr
0yk8V7htQzmrXO4c/A5DnW0q8Jh4B40jgUHiZTTF8FtVmSGb1ZXt0ckELqKdrhMYJDwyfNF0k+T0
dA3npuFX6Iay/Phw8XP55JjL4c1ODaMyFRw/r4Z/wUjW5bWf1TY9VB+BQW+fdJ7UveWuaffDjdFL
xl/ciPNsO7WpOQsfGXE5Pq9WMGDYVHBnmI06PQgsGUwIXOZoSmGocDFMe0KPY2hCrHM8CXDPafQI
GpaGrofBw9i6YKGVhkmDG1a1hmtmmnSWqcA9YfJ7TGJk7zVoKeEONBVu0rkRl70Ee9ypTc6PGcbW
pc0sk76lMv3NlelzkgoMG4bEkw9fDtPP25JnGj6rNZ8vv3P85qeFTmkLJ/QuLxydIxyDxT0E48Gd
ZmmzwVfUHH8L3gHmCmYGhgrjgRmoFmuBPzQzxUnhCcTb+n9xZOE/48PIY3D0jQkuMZwUk2rj6Fks
zS0MqUvBl+IXGe0PIO92/mw4yEb5Myhj4Ps7nm1+NH5SJRvVlCeKTwGvEcxGnXYI7MDvjb0A/2o8
2nqntOuEri13SDq7TZKIELA0ezmtqRYBEiYBzhEPgMfgnJeNVW0SEggJSkUdRq4jAYUPG0keQ0fY
yDGMJpz/6h/H8MBkouP1hXUEAZvRtFQVPS9NhYomM6X3w81zkrq4FvgUtk6bh4ehaG7hRMOugCMD
KwWbvEMZo0vCk0eY076q42G3InnwkoyOD7zZIAkJt+oUUcMaASUniRHSFDhakWyKNnakZmKJL0KN
PqPx+xR/K4ngMDael9zx7i/2DS+qdc6pP+XlylpnM/pmyjvQGWdh56K7tt5WltzrA95qicOVq+Ev
OANwdOEAwwIMq2w0x7mu4eOydoE9ASfQJiQgOkQBKL/PtBywoF00z4+WsfGMaf+LZq0Et8j48Gve
mrCQsCh4h1QmKCMpBp+E/0od6sg6KvscdgkMeppK+KjntG9ALE4qUEeoJzrw2KBO4nGR7CsmGQbT
kN1sZaIyeiPVWkVzxUI81f5BcCeQuJd9hhtDy17nfQXHZktTXZJOe7wxBt8C8r2XhDjcaoNtVGnN
6jS38FeYdphbizsbD3lGD1sRHQmvCmniCTJrrPOjivQ3isU6aRdD8wBzXnc534239wRtWxDKcGWv
SeAcwkKD7plh0vlJRw8t+qjNYVbhyl6ySOBKuNWYtRtdA/70im081BiFd+Dj2yadR3bOAk0Dc7uF
qdiw90iI8K6wNJOyEXkOcbyJtyq0WHV+Dh2ZLCJfNMsUi4/gUvpPnr1coyYguY+rMOnUGOljEqOG
doqfNe1i9Ubf7QppgxJZ49VG5KQrnxeL2kV54UvjdPQEpM/UuM0b2qX8RLhjdaRRXGTXoq5VZXmt
RNJlYh4pkdrB8DWynRKvsYLox30ImrVXp1sl1T/kkzS32jqeLpz2oALpVqyeSeLTPehKNqlVpr1U
hc0Dv3vlQY/M8j3WlLZJPjmUAzoSLLosYF3xjjKRpgkvkLewIg6Pkn9MR4c0p7nU9D8ePNuvuZga
rDJzp0RE0+7SpUmGrZU7+HGTJGwMjlZXnI4lgBPpN+nySceHGlWIIYlq6R0WCGgTex3srSXYAzWa
tzrKOUMSw+no2VNTFvEm0kAJ62GvpTVb65HV44J28eaAGCkqPLz6E1VOGJJrpyE2r3oKu4MtS6XV
FG6TjkSh9gocZhbFa4KHXIHlmDsLiwQiydDCKBGs/BH4BYzrl2x9gizKTpyhhP0S9kJ4QgypGacK
mVgcYHk/F+EE+zUngWLFQMjpUwnrBtyNmiVsQruEbCIQE97UBYdslFyTHo1a0JEbCoMcIWMcHg1E
4ZZJtdfvMBfZu97NIpVjU7GkeGb4kY0ftt9Gcnh462sSed5m9xJBF8rJkDKG4wS6cLdK94xaBYa0
Q9oFwh3tdFIbYEj2aj1uLQ+A9g9+0Ti5zuyKwVpMkkJC2eRcv07ZMlVigfJEZiSz4FPsmtdJprOh
wBIf9AqfVVY/oEgqaJ6beahp0GUBj2cauRlzTGWShpf6Q2vAsOhM8DiBTwmSfffKtKez8R2Srm3T
TlBU7F440S5hrV3ZejKR2wr3ZKdWLBWc8IzMfCufC556kDWavoICEigRlPbGAditncaMksrJaPrh
/3BzooRxJqyOwlFquqnx9/O7At6iO3sNV+xV5zeJ3wxhN8sIEwoPZHQHdlES3K6uHMDQpjh0Lpx0
9thY39hSuMLLnxCcCNGXIK9h/PwmbI9er87w3rQ3LBvEzfar1+siB0hc8m5nqyvFv4JB6QUjRxR8
gEf7w+PKUi4SKYVeD5GYIsoSrtFTCDJaKi1yRpNaFy9W8/cZ7WKnJHYWvUpDkeW9Bd4JTja8Fu2O
9ijaGCZ1xWA0LTwY0yNobNkcbTJDE+Kv4GXSLHy0/y4jOxMNR/bOccOQeaQLKysNLk80F5rcGjwG
STnOFnlejr4YpSF/fV0iD1bcHTuFd/JHaZ2p1Isu+zPypnYtWsdqF97XLcpMntebEn4N8LjhbIyj
krcgKPtUWhExweqki2JKoCdgVdaoOhi/M3UK0hMsgU6MWalgPSmxs+Tbg7z2ooQ3QnB0YLyGQh9W
85rxbvVhmYSsDEvuDjmRmhUPHDkQ06Mue8VmoAKHHIhLHMUkCetBCljBMoFInWkq0fnXbcxYxWas
13ZJSd97z5HFSThCzru8Tov9y/dJXGThSBAAju5Wurog6Vhv9W5pN8zkqqwGw+7XySQFuDiMANtt
AnY73R8G7+MDaEPxROGzo+Pv5RRut2kaTahBDCrwMin2UEfQU8IrNQ0gJZ+GZ4DlRYXcL54f1peg
eDIaDC9iB1nQuTcgUDWmpEFBf2+t9VsqPc/ntdkm7dNpkM6ZLKhTEhYjIR6EV0WzVafJPNdsl3DU
An+UDaeUQ7WpRFlhGOSc4UhI9cJRxaXha1jl94C+VOz3eDeXdpAlHzQ8JtswJa3jfDDAax0lBpMt
HT2NL5HOutAZfifjTqDbWLL6TOQcF+FuiQUExellPZ3B4rTSBiLH35Tv0CSv8bkMO6/yFx5PnUwT
cFYq9HQ6CueEEHesKvw1+Egg9uEmGNUI+ibEoIKUy4PnqvykkHPftPFjv6fZs9HF4XKxr0OS29HS
aDahHMY8gnVQGoz3AfzBRPWZyhR7rwXDrRj85CVT5DaxctWoF0zimse2yWVDNoPd0sGhAucnh5+l
QnaVC1pHFS5vkGkhHqsV+81FkKaYnkSzvVBEmU3k5od5JDGKBwPWY5I0IRue6NY5Vm5/tqiablEY
m/04P6c20TvWT4cLQla3GCbipaKYz1SeoV+JSakJsBS89sCYD4hy8BcbLmHfDgTZK7Yxqk1NW9AE
icPz2eXtLKe9j1IEo5z3HdBXzZ0KUik2UtiTzUnr+DgnBTpgya3/oCMnQDe0q6L3irKYFsLBLnnB
Nja5vBMlBQrrMedNlR6dLEw6d0g7wQzv8NsVhY6l3cCyieNXPFNsdXYao6I4NT9MHp8NckdYMqYU
tqmIZLSqFMzlCC1HfpdWpr1sq1uaChyS3zVGV2RjcNkrtr5VUoWzkYi+YVsnp4BAnU6+pUEmpCGq
+Kbls9pF/uU4ycZEtilbZ8r/rlnxo9PjXLCvu9DDMLCO08idesHWZurKNknHLFORQCIuAnxjlXxf
3t51FIbomkzXaY9JdtJdZD+yDGLzINg2HBbzKrmbwugdpLS0P5w4khoa1HacYvdWzicHJydcHkKd
NbpmyGVw2VamOt0k47S4Yxbez3tNOkOnvSbppJhGSqe4QvuEZATqOSXhuEKCOxVZDzr4vpz1kYg0
xalIKhoKo8XHJ3Pejs5IRZCK0nwbtjzYAktCQKksdDl8ApenGAjNrSQ1dSGwfO5LwraqWWqLXQlv
j5JDbEUWw8TS7DlXNmQjb8kL2sIoZGNOOYriGothc2WCwvBz5XwazFESgbO2xQmlnFnsRbU8uC5p
Ha3K/quTE2cwTO5Y6ydoWZJ9oCRGqkNElM0ox5G9EN/mjdjwJ1RNukwMSnxI0MQJm7DOdqGt7AOa
ZN7hUV3ncPYadOi0HJ+EznhCY7TiWcXhIuefvUgrhNRdGuf3JMrpo8nifaukSHeHyKw33DJKRtUo
YpM59jFd/t/2bzavhFqDb03ul3g4OmTFQ4TNX0wyIfZz6QELqwGmeIxcHNJA6MqkBica/gTypY/m
jeOh8Ce2uxtke8JH6JzbphRf0PkYudL4WSWugA+wFxEGPrQUZPNmRZSTokAtB/fZDLMUg6piLh11
JPwQgiNPJSoyQScQJCO4FG+s9GybdHaTdObvjS0DJ8ZELiowEYURwzqMl0lekTgJ7E56o5iGRzoy
XjXZcGiEgqTeuzJ9ZV4DQ2nQZesJeALKZiCvNXyOHVW1puQk3cdhBgWTVQ4DcWz+kQOaSWIMHBGa
fBwYqJAGZdfISnAs7zJJ6rBt1G2SBh0z+CJY6+kqGYXvtAr0AfyyyWYzTQrinv0hy4efM5paNxyL
AMdxJJj5Xp0ME9iBUwiSBVMc/1EeBYD/Dya/h7APfFFD+SAB2zfwb91PPhpzL9vGqry23tbBf5qb
VGFd1uQ1+NRsU9loG89lk10UxAMzqN9gDqOXclHwpqMoa0OWklP9HRT75THXlcf1sPnJwSI+JMaH
TJ3IQlrOoD4luciOJhsrlu6Wy1U5+RiUQVKMgIiBSLHTEwfMMZtFCbw0ErvWBwK0K4SX0u3C6Xzx
iIO1a8QZRzaIXYuICELQlPRNmAF0zhLyIK3SYnx7n15cPUe5kMJLC0MVIandZvWNLtvxrUEdIzH2
kLZIJFTCH+IBhFhZKtstuArah+nAp0GvJCyTRdPBjTsfBaorfzALv0SrXspronjXuEUt2ZQgalLU
qiqh/JkrS/uglvKyEgiKJg36hs0Kb9bpYnMkksVxgh5hMe5IHWZkR+fK6/ncRyrcf0fl6HaBtc0i
1pr8m2ZVVb6hWHBe62iJ9vhMgJEMP/kHKKwrlAmAjdtDh3mawjQAhSZgnRyoHJALPL9sPtfRhXfx
WbLR2KzYYrkL4TUvyDjozplMTb6uC+KAhp373emRPGyJ5BgA4biII1wNZ9pxUdh4BPG0XdK5fdo1
L6nOBbtYp2hPaJ89shR7kcVFeWJLULoi8saBBSehHp/Fldh9LpAKo7yllOjCgY6TvZy6APk4SdP7
+2xiVT4JAnRGkoJkHEfAmz+iObluLLPqYn6NMYxNJKONcpA5aiZE2SHagkabuULm5hRQQh8CI2aG
UQlj5FJ0UtBM04JutFlXYja6Ro9N5pmq4zghTRCIaY/7QoeJ8ZzsN+CDUTQcr/QHx6mAT0vpuIKv
zKg28tVg/m1DItI53hw9p1wiB/ADmvjBxvAfskkY865pN/guYzZ/Ma83KPrEk9+pNbit/bSmLHEs
adA6yWpLsRHYonNp6TG1q10H5VfAOeY9aYNwdM3hhEQFm827whESRJNlaQmq4jF4RaSsvC5xIl2V
c4dNxzmheFsi6ZxgfrELlUQaq+llfVrCjZJPH/8p7AHrnISaSkDWNoKFlo1tnTjvEi5mK4dFf0Jq
OHdFQkXgLbqdH9PGsylPQoCKhIS6D2DyPuFpIz2H4Y0OUig6uizEHpMobQMD6nAGNMeI0xNgjTkf
ABxXOWl6xJ2OWvCSk0TGCTfsUAYsPFDhidejBQZYgoouhOJjLKJTAt8qWZw4hwVizfmQWhFVMyKC
PYJAstYhgQw2YS5qho+BFRfHRbf98750OyjBVF/nfDxd82+u3ccTAY92UJwkpQgcxbUxjEYLaCqE
36g61wcWpUG7skchkBpET8O4LWwF3J1xBOniHNbJ0enUheBWEZ4qL5IfKkRdePnFLXC20DT+1FFS
yuf2abEtu0l0nNA8SPHA625jZti0DwwT1EMYSAHJvkvSvXulG8zkqiZ5J2BH56NqKkT/ZK8U25eD
A847Cqw+URdS6M9IWhJfiIz38QfcaiwBVRGb9TvVOn/IQAdskVT+K5t8PBsDKx4kL2gdjh50kdoI
WXTyGjUfOR78JCmVTsz/o6MDo4S1C7EduHtdceDRi2ZH3hLck0QD3wd3LDlnPq9DaXZMDjHeZhwU
UwLyy/rwFK1MQg4Y249JgMzRSjUQkK1zmboq4b5CAq+BTgAqJwYrW4oNEPjVozphbJtc4yXboNwh
wprBjvlNfQTcPvj41kkVPgU+DYx8hqn0GDNLV6qEPJyhK100frDuX8hrI5S6g624lenoNwmoz3EE
cKNlGqLtHaTzEO9OHlJSxNnijItY+qxs+C9lS5L3ZI0CSiHDH1I75SwLY9uadUUTXE1TXJpTMgSi
8Qg9SzaNm8K/EX2D+7Dug/wlq7NKjjKLRS24tTju1JQkdm1CKU14bhcDf7y9Tr5vRuYFK0VKchRS
tyV/ozeTF9DlfIePWCAw2HJsCZwbMG27FGidJI1saxNAPRKELL4Ip9T0aDNoswbBlBhwAhuPPA09
iiHNSp9JY6gkXD/psfp+S9giW2k7MdSnfLRZi+Xhk4MuVuphnlNVhCZ14QCKVcLA38i6Qdnh5JxY
RtDDGjt/klECerSJ+++E0f60K90UUDeR7CVER7RdUHPAOewi6cN1BvAIHZRPxTiPsoTB8NAU+B2M
4k4Cy1YovQxHF4zlQdcYo8BI7oPaHkEvVQtFkC0vbSkXby/ZcAhMMDpCOukQOvAlHVy1wOtSEURp
t0pmICAtp+IYNVOnO6bd26edcwxKKOXt1uLxnURpi43ufDyNz4wRdzaYTk1OtJWkHQm7vBuRlB75
o2X/uaj8iC01q6mAxqn768Pr8jrKd7TH826dDNuMtDU6IhlKEsoJ0THmUg/R3JpBGZ24t8FlUTXw
fggwzal4DBw5H/Rn3JcWqItB6JrXrIaEb52icJy9Z3w2WH8b8gbI5g6HesLDXsV+D5YZAYUJ04Eb
RnOozbhiv3mrUxvro5RegE5SOI6wD5jUBWXzoq3XJIsDzw7TAh/cMe1KyDGq0racTuG1adoMWywO
AwtnSGXrbA7/OUzIySGLS9+NLpZ60YIPB7qnCmYHPONT2fiavAY3B01PZVsgTdA64XCc8UF5XQ4e
aC1ahwNQcZ7cxLjgKDLv1Y8ujHRTxvuocj5Vl7UOps1cKffJ6Qg3BaQ4mNsZqnBLNUMqTttwpQfV
G7gg5fSrpYQD0pLByiZycSKwuHNl+5V3pvYOLopXX36lXpO+aWNfOy+NK95FSKjqxTnJ7rgIdOra
QRL4uylEjzep0LoNuwze4ShcRnqaFQxonZ10F6eiCafuEjGqONVSBLQoba80h45LwDkVoT+a8AjO
z4ngWb3y1/4ohlyOEfySlmKxYLE2OIZL0YBc3Cs3pcXwumd3NntlCLMWBTrsfoIWAXsB3BeOdPPm
njAWXNG6y+pOTWr83Zv8In2dHCqMPmN8Uxmb5ZLcondQ3saIz2AlERLMH3LTUnAXwFRJyJfQJvZx
WIlhOknSWjFQYXOA+AAFM+HQCdvaIDBsBlaTJGzI68I684ZYTjl5HcJo2qPrbIH0b3YiM0Feqahq
Z5PLEGtEjrOVNIaL4EChHoVVRUJaCqz4dXltktJRoLFAFI7oPCBnPVaKtC8hNbX2k6ZC5GGS8jHk
ZOCIMPZFnsSY9aEnkuAYQEOXNELrsuPSITc0Ip4yLMTJYD+sU/XpJpmlKpaKIQISlOVgQ+anQVHQ
Kh8ZDnhGh8wyksIVxQOOgmnjVDQ9hkg8RBKChwe2Z49JpqsEdMmqfBL+cxqV6YG7A5+daVKGmcEI
Yd6ezSdgzsEgHXD5+rxOMMUGOYhYXQRPCu/kBFeddDloGviiVdkkrNEcU+3WZk5ShQecwMJhsJPy
bdPO2aYCE9VoycB55JbPURX5befFTVzMp0OhTyq+oCnpIQnI0IKqEmq0lNVniDBnxZyoIhsdhGZn
iyWgx9A2pxCMLoRSucyjvfEq0GeVe2Bxk75xAY5l2+WVQ6qbI1GFpeuCpa83q2Ui3JrzKSOOcVVQ
raqGRguY3ffU+xMFqCGuAlTNU4p7niEkE5bDDVSNRAIqpcgwGDqgluYnHR0UiKaor2KjilGaoYq2
RqdcR/Ftqwqx0DZi6T22GD/OEJpEKmYTj5bWSYRrzAWlnntIUgBZqQKl5hPh9i+vbKbye0xUplO6
g/aF/aDYO8h3IW/AEciHyu81hsvADh1VOSxJNyGgMpLyVIbpbwbXY327oTmxjqE7VNLF8QFnoxnR
kngIYzQRiIi3bBq5FLmAVUxRIu4EXe0DBWGFU/K6wBDuQt1T7SWxFT9uxtkRV6pCLWwETuo4rxvi
WitTFBgTfMUXCmh2ccZs3qH9dCQ+HmgCciwV6CSKBipaNFTJ/4Ktj3rgP56i/iQZdnC00OmsSw1B
zmBVolcwZJSxtcsAOY6ZVAn50cArEQ4wGUmDCqmcUcdl7d6bqRIYQUv0Tywqb47USCXMVhUszA6F
0xJ21kHM0TG2GE/DJ6oqVre6qVyfAlM61BLUEcueb7QIPx1ES9FRJsbAHL6Y1Tsp7rHJZnBxNwYY
6wgo0JZhfjAtQy5bm9dBzYCSADWzwTbgbnCrSapUhR1b9ZF9xdwKG0GBZbWMmCkMpiHJYdI44R0K
sQaOeCXgg90eb98Mmi9lgHVI+/my5aJURQQ6oeRNUgSv4hQJbydORgoouZ0MZkGkXSG+k1fxRXyN
oCu7OBwez11U7VpEC3BLJuUv5xhdHlUIKV2q4rRO2ZY4mGi+EmqAiy6MVu61msclrRP0BIM1qIQT
l7ZCM8GHiNPPcUQ01nwe5CZqW4l8qBQoMD9Cql0zDGmBHTXu7BzyjDNhmqhicoEz/VhGaklvSdTa
ZwesYE4kKuZiF0cXZRIe4KYFYOMZB5KIWUEVJSkuEbNXRwo/E6RgLKFep5feLPWAbqq8a1ZVBeIu
trzglHYT7U23MaxfwaCwxvW7fBi9nJxz19Y2qDQakYUZVoEgh0qHz44ozlHD0QX/fRBRrZRZ9WAf
zeGppuEl/L4A64zkaVnOKhGJAdEQG03WBemgc58K8rFQUDMZQq1QQVblyLsQXNYcIWnjhOoi++VV
nZFkj45IesjL8Xh8Kg9EYJWSEj9O+4XKPr4JiTN/1EE4Eg4Nt82GvJ7oIMSxYJ4rNKsIxLAMxg1x
XUuzZeTYeGlOBZ68BIwkzsjjqeriwSepLgeR1sqDCDjv2BGdRjp76AZ1KtVv0h3TroVJ51ZJtYNi
YhWxvZSAfY2ksrkQ1VFIrZOKG8p7zilf04oqc4zYkl6mUw16ApQHWIuL02lcPvUKpl7yGuFWUuXT
ZfiAyq23dSYmGSK+A5iBAVsbtVjhSyBp9G8qFBiBa+boji0w5ZMwlcM41bHWqSJ4wtmnsnHQVbun
3fCAoHIYdz7OnD0o16L0Q7QvQnitSHGTOeUwRqpSyW8RKBHMYQoERUH8uIbORawWvuTGAwfa1+E3
5ZnaYtW80He41g0f/fNGXhYZx1bsDFMgWukdWbXcx3492I/ihzHXgCPz2oaCnqZqpFjfWJ+4RRie
i5Bpm4Gotfo6Ut9qDDyX5ooffjSTe8yk2IIsagIexPnsO0f5nIdj4D7vIHuUOT4Icua9EwKp40NN
KguecYWyj0wAVhVgNKNEWFIRR4ONxRoDcUMYybR70lQJ9CLRRcW4jjJmQffwm1R6QngqVxgXwgHl
bByEda9XWM1tlk1gM96PyPeSF4/2lMZF7cZ0jmHSkYZGZ2WmTjfpZFyjlUSTC0uYZbkb1tkMhxYl
yMdeCsdV6cCTPKd4gjg3gU5LlxAN3qbOvez2gG0rpTyBBUAT3Q4TXUQEJD7zIjhD71VYyRxUcTxK
eGiKbKTSTQVJ4W1fSacFCxDGGoISRBzgPehMqkZYQXK+Omx9ysNjahHkJmgUZqOZiwmDtAuFMqL5
qfImmUSlwoBjAipRIpAKjAodyZkhQohhmKXmY4MeyFBH7JniugEPeXAsFLjuL+B8KHQgOzmPtKkS
vjXK4SlwOBYmHW+sTJ9psLC3InGYRCIY4Zj4giTJFaO4sXnF6JLodCqUbrBzA/rmxbwODgdoiD6T
coARHI61eVYjNZMEVap9PRRxweGv8NlxCwoJZ2AMczZYcVWTKHxVTCh4hNlU7buJFNikcwyap/JS
56uCMKoGGihDXCyBJuBB4P1ObVpdHB1pHfaqCzSSK1FJhUqXRLJubZFgeVyjFp3cxDVX44e6Yy1h
ZC1oGvG3vC8epHxgJAt38jANz8YUirELuqkQmXGib5jHT0eRQ1WmS8gDOZDEBviDKqRdJS9GUrFZ
8IaUbfilrdbhsSbO17iQcHYimdGIy6Kd6SS/LoXnLoTyjCsEdYwOb/JAfNZHvI5QuGqEqiqhpFoI
M5I9ZKIsYBALqiD0agmEpiouqdUeCCukdSV2LB3FRnkWWACGCufg4rjXL4fTDiOgXwOcOvpI8/pL
aEUx0RarHLApctYoOh1S2aiQDOYY5XDDCizNrEomABxUMIrhslkm5XIQrodoSBWI4KRdgD+acrxV
CxaI+TxCSjD4HFzI7eTMS1SasdSSIZfKbesBP7iISKomjEThFOpA+aWIxi0C4YSyeQqdeT0Zix4b
MWWFhRhXuafj00iROWIxyIahNqrpc4TZHcgnKdKowbimSHFHFV0fA7//PhuvSqFujaQzB6A4+Z9H
VDqsUBtIQWRqnitT1YXOMqZoDG8KYtUzPeWi6Y0AYTJPNYjj39pUd6t0b5d0zk4q07SBYVRos0RV
BEWUn/jZ8pyPok+ruk6H8dW0jAPOBUy/0WYjxPDmCC/ANkFKWADEDlA2lALomNnqJh+a8b51ZsTy
Jd+Y9NqIzk3OPD2G9u10+l5M5Ci9Kp98hYhoHUUj+cppRDyxc9o1x1S5Wuv5vLYGvEwqlZhl4JGT
zqRqdClZq8pl+S7USIhnUD7shYZWzcZNMJR04rOb2kVxsMwzKunWGgn5iKfD8EUwzn/KlhVYQzAg
ok4cB9aYfMyI9WYoNq4E3h3K25n3IXPNtJOq9aSIzS2gmHDCwkMJdZsO1KBtFM9m/R6Cb1COEAGr
zqtgU6KCjXSnnF9WLc4XDqmQiuO/1glkEQqSXFRMwwE0qebx9bXWh0xL5AtaSOfyyHRwYkYnOnh1
OIKYwC0NNfkhbqCjyLUUcmsXZ/kkahnQC64cQm3Pdvf6hNfca4MSBNRAQEuHO7mo7oQRsVqq1kEm
TjfJNJtQaMLTcWZUNgUiAGyHYQUuKpI3T9fpcIJ8JxkJF4ZLca5MSbLUhrIb5YL3QDPvMk945Xh1
84iKTRc6ydP5FeBjXZTLsAmDYst5OCutDqaaK8rX1hkKzprCvVGuJQWaxzkeT/fJopzJLUImibcU
aogxaxnpMGpzhjszo8yWptqJUSk3TDQ8z2QT6/M62Ph7Vnq2MNWKRqkHfmTuCoIcwb+hmCCOVDOp
rM+9ewPZCXkd1xWVorhWChiJ35o1dIlFURx/+Z12PgOItzKV3Svd4OIwm3gq5QEVxSyNRYyoThiz
DVikOQn+xCARAVABo96/2pcYPc1DEwqEYUa0qq/YxgSR8r5Mvg6HYQnpgC4LX1MjhWpIs9YwAZPl
EnAHhZFgIVHOjiN8HBwa8MYqWErlapJPBgUzRGE6IwKVv2gGEjJVYPeux/yZZ91WZBDA3WBRQOPO
YsocJ7LNn2IdcaMFcgGldROtRuGWKB3TKbUtCVTCUsplYU5FUaB2h10bcS9iwVK2NZ1r+WvQZ7ZI
qRZEk7ZMeMj5m8ypVl6cMtc+D8afohC1a+JMySOWl8Kd0lOFB5vdnTgckvikoA4U1OwPplFiKdY3
ma9Dws3OTCVKeI/Q67V5XqS2OY/g42aM0CmD113APujYQ6KYjhPbrgRb0LqpPte4AnyRqqjQibML
BcWpt1YK+GMI9DOrjRVEh5U0aRzZfF0zOm0Rlq/lI62FskpShax3OYLUwGwwBjSkl0FGaGkJyotR
lXDFKFj3GrM+PSbRopIpLI44E3ZT4govvxsihGkgYDciRG1cL+VZy3DljC49RaCI51ExAUEiJlZK
XQBA9lTBeqW9ggQ2It9TGkaqSq5YIP5zEe+AKaDV2pU5KicwgJYzMxj80keEK12eMsBfN0uBF5it
zxtrXW2Da0yQNNxkswfrw8/mEyFp30kpdKSEMYaN2UR7Hh0lc8gsA0GCBFzDdJPCf1BhgYuKgn2J
AENXOfLA/1ipQ8LIkjazdWXvau+8pDqD2Gs4AVaRAo5EBI5Feub8kcbYQ40R3ytBexYvAoy5hxuj
J3ZvuSSdVo3K95hzaJPLVuaTQ4Trg8/CrWYRZzxoiFdcNoocFhh5YxT+BCVg6N+cR9KDvOCo7erU
uAE8lRkGY4AdBKd+Pp8cJjSapuqKFMnf0knyjSpOTdPpdGrE8JKtr6LMfZdOtjSVRWknPO8g4RFA
Bb6UNOAOfUSykTkfGHfloHVMReFK8SsthJ+vgj/Wpbpyj2m0Og7It88Axdg2V9B2lMIwTIRhI9nD
MVuOOmSeNkeFMiNdQhO43FccsxOsTTms4qIwtZA/hTyTcwGSEzk7TH4T27VtYzZ6arvZOwoEiFUR
QWo0k8Gl8zXdnNnlTA96zGTBUGWP40Yzk5LFqXo+Ol0Roj+qMJUTFxGjKK9vuKNNhHjWIXsQijtL
MMUWf45oPdnuC8Z4kyeRFJLaMSwt970JXB5lcZxnveWQ4uuYyJmKe+21faRU8B+mlbcaB2eTCHXT
yZgCykVbcVwocuVDTLkcEmb3G89t1Xugqou4kRwFSXhPBmBoXAjFqRwjhXZcnWvK7J9ahbI4Djd5
91Zo8rxUzaiakhyy0LXBMZ3XbFepIAjSR59cNBUu2vMhLM4h70QXUJFQKp3ZoryZSPIt++nwbi+x
e/GmRJud+nZQ3wTQSQr+VCXDfPu0Eyb5ucb47xqjG21mo0wbZXdUL4lXS0zeKnLbO2mjNsrM9u/p
nPmejhngmoByBc/j1smNv6oPx5SaRubHRu6slbWG2QMhu7jSvZWpgltWxUXXoVpWCy9cImCe22uD
A/kkiHUwJjqMHvEhRNQN8KQPNUbn1Tq2TTp70LPUPD+TWOaJkAH0TpAJ28zQmprKGKppRfgD3GQS
S1CRJIbJlmrETWCkTtmIoTqdGjuBdlyYdMKBX5XX1uY18rMRpjhJNDOgNSfp4/A/4rnBr+BGVnCT
HtrYYEiBUw7zljo0rWBCkftV5X0EiLKRlc3J9sjXCZXCsUTGjAWXW5nXAP/17axcYIHSTc6KdiU8
cQQ7Dvj4UvWJ9SEKrKtLtNYlDJGXVxnuLuN8ZZhNyz0I4kqUpNw8ogkFFzFbMyCHqcYCkI/wNQVN
dRH4+uMLPJyUUBc87q7F4A51F5kvjkTOJFbJk2inevhrHdOu6CInWJKVMGdgB21UCTN4XgPjingj
P2wqESBThsaxrIuZwk0ZahRzkjkBSStdrJ8WJIYOFMtx0ozjKnwYuEaESaIoyeFBilZK2f9HXu41
aamiUjfw1xLXSJSyonwVAzbgkHdaYodkTkPaXqaw7Iq2SA7NQ/ZPMROQUrw4k/OTR9LdSJRMSf2N
EXbYXPvtwkfdk2bK0I34FxR/gw+aQJ8zjOxSGdjRzKTArluFMHiMAcuKGfCHJC9vXIrPWF70Bn7E
5IxIidK6uYRWyI1D0gFso4DIPWyBxXghFnCgTuBnva2PkUPA99857dqG+tCACB4kkz/RRSCCddWY
s1KZ4TmtmWeBazljB/qTPdsc2NHH9Y8wEvg6cFZ2SLuunXx5E+aMQ3MwFx9U39QHCf91r0lB08xP
OkCId9IjxOwMhsKJHLQEV+CRbBRO6RsqPTPIb+hCeh6cn4fqI6BsXiFAI4zkscbY1kl1+6STmjKg
6znGtKom6VeISpgguNo6W+czDEs2ShQ1DedTfRz/7CChwAl5Bkl3Y3Ixgd8GERU9DisO0wgrNdtU
eDCTWBCOHfbYX6wQHAYmYhh77qE1CM/bRUQMf8gmwTfqpcgeTPIe6TQYc6c8b0aOh5a8iG5uVxEE
fYyLKVAbU5U96qivSEgeB2JToU4pbJq4qNC15BFVVPFTIdR7lSoE0ohRnpJ/HtkcQ4frzEsUFblr
AUCmom/YrWfbWlhXCiS0wEkU18aZyPGygZlXMSNnIC5zSZm7vQVq69qWs7iiFLDk2FnZz8KZZIV/
QZ5OQvohy0IFZEb5zkDYhiPxLT9CVsx7SIEgLpFCK1WeKxtxAoR+dDqaVdWibwqVo4XSQ0WJnLic
OGD+8KmkBUUu8OhM7AiOxdu/hJPzx9kLqk2FQWgyqNkwaYRItJ9BtA4Qjcbt7Tz0T/sYqNhhOoJd
eK4gAdHmius2nC5PvY7I1hI6hpKCIziXYySuC0wkqmhP4vFCUTWJMxJVG3FYzwFiaG5SBUObM8mO
yl/YUs5C5Nr5yLiNCoA4XQz3AQu9IdxaNmKqCExWiVe6eoyS2OQC4oqPoabBHnHgDazF+sQGE16x
XwJiEZTNdMODUc/mk8yxFqLDuQi4CWJRC51IQnuzuA4MXvtV+/aqTL9pcuMD9ZE6nT4iWnXgtSyp
9DzdGK/RHJMaw32bOxe7/xyu7KDCt2nIhpmGBnRiymmi7UFzZC1VU87SlZkm5Y6H8P4QVs+gG5ET
GSU84FZJ5Z0dM35R2/Teztkh8cBnhBP43PYC/vQ8KOO8PtNUOFbGg+cKYkZya2LE6Cj6hvixYeMf
OnEbXCOUH8HT1axlO4BVl3d8uYGjUIUSvY3vtkfem2HyQM4bz8XVSbWnFPFRIisU4IFJJQCWuGWG
LVOh29d0+nSp54g34r1ZEBgiQohGtcsJqZYeaBXqf9pnkk5tVEsBHHc79JTnnoDYA9+pCW/R7yeu
XVURu2iJTiIKspnAj6C9WA+UB4Wy9K0UtW0JJr3W1LV0l8jK+acohEhYOw/Y89lW4wvLKE+miSbY
t2VTXDFdFXS7jQsGlGcYCgZxqKVxbagfnCtDFk0bPoISYq1gYWsFxavm7qTSX9JT3trMk3ZwlwvV
QkDw/+NLS81/gEtoIi+a9KZMEUnikC4Yp125GRXfWatSBYGOuU+ESi+45OziBM7/0H9TOB0kni1w
bStvGkkMhhhaJpaUkbyC1j5DTmTGdtjmYC/DO4uSzj0rPZwDrxGVSydFGxrO95HUQhKFBYyExRX2
JA8kbZAs82TJopOMpFUComnM8c19mBis7Bfy+kA+OZDXamRug0W/k6lQG2/bbzDXPZ1aVhtqbgaa
iU3sjLozBDS2IkBBXq7C1tJ1jV/wdEd2znosG7u/Pgxq7C2VfjDkf9sYeSWvN7Td2lR3TLtgNsYI
HDyhuMFBgew1kYSaSRWUsJk7lCd49lVQUtY+RDfBlkhpyhv+BVt/vDG2Mp98IW/A/WaSk7F92vnu
jpngNyxNp8G3h3Qu+2eMPU1pPUEZr7Y1mK4ZPn9gfQs4Cg2h1HMc9NCcFeNtQMgOlwmkfpJ0lZX0
ewfFynhLd9GmYfAVC1lG/3cSi6ATKcw+QT/mhDr3rvRuRaxI3FWFWUXI60LgJWy9ig5hoih0pnVo
Q8mxtZx4oZrgzq0Zct2UVyU1RooZ70kAjZwZWbDoXSvTzrgMtxJqJaxnZKh3VCXKEPlS54JQvV40
PVNFn7Hg6ISAhPUWtk+W6KgoWBcZI++CsRlX0fFfPdzO13q3TI6bIp0TQRh8RofcKT0VMqvheQgD
y3tgcHAmVJXRzbgdWiVy6eKwIfd7VNJ9R/oPBaYi7wBZAelFDVuLRE5cnhExflIuJziJpgyGjqO3
/PWZpHAYj0sNfyybDFL94EIN8F8skqanbBi6uY+wiOdpctHTuXKwMpHsPVXbhGKOUtLSSFO7Ytfq
Egczd8P1CVafcvS+glRBec2XCE++Cr2hHedXpSWfU74wQhUNT50AlpiPazaCthPGO3YQnClR2hX1
cX7LWsUNSIpEKx8qEyknoRMOgRRveVSpJGUyZKqk4+9G9GzsLKoL6TcJSN65puO++tArLuuiFAIT
acBm3S7tBIURtJeQbPouA/VQ5VBGH4W13tJU55jKs/WJBUnnkkr3Tmn3A/XhnDJGnWSw94K+yfJO
hK17Bh2GhAb0TkqTowTiXBeqKunu42vxx4m+yLIupCDYr+rDDzfGhkmPJkQ7BoPH/A1pU5j2wzpn
sXrOpOEYdjukhuVVbcecei6bHEIqOdwmEw6DYDXi8aMiSsJMUg1vF6VhGqT8WNA08LYIlWSzj8mK
Koq7aKdVKRvkzkCcRavTBmJPnW/OtTUVic5vQUTjM2jeMLFEPhNXt4TGoAy2TXXQHDpiCNbcYSM0
Lsl9Z6BSz3LV0oIsztMUxebOt4OilhOOy3thETukLKzcarM4yM4V/9nRRPgS8WiQk9FKJt3MymMi
yAz3KXdIHYSNMlVBfKyjY46AdIMmIGWMoiPDYKtcFweqbfTMbTa21gr5c2X4ny14m3QZG1V4C4TA
NOG7KqFDTbnkXwklJVVh+pZXTVE+VSKX09pTsalSa0pfGtSEMdapLj1t3I6aWp5IsxAraTFyulHA
EeGu1KCICZBHdFJ/+fzNa/xe3xonYuPwcHUyG3Ppu8cY2Sqy4DDhrjKRgV9kg6IKeSPUjSGaGUdI
xWm1cRxcu0LfR5qGw+ie7iWRnldJqZyzlKWA3cNAJo7bYPsy39/JDzJ3zTNmWwh0644z86hLerVn
pkgiPBtrBW48M0FFP9IHTFfxKHeAbN2TiMvqUtBOzQiQ+W0LAllRzyuU40eBj9IYW5GNpYJEyCPe
YuviPqoBqF1M41ZJlantZpl0j0oP0fWjGuulxqCL0o4JVwGbd0U2ynhxNgVSz2qM8f2KZk2DoIMt
koqO6slDzoxj3zyla/Layrz2YGMEJGCfTkCIdBPVS0LVl9OJXWaCHGVi4lEU0fLwAW73C84NTMiw
y1ZTz5sUW9I11mGuy4e2Ajl/RahjJwhilNKWbFCkvkZGXiAv6cB0IwIBerAYGRvnTNdpJxVIwfxX
rCaFp7uI+JwTkxVPmm6Y3IHdgmITUugmFHg5TyOE6MFUhHLceczHA0TrEO8iXpz4Mn+tXgOrWABA
ak+KWtQSEps7zJ5PdId2olOBFGxJKPvKGNsSlUvCgRXOGOEv9gmJuNbHUAcmJM4XqyVpSflQ1Rem
bzOtW3HhufR1DeGO1t6grsQA0oyWDp11TKnFcOmD3I3GRlozRskyutUJxS31ddTi1pfcEU3aiL3V
QA7QHPFypTuHzi+hBJhXykasK1rgUW27O3N9rolpSsUJQAuUqqXwaNUoXZxJ69zcvT7Ean/Wgp7I
n9O63HedwJSWCbvYxUEsAAkdWgNjo4k20lUokf5LocddWwC35Fp9d7XAXaGkE0kqVImSdcBtZgom
5gDrl2AXh4/p45xL4CQziLAXbR1cjS5qDZlE2TgjRzWUIodcXU5KggNKmNU3Rbsqnoq6RMDZ1xml
BDW7QdSkB9F9WyFOl2EIGIAdVzk85purPWvyOtjRfbrSTboYvgiM6+O75pw1/Lzy3OQB5Orry1Rz
872S3OJG4I50TzdBv3ZKunZJuucl1e+Nv7Bb2g2DnJNUlqqeZ/OJVyxonoxZixgvq4kPdBp1Sdhg
69u6TmpZxmfbzzOzxQwSowzohqeyCZBKp3ZvCbqTrRPQpjfXNoLfM88gwUyfSeGG1OoGTUNq34m4
hhECs20i5k14hJdtg6OdHqjm8k5iiOF4DtctYuMl7cZcA8nWkLuIqeG85FI+KoIOTReBAGdRZK+b
CkJ7qa6Ix9xLaTxyLlEzcbcCIvPHO7BmrRIVHoyT+3GQS4EtbrWwOWiCoknjPkxKJL5OsFnrMDlN
JrQxXIuoW0AEmwezxaa6FFqyg2J960hfyaunor1pSA2ri0xyXUZIWak8TQrufN1UgiNHwzvfKFid
4Oa1dKOJ4gRcasqt4vOmijfqv6kQrxiCH061Dz+Whlr2C2Vftgi0qAOAFmAYi4jQ+5HLy/CxE6Uj
BudmXaLiWvXIAWKXgwgIQjmmt60TrcuhzvhZShQnKnCsOdX83eWaJl8AKLT8jhlb6745m8sEMuH+
v07iBNg3t4GK6EoltlMn0gFfG0sWQUq2IUiTbpvkLs8FN5zI2TCyukmALBexMm2LbrVxRar0nopU
CyUGMaXhtQ4V/eRSuGsdM4zBtOdkrXjaRDpg2KkF9CImTpG8BMXEC3l9nBsVUxNtF/WWz30bzYJ2
gfFgDSo8BKGZSWY1WNO0pTTb1xQCMhi0sR5bwMcstJF1HmZmWT7VCE8FzoeniuKOgSSv31ydfkL3
lpePr3flYrqsaJdQ4kKNN+ckidSc8MRsuIHlPpBP/tv4CyGJDfY7jIk6cDcGbfKKg39BBVpC7lle
u2kmWZvX/5BNgMbKSTYwr6vE9LEpH/y+fdL5hkoPPBJMEVEz4AqCoAcN9GhjzChfp0mZfNQu4DYh
nZrNXrSNEYchuOcz5Mym2m/H0zhGKo1zPL7TM1Xqee4ih8qmhhkmbX2lNyd+E+42xPIXVAhouzlJ
dTrWe6Kv022SLrI1t4EpiQxYIwmG4JGHBozsTE+4nGkgMC5nC+OadyDTjrmI0CUpeLCkqQwZ4tzv
w0TNMlSBPdOviikIAH/dkgoSGvtSaUhJ8mKrJDtq7RSGpg71raHDguB9ivZU1sXF84FLm4vzEaWZ
6IA70LpARXKORzPnr/F1F0U3M+UZQgu54UJJSwvJ/2bCj0o+K7lez1/O62ujHH4Ezi1V102VmLAC
LUl0YTonEoQIdnncJSjVusSLo1uSHdrT7RTwgRClsZHWifW8FKVzgwRfNQl2xAQTXBYsEZtL4Rx4
4IGb0QSDg4OPPPLIX0brhKazoZjWSZ8xDoNkUX8Lap6IRuI0heDUSWV1ORor/es8oWGiAx2Fjiky
m6gydNS/T2wgVE7T+vp22GNJ6BIPrzWPPVEbGuYQwfb77qOl0qoxNPLyiqd4H6TKbb/vW7k3JdYk
DgxsWLUa9M1oXuuZP2/uttt1eRCkmhgarj3+zO7X/aBv2ZvDhDy4xRud5yvDQFmFGpuGmm0lTBjM
XsVap8MgSLfuG4P68xagOBzVrVALFhohV4poU4YhjFlrjH5/5+yHGiOPN8am6nUU93lTEWToFeFa
3tJU4NlXZ/UH6yPPZOMwdXNNlSsoZ4Hb4dC0n2OroG/W5rUBVdsArgZtXQ6Tjtoc5MjKfBK8mRkq
TYRYSJXjqOSUoN8GGmijbazOawzCno6qH/uuziEXkwsbawhmy+HKITcJLhQMddhmL9j6IFWqchOm
SaJXMD6Zb4WqFVM1HOFMfNRbM28sV+YjcyhbNlLHB+vVb9IFSUcf0lELSMG3bCj0dFMloy/elL6l
7ArjKcaGtp69McaqxdRBFgNEvobZRVRrHJXibrtMGdkJw3Om3MfTbb41mWuf3ijJoia3hovbA1S3
Ibz6roklrpx8VSrSHFHSOpDiUyTWxUmOhB6HMDtFm2dTEO4xiTjOaebBqNL7IKIdINtRtRP9zpR6
WW0uo8Pw63JChQg6nZEQtG4KDwTmzLaN5kKzZ6Go16m4cezBEMAqItIUjK6O8ghN/cWjhJM4Orog
ZGlOCaoSj4WHxgrGAzVhPYIMBJbvzTg4d9555+Y1wcqVK88444zrrrvudfZyAgeU1xYxqqTGuRxx
w7kNraOzDZJlpquMUxm5jdrABEPAiI0jFVse2bXt0sUf+uq5QZ7+8vKrb7v8qnivBGgGHIDRoaGP
ff9bcxbOD+9f+alzfnHRD4iwWS074W/edsIH+P1NA2vO230fFt87HPrOY67+QfGRQ499adVqVqLv
vvI785buHv707AUXr3n8mVZcIlsudalWsQxSUr63phLPg+s6DSZCHKicVCiYKJ5QahDC+wdpuV06
RqHXTu3ZKpUo9Aa2pcHGt/+7e+vzRgfW5fXgg2btGE1cmaIURPlGm21lKsz0vJrKM7dLu0C4L0w6
XraNrZLqgqSTg1f9Jp/vsBEZaIXRej5KgAL+lt322OO8b/wLCNk5CeqMNVdfDz/BIq4IWsTiI2Ai
BIl4E7RCuOqo3yDii2nWuCkR565hMP0aNcED9ZENVJk0jIyclhU57zTK36qGtEkOORIRcFQxrovC
C6c8dyePJ6MLOojMhhhmTVomFC0XxJRkNOcTqmJoaukBwfkGbhvKLDtF98yip61mykvGVaqoJ00o
y7ekdSzGeynz4bxT9ercu07FUCixyPD7bJk8RpXaVEsYhuhTXYumiWcgkWqV0JylFQ/NvUJ0S1bG
CPzElMNCJlKOTkrFmb+ZD4Upaf0SfiEoSyucmwVwaApynCZdGtgcUo9tLJkauowF00X9U6AxjXv8
MCyeI/DFzDChZyY0j7qwbHxwUuvmNkvB4BYQvMyhK/NYBA8rdgltQeDjQd+5AKMzwQ78ySUy/Fq0
aNG11157ySWXvH7xtKaIpzQ21+Jz+JKj3LOph9k0FUrkMpyUGw9XPOCVSI7JGk18Fr0gduXCne7+
vsX7L1tCP0v3X7bFwvnxlLoIKsadVW+46LvxyPc74W8ESOZ+fcWPw/szFmyz5ZLduJPCrocdHN4f
Hlj7wvIHWQXOXrBNrG/g9cLV17cFWXCJVY36afL+Y0BaTmKRd0+dym7GqGJmhBiRa8ISH1oF5y4I
R19Vx9Re/Vh+iFnrYBs6aV4OonlJpfvIztlJFGSPbNK411kwx/BNkOBPZGPMUEm9aNUWpgL+zU5p
F/zy6/oIeCHTmHRVp/DODFOBPy1Jp4Eq4i4DfGZmzujf54D933zAfgv23XvOsr26F8wLRDg66iDJ
WRPGhs0ylV3T7mXV3nd3zoAbzjMdcHN2j5gWloUCTNFMU5mfVMHLGbTI5cwYtklisuGJIkQyY519
SQo2G6YoKEMoHbFuN5zH7zMaviF93+GvVea+KzgxdUTi4myE/bER2WURM3fejuSC3Abdhzreehcq
LUh+fUElMytSysqndW2pe22BymlQP++abwRQ9GJ/VTSQLekgL2Xb8gW7qHSRc7E159rgr1ogXolE
1UwLaK21wMhFBDNJRHHWpBLCnUMClbW41C87V9YWuox6iNrtlGysti6gjlDaJqr5j1NTSfSTau5g
W/wb6W9hZ6BMqqVNGDsQAVXB01Wh41OJ0BO6TVu/ZnxAuMJEhEAuL1f5ugiqFLwc7u+dy1bLhKL1
z1KLc8opp3zjG9943VADXooYXwTq+2obMRttgEjoYs3YY+0UW7KD5E6VuSKoa3WqA1ythIIrBzGa
9lbYgoUk5XJacIPiixcsXTxj4TbM8vD0vb96ZdXq8Kc3Hf/+jDb0dvvtE958/uZfcMgFROTSw94d
32rDLXdMrl7XOiLrvAczTpDfCeUrE+uc0SHrhZueYd9PAhO/Yht18nQbAYOgdeDjyTwXtccudgnJ
sRHt7iIjMaf2d4d3zNyrOl1FnRZ1CwgxAkkz8kfdXhvcYBug0tbb+vZp5+5p977V3oVJ58ON0SGH
uXpuE86QwiqRfIC+2dpUt0s6QVXsnHbtlnbPM9VWMzbAeILtzKZV5ulzPIce3HA6EfwkQjsU9pUl
QTNks0M6Z4LXhQQ2EhJoFFS7+Ox5JFlD0NzzwjkXFcw7iah4x8jXwGm068EawIUjZFagIMudtxHj
3mW6nC3XpaJvPt1oZ8zSlR7G2YuQopeyHrCKWhOLfF3ROaZIEUXtTjKimGO60gZRRrl2WieWraFO
U0UtzAOHlnNt4KnOPyzuSc60xZfEAX8TIbuSEvWAjiEMIeXpyumicpCwLGG0b99ppA4/zIBQAmoh
EWhTZuTir3Mlz961BEViyhj5dm3KHTl5qLx2UpzeJmEfwoxs8vLJJRi9CuDAEFumjqKGq7uSSNxp
3URp2kwFEM+ZCaaQa0dkpEI7ChQl7PAGpECg9PlzkkZ/4hOf2HPPPV83F8ebgbRvSklISY5ZJjTU
UdV9QDCzkcv2QpUMwCp5PHE4mHdkk9dYNpdYHAsOx8crvMofHhy6vax13nj4u3PhFnr4pp+F95ce
/i4QKHOX7gYeT3jzqat+yll6UIf7fvSD8X3WXnM9O7nwy8oLvgs/z11w8eoLvsfxpZpnhMUccsNT
ANgA1+HcwzC12WYIVs15WaYLKnEhmRbqo4ZUQXLvW44UJUVUgQtQMG/RrZPTu7fu9QmsqBSsrAwi
xYNLAG7E7bVN/DsXY66zdVA/cMEMk47ZnAvv2RjnbdypzP4dfQd19B/WOfP4rjkHd8x4V8fMFqvZ
64ao1VUxKmpOYdnzMFLPH8Cm1oNrvLUBcwj+zYndW/aa1MtEqVkJZcgBI55QlCzgxfOI6IwDmA0X
NeF1Xkj5EmDsMZpPUtEC81pmzjsWZLQ6Wz4F7KlXdIQ8Fj5yNjh6DHbu6CT6g6r3dQo8UlxfkkSx
ZROXoOuCiM/7QxJCjMz2ZtmUR+LFNRscrslRcyXeeuU8+VYpYxpTieso9GdU2+qcuATND6NJhqjQ
wr1dkixAhyK9XnLckxCHjyywpmdxUT1LySuNKBFbqTMjOeaVUBI5QLoI7TRD3WKtEL4hlJHEvr6J
AjxJNIa2sRM3dSJKWvW50BClQEaHVgWZ9LmiNLsNFNlONTcbf01qIHptu+22TdiBj3/8468fYk1I
bgpbwBWgYUlWlZ28ePsWk04GoND/hRooX7qpp+SFVULVrqS4128R+df9oqxyDjjhmFyKCu++4prw
/swF8/sXzH/z8e8P77y04qn1K56kIImev2T3/kgVTQyse+mWO0N4bdUFF4O+Aa2z5qvfZVk8SWGP
STJgx4nPeJL6FlONJ745iCz6uAE2UQflhji4jZKMUDau7JMTmEhDGoaWGmFnkF2EzGAL086P98yr
ajPVvEX0J4otA/h5LBt7Np+gsgmU1y/bxkabdWN9UsVhgqfWcIElDKOFsGSzTWWnBINvs00V/I9p
xpR9PhSONWUbKkD/OXDnsTou4m1j/v8u8gaYPbOOoUIMP2IBKYUBQA2AkwduXCbxKN5grAudpACV
hCIZ8pTFsY6okMt6yEYBJR2jZBW4dODYjZDWaXhDVcXWZIBgVJFOVHO5aIXg0aFpCsMZ2JjgmmJG
KFDQuMA7BagStV4tYvoB/JYItUeiCz6uTKJwwXVrihrFEtO2qKKSOC7FBl2o2eL/ziU8GGk1pYpW
Y1o3S97m2Fqw/cu0/IWbHiR0HH9yTqk21SahEDBoYq1bQk+69DiF1uE+p03unS6Rcqmoqq9A6Lxq
9FK3k4pJQDDq4oZJyHwXv+tQRM9RBN0SBt/MKxUWUs0+e6XAKHq8YIBBB7Yo1jqNCB7931EDK1eu
PProo59//vnwzlFHHXXqqadynO3kk0/mN0EtnXHGGfwm6CTwhL7whS98/vOfj4NyRx555IEHHtjf
38/v3HXXXddff/2PLr10cHBQRQYILxtcdsiRR7zjyMN33mPp3IULPPR2aHhg+f0v3HzHumuu1wJp
t2LC82d7+vsOPOGYvY44ZLf93ha+/Yl77rvrimt+c+Ot40NDvGm2Xbr4g189t7u/L37Yd5547JL9
l2Em/9EVF33yLGFqE6QHed6P3nPf+lUDW8qQFi1dPGvB/FcGVsMAnnv08ZdWrd5C8AVLD3vXnlH0
bMWVP+E+uyAglhz/viYXx8rp3uncT/Ut3iX0k//dkR+0wp4Con+LZW950/Hv3/7Qd1b6pvNnRx7/
/YvLH3j+2z+wqwYmSPeMUdYHnKAF++79huP/Gi7u6Ov14MMVT79034N/+O4VE6vXevXAjAnsmM+f
u91pJ8xetteMJbvw9Y2hkXW33L726uvHf/Xbgztmgk/wnbF1vKNOjlb/0Uce/eQZZ/T3zzjplJOP
OvLIAwQA+fSjj11/7tfW/fy+rUwFJPssUwE5Dvqmf+E2cz98/LLDDw1zNTqwdsN9D4IXuHb5Awzz
nb5k533O+6eO3t5SJPPYo2btuxeMfHjF0yvOPl+Qe6p3wbytD/kr+Jm+eJcwM7XV60bv++2Ga27Y
dN9DGZWUuoAcpc2TKrNw37duf9qJey17y9n0qdUrV1192WXfufCbmzZtOv8bX1+65x58UD9zxj88
9uij5YJd6exLbbB1s+HCNI6gG9D7ZBGTJlzPmKTlUnaOnnlfvOBb0hF4kuHaRvvfsdcqBVKMYUoR
7an+86hpSoWUVkXkVKhQsX5XhwCh9pF5DyJwyqOQ20jnUIyxmTQPZ+Bdud+kJy1EFl2uYy1DqAu2
HkYAT1lL7iIGMydVz3GNcOC7itrJ6NZmu1ooECMoVqnIX7JGWkVcpcEANZEWC5xYrTVM4vp74mdi
7hBd6wpiHT11haJvYut8dSDh01zSjPHTMdxXRQ1b20ZHX0XlxCE1SnYhuN7KYzjBv+YSuGcmEk+n
5lT+56AaAK0T/2fQGYsWLYrR1fD+tdde24q3BvVzySWXtIbjDqTX5z73OVBgN153vZbSZVinf/js
Zz7093/XW9YHCOvs693p0IPhZ/D0U+444uT60AhHDj0lsLJvPvw9H/7+hdP6mj+4+/7L4GfDqtUX
fOCkVY89Dt/UQ8CBpsu2WrhgK9IlLgqbhObTShjYfnrRd0//6pfDp+BLb77oe8y/cuu3v3/SBV/k
9484+5PdfYXEfPrmn2dkRMAzghqIv3fN1ddLD24FQjMGSXMan1uzHHD+Z950+qlNY56+eGf42fG0
k24/7xs///LXKbxmO0xyyFc+u+wjH2y6uH/JLvADFz/1lW8/fcF3qDTY8tbf8dMf2eFTpzddD+J7
4bFHwc/G+37zxElnHOHsk9nY7bXBptWHj++x554/ufanCxctij++yx5Ld/n3y64+7f9suuZGUDlb
k+Oy7bFHv+HL/9jRV9IlPQvm9Sw4ertjj37u5l/c/ZF/VMOjsNZbLturaTzTFsyDHz4/DI6AEb7h
y2ctOvao1n3bMX9uxzFzZx1z+Pprbvj56Z+CE9FHwShmjoGJXfSlM3c87cT4I/MXLfzUZ8855qST
Tnjv+0DfLDvggLC3ObKaCrOLK2L0PvulhYJWAHXEakMFvDDLiWqw29FBLG1NIiMITQ/nIhItLcR9
mqFxVATNMdVcuvkxXzgH95UrejowL2Qq+sZIhQrX7cRtICX6ypV8/Ff8vqZeHq4ItxT9FJuiBa7o
r1iCK4X8KEf+fbBBQMkq9L+JoL26HWuJNO3l2HgBjVEFUtxn1Mpgq9BkRJczx1i9ryQMkGoXAFlG
VFtTpacrYG9tCgYiLKLoNiK8lxodZu7w7VpdSzOeJgxCYEIzNFlcxkuhbZ3qUsOFKQqGNhc9U1Oj
yYyTjgM2siNyiWjnASDAaBnOdghpdOC5+8u8vvGNb7TVN3feeedm0j+sqE4+5eSA8ejr7//Q33+s
Vd80ic6DbvhRQ3EmwDJY6y3Hf+D//PjSVn0TXnMWzv/CbdctXLr4tTUqDR02Xehux4GgWy+7Kr7y
sI99mMAkGJR48MZbwvuxvnnqptvAAaK6a7fFkl2nk9zk1/pb7pgYWCs1sM0DAy01blHf7HH6Ka36
Jn69/awzkvlb19Dk1W//6N+26pv4teunP9o1fy6DVsGF2uVbX2zVN/Fr5rK37HH9v8ETvbucXAmL
+Ms772jSN+F15Fc+v7anOuRykClzluy297e/3KRv4td2h75zwaHvmHSvwpIB8zhJCMaexTu31Tfx
a8tjjgC1NE0zK5rhNMkeF32pSd8UvtSihVf+9Cd9YlqVMFFC5mbLtQpWOSlr4IQwVnEnAjhk4PWk
EFBlrdXvgskcV/mEQi6cUapUHSKGtwlKzk2gp2uZcGGAevA05Sd8LYv2AO5UomoSkPHoiVAmmXqf
ryhTyxR/BcdLmtMVpeY0oeQgpjnQJfTaFKkCT2ATT2xINZmCkTMU1btY37SKS1fE0FrVQ/tciypA
Ckxq5yP2lOl0IYMrLktzAZErQ4WDTC6HSSWipQMbqWqirgmdBVy7vJeLMIHxZEpmWuvynEwVlGuB
0ulX83KIiSFhZm9ycbj9XB5RfzckG8y+TibayP6Zun8uKosSjoO1qpZWfcPqpD86ulO9/u8ll6xZ
terXd90DCzMyOPTzG258/0koDu664aaH71n+3KOPg3m42x5Lj/3Mp4Mcn7Fkl22OOerpq34ySYdw
xuJd/tf3/vVVvwgUEmid03d5k311laNsaQc7Ifd0Q4ODP7v8qnefeFzQZKDG0HlS6sWVAysfe3zR
0sVNd1tx08/QLKW77HLce+M/rRZstGlnmFhJFL35I4W+Wb/iySe/8m0zPDZn2V7zjz2yhxTYLV/+
+sDKVQSdMAd99EPh4pdXPPXb87+VD49sve9bdzz2aL54xVcuGhxYy72Qtz3txHnHHhmubwyNDFx9
HVwPj7/gmCO7RTv2Lt5l18u+cdd73t86V3tsFlECSwZ+26pb7thJdy067YTwPjipd571RXA9d1i6
eNGh79x6X/RpVi9/4MmrftpF/YQ2vzrMLPn88gdGBtaCCodhv3DL7a/c95vxgXWwEPMOffvCDxff
teT0kx+6+IdmzUuKeqzNXvaWOcccsZn7g7szXy0sA3kLPEtbGpI4sRz8GIOd8RBIyXQ7ieR4uJrP
p1Kkim6UyoPqvl8kcrDm2OgIGdjmJtUtTaUfCaPdK9QCY/e0W4vz0ZQQYhgnsREX5ZAteWmda2lx
y2EwKQ32Ihw7XRatiWyUCCyQXVqHLqKbMZx1lNKo+DJq54rsejHIWNm09Ahu08Vyqi+VfgRNPAhO
l8o5PTWOds0km7kns3dNblYrvLvVNYkbs5YH78K/gnML/CYeexbXPOUlECN+iI0AE1HYtXaEa1It
rvwIut077XI5tAss0S9grIy84sQrnqLGivE/jJ7KS3r4j1Y6TeGyz33uc/Ff2xaEBr2ycuVKuGBo
aOjSSy/9xCc+0aSuvvCFL/zrv/4rKK2jjjrqkksuibXRZz73ucPuert3mP75SwsXLvrshz78yqo1
3P6kU5uVy+9/YfmDn/n1L8JHdjzu6Ieu/HcwCUdsfuIFX4i/aHxo6Iozz7n3ih9P6+9bdsLfnEjB
rrGhocfvue/BG2+FZV1xz31HdM3ebb+3nX/bDeFTl37p/Eu/eH7U98VLEBe1huP/vOWyK4PKgddf
nXjMv515Np+ZOy+/5tSvfqlpfh6+8WfW+RLO7aKoGsjHF2+5PTSWts61EKRjImfWkl37IrjBL/7x
i41f/Q7m5MXlD97y5X+Z8+HjDjrhmNu+/HWupNt2D0wvhYvvPetLMG9gzcG/vzv/W4tPPxkUz8Pn
X8SYpWrfdPB4onkbvvaw4+0T/8UtZ+7/9g/fdeNlWy/dza/ysjePvv9g9cPvt902sKwXXnjh3Xfd
tf2ibb/2ja/HXsK8Jbs/eMMts0xl/iHvKBJs3/3RE1f+BL/0vt8+9d3L5u371mXfPu/XHz2rg2po
XrzvwUtn7Dx337cefONl4SOPfeUiGDkvEFj9xNvvQKHOWbLrkxd8OxsaYUYy+N9L9/1mdGDt7ud+
ujhLHzjkjvMu3Dbt3NpU31J26SaGhu8560u/uP7G/5x8+YSTTzrzs+f0le0k57n3Pct1Ex8wZwVY
VOQBR0fSAXTn1gnypWJLVs8/q2Ofic8pNoVz2KFnPTUnZQQQ+TeWm/TMMZWlac8bqz0dpDLnmmo/
dVW3Rd2Yv2sEiQ6NuiXrrgskF3e2TeidRDo9c4Wyo6ZlRB8YizYnSDzPZBFjySI220IztBBLU6sR
jbB1VxaXutySURWEh35gU2W/9dQqJ86XuBKDMkcgXUy2zUx3FaGG82ZBVBmjy6WaTTC2VlPVTNEs
TJcifqFYShmubHWhC05z2M3IYuXEjqVb9F9bXHvr2HRLeqxIeWmvcjzbCqPRjKculnZ4zpvANWq8
EZDvuYBq1J9UjrN5MgJQG1NJnKOPPvquu+4K74T0Mr/OOOMM0DdBb61aufKOO+8MWme/Aw5Ysuee
Tz36KDz5upWrTnrHuzyfrncncVXWPvbEuseemCsVlNvs+9ZRSnJ0LZi7cwQWgNe573rvwGOPo5oZ
HPrZRd/fsGoA5uT+G2+1ZZIM3dzb258OoXUobS/+A9XBuN/es/yFVQNbC4hgn8MP+cGZZ1Na1e2+
/9vaxIv22+eZm2+DD85cskscVVt9zXU+gTzFOjHfV5ekxD0w4bj3Pb1mfb76BVjll21j+bcu/sW3
f0AckSgjppXDVrsd9z7wAwYH1nQQi+iKi3/06MWXYiiDAvcLD3l7Nbr5td+6+Lbf/gZEJEwURnUm
Xl7zpfM+8++Xhwv2Ovw95oc/aIXdw+ofdNBBjzzyCMzgPequBYsWnhNZKvDg4Ik+3RiPv2vRIe/Y
9ebbX1rxVI3uBurzp3u8vUblR7CmOZGwZeUvYnZRpuTpIA4Y+P33V/30KWpAQP2sXIN2PYzwD1dd
G6ucJfsv++o/f/GZbHzBokUnL3tLfNuLjzm17/7HHxhfP5qNf+/Cby2/6567fveb+AIfm4pSyqps
KVtXwI4zab4Arvk2pmPntHs65ZCY9IhB6kaKvaj6x8Iirsvr8G+dym6orRwhIEj3ZEQnsc7WFrtu
rs3vM4ngZZrLU1qAxaWtHmkdzxjEXIUBcU/0/ghUobZAvgTVu7+Ejcx8ykbHrnlcVRNldMqwK+Kg
q3ptVZaD7XgZXJEEKjgFVImJanP6ZvPX6ChO1UF5r6YeKy4qztVR0UzbL7LCwhXzTAch3lTfEntd
8TcaVyoEbGKm8ZYNeR3cqjFXlmmCN9MKU5eVStvLXDQaLJKzkSkUFgC7KWtu8YSezTj9MD889xz0
mGlfzPHnfIHOaEIThNepp54a65tF9IoxCEHfBJDb9dddd/Ipp4R3QOs8/ehjbNH09ve/+8gjjjrp
hJ2WLumhvM6T9/xq/Yonm55ngkjg94zKLdGuv+LHKx973ET0Qb+58dbcd6TQ1sU9l3RTFCsKoboY
uFGcHLJLYO1vvuzKD51zls8WLFywaOli+NKevv69Dj+kdXKWHP6up27+ORgEux9XwqoNXH1dsA2d
0PDFrxoVda559LGSyjn+r+Fn04qnX7zvged+dEX+yO9guUdUntIWfGXF0/HFOx/3XvgByb5u+QMg
neGXTPpEwcVzysJ34+Bgz7I3gZU7TiDsbU1aHR4rgcIPPNAp17p1wZ4IYHoQl3fedVescjqo29h6
W3/+sce3lajjjCW7vOeea8cG1q5Z/sDqW25fd/PtHBYONVWtLE1M8+NBO5pBt3hN38Jtdj3ufVsv
22sris7Vh0Y2rnhq4JZfxp+dbSrvqPY/2BjZcslu8furlt+/dvmD19dH/pBPkGhzTzz66NU/uuzY
k08qYBS+5zR9tybyZpGPplxKIswOappO5iedu6TdW5lqp++DQntJ+y5/BE1GF3aja2wg+uoeasla
wf4ACDpowDviE3QrwzzTFtv5TLDL1U1Nr1tMbOmbHugKy5SUTHAimXafoE4kR82/gNYZR56whLlw
lKSauNY4l74JQfnoMgPvVLE1ojXz6HPXhKLWSrdY6E46TGOqXzhDpwq0tsW5uSk6UoZ650RgcoHO
Udp0xvyYuoVv27ckD6EwHxAR9sXQLbeMGm9TWBmlwPw8S/sc3dRDQDNNnA6hF0qgaB+s2wxMIEx1
4G7V5Rx/TC+ZciMW36qEjBEi1cdydC6tmhROjtCkIPPYaA9m+zO+Lr30UkZCT+XlbCYD1KSoeIZW
rVoVv9knkIG9D9j/ez/59yYEwW77v223FgeiQWSOcbklvF5atVqX+7j40grtiZLc1AejqCcXqImL
Mr3G015hg8UbLy9UDmbvTzz2+5/8pwNPPCa8MzY0FLAMex//gZ986vPZ8MjOEf/Ni7fcMT6wrhJH
JVqOxyTVNr40uOn/nnn2B796bvwnENnwc85pJ29YtfqeK6659aLvq+FR5H8cGv75P/7zu87/bHzx
Fkt2hZ89Tj9leGDt41f952++c0l9aBh2WHfkcsHr77523ub3AGG32hiPYX3b1thSAwUUj9/+5Fmf
//creqKVnbZgHitF0BMrb/7F8vMvnBhYZ8mJ0e06TZKyNGxUMc3B0tNO2fu8f4qvAl8KdA+rn9gG
3yKpvkVNX/aGN5Z8+rvuunHylWFkpTNhrVeXd6b2Xcwpku6QeVT77pMmJIQTKd9hZTAnqcwz1ZlI
JmQSDowLJz+Dl7gUZpjak8Pf+nUKWmejzUZtfcjmzG9dpRY7nQo7XzDLHHfBgNGOmhyLb7hRp/TQ
ErOpiUG/zX7XcXCP+qDQjVCcpZTmYV+nKkx9zJlE/I3Wy1lPHaRVU92MbhPGcd4hY8LAEjQ57rqr
IvqvOBvvCgpX19QFrmmZIsDYlP0htc/foGVj8UlDv4CY5rnwH3TUbzuAp7Xg0JRIFU7Lac9ZFsKN
zbG+0NdKRaHIFm4erVugKy0r6pfblnt1ThFjDIAXp8u8K1FpFHVKzF1RMe6kziZznqaC9U2Nek5z
e6hGVKeWqz+blwPuy0EHHcTlOH+Wl5sCiQCPvXiPPZr0DZjG4OI8c++vWu/DgW+32S/aDP3t1C65
dlEjztgoE/SaW7Ny1d033BQ+8LbDD4GL3xGpnGu+dMGGiAJnyWEHg9CPK0DBxfHdMqS2oLVXFVc4
wqm45lsX//MHTnieooWtSLy/PvvM8++/Y8uF87kA9rcXX3L9caeBQ9N6ce+CeW/7x4+fsvymjvlz
idvxj341wXheyyv1LETm0XuWf/TgQ++74ebWa0BP7HTce4+/98YFh76DGtr6Td6kNlyUuoBfdjj2
6CZ9A84c/LQ+O8wwKIAtk0q3SeL3h2w2SfmSgA5tF6B3vSbZrdL95krPDmkXNprTRZE5F9JWJG0A
NsR0pF9Kub+48j1PVZzJZ6qVMYKicR3Pmrz2ZDYOP081xp/HFtqgeFAVdVLz5ukm6SSl0GfSvarT
d0TsAHacq/tyF8Ug46YQ/1Q2vtYq7vmWCNwgqjfErAb7NFxpmwtGKYLOuvY3n8LhsAJzSKMciSpB
zJs2GGunEmItVPv6ZFUJbq5dzCMgleCxwigF+ko9gguqLS1rGvGhiRun2z9mTIPGJfkxgZ5rAbmF
7sx2itlrba7a5PY1vT/VaXRl/G3u28KqXJVo5eJK3lQEnPYVWD5FyRStvrFHjQ4nh9S4fph5Bu2f
yqsG2iW2XqeKpG3+1aROWnFrMF8LFy5sne7Pf/1rQd+MDg79w8GHr1vxRB81dpxmkv9z38/nLt0t
ThI4StjE9+ns67WlJXFxQ1XX0vG7VUUFhphgI6goR5pJPvOGy6484IjD+INbLVyw1+GHbLd0SZHk
v/xquP5D4poc9NG/XfPYE+GvowNrV998e1JEP3z9XdOoeB8PuQz82jtuuOm+G27Z6w1vPPjEY3fa
b5+mANEWC+f/r+9d+N1DPsCb8rmbf7Hyll+Cktv9uPfN2/ets5fsWnIoF2xz+MVfu+TQv2kySp65
6qcjA2u5lKHPJDN0BSz0X9YGn80mGMYDf4L3uV5ks2qp9ALhiyQ3YB5p+9yjKz75/uNg6Q868rBl
hx/aVB3V0dd78He+smH5g+AjmnKTXVWIGxQTIP4qvdOXnXd2+OsrK5664bAT6sMjRMTp6tOnnbn6
0dLHHThPpj6wLn5z3qKFLJIapIC1XFmCWZvq9h0zd027YY0Gbfa7xuhvGiPDNucoVkVIGMngpQ6w
xpjQv0QLklhzvxPNnhCRtIKXk4N22Yi+TmOSvrQb1RVu1A5ttkZO0pT6hGLAjYNamBlKzBhRPIy4
nClZS0EY3SKqXEvaUurNBGSFLiMvazDtGYmuBYAX5XJUQb3s4q8r87vQt7pyAob1hG7umFmCYwTS
INvSGFu3drmO9I1rB1swpTYxzZLdlIkbQg8erQv2kzYelZY+EBH3M0cZM887rFzRYE2rMhW0iipS
jX5NvAC2rG+SP4akOcaPh9538Z3jM5sGW5uLhCmw5rUaYwRyqkzmwNoksXTkkb79k32a/74f88gj
j4DWCZpmT3qFcL8mJRQncuB13933wPv7HLB/eOenF3131WOP9xhmMES+qdrQcFki4+Q8ce99JcTd
iX/z03O/CjIrlICBOAbtBe84HTnyqq154DnriqROYNh14mt73eNuv+GmdasGAjnCuf9xZbjLbZdf
vWlw8NbLrwoqZ/7S3WdFjQ+evOon2E4NwbJgdZtQk9y6l2pUpYGwkd7pjeExmJDLzvzM3KQDHmq7
Y4864KMfCuG7HfbbJxiPILuzYWzbc+9Z54K91kXxqzeefkqoidl2v71htzx37/2L9t27CAauXvfo
Vy6y1Kx6XtLhkg7QFk+Nv/i10TVO+LjgXy5wafJjKtLXoHVOmcMfbgUXdPX1vjS46aWB1T/+5sWX
f/M7XX3Tjz36fUef/ckQHYURzliyy+jyB7QUwZQy2NiDTnNKefaS3eISn/vOOndyaJjlOxwKMzza
pAV7TQoz1fHkc/H7Bx9xRF//mRsHN9moFGPfAw8oJc8q0yppN0j5DXl9mBpkbJt0vqwbY1SMxdY0
c39gDSbBa6nNBLOvOgFYYyEIp3DYewZnbojuNkunW6VVanaguVEei3ViUTPEH4jhNdgJ4Pp0GAyv
USU/XjdqczACqgzIcqVK/lIDsZYel9pXj/rgFm/zXDpq+2aPUbctG0F4OxHgYJh0JzalTQurWDDZ
mtpbxAlUYTbTpuC40gzddiXKsjLTmi51l4krXUr9DtrJdE05EV3Al+PU16uD4kLLAF3Ag72+s1Kl
qwRTEFql5EIMaHyDBl3Wds2KsUxZrV0Z465KLpSL+5Hqsq3cNO2BBS1W1aGBgglEhA3K3XGr9knC
C0x6/wbz5xxbY5KbRuHZ/Q/3AG2CU1977bWhJhT0ze0RXA2jTCtXLb/77iYiWHB3uGC7m4rGFyzd
HQRlfMH2++0ND7vyMWSaCW929/Wd8/Nr5yxcwEsFnzrnZ9f+8IX/+uzPrj30ox8OHQpaXYr9Dj8U
nJUd9ljyt+ec5a9xhY0W3GGCZngr7IbLrmj77D+7/CpsQDk4eFvEyRYXhz505X/ywdY+xK/btYby
BSjgxb718EOu/M19S/dfNi6FgS+uHPjJuV+7rcz5xmHlnQ575wnLb5y771ud0O5uWrV6+XkXrrjq
J6VYljYrrvzP+J3dTzsJBsmUaNR5zFV23/HjA49cde1Pjj/5pG3IK02wS7RrqtYURjsd87XE6fcu
7BmT7LJouwsfuPuYv/sItpAxpt8kPSOTD1/5H7d8+gtNQbC2FYXbHfqO3gXzehbv8oZPfwx1cHm2
utA55jbhKCWbimF7FszrX7ANDP7FFU8OD6yJ99g1t982f9EiNGuUgT150Q//bd8DSioHRvuHfOLW
2sZ76kN314burw+/bBuzsfdBx6wESZ27PLqSZoDWizsK1pwtm/NFX7UqEcrtknbtW+09oKN/17Rr
tkm5FdskdSMFBbmVqc5JqrOwIiftMohcASXHOq+T2NiIBZxKlIjWtuKbdOikzLRfWLsxUkoibFbY
HEAFgnGzyWbwdGvz+vP55H9lE8/kE89QxO/32fiz+cRz+eTz9APOGVw5Rm28A7GWax8zKH63EbNn
lJPQBdWmsPfDWlQ9U2IMT4j6F7gieMVJphrx73mYA/0+oXz2od6uZ5gux80Kqn/drG+mqqY0oZE8
Y4sjCIk0aPZ1+kX9r1MhCWaEIS2ECpOoiMqVvcAYZFEm/mku+S/FZoQXI1HNXavzcuEmf12Kf8Cv
wc56uswvFEDS3KKD2XMbwhBs/3K0A5uDU58S+TGLFi16+OGH2ftprRv9zoXfZCDg8OBQCKwd9bHT
6kPDz997P0irXfd/W2tF/dk/u/b9XVvAwl/6qc+c+eMfhfcXLl184VMPPXnvr0CAhsJMpr055atf
Om2XN764akC1AGBA2fzHMyv499tvuPFJwom1bWTiKxucvu6yK08755+aRvXCqoGH7r6Xd8ktl195
8InHNl3w2E0/f3HVqrmmo0rIW+ODM6rRQpiI+AiVN5z9h3/5ytYLF/zrbTc9/9jjt170/fHHf79h
xZO7H/aufSKA3PjQ8AR1+Xzn+Z/tXbDNX9905Usrnnrk4kvhyvWPPbnDoe/cMSoJAocAVMumgTUP
XfkfgX602td72D3XPfyVizauWl0xlb799t7yfx9n+qYfduSR8DM0OLjjdtu9vGlT0pLa5wqScFCr
5b/DQ06jXm3vOvsfQOV/8KvnHvGx0+694sfP3vurPyy/f9uli/cpr+zo0FAuOeT4NWvJrsc+6hH8
f7j5lxODJZd3/2+fp3t7hgbWwOna4bj3Li6DA6ctmLfNNz//qYMPh3ke/tIFH/n+Nwtkyh5Lf/3s
72G54QFjJzs+w+vzBuiV7ZOu9bYOIjinCBi4F8wpAHbACBbFqXFqWcTSvJsbQ0TGuCCdsA60S6Wd
CWimhKUGBtC0HsJgHWKgp0szDmISkXgIBdVHXN7pUFujA4RJphTeyahJnaSO2jgTMXhXlRtNsgwZ
p97hz2QT6yzCtQct4hcakpxwqOB1aKoECm+mSecm1S1MFTRlULodUZdSdtt1UYWDt6oJkWvh4qCC
CV0VdGgvS23l2ICI2afK5KEh5CP9eLKi94Qn0WcK8E6mmXc6jcQut0dJfJNQnb4GUpI4YxT8+0Si
ZK0lpWHGbZQAY1OpLXW0MN/FtAtxsgrrduNPUTs+7YEVrgw2L3tv1rXApoN5Fz1Rir0gnTOR98cp
NSeduxrcEspxRY7NnHB9OvU/rnJWrlx56qmnNjV2a0t+c8WPfnTxhRd2UEjhp5ddfsrffyz86QNn
f6qUIhpY01/Gp/GcPnTjrXdfcc0BJxxTArnt16ZE5tIzP7Nh1WqucBotJ4Hi15v23+/JCJrcjvGJ
QQQr77jhpr+SjA6/fvyt74S2eL+7e/mzj64AZRZfsPyKH/uGaWwaSZAwazEUSJqovz3nn0INEAjo
WFyWXKuLvg83/Kt/+kSYoi2W7PrO73yl7cUPfueHIA3HbH7hJ8/67OJddpQR/j/q3gPcrqJsG56Z
tdbep5+TSkIqRYgQAgKiEEgCIoIUQQVBAcv70pQiYsCCIlJEUekK2EgARSx08EUFEiCg1DRCJye9
5/Szy1oz31NmZq219wmv1//7qd+5Ytzs7LP2KjNPvZ/7hmzgoJuGxq2d8fn/6u3qJknddwNfSJos
qclaYMND1rWHcwPgeD7+za8O+S2dTz27YdErxEopS/k6aq4Hc+B+S26es3nxshGuTVVsbzs0f7Gr
OjvHZ/qF4A9WJGU4f1hv0476yIHHHJlbLXtO29Yvwi4D2zRZNbwnbJxoimBhV+tyI2HJmrBtg6lJ
l4y7iaUG7sSooLC9KowJCm0qCJx0qXCIaqcmIBuRBs0wkwj4mJEiguzGagwSRRvxnhktLQhNOQMB
uUWjQVxchNwEigP5ZhQXd3CqujwjW0bmPoQv2nPlFu4MJHAL435kvMaWsE5yhslhH5w+NDzQziSE
RG18UJygiqMp22sS4AhZYW+IWX2sJZJEkKwdm5cezhCkXyq169jrFH1gTZ82KX6B/Q1WHU3CCWJA
oht9/J9SjiG/2IZa4OQ1ZUpRLzLAgXqtnfpp1nqvw/llJYMUN3V5nnYEQr6RnBVwS6FxMsVLywzr
qKlrTQ2piSBdGymXmZnctWR6SEMrCyly3VYQs0RJIv5NeAFibUrKKWjNqXL9U7Fq//9x1eB1huTI
8T9zb5tz+ue/YNm2hfzJZVe+lh9Dyfqbu086vStTFRFpZipuPv1cBAq/+/nMvvihG2/xD/btRYsX
zX96yE/uO/Ogeh+TFWVKLAhE3DOntrb2wNw7Y9dUgycCHqgGw/3M/Q8xyJAhAxycJsbUs7yAcYGd
c+cNNz163wPvfmlL5z/9myu+Dwvjzzf9bPGD//PuH37nqWef+N61sFVglz6zac3HP/ThZ+fNf5fP
Q/h/4nGfeOC+e4cUy6kpeTcrNTovrcaArvVP/f35q2549xODHOXBM2cL0hXtN3rNoqWrnvrbNlzO
B+BuPfbFiyrbcEtvPvnM1z756ew7E4OGkxtHf6NlwqcbRzd85ft9j8wb8hf/MPf2P+SfKU9ognlF
9hra84MsyYOlrXBCUNwpbHhv1PS+qPkDhdb9C217E7BtGBXKYscMEjs9kcDqa2DXB/xEGyU0TVR4
hF/poD+sXe1xAU5czhogauqg4BCD5cD50fbXOs/2L1LNpxoWL0s0AA4AkpstOv57te+XA+v/VN66
IilBrtOLFTOLifWVfIh+eoiSp4tEvtcmldfiwb9Vev9U2vK70sYHS1uerHS/EQ9uSKp9OiGkwxAo
rCEHVwPuojsL4AUulUiJPvl3meIWjo/gchOv05XlSenNePDVeHBR3P8qlf6WxP3PVXrnV7ofLG3+
fWnT7wc33jW44eHSlpfjvtWE1OjWcR8xO1QIjCcdUG3IutD/yozpIIvKq9f4KlkmAxO+9pjlxLP6
iT4PztDA+WsfEjRRA4oxzuw7QFq6PZ29MtvarVrklAYV80Xyki1TjZhXAJUsMUstO08TZ3gH/hNS
nKzXed/73nebEynI/tx3770fOviQ//785x3VIN6I/q7uMz780T/dnqPOhGh33veu/dn0j25Y/Mrj
V16bDX5VqrEh51548dc/eMgLDzwyBCbijrtmf/DgB2+8xeR8vvjuCSfXeB0I5MFngJWvX2E1uiAM
NPzL/Q+szoxxwO/ClVqmO4rFnrj/wWw69dc7fmPsVKPmrNxse263TEO+cEqnfeL44/bdHw6+Jj8y
Aj/rOlfcfvn3LzzsGCbMB/dwy4lfuOaAw1+483db8u6Z3fZj37vmVx/9FO+KyUHxw8WO3Qf0tUd8
8pdnfHnt4ldqoTI9vT233vWN3T7wh3vvqfCaNkOIMPl4kCVqqnXbl26FePH7N9w57eBnr7q+HsQ8
0N0DJ/yrA4/qW7maOAiwjw1f9/tPn1HjdcrdPUt//Yfnf/orMBybFi/7w1GfWZn/QM+KVX/94kXz
jvncmFdX3H59+hzBNE+LmncKG48sDh/VV974+QvfOueS1zLg+2fmzb/gv077yhdO03V6ME2ouyNh
670Vl5bGAyQkip8ajdI+0XAVbacKo1Q0hv6GlKXgxHWqTndSZ4LQ7CiGt62hK+WbDINiP1n5xAGN
XN8CQ/huE3NhiquyqABE1qNmqmNIaceYlhYcuTMp3V3a+IuBtcvigbLzi4lIVVH4T9WSm5DZoZFz
JoSF09igq2/GJfA395c2/6G06bFK11tJqcvEHoLPoi3SCcPLFFWXS8JUHUtYTWOD/U0PXniyJqmA
g3mm0vNUpfvFat+b8cA6cCc63qzjDbqyWlfejkvLk/KGpLJRVzuT8nPV3nsGN8GV/rW8FT4P/7qB
RIwGCOL7j0K/6my3N0G+hZbNQpwjSYWb6xMUhDxke2sZ06SGaovm5bFzA6ROWsIk28T656Zw6kAK
lCrtETXXNIc9WWfiCAEdtgTT/9hhiv5zXE5NVY0hA9Lh4jioaSCMQAPhoJqkahSqRQWjO4a/d89p
8KKRyMQi15qDrSXbWofvMQU2HljbDdSVyWA1Gd1h3jvjAJPJABJX4/YsRg4LgLtr5KQJoydNgNfd
3V3LXl4U+xENk6ovZ1GYIpfqZtqPsuafUorcwAn2NRJieBQ1n+FPqwpDYUkVq7Z/W92qk5FB2KsT
iNrW0LZZlZSbCQ6LCm+TJr1/x/dQScS8sfwdcHjEW6wgvaBajUVbRPTtcGnDJ02wfbIVq7Z0rqK2
pygS4qhVwTEVjXyhtFpC5alx03bjupDp6asseQOu+OVq/ye2vFKw1yfLVpN0CMFZeII7hg37Ra1w
aSGOwkQhXVrBZnLMWIxnnrQ1t6IyEBpTcNIbFi8r0uRjQSowhW1KlYyljYH73zpx3LCJ4w0xC/Qs
eZVbwbGVTcNLa544rmEicmODj+xa/GrBihRQ0Dd+u3DCWDjV515+aWJffGCxfTsVwc00pCzwUGkL
RMFgrchks46f+MUffnf4x1Lezx8d8JH+Ja+1qxBu2kvVPrBWkkz29kHh4GIHHMqOK1A4iBIVeV5F
bn2FTuU+cvzz2fZA4P7VF0IgNN5M5hJ2B/izFnxS0tXMDbc94DG1Uj8Jlg0sng6aPK3hAcs23v1T
KyPAOgY3c9vAejDNSd5o+NzIo8VNrqmQk0CuKRbBQ4Q45qiGEftGLXg+iLiTfH8gM4O7d29p8/Jk
kHlVYHnMKLR/pDhsbFBopgwyW91yxlrErvoHOwL8xAZEN5RXI3owrqJ6EG4oFuqukOY3rB/4DFxg
TPPCxLxndyITScD37hY2QfwxViEDHveiZIaPdUisv9gGXSb3MhNjex86o1CeOBIyn+vLTCZaQ9bH
i4LhFZ7tTWesVj11tEwLntn7ZpTT5csOxtYTPZssyJtOO4zz4gqJg04ZYwkEqy6ziZ0C/H+sv2Hk
dM2DVBnNO+WMssdDv/7kAli1TVh2UFnG877u7k1PPgP5NXODe2wxG0TqPcrX5j+Tp6sxTDAlHYxS
ZCCSGztXrlm+gv23IMazZIgkOkdfUTPebKGKxjX6nHBsQmwFyki/YH2KENU1lstM76irhPJSPabS
r1kFkrkjcU4C9vC6FSuWrN7QT2ZhY1IlvCz8K9g73DMJ4TYxKCGrtK5z5frOlTzuFxEGks8wdtPg
BarwKByGR/6V7q1b1sx7EkzArEJH0Q2f7xI2Dlcho1RYuzpx2F+dn5+AAH/3sHmHoIGtZ4yZXJBB
E1h5kgGTVLq6Nz71DFgH8A3wvQ2IL0Ca5EZ6MWCEg2Xjpoo7wVmuLNLCSKxYOLqxmOASEHpvWr48
6FxuGGdMtETMW4zbb9X6YNUGuN7pIhgZNYxXBRyd+dSRrad/au1xZ+2nq89Xe1+u9sUOaLr/zBlZ
f7Ohc+XKRUu3CyJuDIzHKCFYkZQ3UfLhk13pmCsDN6ZKtwUjX+0w0yrDDiDTGUnuXBhvX3jFVrCf
H69Mym0YdYH/typriRNjROZyXWmQDVysKwkWLkGHJ/J+wpsXR7SDydOqpPKHwU1wIb4OX+OrhizF
SFmrEJ8Cmkg4o2oS8GR9gwk8x/dFLdw+8WE7DhiJLOOUCHIw6yFHUpBsZZDYeyF5Wo0FvYG1ugKX
kBBpQsVi/PD+V4mQux+7OAkn1mTxExblS1xLHxw5JEaQJ+0VtewTtUwMinyeWV3zmm5TXW0q12uR
uTJXCiRLTMrRqd1KcINSssa3edyHn2oSpoZMQdbQV5sMUqMmOWHFJlWXzWSfXZYcXdNmCSvWPFqI
uudfMZYx2m5gXjROEP7/mR8i5XbRnxNSDd04NJkMlV2yfKd5XjomYKj2iHKZa8RxkqpNNkmv5dVm
WkNlmSlQOUqbrGoWrU56yCrvZobaHulIB2+SLOWIltYrhobsPu3ZgKSCAyn9xFy/TraauEvHOLxC
jMiMfSevgGkfbDn4PGyhJlpMvSTqzCjqkLwsx5I0F4KLJcahH8lqxIyFZctCAQotIYl71aAINFai
CzhwLgdoA8PGhn3bgPaBchehYHOCaQanRfWu3GS4p7gPcIAUexscs9stJ02QIWpkRwInOUghKkWI
SOIJMWlF4BgKhPZwwEGJ/fAIa1mQyhjKWiRXV2iFmIIzfTx8xyMvRYoxBwQOaTbTPD4Tk5R5RFrI
d5ISXN1+Jx8/4rpv4bDU8/cWbvnNAXPmbnxzKVxyQ3vrcaeecv63L84+2ifvuIs9a5XmIkeoEG46
JJ0dOKSp1iUVeCdE9jN7S3QmOjQZecbEMegzX47xM/Z2h8tEapNBFkFIAYZ1o66s0oiImxw0NNEV
8dw3qYphljNSIUaOsI4spJ2OfRpvuRzjpHEcUeDJHihtfi0e1Ok0aC6Qsp/3MtjCNt6D2tlGi6bj
ip6wDBpmbVL94+CmkSoqBo2B+4rACpUqUUf/MSQZqHZUxX00kATRGPjgN+NBOPkBqugoxzxGA1t4
sjRRkDB4soYggCqEPmmgtKnaB4eCmwxp1i6ysRWrCCIYCrbmBl+y8O4cb4ys6/hmJlXsb7HJCo0M
ZE7tbYhcilmlzRC1ODdYmNYYtFtjNcM9jqm6dvDW5P2NzPJ4uSwnLexoNyziL8nDq2NRq/v0H/6T
AjCky3WkVFbhirn2pGft9rJOxKWa0m7yE3OP0PN4OvlYenJcXbFYQJfomDyEQ9SR78r0saWrRg9V
Hs3skDyJnn/YxurZhniqsuAoEbNzjkxfv0XHFQYo0mmVSH2OBjMV15ECN27ZQ57JWn/aS7yASlxA
J9YslLfACWKM+ol6WZlURdgEaPS1pq9KKFYhIJPgktRoVWiTYWb+QBzVMHxp3N9NIODEpnzpTeCW
bxNyWRabqEDK0un+Wcdk+gIaoyXOMc2BfEAkVxyllk3MrSA4eD/dh8TtLrA4mlgPCra3DKvC9Gld
zMy3S8cEmmSG7yKMu/FeJNyBMGbTuBETrv+Ova621rGzTz8X/mxjlb61aPGDV/5ojCqQm7Q0SCNU
NL3QrqgbBy4H7u0oVLKRWWeTb/bS9JURjD2DBVyVNuPRmfDWN8mYFaaH2iHwOLbqyrLqAAQcRXpk
g5RoQqY1QoYjJSKkC5TiwK8XaKm9C5mTJp8NR36x2rc47tcZN6NkStSWGB+Jo2Mr4oiMZBg0j/5w
wcCR/KeXzIlaha4HEw44qcBk63scSpoMhC6jbowXZjJynDTnju4Wnv4ANfy36GofTQJpW4oUkWNG
4EF4pENlDRfP/+0SKe2ynNgVh+BX1uvqc5VeuCK4mRFaHFXPeeEVbrJY85rCVA0+0LhaVE2REClN
kbYVV6+3PCrDIGUPmBkJr2m9yDyGzS/+Wry1TDEXNYoJfi7KyHRemONveANLGS5aSaEmfhLYS5Hr
oQad/kOcinm3LAfNbphhdgrTJqrkAk7oRAw9utzYLUGkrS4L1jlAYe20bcaLyCxn+JAMUcqRhKsM
i0b9+JXv99XIH1ndLfqgzhwTgvQ20uniLoKkchblv4KJwMGaQ8A1TGJpvlGGZYc+gN1epoCnkfYC
Y+F6yHeAuam6QYsKrxDJX6sSoYuMtaWMizrMth7FjYQY0wX4Cum7xJ69EcL2XcPGKFMdhi8+rDjs
jsENPXqgSvCthOxoQBubcb1wXRPD4r5RKxHUo+tiOkuVCeW4pWFcXRuuqAdnmZOYnC58slUpTOw0
2vd+fN/2Y+CYYL9CSvKKRNfGN2eA+j18aHBjsXSiZ9Js1NV26n5FdBCCMmscne5c8dBZs4/86dX/
6wJ+feHir3/kmO0ROKCooohNMrL4irtBcK866EkRTNZ4PXjNaUHK2SW1pVnjFSUddYhXm9XVTJWC
zUqJ2OkhjwGPskZXViRlhthA6sAwDQhHNppqk8Y+xCDN71Gl0URZlU6ZFaERTM/YmZTnVbr6iLBH
2UJ0DiOjLJIWE99hKhyuomHSDd9IFebZo3WO2J9cO13OBFUcFyCLdugAmdJhoGtSGZ1ht0tczsRd
kF6njsqadTx5SpWPwM7fIP0oFtMGqJHGRAm84+C+NSnVLJChrgUR5Hjzewno20ttoV48moY8ckGl
Z3xQmCU74N4Gwnh7LTMJzZAdnW2xA3NikLht5RMGPD3kBJaODMJWU8QQ3NI5HiBR59vqintIfBBk
nE32uXtqBi6nO+64lMzU2FKQCWNTS7vmaSc8TlcbY4Qw/3klNbPt933hO8XqUM4eWpnVdCI3IkBO
4GIBnIQylgs2yAv2mQyFgxvpt8RlOpOi6hyCMKdV7mprJqXByKRB2azZT6FJKWuCkUxZ3G5cphYe
GxSaaFYcNiEYWSqSkNchawt/1icVRL1LBRtsuAj7ccgcwyL4WJ+JkfWESI+kI3Sh2hRBdV227fEu
CUbHyOhBzkAZJMyF2Eq77qWwATt1n/iKwE6V6Q02Q8NVWLOPIPn4fON2X4+Xc6qhhKqSSwXLOxpM
EkK2oslBwwhq+bAWMviGWFqjxnYqJlw4/k0DelVpCkJv1db+FpHXgAXK8Pa2ycDnKy00dFDEw4it
Oma6HU02UbqqRROxkCHVDUHL4Ct64RftEhBcoYUrhBu77Nd/3OG1VTtdPrt4wN5DLtFVnZ1/nHPH
ry6/aqwqYAuc3F4PVhrBeCkXlmJhp0OFLrRPYhcLs36BEDZf98QtMpMNV516b5k63uWMToqjpsbG
GFwURCrDdbRBV+BZ7xY17R42b8KZzYFVSSWJDYvxgF1OUIE05Ppenu8yre9DWswpDtxDne9HZl5w
+5pAGTIAfzMxKMLDbaTR1MA2pdH5RW5ayFhiUCndlAy8M5o686Gb7lR219ba1iSdzEejqVyXu+ry
m60Ea2b3kFABvFUEiWNa4XCtx8p1W3taIKMB0QAzRMD5Y/BBawZjDqHXkjpRZ1zeRLg1uHt/r/RO
pNJlg5QZprohIAPZUpvOjDqJGiGfTPzL6QFHGFWqunucSIYqu1YuISMwYR2JJlyAsJTfKUApO9lT
7wUJZeabLy7yw0IIHs3r49h5hmpm9N1Y7mvblM5wCpn/h/o32YKDVWh3+W8obfWdcxpcOuSBqLEh
AwvXkbqmG5QZsdJ1tdd8QiNNzt3UFtby5TU/fmtjiXoFPZGvoYna6TZEkTVRG2Y4TW8kVPjiwBYs
BVFyoaEfRCAs1qkV2VM7C0IFCkFrFC4TwrQ+kSQU1COOAK02j3NrjiIDhvdQWsOaK9r5G2PYeWNl
jV04IcGYelIQa5liwAJ49EYhdwoaGokWoaZf9aFix5GV4X8ub4WdTPkTvtmsgt3CprEEqWK2Y8vb
QRKZoZDZUoOUFldpPPsh5UPMWAjWEBLMAvkkOM5W8iIRRu7UDgWHJKtcUenX1SZKfcGjsYcb0LqC
7s1mSxGF94w1QBUAeiAQpJdpnn9K2Nj8ytvrP/5FNWFMdPiMnnEj1e7vgeOsXN75zvLlz86b//S8
eYZ4bqhmax0JtbjKO4eNHSqgE1NUtsULLEtNzR5f9bUgYwqMUvsT2wDcmlTGHFKEnnAxihOjhLL/
JpIqUFgdNc0BgrLgOHuEzbCQ2lXwp/LWlUm5KJu4ugwp8oq4BLZ1pAiTbWuXwbfAby2q9ieZHZTh
B8uhMdkwgeMfgQNJYZGLta7Q6tszyvY/sD+nLHbGEvHBugrd1gippqr9VnINdI79ffSspa2IUqk5
Wacr8KcLq4Z2GgTW3gABx0mBPumjEaIBUgszthlsK8PjVWHXsGlCWITd10jJFnP4w4LfOWjs1kln
UHo9Hlwa98OmeycpLaz2jSUEYFTnb+pf15Q9tmHipC+fJjb9ssKyVUsWkE596lRfIEd+ZUt5xpi6
1pGswc3KIQjutO+8mBSozeT0igN3mZuxS7MckQEO6BRN8P9R9/Pfnv1kF6tyIRWH5CHDXqUFFBLX
IWb0yjXKiExJhs4weZlYL3mobaLjGTIQSSPcyEJG4dNkxgLkTnvuDuv6NdKIE3UtO5Ri7OjYdc9p
ryxc2NPVneVUr6vq0vyBZDw0qta306zfqKCAiYs21JZX7RQAMvqTa8rrdaWN5rcL3H5AHJqhZAUT
I+6IEleKJPkZSemCSBwZqNX+cs5XU4ZBtyhAUls0xBg8FcgQFCjkd7LzTGeC9RpwV3CrRweFPBac
M0jMS77aMh6dH5Zx8PTgw+0SRxcZk80wX7Y7kSXvsvvBP5ckQ3AXkOKLEgj94sIISpgITuMwnrUu
FraHCmKhG8nBwJvMBKNIi7OHOBzY3IfSFmk5naOAV/G/lskVNZAB3SFssHjClWu33vLrxXH/kmr/
JsKmbyZwLXtcBshxPYqvYoDgWGDZxwfFNmFbU9pNvycZfBHz7RqG3mbKWyYjZJVQNyjJ1F6qjtPP
UM8vIX7VAuIDReS5X6kttxXyW6J/bqfd0S3jkrBCHsaFwzVoF77Jy6oDXSbWmTp8tgTtETfMbJZQ
GtGnk8ZA6YwtUohMsVCO0LbWsLAZOA0x+K4tBimCGozyVfFA5DRBvRGDW8eNLtIGQ7A+e+KNSRUc
5Dpi32GSU9bBhH06iMlxDBcyQBUC1g9TBE+A0GekCiFs2jVshMc0TIbNisakpCQZOgEhLKTXSPeg
wnFBAdbzc9VehoxPi5rHmYIQqfTctvyNL2qlqYlLRGh5s1kjRLuxfLh87UFmsjUxTDFu6hpCRuaR
BWYoo2TqMIQ1LjDTfDFZxh1Pn2rqiETDxMFnPVwt29T5p/987nOf++xnP5sVL9jWz+TJk+HDt912
2z8ibcBMa/DhrE/mNkA6RcXYgWwCxORI0rYufee8KgPuoCrLvCJNKhrBLM9pxy/L8SCcgtOQs7hn
Xf09eP/LHz6aWaK9jpM7oHjvntPm/OVPpxx6+LPIeJ0yt2ZLrpy3EdkUXtR2QWHHoCEgVhJY9F1W
yNUMIx6UiGpTyE+sq8sJSdVC/SkGvFaM6COgZ2QjI4v6LTDbJq3b2IosMFiZkW/GKVyQqyEjr4mN
mG6p0SblQwmlHc3jolNEE3stFFwP2ZYTOEgRHtkwnMJk691CR2/DZjW0ADmLEswqRxjXUGUEBzVm
GMKHm47paCsU7klXf6iKpEgcHBWtMUchhY4iZUVsfXgehaITk1AwSGTM+NUErMenDfkQAf/wdsHr
cUGx2Yo32ooQcYwGPSgEYCDIhfMoUeTXZId7bGJdIH3obh2/rKsrkvJoFYH3KtIi7CGSCPa7mekW
Ig+mc1OGYTKuzOZ17Fm/Dh8QRgkcyKMvMQhCGxAJB6clunDvz2DB9JBsK9jTghVbkjVd6BojlVDS
3G3it5NS1RVLRH4MUJtce5yn/eFXNuoq3KUmhzSz/gO9joa/GckWGm5fKZUxUKHG7TBShnwPa0Y7
GTjup+V5u7JyHXgUuJ+bDd7ntUkFHh889A4RhtgzQx1V8Dc91JIZoPFV3xgGfzNGFZAMgvRY2zEf
DWgux+EqCSURUDLdTM9dUUn5mUoPuLfX4kHII9ukUf+AoIBM7UnmVjMpWWbZa1dBlcZBpRzPghwC
bk5BM0nPCpcniZSMvL6dU4MskBlN1VRIOiM4uc1Oh3c5xmT2aj3F5D/3BxxJPeHmtj55ySWXPPHE
E/+IywE35l2OQ6k5YLQUWQrV7HCTslzukqPyAs2UIDxaoWEaRP5DkY0Q8xBAmwFpN5GTRc0LB6bK
soJ7aBaD/bVFBxhZz6rk/t/k1RV5oggsYxthBGCzgb/hcZYAl7WBCBo7N0JP4Ol0BA5gwRo2VRea
RIv0jRAvoL2EYpMKSjpOqIbDNXRB7XQGB3NhxHsdBiwZbnQRNJuBaMqGsEZZFkLF8PRQuuQSgUmS
7e+295tkkmbYyQy3jTyTruVyFwW3l7isz+VQkRY2WQ4cbrKMHPSWB5KqjnHOuEF9TU7RowYqrrZQ
JY0A6bxXgVAYEQ3AlhxzM7O6Ed8MmvNmEdC0vIGrGyHDXPGaipZYvLUzPfhcimiSkLmShytDVxyD
14kKNifxW/HgG2KQhpcZ8mdGBxE2fqg55xDJPN6LD4dXmvLj4pkqR2ADVUXIq2QLpllJ6HBEPPQd
U/kUbCicwN9piggSGqbGoTYYRC2VPodG9EX47EB7QgWlTUl1na542ILMqg4akQVl8UFwNlknW0U1
ogobx4hWBJMqaG6ojkU2RcEhvsrUUaty0456QpxmhZxtWPUXpnpLy1NcjWSalS0aB9TWwdZA1Avu
ykBh9ayHkptenTBkgFWOcPfRAhihwklBcYeggf2NFROSoqbbz0xx5KUCyFn3jJrfiAdhG8KNnV5o
g0hC/QMUn/lwKgWbZXW2cnV/cvwCm7J8KqnMaA0PdOLiASkY7CPd+skqQbzLsGotAsDkuwk1zZps
nyBMbDL7f9fT/OsbOaHrN9p5bAcQCJw+ZkhA25DqbCGX3eifIuYvUmiV1tMUpJsRyRU3tY/2UxFy
9igydj3GxBlBP46TR8F76m4Kwo3MehedU3liPlo8w3YVDiM1uRFBBM9uYtAAHoVgYJqpa9jIQoAM
1oqHpWHbbDW2l0vdUbxw+GS/ThjNCadnEf3CVho1BeDdjtgoy+guqEARe5Sjle3QNjkmESm4e3Dk
FtjCiBqg/oHtWEjh2glmKEF1rhdVbYZBJXtjdy9/OVocJ1MmRNrGYLwAfF1FpikOAR8Ei1MomlfQ
kpXUtZudRLcTkCPRVHQOnT9DX5LEzKFQITdWQOQxZkKGKWEQX560SYyLwV4X0VwGBYnz+U0qyG6l
kEBZo4JoWTywCTFR+F1N2DYPxyDiQ/mWIT07wgUEItCCWwhb8OOEoRARFZqEn8wzjqBRY00PewxB
nqqEwxQu1PPCXmcqr8eDEH80KVRSwHosmj/IvSJ4sUfUBO/8pdwFsX+rDIfLqIPoj+HzkHcOUOpf
P9EpnYeD2wjJNLiQxLEr1eQ3WXCmV2CpMDxSV2Npiq6+PWna1EZUaTJLn1xgLM+hXTw7TJva2t6+
+skFEXbONI+gTVDF5qm7Nrc3F955W7y+wWOseeSr4KIW7m8NIpwshvgMfEAf0qhT4C91WaN3KRHs
sN/5m8TZWeb1YJrR0YgntIGC9s12CKem7hq1t3Y9/bwbxZTDp+/banR50eKd1/et15Vjv/HV5nXd
4u+vdpx4dHnBi+UFL/2v2Ci22rDk2k48qjhh7Ja7HoxXrq5XjnD80FneLEbMp7CjmsFB3tcxbRim
IdaO60RsI501eYB+vdfICkBoe0CZ5ZgIfYQo/x3uoaOj43Of+9zHPvYxJg647rrrOKeBN8877zx4
cc0113R1dR188MF77bUXvK7nGjj//PMff/xxZo+GF3PnzLn9tjkZZ4NbDr7l+FNP+dDHkFV+Q+eK
x26/640nn2G5qsOv+nb/ktfW3XXfpJOOnXjSx+BmbX36udd/8BOhw4o07z3lE8OmTvndRZd84OTj
9z/5BES1PvnMfVf8EF4ceMqnDjr5U3Dfls1f8McrrvZQwu0mTfzIl06bRHIGzzzw8F9v/01fd3c9
nwe/2GfmQSeec1ZLR/vq5Z0/uexKmXtm6I32mznj46eePG7SpP7u7sfvf/DpO37bTM0b2HXHfv87
Nx5x/KhJE6Zc9MXWieMGu3oeuvJHb7/8EgqFUTqvObQ3hvgrE84/EACmEFbAgo+DFLN3m1gSksKf
YZF6oSWth2wkCtep5tCVQloIvSnFkcGA0IoEV2zJ3i5flvU1nHrKbbDMWmIPEmtRTOwhU7y/vzlB
3Uwf11U4EOacTFjtXpQpk16c2ORmGpjpRJGf5oanJQ6hYmdM2EU7q2Q4eZLt2OXGk2/HSg84VUyO
E8pj+PSYXlPkFYXhqU1A3n3RhyEzqgC0KnQ5bTSLqpzIvLHTRbTrlWjEwQ7OqyCKR1ZpRRNOgWtT
0xSq9NNykMFEjtDFU7kYx5Gs3EgAUzQ2iKABeVnCaVEzfGYMMbkNI3RcI6Vf4E1HU1kPnGIiA/CO
78Qlkef09FgX7ejawOVUHDjbpMmNtT4yNyVti0aQG/ULREv20cDpAUd/9AtXXzHaiQ3Cyv/6YR97
cyFKfrxnzz0uvvv2UfRPA93dPz/9vFceejTQ1Y6Wjr2/9N87XHgWwvqvuk5cupDXh6I5AbjVRaqR
MsSUW5t9yKUWl13RzGQo88tMbUx7R2fcqqK710T4vcgV8BwDL6Xdxux0+eyO6fu+es631v3mflYH
3+3enyEw5Jgv7Lhp3SI5cPa3vwk2pLrmlx1fPa3rhz8vLXhxSMlOO4PpEpqY7lLHiUe1HLBP94Ln
9crV2il46jymyWR6OZmnYPFpSW5UI1ueFXZ4GOMwq6rnjslj7FLmsUtO7zXHoiLrFOF4YWSJU8Nt
8U/8C37AT9xzzz3gUebMmQN/g+N56aWXwIVw/wbcCat8dhLLJHxg3ryUl7e9vf3LX/4y09vA+5Mn
T+YXK5Z3MjcUZzPwYlhHx2NvLHvi/gcfmnvnYHf3Uad+5vuP3n/1CZ99++E/gyEYM223Xqn2POtz
De1tGx95rG3qFFi4SXffW7fcDk9g4qRJHdN2P/WWa3Y+cP8Fd96911GHH/2NC+BGjZw4fpeDDnjy
jt+C13nvN7+6sXPFvDt+Cycw4+RPnXr1ZUvnL3jijrsa29sOPeWkj519xmUnnMIbpiacP/KUT1/8
85+u6VzxwNw7x06a+PvnnvnJZVc4OBaum4t+9INTzv3SPTfe/MhNt06eNnX2D7//qVNPuenEL7T0
DsLZ7nTQ/vudfMInb/7xKw8+unHRsqmf+cQXH/ndqWN3qhgzLigi9S8Bt/oMcnjEjp2JB0U5uRkg
8yfsPKMiRIAdeIQsqkIhnvSzyEMNSydWchFNn3YDOrY1AgkK1rdxt5QMNtV5ZDJSrIkithXkVKnh
VCYXw4kfE3YxsVhtrmkr7GATsYKSpASRdh6tSLBmtjUtVDKsYItCEs7bM3bz4IJxYmIYCxtyfiwz
ynpu4IeaqdCfULoJKWDRqGa8dfh1/STYzPA/sFbNVEbLTh0VKblsIT6IAqUXTVQaLVDJUVjPzQ1h
E2CtP8TGkrRwhkaa3eG+mjBZ3WXDfPDckMf/sKD2VKhCZhwzROh7i9bF1X6wqlsSVEtjkNseYfMI
HBmRA5ixqR3DRq5WJURUUVRqeqFtkOZqW6fvO2r6+6sr13bd9QCsqFFfPc2N/pgGEx9Z7Z+yZeOt
19+gXSr2wZkzTj/vnLaO9qfmzb/5uut7urqmz5x54KyZmdgL1+TTDzy0ZtEr8Dt7H30E+JtF859a
OP/p4845s6W9/cSLL/zO8SfDHrni0fvgP99ZtKS/q3vqjOnn/va27x/+8VVP/e2QO27c4aD94+7e
sL1Vm7S4DbHmobM+dNQ++yV/elIsfdNY1VesqtkkhtiMlGThY00UxogsqAhdzSRqfr0F0iOGLeRa
c2iS0ZuBn50vv7B38Wt9S17zWAlY/KT9Ex7/ocNMd++nNictx50pV62rmf30xFQ8gEXekWQzBUZF
O9Jlxa4CLBzTvJ+WzQz8p0puSToKnBnskzVTPoY7sFTKp1/JKFIbUo+WGa+TrfjV1v1EOm5oLGTD
kvHz4cN/YyXNZzDMAA2e5jvf+Q68ee+99zIjJ+Q64I34NTgh+Ff/u7/61a/A31x6KUo9wvszZ+IK
vuw7l7KkLpts0mWSECUd//79N3aupA62+vsDj1zz6IMnXDz7+ocfgz3PWlvrH35swdkXkwiH/MBL
D4/66MGrb71TEvfauGm7l7p7vrv7/rACHrziR1e+8rdDv3TaSw88cuFu+8EzfuTGW6999bl9jz5i
/h2/BR9zytWXPffAIz89/VzGAT5w4y2X/c99p1195UWHHZ2f1BFjJk0Ef/PC/Ke++smTuru64JHv
sue0X/z5EW+eZs6aBf7mwbNmv3DH3ZCPP3v/w3+84ae/fn3RMWef8fCVP+6nVXHEN74y58CjXl24
CC5t2cJFp9xyDTjCZfOfHqUiTZTPJaoPgFmRGWJQHmtgung/bkrRMVaQJA2ENtMcBiNPtDQ10G1n
yYzXelI8ls8yKaiZiI2lcqIHlWYZsUGhwUAPSNkhwlZiSBwysmPcapFaD57Z0zgqM167LMycJ54y
DErksVDKdVCSg9mx2N8Qcw+W6xnbU3anHTrGDb9LuW7GWxfuHsa2xk68cozMgptYt0ywDl4R2Kfh
7c7p9YBJ2k2QJXCE43chAzGcFHrcNhVQN045Cn07g0KwMUtjCEEAN/aR21BaXno7BCpTgD4Rb9tk
1A5yUZTKbEyuvpTyqrWoYHfZBOnLm/HgMjE4oJO34xI32NqocwNnNZaGQzk+xXkUoYfJcJwqHrLT
lD1OPmH3i1Brqn/BC+By4MWo2af7y4TsYw8hfvTdy7XTmzniY8fM+aOVhUVPM3PGkYccesDMGRd+
+1vZR9/T1f3rG37ChBFXnfbFP93+64Xzn+KQ4rMXX7TTtKlwASdffBH4m2cfePh7J5wKN+2kiy86
4ZuzP/bNr/748E+sWry0suAleCKTLzzTlxOm7bXXH/76ZyvG+PUvr7vr/lfP/has8AFK+hkV4ukv
Y1p7hKkxXEwzuSG5dJLPkzcjXJPTNCOtVJq0Xgo83x63X/vsrBOS7l4fc8AT/8mfH4av/sKhRzxV
HLbn+MMnzD69/7cP9v32oe3+iOIjPbfeNfyy89efe2nTETOjqbs8+rXv7n7hl/Y86rANnSuvOOGU
eOkbu8C6goNP3WXK7DPap+/b/fTzb118dfdipKAFk7XLRV9snzplYMWatXfdt+6WX4ue3tEnHrPd
icdsfuTxpqm7NkzYfvGx/73D5RfCO/Bda269M2xrbZm66yvHnmYh1H5M0OTYblJdVSOyGMXcpKbJ
FdxEHTu1o8wxJjfV+y9PcWbNmgU+I6s4wE4lK/Q55A987Nhjj/W+yoVLUmX400JPgCokZBJZpM2S
+U9hpVihKcTmc3fvkrMvLlgNJdHz9PPNU3cNqNBUBMvS3vbk16/gVhDYBVjcTe1td194CZ8JZPed
i5Y20bKeecqJze3tc2d/K8MNLn8x+5vTZkzfMa+fBu/PIMm1ay/4GosOwElCJvTDr17Ek497Ry1n
nHsOREny7j/tW2jZN2pF3q2e/vuu+OGML/23V2h+8aobtixeJsmcLXkS9RFgc0I4jJgoKliz6mKV
rA2yDDhgMVtA1jBODI9ScvUJjTu4hCJF9zz2T0Id0gs+ZnrGuW4k844T4wsWJfqJIXEj6T+SBCSC
f8AojA8KHTIcspjQo5P1SYXYEBQjCUPLSGSb8Er4RW/y3Vrp9HelkymzGDzjCCUZ9l2QtjBSJAK6
iP4uUP+54JCNzARMJK+S708FB5tI4kHjLR3AefVkEw4PIo/92qTSGZfW6PJmUnnptUOFRji2MZ4e
3WriTUl1tS6vSuCTVXKoJDXmiJlrUJQNjvicTpVBEFb8uMyy8RTtlpycFWuHk0Cyjh27cNXkSKoS
KxkpIQ8+oNB2VHH4YcVhswrtRxaHH1homxAUYEeMDgo7hg08ZQK/CAZ6Cw11wsnMPPnEvS46m82o
pyVeftyZ7xx3xuvHnr76ljvZefz8+hv8iMblP/4RepFLv3vUIYd2U35z0qmn3jFn7lGHfOiYQw49
9pAPd9MWnnPDjb1d3YlTHH6JFG9bO9oPPOajzAkEzxT2Ebx+7Pa7uO36yI23wH9OOeiAQnvb/Rdd
+vL3rU5SwUkt/PKPvwN/s+zBRx8/+UvdS14dc+IxkJ+VaCq2l+4VszmwvifrgXEhOsmAfT0En1l5
Ggm8E7muCSccJDBGej9EwyqIjBxM/LS511RyEw5yjxnTIeeDIyNcftzIxgP2FuPHYHZ4wN7wZ+R1
3wonjF2py5Xddmo5YJ8P3z9316MOg9+FnO/Ib1zwp9KWdUkF/nPS7DPhY9XuXvA6u829ptrWPPyj
B7//9uubJox76+bbB1eu3unCs6bOvQa+rnHiuLbp+06YfSa7mR0vnz3ujM+AOxxY8trE2Wduf8Zn
4F+la0dlADipZBejn2NXgtZ52m+TpwjItqIVkYQphzTQJuUOD//FnmaSU0Lk7ssll1zCPZuaBs+7
46HhV+r8jZfec/pL0tN3i5PP+dLJ535Jku7LLnvu0U9Wvsg4YylLK9fQzLNFapVXroGnwpEs10Ya
Vq2HCGUrrcWVi5buedTh/d3d9YUhlqO+4O45mUTWPgyIzrIzKLDIW8hLvbFocbaoup5UEnYLm1qK
7ROmTS20tx50/680PexDdQy7sam9HXKpCk7I4JcPrlxToQeJKljLsfwYtLfyQEyJqHzhKsCO80A+
t9xZMahCoiBZ1IOg6yUpX9FCpAPExQkpjmWzx9OQKS1CFoSSKgayFqTkag9ixmIqScHphkq1B+Fe
YQuYs3AbtIY4DkLJjevK2s3AhICCGIJ9x5RVISJL22WykwTSa7G4WVcC3ekIMXiaofMRcyy4YQvL
uGXsL4ZuqiCx8DamuIU7gMhyYqGHYBnRVErDWaGhGWZCsB2QQ7QFYbeJQ5qvhBcvV/tG0lw9uBlI
I7YmcY8hcU8V7xqCHW9ossVDbttayhau9uDWpdYOqh3hiKt1ITxUa5xZD9L8zCCpJTPUiXT8Rdkw
VpDkmuEp2iYVTMB5xqhCsUgL8s2Exg3lSJpOqxD1Dpz5KNKOi1euXfmDm8tLX995zo/9+h9c8AKO
VQo96QaMF39x/Q1dW7vYhIHPmDAZ9/tV370M/v7pddd/7ZJvT5o86TdzO1d3dsJpfPqzp7Z3dICX
uv36mxjQzDCWto6OE8754ifOORNiuL7u7rmXoRLrdqRa29vdRXAelJO3qdW03dc/9fcB51hJnSRg
AY7B7p7ff/qMXcLGN2W4z+3XDT/i4HeefAY+uYlmPwepVKCc56BKsjFDza8QL5+CFJDFihqpOspE
dqwfmhDdLcla4gGeveq6D37t3OHT37/L5bNtuRjr2IlPeZnpQBC4dKuxo9mv/uAnf7vj7jvXv335
Vz6/nRBPzZv3+Y8ff+JnT7n2lz+HO1mi+Sr42MP33bfgS9/YZfioUxY9Do6t5YiZE086Dt5/4Rvf
W3/X/RAZfOitp8EbtU7dlR9QZeWaV469BNzMBzciVAHSGoiq4QPvpSaTyIn0yCyY0HWJuJonXI9x
m0Opxit95Du1WvokiOsK/9qfyZMnc6GMHcacOXO4H5P9eRdUNIMIzj//fPitPK2ZlMzH5aTu3IC6
PPbUk8/61jcuOP6kl+c9RZBodd4Przrm7DOY/5iP4JkcM+VI236kSZGoTJYIlqkU2+xCcL7yxyuu
zpLRwYvfXPGD5YuWBHUPSWSSIc4beJhjt6jJqCLkxXFP36Yf/kxT9bmPAGZvJoMcciYZ7lgWZeH9
A/9j/scuU6W6gYVNx4Q25mQFdtdWHHBLGKTAcX1k7wbE3Rhrd+uEoJ+KkWAJVQxCQq9q4of20V8r
Ck0iWzzPpY4JUEMsgticOgGNjqgbzO6YoEDdDpMtXnMdmdh5sZpBbk9tQf+qiXwaGQ3IR6LXSax7
sAPPMTl2Zaf/ZHZy2fddEycnExLVjd1XtiaulRsdFY74TlANzY+5sQRDRFzd1A/DiK9PWB571CFO
EFvcIoKqRDrIYSYar4pV8tZwRQur/U9VegJ3K7YPChopkCs4vBKXICvqCeNdwqZ2EqoxeeITz7pP
JEzYBjNULK1YulKjnLMP6VcZM9ZArWzPge0Lqgw99AW6mAZHirayh027tbqyhTghKyaEF/3EBIP1
PYUXDlF5MZBg0UoqAEtaM0oFXzDqU8cUJ2wPbuAX19+oHSp6nJM2p0aB9BagYCmf5YWXYHntjhtu
KnX3eLLwpvaOax99kIXVb7v8qrtv+OnWrq1wtDWdK7aHA7a1btXo0Se44PXtRUsMTjpXuP8Hu6/B
DX5BfDZx+Iim3lL7HlMw8ttj1zJhHPooZ/WZaMUJxBnXsEmMZy/EAzVLBdtqUlCcHBSZBSO0VAuY
VrLG3WbEW1c/pOMJQjz38kurzrzg07/52Q5nnsInuVFX30xKfs/yOfBzHLCYOLHs5rlvV/s2aZ7W
FT+57noILt8mY2j5Oun9uXPmvDC4YfTarg8sXDx1xvSB8aPHHrgfvP/Bm64U8Mf9RO1t/GLrI08M
LnkdEhprpp5+AS6wf8ELGfhH6l+FZUZPec5kWkyzohj1/oblXYxT7aoxjyoz9/pvyHJgwbGP4b8h
oWEP5PObd5GUHtbR8fjjj1933XVzbrstD+5K9SJDBkNnpFjB5by2aNFz856MLKgJq2GCCgUR1TS4
/xzIGoabFIDRSAsOwbWm4lC5NHyXSVAkJkBL+Mkte3KBB+fAou/u6kq8X3Fnu75zpSAEwQO338kH
GSYjnlhqk2FFBqUlr7cfMQv+rnT3kCZHUtJJoaW4avNar4jD4q2WbZAbyHAcouvoom3JNS5lmwRW
dgXyG9geFcvYb6/bKZVhmzpxqC3F6jh2/UkeWac8AFcYxOyHFDt2Dhrx5gjdimGyGqGiQmakrB4J
bXLvYwMWtisz/zMKqEIBYB/uyQr4sxacpMNlWvFugEblDRNsSA7JCUXqmPNjl+IgGNqRqDsiV+MN
ekTcCjWkLA0k/cBtJBqxtIxeTBtMYhOooltJfx3vUkkiXqAqgsggu91uYTPc3reS0lOV7kGNFZut
IuaaTBOBwbQ23SIB4/K3am+XSXYPm8YSPaUbrbCFDg4YtTF2rC9DjJRQ31vbS05Zf1hxp2Ih0Za8
QGSCVk4jDF8vQaoajWLuCa5IJ5Q0M9MlHLbVBBWJQznwgCaHDXIoOn04r+2pozPn+hvBPfgqzaKX
F8LihzzmoFmznp4376BZM9GwLlzEVbvjTz1l/KRJvV3dv73hJ5E7fzjUl3/4PfY3/7XfQUsWLmQK
Z3im/3Pf/Z8/9+yPn33mfffeC2v1K9/EBGLx/Kc3bd0K//lmbDYk1V2p/QZGvEGo39/w00+ec9an
Fz4+uHJ129Qp3j4aGgngfJHqkMZpugseFbfMhi5ujCjFGUHY6HFBkVndmG+ij7bSFiqowvfCA+VK
2sqkvOT+B8Z/79oZX/8yH+SNeBDyXX7d1NHW0zOw3R67canTF98akcsVsqiCyitxWCYhVyIeM2ki
uKuyLndMGg//+ebmjTsuWrLjtKnzv3dtdcFLyNPR3mZ6estL3midvo/fd/1LXuMXzVN3hTw1bG91
SbBnUxMe1eYnqLK89XZ61PqlnJFUIhWwUHVgtAwxmKln0f7n/4AZZTgZ92Dg9X333cepzLXXXnve
eef5ydAO8ijwU1Nkgx/W+nzs8cfnPfHEpd/5Tjqtwn6VGg0d7R2wYg5EHEFu7HZVZ+eu06ZBZsr7
c48Z0z908kl8ZM/YyBS8gWX8lCIVaLFrDqLU7VQ0OogKdgA+5Ub1JzP/jt92Llpy6g8uGz1pIr85
edrUm1594cSLL/RCCdtNmtDS0Q4n8z+3//rNhYu//MOr3j/jIPhScDNfOPfso79xgS9Gr7v6Vni9
/WUXRO2tksqAkz997Oc6nz9k1qwG5+lQ3oai6dg94lYa2dlErQKDMmXaJ86YrFADHTYJY9WSXBGW
CLioLIPqOJJ5UBSPLhaJUj6yNA1IrgPb77Bixx5h80gVMu8AZ5BS+kaip/+pnSOT7ibHxN0Lpq0H
x+6I8dMYTgjgdsHm2YytkUTbZS19b98R1ho/I+UG7y1aWju8VkFwdmKpbUPpFagc9bK0fazAtX9i
FncgH8wwswJlA8aWBaxEEAI0SNme7RdbxuES6Tzg/JclA69UByCMgPs2QATer8eDS+L+VUm5RJAw
EidFeNiiav+CSs/yuARZrDaeqNFybwtb2BEF18G2nTPDICvLZtTP4vH0ol+zgBi6umpeVlFa0QqL
WbCKgvQwGpWCs20kYGE3zaxAMrGVhiUhLXszLj1f7RvYbcdd7rl17GW4Sht232XCPTe3f+oo+O22
I2YWJmxf7e79y00/S4gjYEtSffixv8J9+/WcufDhO//4+/kvPj995syerq575t6B7UYZgP+AfwJ/
M9jVAwf52V8efqmCXaKZ1OaEny/+8MqbHn3o5j8//Mu/PAJXdOWl3wUH9v6ZBz365iu/eW7BUad+
Bj5z3Ve/1muSfT9z/HmP/H7Kpz8O7+z+6U9c/D/3TN1rz0e+9t3nrrqhd8mrurtv3V33YxVrxRrj
+MfKJNtBuY72enSe6ldlxvsaEGeI9J0QWrWrkGdRmSyKsTmw3fjm+6kXei7mb1fd0PnQX/hawAnB
o+fXv/3ro7c/9/TeRx8Or3c445SKKwlGhEeHZR/IFPHsoYm+dnLTL39x72N//tubr4PDhvv58zm/
+h3d5D0+88lw4tjhRxy8+9xrxp7xGQhVs1NQcXfvBroJU+69dZd7b53y2K9FJkznfm06iiAdJ7LM
sTnYsMB5F2mFUFONc19hyqplG5GbFP2/nuV89rOfzcIBbqMffn3++efzMA1kPJDcMCT6uOOO8+U1
ePOee+6B1xDXPDFvHnxA0ue9+Vq08OWLzv8KvLnk5YVfPO/crgTFLg/dZ79XiceM6+NXXjD7vXtO
e+j1pa8vWtTa3gGP8/dXXH3Wrdfvc9bn3/nBT6XjuFM1AygyhWEQT5doQxxcocURmfAISJzHGl75
kY9/+e7brl/2/CvUzN/toOkP3XjL3ZdfzZ9a8uTTJ8248I/r3nlr0eIz95vxlcOO/vGfH7jxzw/1
dXe3tLcPrFjz0innve/26ybMPvP1404vr1zz5nGn7zDnR1Oef2Bw6euqrQV29ZKzvyUWvDweBWMC
Pklm5VLuTCCCXk9sJQXibukj7mGng4nTnYMi6aaxas7epKtKCRKh4gKjoYK45RbwDD8mHTeDg7+/
0AqnQQOedrwuk8Z5wvOhYdDaif5uIVAcix8zmpkLgCODqNkEsEshonwnKY0TjDiwg6JZBlx+yqHN
DExGVMpuj4qwfSwf7xOfGPoZSRCJhKZkuK/l8wzeIVy0tL0TBwEXaZiG94YEGmynpJ1GpuCcF1f7
EQ4nBWc2LELaKxB9wKRhBJVE7ICgWwH5ENjNaVEzcUlEDCfV1GdiItoAmdQMtegEDd5bCQOTgb0K
l/vCxyAoqUg7ds8WIXYNKoZRsLJDQOikhE61gYCFLeRfI1J86CFzvBYzOvwMnPP01oZWV59R7a1N
B+wzuOBF+JLhp2MM984tt7f0DnL8wSkaXPilX5kNj+mM887Zo6Nj5fLO0z9xQrm7BzbRB2bO2HXP
aX1d3b+/8acqI3UI59nKGDMh9plxUAY6bzZ1bf3oIR+66pofHzRzppiEoeR5nzhx5aKlyOg8aTyD
C+BnxKQJ8GfysJGNwRo4gRc/9l8QSE258bvwT5uffo4QLoYR0r0kDV6xIAvBHLg15W7CmyDhKXGZ
Q5YnPfad7SwV8YKSqVIjx14HjveinIF68exvwrm1T51SJYDo9y/97kWXfHv3PfeEk7/gkydd+vOb
IQCt5IZgcomCrlPphp/TPv+Fn/3ql/BixfLOz378k2u2brnhuusL7W3/de45M2+6Ct7f8vRzb37z
6hqlR1iByy/+IVzUyBOPbtx9l/VX37r95ReI/Lx5ts6mpC/MOOZpWUvFxl7Hk0HXNR3sAe1EDo/D
S/OvGACdRT/gP5544on6zg1T4HCFLfuvkv7JDtw88cTkyTvA6xyzqUR4zOKXFzKQCRYiLIJVnctX
L1+RJfTE8b2Ojv1nzgDH8/L8p16bv2BsUDh01sEdqzc1rtowZtpuED9Wlr6h3E0PJ4yFYKH7qec1
vY4mju15+nmq6SNGPh6/Xd+4Uc/Om8+igfAgJxBqYPnCJR6QCu9MmXFAb1fX0vkLNhBYzs/b7j7j
APjMus4VaztXcECx94wD9581I1r6VvKnJ5FZYOoUlGVc+ppni2qZvm/LAftAXgwbZqCrux/Fg6tb
Wxs69piyafEyiPsgmoZDwZvvm3ng7mt7N69YCcaaBE5Q6HCdrgwQz3GRyoNg2jpR8TAhJHTApqfB
kYiMRHsnCRNFaFESDPUD5H4Bg8mYVewApzcmKHBWhAkZacu3qTAcyuVwJY0Dww0JEuODLYMz6adC
dklgfrBvoRXSpsBRqMG9XZVUVsNnTDKGuBErJi24W6wdGjjlOD0NQ12rDmMmiQ+bBoOSKklT95H8
DxNU09yDReaEDhPsDZypk4kyjj0TTPPEoLg98e0z7RAnHzjjQvilQQch67UT7IZhuH1kx0t0YnyN
seNfgS8aIaNdwsbdoqaR2I2zyRyHmVRZtVF5DyHiSpYt22OHLMMVL3icpLGoPzv3Q6TphLaizJW5
3SJhqb4VWUm4lnYcDFBvxYO/HFi/Jqn0mniQcMMs+XxCw8jJCGYLssKd4Hgg3Um6e5983+EPbVzx
+8FNwumkMXAuoRs+YfKkNZ2dReLEbJMBRFp7zThwzuVX/fyy7/EcjA8aPC2Nx0o4ugfWLMDgZuSw
YRVyXZDWkwQffhIucIQKmREKPMQpF1+039fOLa1cA+fWPHXX3iWvPTHzE5CRwHUtJmrnHhohYCxi
ycoW2LXnTXyRsu2JqmGvqHlS0NBK9J0c+sQkENdD9TRK1vHRVOk0YKPtGjbCvRqGiAwD//RMpefh
0hb4ZFNHO0qsdvfArYag7fDisJ2DxhZq5sE5vJ2U/lTe8lK1r1snJj/gma9LY5EGHDZHDwzRhHPb
e8edp67tnRI2DqMZ3tCVE/jGtkzdFZ5LecnrqL83fd+d7rkF7szi98zSbjJa59X/VEYFRjocSpAB
jmZnAEwd8sL/xE6o6V0a4f9muhoxFLO3TNszPimxaZ1y4p5pamx51YSHrkWuY9lCrIsQTsL2HhVE
rAXiaU5SRXE7nW4pIvxsHazO9UkVcuTVusKptKgFezDFHv2uMTklA+afyOBAyHxDzh7uFjbtFDY2
S24jGyVlRuAoHYeskDMYIJzuO0m5AVxsUoE8AH4FzPd7wsb9C21rkwrTmCMuWSNhIteLmMOqBxXp
yyRVoEieRCoX9pLDCBiqxNup7AyBJRGQPF8pRwfRvlFLhYv7hlVe1GSaPwWXE2zD5WyhQs0guBwN
N7ACXqeLaHjGqMKKpATnD/dt70LL0cURO4eNVDvCivrapPwCFcF3D5sFOg/jqYK92mDoaNbY5ZTt
1FFirB+yNageEzNDml8/JMXNUCLJuRf7FbaATH/JrDkRNf/3iVp2DZsmBcWx6Gt5MBMPDrf6b9We
1+PBTURfBrdu0HlrBsi5nIlQZzi3ZHxFS1Lpr0IcPGA1poRNe0ct7ZBSG0tk6uhkBD96cAM91Nsv
WQdsTCYz48QXnE0jOZgmZen9GWxNKY5imtQWEqdhfKNyH+CSF9yluwY3gJXso9sI37JD0PDRhuF4
YjKMMlKPmFXMPq3xgL23PPzEmzfPfbbae9vA+oS0kSJLW8eaZrZf2EhcAO+ZvMNFP8NJlG8d/xnI
XbgqxZBunUEb8rMoElZ7MFO58nNRbaTqpp0EZ5PLMocjDVrDLsNHve/Kr48hfPCmhx9f9s3vb1qx
ElYgNlqqAxtNZSs1YOjb3aN3go0i/y0TgiLkoAwciJyJN2699RlUN2BF0YQANXAC26lCBzpXLDuX
tF6py3cPbnqh2jtIZNgRDUKBFTqqYQQ4pxYiiOsnEvGHSlvg70FnObLUjjVN+8Cx5TL7cETe8b1h
08xCO2uKFx3+no+1z4sPFSds30fAAUh0gvbWNRf/aOOtvzEZQc6MOGQmy5E5XkqvYlCrjW3ScFDk
dXq4FGzsMvjPo0fLEif4wqKsVZqxhGYqoziUrzka7VgouOlNNGb2FgSOcq2e/kE4HFeCfCcyK14T
krIOGFymk9oiYqrDemqjrKm10/7S5KgjVCoCL4lXRhIzoKoIk+OmdCMnXvjdyx2y+ZCoTxXBEt+I
I4+Cya9gY1BTAaXVaIIER2E84zWE+Rsw/U+8wY2kL1vjMUm+gXBrlC2TdoNMZefJbXN6DbHk6qQC
MRoLJg6KpAl5UZVMiVOlyDAysYaKJ4WEPQn+aeewAf4N9gZ8dZ+Ol8WDi+L+Fyq93612HlUc8d6o
CT5TMAqM+8gkeq7SOxZZFENueoe2VkZs0I7xhdlKYhssp7c9cTTADdJO6UtLmI3hP/iGRqe+zMU9
bnuwNYcb8oFCy2HFYRATEDAvy0aIXwpmazn4y7jUZZIRKoI9T+g7rF5C3gk+ddApDhiX0/D9YZ/K
vIpc+4blCY5kcbUfC+4cqFqwmSFpO6JvIYLUghXR0YmNH7Oc/4xz08wkbckkZOC8nbGic2ShiMhc
ce2OnWJJJBEtUQiAXq72NyBDNqbCu0fN4ymkCOqIijZf/TND20FSiyukL4OP8YV7+IayvTHsC27s
XMnD0RVLeCEcB4Qgx6O9dGmRjD7vL0xEWByaeg9FUopi2QWanbIw5XECuYW2V4Viz8Db51yy/JxL
WOWBnRbJTmtG2JeoAeZT5yywJaLhG0a+tZCblC7lpWIyAilZ7zESqGw0QNnzaKJvYFp61vJhOCi4
nbGiAFHa28ngIE2eMaFHOzMeOZ0UDnogaqkav+my6idOUNWPdTuaFWYy5VBgQ8Ic5AVW3whcwAqf
ee3Y08fNPqN1+j5BW2v/ghe23vVgzyNPeDpHZ7/qKPBzCq3yXfIEYdUCc9TXOiVptHXg8D8qs5EZ
v5plc8q6mdQtyZQZWtYkE6RSGbgdJ5xh4iTDMsrIWi+VFb9z5GDGZMT4FMNPDQbmsNyCBCX/Ysva
aZIc1jADHxSsOW3Z1P01wvHBQrUgkYnsQwsVFxTuItsnz4C9HPMEjsHz1AhYFLL75T6aPgPT1kGB
FSz9iAQrB0RCQZxmkWkqLmlXiUpl64iRDG9UwfEBh0yEjyLTiqlVSiYV7oVdBD5ggmpYHPezIhxD
aQvKNr/qFyUbX+uxiAWgCenTEBDBrqLPAUYPLrQf2zACsrTHK11zB9a/L2qZVWhvJcWRV2SwJO6H
d2wP3A5Co0ePXZepaivpNjoOHdRVUUcnwv9EoW7hrrcBJSoSRep8hggaeJSS0g7dLNXMQsfJTaO9
DEEt/agRa3V5TVKBX4G8eQLdyUGr94zUKT064VLeOl2BDI858LW0s3UViTfWosiY/Zq2LPzKi9W+
dUlln0ILWnnS72HYIfdIuBbajOTfmohPHBzcWKlNO0VEW58ZgIiHQjGanOTGsc0AawiijzIdnKh3
NKmsKuqNIeSBG2wNqK5Esz6mVrOyFoVIE3/I1GdhjRa5IIxFxNAksnJ4S8qByMGwa4+sqJVQROie
GJ5ewCEbvsAB6sZRWobbBNzAKOvj9RpdgaMViIkOVsuooNBGAkuBI5TjCVlS8cDkBqsF6LDt1JfO
i//yHsHKM8lLs9Y4RZkmRKE8FVIlgpthocPOmEzs6wEIPHUPJwzns0fUDNHJ47q7j5qvcMyxpGpa
pNsrHOalksHFZD2NyFLgU8RMwlRokXhwmCvkEBMTckQ7vfBUcaeycs2Kc7+T5VDIUQmk9INWq1s5
vEyKN9nGXI7JM71Kh4Lj3aq96IthKOy/iWCtDmfpHKnMPbnsCIuQuVynpvIm8pK3POYonfmm4Uk7
ic35cpDjNcqFEv5ZWGbJ/AnjhheKIxq4m2BSE+QntmFvlpXPYtJdeUS4cI+h60yeyKsZNsD6pNKC
pfaokJvPkFkJMq4T8mgnuJ9WIg7eSroDu0SNXmMcK9QaizA85haTKRzQCdkOzNwiEmtQTnKGbQE7
S0LKKu42SzYQFB0rHgiVKKP5TjJYlEzUhiOlbYRh8zmZzx3hujYkFUllHKpqhqz/5ruvNOqECII2
FUAYWHR35tDisPcEjfeXN8M/QWw4KWg4pNgBhhi8cgcWx8GPBqqmxm3SYTQr3urAwYoGP8uUvhBR
sWTYK49fKBo5gkvoIvB3QmUu8KZfaBqzV9SS5/NNBSYgDt2oq/DoW0g5NKbZqTL5mMSVzkngGW/L
CB2B14Hnu5kYH7gsDtExd/WZ1AsNBDN5E7QdAtVqxUwN9Y5hQ9Fycdr1iZYFZZBMA6tLoLCCZjlU
YzUx8YnjECuG3qhSEbiULqTceQDCCBUMSE21NUkz0djbg5szjMZ0uoxeWh1AdR+S7obvhZgGoquJ
psjUj2aoygQNPGouclZFqhvGNstNXtuStSabmFhyUrCbqSpVTCxzMdUHirRQSXsCmV7hY0wbAXFA
hwomBg3wN7W4dHuA5a/tgwLkzbBICrY+5jkCMMvpRUxzbOurxnCaUnVVBI5FIrohrJfawIkUEWhp
hMLDRodTYrkERJiHtl7CiK+Ugc1B1zj/NpQMISHsrmHTW3HpjWSQXdpwijh5TQakZwHbsFUGW1hB
sXZgwyrZh44dv0B5mG/CtRHUE/6MxQE4dGO+5UlBt62dbEuVwGSABhy74QQ3XXgg//dsIet18qiH
bNKDO4gr70M3qf6VZTTlshaZzxzl0EzGUtTp02W9Dhs+7WJe2iVWOAy2EKzIJgKDBnwK9kkMPehE
gaFXJSIvjSTHeEhG3K4QJRzPlJxQWscT2HRKeLpZ6cITbvc1UDOfLTWRpesegRqF2Jv1jBomBXho
e0NYuNECXkdInK9cmZTGk/o6C1gNoimM+yjd4WL6AAlRB3TCHE8FLtfhVMPwOqYGWBkn6YhADMvr
+D4EaCxjLB1LJveNYCl3aWwqbBei960S/6PMOF3IwNi1M3UKT9WQCyRgsSsKLU/Kowh0QJzNhrOT
Awpt8LuQ7jQTXohKcEXm022hZ8chf6Qk5wqGOi7aUdVW6VbzpmUlUIMRdFB0/o+HWiCMHcBqviH8
XlClPjkOC7eMA8slhMhwLNjag6a0AOzvIAnMoMPQCBngQRZWkIxd35tX8gChBso2xLNY0ogEMirG
Am0tR460SQyXIvHcRLJD0ECEpNahSpsSkQYEEiAYz+bAa4Vrj8QIALdLKldtC6zcA+IIulCWVHHv
kMb1sbWDBiuE5ysWVfufqfYgAoJkmbBvn5ThhiTbFuAyrsvCNSLjZqSM4z6JeL+4DpkWxiP7GfeV
guhsjyRhVEXFDc00kWY2OQPM0pDoOkAJuxJNFMEHtiMxVogFQ3exnJrHDiEJXp8fnOadaCyc16u8
KNKyg1XRTOkCciMRpWkgOThAwoeEcguOriL6vJDCF7ik8zfMCkqPRmu3v9qozdOsMZVsJ0Y7msa1
/chmgqWAw1iPgkPaK0NLKyxpewG8i0PapA1U5+8gDDdsE55jGy5DeIcwQaLqCLyNw4kIV6tXKfWn
TZFNTu2GWW4xfOEyu8mQGso69uiUeVHaqWRZJzpuH3fkButMyn1Sq8Twz3VC9ZlNtiWjXBEpm+Wo
rM6uSRVLTZoKmLykq70iq51M7iSwkQU+myYyhTWFNT0UtNcP3Ilcy1pSLgKpvZ3/AKshSNyFowNh
0cX+ZKySLm+GRsLtDCNtLu49lDARSbaaeLhOikoGdaKBjmLGGixYkbzmxlBtYTQqayGvWm8SMxSH
tEHR/PF8hrIi3I4NyEv+EPQ2sDP2yrPkUvsXvA7PxCBErUqrYwTOylT5TbD+vYQ3C9xcoS/0kyAx
VmZ6iXSnQA+Hhg1l1abXFjBWRKZk/U5SbqN+w0SS9TWkZLNz2LBRN8PXrU4qfJPBoLdSHdK2TB2F
pTVtLsD02BjLr0z+hoTdBLesAoJISMSFa+7PlXHAM0E5MmMgsZigikKYPJOc3ZAlRAxSh4Z8D8TX
PehssHgI3heeIKQ+JcQCWHJfjj8Cb/6c44kk9pZb0efptbIMaQ1j7Vi5pIDcxgi4gGwDHtNOYYOF
xdsalFX7DiW4N8KPmzRERUshHak+lxbRYqK8JtUYBalLWAltblc0074YIUOayImfqvTAV6NaOdlr
uD/DJU6lWOq5oSwDW67IT7MZi2IgKIHy6ojeB/jxfl/f5rpQgRZeTDncgEBEWZluGhfZ2E26uB5f
tJH2XSHABTxGFbYjibnY5OZa4K4OYEyQMMo0cPhmRW0nlRfxVc4rM9Nd5JIYb51jIoliC0z3mSW5
NW9ZLhsSN6ghYipRMHAoLF0ySjgijS5G5BeE8vggfhywv3YMGl6LB5ByNxOCB27n+noab3+4D+Bg
RgYRXDgXGzjjYdYPSVB76QoPxrofmZc7Ml5Hx2QYuZx5lJw0OyNmZQiydBIZw2jcBjT1LoO3KtiL
kOnZ4fqYxcQphGYlesw/xevI2vwmzWzSQmEqFC09piiyjl1ZMW3iik9s7EP84d79GlvC4mfDSRKb
Wh47gG0zOWwYRdhWDrtUXmvIi2pkeWRZndAP0AqnY8Z4WVyf9CQ2o8aUpfpnajLv5zl2y5IDwjlA
vFMgjfSKBhOAKUWPTraoarNhNQ7Lme+1YYiAy4psVjSeUSPixBpaG+xqXpVUIDTuIYPIXLmJ88R8
ByKLzePbzrJpgr0RQXU1j+NUiUYssr5NeOb/YdQuel73siYj9Sr09kHBC0ORy5GDNHDDTfh+DckW
SiQjGTP5G6w+K8ns6DyJ2SybwU02kHlak1Qgb0PUA1Yw1B5R8yvxwAZd7cW8TUNAV7VzMFbHllPJ
AonRcZSPMj/OAzFOl9ImS6/gQW52VIXiboUfAN+DLQT49g8XhwVS5vt69gdu7Eaa+2OMQBcpbG6l
Pk2JYmekYAggl1JcPywRl103PRGOeSXlcGVMbqrdIoYgvYnaFR3kPpgDNOQ0lNKFDboyUMWK0HvD
pjYVKB/xQOBiwFMqXvysPs5CEsYmPBSJS7+Fpe/kcxpBLpmIHqTsEthN3KrC18XgW3FpTVK2RtlG
32gKhxMWUQ1VVHC9SWzU2d8iRBYDBHgjxM6QVN20v3ZcAIG0cGplFSoFV/mKBlyCZIoNJk9rcF19
ro0b5AMMYBW1UpWSpXKlHQIRxpUKYsvaqXkZl1CFndwGbyrNyFKLeMwqPmgnlKky7RlvFRPX/yCl
KFi9OnL4adZFrFK0J6huXCVVDje7Y/wsMKO5Arcs4aIg6mqX4RbkJMooNDo3SeLFPKONRxiJZiQa
JpEBr40iaS5g0ryqtTzZFjirCXgYm7TAWo6N0hQnyHJm88gXF1ek5zlNtbVq5MYZt6azs3z5PkjY
TMooFVKj8lpYWmZwX0bKDHZC5NMlsQ15N7MNZ+OBd8qNzshUiELW6mBSX66RNJU9ypPTQC7OlInR
hJG7MfkG5Q4eOErpCBl5JdgCsphYiRpODO1colV56YgaXm6d0QOtGTExLteBRTzaclRgUF+2Opsm
SBdu2gQKiR6YCq8hlzWQrFOqHrqKksT6DCTFYE0UAXVkpjcrXJeLa2LYL6VycLMI1iWVt+PS68lg
l672uUF0DiELtm8UFNz8jZ+i9xVhxSP66N0N33nJA5K4HxLPCtNM8FlwZg24wQQOGYCtxMEIKR0f
zABBhDVZjQrNdSJdN4EFuNngezmKxLC5ydlAs4ct6JxsI3Mr5BwSzdwoqpOgNrCOYQGAQec1YCym
jjkRkS4hNmmJIMQswdYikDjOPWUtLKQtTgXbLTitkaSaJ5DgYxaK4mvQA+RveOBmwFLyJGRQwlbL
xEPhEflvzi9hbbSYgOWr+4klk4uBcAnMSw1hykanOYSAWsHdIHzYlBhJDERM/Go8AL87hUZ2iPsO
wYQKJ5SV0weixe/OOGRBYScapEhI2/LqC8siwQFBNz0v1iD3kSqPEzC0hKf0S0LXFO5FLXkwHhYH
9VVQ1mx8ea4AI4AqQcATafUXeKDNZHwjCYNZM6aZdogwkG0k1sd9HTthKhkcrHwYB4uw2eKbRSDS
Ko9xJ0dEfFZsvpkCC2ms0dTGlp68KjYp5WgiFfSUM7Y8mC1qeU6/mIsPZCZpCXArCy+5bHN9EWjY
eDgA1IVw6oQ5hXGiiFYybRMflaK5a8LnJXhYIr8UbSbAFFBtVEADf9ahAqpgW9SM7xnTESwZUtrq
NvaesBxV4oDpjsIjOwGapkMWZWesZImF1dogP8UIZCpGHjZqalwAGl9aXrrquuukXeo9laQqB49D
2/wrB07IH84MNe9Tj3j2c5o1KGdn7+wFc9bfSrMCHa7V5lEoZUvPriuOLsmz6ka2ZYJBARepqd9I
tU7SKfEpMzcwZJ22biaOzklBZDIhW9gpSNEugpDsCJikzcSzVEU8jOTuhVOeF5HDIrfTPAFhgVB4
eLgU/QqWI+78fpJkb6V4tuBr9CYHiGCETEyLEgN8naxNKn+v9m411X6tle+ZCwsTUgy/ocROu20e
uBjWvukqtZwxQODWrAIudof01OhOqs6kTK4OQzZwEuOCIooxi8DWMXiF4LS8dVF8kxkVgrZYWh9c
oQ4lv+AWOrevikS80YH3Bx8uPK/tVQGyHGLloiMYMzYorCGkaWwscJZFgKigobWDzPJ+s+GYtNE9
NoEFD9/gOXFup9yYZwdN5xEqNy2x8mJj3sYyAdK49wan1yRw8IVD16rNrZHDZkVSgnSTH6gFhtoh
bQvOZvzC6BAiFVSb7uaGNtxkg2nLgFPFZthrQkOsEE+ACZsSNo2n8duAnDpXJtCuSdYKyw0MUN4n
2ZoErlNC+HJcZl3IDIYDjF7wNCKiTwRxULJboYh1QCe9MhmjCoGQ9UWLFN6JOt8Yzk9QxV5iv7W8
wnhBtq2pHabAO/5UEwyhmARzp9uLXQppCnZoTHAByjsqwr9IlqyGRdhMo3UF1yQjiygTY7JySnzD
efxlgAq8XHd1o3XCgdFZcVw3IYpPacctZIgfAfZk6LxOhjfMDXqTT1Vu1/P3cuoJaX3oOjHw1b7V
z+JPZaInL1Chj+yY9hB8CzhmQgfqNQeGq7KSxY2GoSx9xGhsXzFL6Ew8I5dyU2vp5KbxKDUWizLa
iHpexBpQoraK216ILsuFY7LAAW2ncNIxnUw1z4Rw/fCMEdJDY8b2DDjjMyl62LA/M0ZkwDMmEwOK
VOSqtiMiM7M1Ko/z4zhU5j2NbyoS6jEAAw15/egAi5VES24XLqvdxRin4OBebCcWha/CSbc0PYiQ
ATCNmP6LyDGq1TAVmrqmqM70/2UOv2//hpirichm+CoglqlS1hU7zIJyU2ZFO4InWUyCVyGYrTGi
QCr3WKLZauKROmpQGPJ7kmlhUkwdWwfqtWiuvBZwDAJtR9EFOwyeYXSTdLMCrMvpx4NYwk6nSTc2
nCN0YwSz1pbaXRNomoEAGwnuDDd8q47hCUJOsIlGTWPj5dqIRJkI8LkIRuhkjB8VNdt9b6xC80Pk
DmVVGrYahIg1xBWWEDhN7Bw2FhI8H2rqYgDYh/lQsJlAghVbl7Api/CgWGrV8L1yXXemUKSrcj0e
N6piAouhN+2O5zTbouhBdRysp1WtVo1lbytBXquTMrk9EvyOwfdvgaePaFqsR2GPWgqHNLVjp/0k
DgaPaUDpdjQ9QbsqUucGR14rKoAk0Y3v8Nyc5Nkm8GTc1dgeubrRxzQQeU8iMIkRlOXIujqEcnEp
4zK2OBpKmvEUjpo2tQjZqQC2GpBoziy2jySIZn0BwzcAQurtQ0AA3pFJuD1U2l6OnW9P6W04AOIR
ghgBL8guGpEQapnw/VwKDhwhaQU5vOHG4mpk5MsWCkdGSpxh8m2kmrIKMgdKzck0T7BZDIuwq1Zl
BGM48naqEHYrZWs8qdFwfIJE1sceQsp8sE9eU3EnP6Kwr5m4jkaSt5Apfs8kBAbpJyPAJXGdrYZR
1CIQfKgKdA5kGFEZy+oDSW71w1ZFSdmqk45WNjtMrb+f4tK222eNm7QG3xY5HKthOoWWNrxtH4da
DCZNxXhgWWeEdnRKzG88R2I4XIYDQvfiCBhsIewoxHbmXDDQyJ2iZA4ir7TDq6oeqZzlpRcZT+Pj
L6e7Jf0sQhYn7o9AtByYlIC/wXlAFbUTDMNO7ch03s+jk+3AphOTlxlQsg/xWAWLe2tyG6NNecVJ
4VEoyq42o3MjTjY5aBEWvFLQSP5fFp6ShBkzpevWcoCTAiUaaOR0nCqCSeolIsvNqtoibOkv5wWN
Ddi59BGznI+Uk4OGvaOWV+IB6QBpQcpzFXCuw/VJCqlSbnzOrIUjcRB2BAQrxYjI8uRL1FroIWxV
RJa621T3ipo1JSIYoStbK4uNHXfg8YJe4u2ICYXMJl5Jm5SQv0FaeDSFUlDLXawm9sMXqn1cXdle
FcHYbacK8KGl1X5USibZGHgn1mYd0RsrfMeicVzH2CY3fHWuvSdYvpcx3zwjrB1rDvoAiWTeY4KC
SHcafqCbeBut0hpxCjhqO6w4Vekp95h4dVLpIfZu8AfbkQwdNx4CR0ct7OAOTon2EtX3ZmJhKJNM
QxsxqcAKaQbvhSM7Ptaxs1ys6QLJE3YmwiZ44qRLLRKHRAqMLknD8XV2cQbSTp52kyzpuqTST+0E
33uTdpZcZNmLeZtgGq3Uh4sd7wkbm5xiXt2WN34kpYHGYlgEtkQYlpIVPUs72Flnph2cHeW3BXXU
pKV55kJFRPgOpt9lYTps7BtMxHtE3EWc0BAGvS9qibC4jWumji/RcAwaOeQ8Z0tVGl0SxgmfZPBS
bDEYxRelFDgEeZAel5UFQwvXUTYZ2lmr9iZdt4bDBXjQzUaNCqLROOqrHEGGvVHrk+pr8SCOPeSG
ciz+Vrv6PDH9YPOmmQo/oSNlL9PkYYCOE+VuQ7cAYI17T+DR21xS85G68qbe4dNq2ijaUUGLjL3l
kWPpRHsd0YClG/DoOCmlJz8MxwVFjFgNQjkVji8g9EJJiximXMd+vXZJOh/aEroJj89MYWMyL90j
M3ORgfM0QY5TQNaTotseKc7nh0SMbwtiQeph09/1YkopRZ21OWlzKMhlV7nKgMkPorrioZTuuvxN
D9wkrciA3JRzdY1CdWAhHb8LYa+Cedik93ye9irHVI3Pg6gDTdRNVIN9OsGxicCzomQBhLYsxrAI
moTAjs6+USuL7PKJBy779OCLiIfDsXhicVO+qeYmv5jOi2ZEsN9uM+LQVdIhhIfsgUol5EVUqGl1
UswupaUnUbHLCGO6NEEJAVeWCJ5gCbgqNtK0SHRwOJDevZkMrsPhSv1OjNRq7wlj2KI7Bg3YhwsK
JLCm2mnYhYBJhpvS0nHeKIdNZ5yxn07llg87/kGCkwXUB1LSN4TQTuwZNTdKlX3csCm6iROl6qJ1
jmorVIhmJqGNhCCAX5wYNY8kZErB2SmZQWoZx7zQITWbGIhnwb+u1TivsyGpNuMgMEIP4AhVEQ9o
P0DHcYZtNa8lacgGyieKruEXI/hKIgiFhvA8Ex27jV7itVtPpN0VR/mTa09SOm4ciJFXHWXh2KDe
KWxstOwStXXybKoTOFBoM4EaBgw6CS8PqvPxcpoKGJuhKtLy4gpbLDGbZv1vJPGjwhqzEpRFUtGG
5/N5wLMpoRmaCO9bkcNKgqqKtLJkZcXBCHKPrexgAroOmusEtPBorcqiITiCSdyYpHIdCjfDZ8eh
2J9xsS6hlQkvioo4L6QtxiJVIE0vNbKUnG3O4zOCkA7Wf2dS6iNzbWrpbSyor4PQ4ZAndVBEXpQy
N9rJiZfMFEUs+Mk6SPu3MVkK+WzjSgklcrSK6awoD1R4/pTUJxlj6gQLlC1pS5XT8xVYvIZt0KxV
N+V0/SIJyFDGtiqHTlI76jB2ExYnZtJgPzevWccU4BnDvMy7Z7dW+eKbb3DJlDyc1pP9EzCTq3RQ
q2xEI1KV7vpRHiJNyveNtNXENFkAdpa5S7uKlkNoGD9z45ZgyvnoHKrgxLlByYLBElAlw97BgscR
RYseh8ZSuIRdUdupqDuINyZVXn/DTBg6LQAfh2USfIxSq8aiA+A57iNalsclv1BUfjAtsMg93Kgl
itZdMcH4am8Wqs8X1UCdappWke8kJZrUwVDdy/HCBTbSYKY3CmxiBllT0iqbiTVJiaw5jiMk2nD8
aLH/qHkJWQ4WneAFfAB+d3yAuj7wRa/HgxDaw13dISiOUgXIbGC7QlLObXNOQLWxGTfHCo1Yn8Fq
REC1FxYjqLB+l8sseSQoQWweTstDgnJS4+idiIMn42/0pgSFHqo2JDSeelLRbGOPqG4kBwDnRkJB
DnrragiKdoq3ucp1SZlMOgqw2T5eF8EZvAWxrcGKSoEBJiIsyQrcB0YzSwuFsKUq8Dovi77ENI8j
lR1Oufh7Y1fLYuaVfo0A9FXYWLLOpr6TnMlvDAMWFDpjHVFEy0jcQMp6EpCaIptycDiR2WUZQ+Y0
YEyOFzk78a6sEJ+LDi3IRUSUg/Iq1ejJ4i4Rc2UM7gw4RViZsDYmBMU2XIpkYYzJi49hiDNI6AxW
fKCxM9e9NlnNaeaHxgfUJsMCVSN5jASWQYALDRZ5Cnb1U2iJqyxlGHRoZ5GwXkzLu5ug54zz4I7s
/6Hs2nYkO7JqRJxzMrOu3e5u291u3/AMePAAMowZCQnxgsQHIH4AxE/wJTzyB0g88DZPSCAkBsEM
fvAY48HG3b5Wt/tSl8xzCfZea+84kVlVHrBKVnd1VuXJcyJi39YFu0AzIVmQkmy9P5x+Olyc0fG5
Gnt3GAccq4XK4tVm8Wpa3gGrjwOtHULFVA3tXdU79oqnt8de1Ll4wNZTklwNQcowppD0Q+1+ua23
RvcHG5QAypErtlNdG7T30oIEIqn0yRGjSl1v1n5xssrGUNRcGbCGpBLc1czUitpZKVS6Z5zHvVAP
aQtAolbJ5sCQCiWtDlRNHCJuM3LjFTDwHWjNlolOqOZ+9E1pwq7NavRI40/RhhCji2KVUnGAuEGX
LadQsTKchdqv9xPHQWupq9AT2ansnPTIqnqjWQ7ZBtQbpUTspqT1RKfFSICk+ibIz64clmr5I5lZ
Xucq1gBzi0y5aBII6ruR3G+Gn30NKZRjLKkn00jMGDP0PUBgn+YBIvzW+WWKFzQV1fX3XMfgGSyW
UWoUiRZPp1FCo/zTg7B+q9kD82MipPBWaI8bTSol77kHdoUswn/rn8slyQm7wfTotaa/lbp/3DyV
kHxXtlxqGE4yJWRQ0pX7xQqgA+6uR1RDA22aDUgQtqkm+SfLF97tDqohpR7iJw7/64NZFE82utMD
4sss8UYxe7chIYGNV5BULICUhD94GJ5smGHwJ5YSCpdI4PTF+MFw/ilcDBQvozlsO+bB1NWQcrAt
zJrswbhp8Zb3myXoMs0IxRdKjSXoCsuzeH88+3A8e472ZrwKROplBx3EWUgpkRYbcppQKHaVuHK8
nqgHRcFIg9epPsKqNyQLZKxY7rV5qxsj2cNKNsbQG0evBxqanWMkhhFaOKTxnRPkY7XHs3Pv2eyi
LHqpukYX5rBkwjdpi6MGQxdquOmbIkXTV17oTk/s6jeGjzWbpckjU92NZ+uYbXzdJqBbLF2EjZOq
bPIfuu9OxoGAjnr0wBmn5DT3FHC7vKfOPYv9pEoiwZv8DA6NQTR5YzXJZq6gV4LeFc0GE4x9mXA3
M+jZZmbJQdLlqSVHqEUTkzaZjNr1IM26BkWxZcam1h0shT3s5SRfvL8HY3qU02IaJJHsTcGJoDVY
/2YbJIw87Mpopzq5YtxqZ8VK2rmpwmDaHdfH6q8zJm0NgOZmBgmHQup2aZxwOZZ8Jz1o7inPIUT1
K63hk6rkjxaqwdUHUoUFJEEs4/bCIVi2J7B/gJek3MgTbrI2oy/8mCOJr3UxzWBaRuasDH5JPAoq
gvvxeEFLD2VcZxtgFhwBL856awDgEhN1FJq7aYFGcK57HzmGQvjXRpkuO9UmCJg/n2vPfR6fsjE1
oHXTgzkP/YzmnzZPTXvRkc29nsWGrF041R+Fl77XJ+NFj0nPi6kbQ/uv/fM1SDy92ok2oNNrdNR+
3aSVmQKgY/t6szzAWala13n609Wdn6wfd018pz2QiPXReHE7D3LE3wgKzpb0qEMdQ33ShYleW8UG
2qmB0y6AXmM/apDzNxKXbC0CiTc/XhzVXdY1AF1nKLM4yma3kExe+f6DcX0CLtE+AhsrDM5LJtMu
TBiFMqFGPu4ucMn7snmyhFSuXx7cQacD4Y+HC+Km7oLw9OW0KdMj6pmyEyjv9emw5h9kwSw1jYVG
p6K9lTl/K7U/7Z9/NJ4/R6/1OhwpXVZ5KkV1WQ0Fu0zUrPxymjqXmJS2j/Wt7pxTW9bmrZB3SBtT
1d6ZcjE3ykUiJQVr8TV4GGwTd/D9YWF9hntWHGCPYis3SpbobfK7vVU0+jCsXMzgGIdgTbDshuW5
agyQHtsQBcd37PVWxMGCZYbjDkwLHRUS5nipK+oACWd0KM0LcHWjvs4rafn11DfwtnfdAdLjkgF/
wFke54cAPT2gbd+AwsjLqaN8HKnNozsOEF6Ls6pplP2WW2PnsONtoTI5knZkFVVZIeeq59FuK42Z
ZloMdZi5hLqqoCUxbpv/br3SxO/gQgZNoeDhBzLsQ0FtIw/qQcOcjL1lEBQi3HY6j4VSG6t4U2LP
ZZBYvEQmUuxsVAIEGyySOq3QAyUObUcJNFwlYHzZr6WWzCleA/YR8BLgI2LaFvc09aqqTi/DDyqp
DBiMn6MlQHEIMlEqCUhLH+iT3bin8OQIzsmrXdLBdAALmfrj3HQGIAlbotahcHQQ+7N5b8uDe2It
tVjXeRR4b0nUx7VN2aYR5vRubJVAv8voWQWkIfWGP1JkGvhP2Rpxa4WlZQxaG57FtEymgrVEmveH
M1nom5gl0vw6KjA1V22kGtSZ/Ifj+b2m21dV6RU5OnTouR278yBn+oYWZ3+8vPl3Fyd/f3FyJ3UP
p83DcfOHi2MXktijaGaDwWIySLHhZC5wd6kaDqNlkyjG3rNKRf7/g3b/Panzvc/Aqvc5kujBEDik
+7DDrEHls3EtNR/Ah4kCWUq8nSaoKYeFGQRo4ZsxPNhYpWKQ9C6n0fE/xKQR7yc3Ry5G/v/hcL5W
6R3VelA0c+5H98qLkHgoUUcCUtPrD75EEDNeQLbWKXqSz4FX3iEyzKp9WNiD57aECNHxFjYf6ZVm
+V53uHReYbW54jX6nopUvCHZgKQRee6hZee3jc51H/MWbmqLDIc2Wgw2p8qzVqENRIERaNayFKPU
9/G+Mu26m0mNSNjSBCdmKnM+piArNLJWkYd7LMy/1jRvdJLEGeE+AK6qc4EJKNQFdalApk/L1t7l
nQo8JLjfAUUBWpd3A2xHyxH+8pe1G5bO1bW90WxJQfN2xC9h/CER1GpZP/qXGF6+grbhq7DBXris
FOeLfZmWOUotqltgS75BW3ILw82mMRTnjFg3pcKlBs9ODRu2RJYvn65Xlr9XFAPsCciDgupfkluW
llOivPFyUofgQlyAAIMk/LqKs8HjCF4sYppbIK4iVJO27G3q/tVWPyxXrV4WVefqLTY9nvpjeDGt
EjAzOaU4U/rz9eV+vRnitojndmjUHv3o8lwJx+i2ZDcBpj5q82K/9aKNC7dHuzaWqAOWCd+YWN7o
cyAWZ2PZilj6oFgjrwGPmtCmm9BbTFRViKEGSjBaoNfP+T8FPPQyTqcRwjCpJKST9T0mxhWigEbo
j9UuqKMJzVl1O+KVRxh48u0al0Fc26hG08oVaAEDKoMN7t4RpjvvdgeQr9YXv9muOAaTs/J/JlUP
k9ByR0mX0cctyt8cYZcg2/t77YrMbdk8f7b34j+sn/zHcKqibfbww8+HU/l0UhxIufMcyJcRvODB
TQFyZV6QfJg3+ueloLJkjn+0uFEzTggqO6WLM4g+7gym/0n288mg1dudpmVK8WgaqKXdobbQfW76
zZoPF1I3cOR6FG6QaRakOEPRUtWsA3FNksnKTZPq5JtJEdsvprYHnGRyR9SANiwDvARpWlzLQXVT
0RyZUM+l2qxdPJzWlwWcWFWTI6ytv2hjKr2kCGUHkIfoKfXb3cG9ZokDNG4PYPLOLKfGR8jJ+FCN
AYe81UCzUmB0a5bCsqydWhhXJoczlLR1hGTfWRw5TmPXqM3mk3bYpj33C+8DtSGmXBVkVDDbJP3+
WZwYePi8jiCcUzz6SM+i+lnRhdN+uOZDCnL0hkGkn2ybMdiIubavLop2S1OoYpap0Kf93JBXm0z7
x65wYRFRu+vA8U+oyRLwAp2kFC8RsotVx8qbNn0E8uEE0+uZgHJdxlhYKHyDhBBuMmsxXik/do1e
zPaL4xUvrk/XmHd5W3FbSLRlU6IBBSmhG6BLdtIAjuKxhwWhDQMwoUnM/iJoJSPi5WBl7O6UxeUA
fM6/bbMWZwx9sZny1qSPoOV3t5M8hv4QnAzks4GYCh7EueLm52uM5y5joaNTmez4jjYZ3pgzICkO
pnVmdBwsvtKkHlyEkSnzqA0r5Z2cK7KP3TDCwdF4Yc5VyVdEF8BnCraHlOTCZIYjRVCeSsiXxCc3
qQoedeBk4tz6tGZlto/xX9bPXm4WSJlTmo0uFHOPNG1EfUfAW+z94W7338uG14X72bjZg74IYQsG
g6byFQUNoceFHkig7+TCRa/Zc+cmUYHLSX1lvt+swNdTdOxXAF4fYPDb4ZW4D5FOxgh1ze8vDn+r
2//r08/lx/958+y9xeE5MiGpk45j+8FwNrnQiLMEZtBqkWHO5dRGhivJI7G/dWqysap6WtsUJzvU
StUHpL6R2u6W0lJVfOEELpDkF++biqIq0LlVzQyfiQaW1RyZ44rSe4EZ10hDLT7N32j3ztSdWtkt
x6mR2CyBYQ3vCaNpZVtIWLHTfw8Xkvm+7Tjm/dCcTyo8qsDI7fZDwRcR2cV2TC7k9hxBJtWZ3zvt
/g9hRrdy/gk/VopxN1Wcpe10s8g1vNYsPhk7VR300ny0wXCYLK0JJTGvXcNrJfjsYjNGAoVO2pR3
WahyT/5rvPjdfLjww32NDI9baeGkKAaAw6D6Y71C+JTydZh1IP8GFLCWyCnXENdBOW62qtalAKUP
3TnrGwNNoJC8hSk1sPxKaUaOGKAZ1Sc76nmBIcoSE68YaVoxQfglFHLbvtqi05UnuEecak0dQ2KA
BW6PbXUy9Wc+ZWRWdDM1zRQWKRWgXdrupTbBlnsdPPL/36xzB+57OSZde/LKfiQmZNCjUX0gWqhg
SS65cpHwE1CUtbXltLvR7etHy46RP1fN2YJwKMVNY0P+WJcO9QqbZtm0OS2SnXkKcB9PH9JZ9ABG
juO0ta3MK+8Qg7agz7sqCbEKVEhOzWhkMCcozbXS7MAaYIupr2S/EfXp1LrUJsph7bFQSb6jtjkV
cNF3nqwWCaVGWUMCUhOlZCx95lkr9EYejurtcUthM7aGpiq7dNa30kLHAMuyFA9Ccz8t5eb8ZP34
Z/2p1BlvNrqjkpnGgbKuxfjIPgALlziDiKjvqTUQcahs18j5JcngUZBLWrfoMKgLuKbyy2gCB/Kn
hp8i+cwQk1i9cvmM/9mfA/uUfrPdL2kXt9kNfSG0JtHP2cOPPMvDFxPVjrXmfjGptcFfHb72N2df
fjie/XJspb75auw/H/tncbyBPlJ07GFCKdZZj4VtB+s/kIvaxcDfKcv72zzcCm2DnYhhzEglmwtv
rLHFL8f/AxRn8lgfqJDdyMxAng7xLGscIhx/FmlnmD4Yh5wwhy0OvxapmplKEXmi8+kMWqhSLt7p
9h/l/oux76dMl8lHMD4g0C6QIAkQ8wR/649gJyF1icQneUAfjxdy/RK65HT8EuzdGqsdI2EOYdjB
Kzt+Um7LXbCLDlKT4qyOnN3BPlV4yOCgwcmxMy+nxa81q0/H9RMUOv6bw0zp28aJ5W0N48vnGvfO
4PyeojpDfiU70q3p0BgfdrBZHU06Yi5NkcSyMq4bfUxSOpBjzofIxGiNdUI0DUN8p6hr2RqJcBtb
VDrYVrHUDt2FDqp3e4ArDpqqNmyNUK5yMqoTupcYplwgiEv218M+A1StkUpxjeqjT3TG2reGm4mV
JGs2APAdpidwYqTZq+ERYnyBSvmO7N1BGF4mI8b/g4DZZX2ZcPk3V9ErXxJGKv/U/Pn+3Rk3zRkA
PhIx4E3kX2MRX2r8SNd2UEWoNB+06EiGbe2NYghd5/jlUhzvYQSiqQQeR08ygVJBTAiJk5JiE4v4
nY6iFY5l52v7p2LBXZQ3HUKRS43OaTWLPbfLxVDHcduTaVKpHH0zC72YAA9vrDOT7J9O8/QFDK0X
qE5CpOBS4o0ltpKFfzff5plFlLwnNrlkC9acPpd/759/opyPXqLFHSkFkuFcGVdGX3zZxMYpKW8f
tYEwGg8CtFjTz4fTW9AhVctC3z8HqmCtNJSX1M+7pcxwrFAkYIwOj/Lwi+Fcjj/FsKZmT/nSLjhE
/ko08Fj0hnGLC4CzofJPke4lqnj9weIYXpzjj3TGoP9KK+tvpiHPx5Oh79w+3HS9II9mzNBbCmqY
5C7db5bUHJNvPoOVPTmexS+S9dPn00beQn7VExh9HsAfjHY40w7SFxJnefZwjOP8vGJJ8IvtXofc
TpI80E51DEbDCLlFj7OaGphNWUSaEB1zbFYUiRIvFH96ERKCsj5/MajbzevNUj6mhC4z6XGEKycH
BBYOLgXgk3Bdq2+1K0lW5GcxzEjNbhbHMjHW89fRgzoXlVzM12qKaiz60cMbd02pb7b1H2f0UCyC
v9Hu2IboMnOxMkV2SltKhPvR4kgWIfWBWCUPOpRKpKOhCkmEI48a47VokOd+H9D2m7q/1DZwBY42
xUpcWMtpN1uZsWKFJge88e3WaOWdwpZ0DdAgNq+LQDPaRfqeUBmkWAlb71G2yWejwuIDxKWIJqC3
tDxTebI30OuzyRMqJHlfZkj0ADuC9KrshTdbtRHqvES7jOO97utXxpvvLoaucpnZGtVblvwXB3dh
xRXn0oTYBhM4MlAvgrMNMVvXIS5dQYNolKl+pV6TZhzzlo6nI8fCzFZFvOnLgJEzxjpQA0+ycL8p
pxdZ1bATcsIli4RfZaMwH3nRVcpzLUrHj8DJl+nOWT+hcSoGj4MLbw0Zkt1yk3TJd07nNxIYHmjb
qoGMWHShM4umF0A2QwA0FWGJWraoxGy4dVkTeQ98TFnE8ku+zf3Hw8UBthlSwvnkim4q03vviInV
MqWbcM9sXez2g+EMFgndGvn46GTP+5hnkiIQnIID7Q3KQY7Ppkle8P12D94KhL7w3ppOJI9OSpvg
sSYqpNFeU74vB59uSBtm6Lj4nfbgMDVypL7arOTCIJOqKH8iA3sfdFEZmjeKU9aNEQDzEvRS2cl/
e3Eix+Lb7R7AxzqYOYVeJ0lFXAN9CPKRfyl1Aw4alchDoOWpvZkz93nuOhqjdnYOThbpZ/GkqbJQ
5JQYfjAa9k7kwcUgRYZ8/3GWOicfwk/IsMWWKBg+sHPvnw3Iufdh1Sof4aupv5k6qSll/z5Q/5Wa
UZj429be76UaN893iaa/0x28rcLVLZnLXcV22BLndVK2uR/NIo30CdTZHg/E0U24izX1Di30Eobb
+3eE5+QZVBarnHgfu+Z77d7vdYfHuEXB+quWFUFwJNEAm2oXweYlsAhCsCFGoPU6SZsTsahhWSrG
/TI6DMdH94GN9DMgfR5DRugRAu1TFMo6G/OTYYymuck0i3AywgS4zKjLbviFxC6rBj/JOF+C3wpJ
QtS2IYyCWBika1FWyA1NgxavII7uWdpqiXL9FXbvc6z/XL/su3+2fkG4dqJxRRBq/nL/Xgqz8IVh
jvmpYiy6swwzRR6uOBnTCdxCSJzLqVhZy6TKFaMk+HnOeuxryDOgZaqL7oL4jqZEicmeVWA1YDpe
VtypVnCqbl64BDnYipGOzhjcLr6k76hUQpwDjAFzm0o2ZMJU+VTzIQ577O41nLYXJSDs0s+m9c/6
U3kBRYK5QNvKRmwA7HXpa6jE1iqO2svGYHAmkAAaycflK0YKTa5Pci9rcYV8mRLrNCqmfMDgBl8t
CvnbqZ28+StnhwStF1L3WrO6Eduvck/TM3nT15uVhIQ7+msTl0TQ36bjkIfjRi7mtXZJzf8eYiG0
5tx4DkhdEOaSYJnEyRy9Iss+rpAWIobnefwaKEo5E+8lBSllpCAqkoiwp2xHynRGQ2dEV8HR0wHy
aHzWrwL2LUWAxJKf9s/kF77V7smLpaogH/Mc2jaQi1XIwMfD+SlkoYmdLWJcHm9s6kAFaH5SY9TH
WBO8zF85bk3dJ5es0p4quohnYfxSgevxlWZxrpp7upBA9jKQ1SxLQ4ZH0u2Q2PdPLYGzchRK1Hm3
O/xBty+X9Nm0iZHLQydt8mcOPIr+xUr1//VapSb+cXckmfItYMD2zI8g7jT9WfZz/LmmALNvW2sG
RHWn/QaKc1VXwChKUwj5SnLPfGdi8LM+XIKn4rMkjkulIPthq7IRye3dNsqssA6/BJhDxE6mNSxi
+By5p1J0eqMXT9x6viBzX2Pq4kyh4Mchi+MRPJO+VcMkDTb9/KrI0wMCHMQjJDbhW9ffGt2kMeCv
R4r2lqqrQXqtwLnbQLLJd9BOTHYy4wF0wIu6K2irpkfAPnQUBruqJtkJM9dPu6/92Z0IlK+yGbvy
O7wn/yvAAPiNxaCPZ8S9AAAAAElFTkSuQmCC

------_=_NextPart_33d9de0a-d0c3-4a98-b4a7-04a0d923e67a--

--_002_2555177PyF0XoxEVRmerkaba_
Content-Type: text/x-patch; name="fio_3.12-2.1.debdiff"
Content-Description: fio_3.12-2.1.debdiff
Content-Disposition: attachment; filename="fio_3.12-2.1.debdiff"; size=3069;
	creation-date="Mon, 27 May 2019 08:06:58 GMT";
	modification-date="Mon, 27 May 2019 08:06:58 GMT"
Content-ID: <90FCE5FD2497D5449F599DEF11C122E4@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64

ZGlmZiAtLW1pbmltYWwgLU5ydSBmaW8tMy4xMi9kZWJpYW4vY2hhbmdlbG9nIGZpby0zLjEyL2Rl
Ymlhbi9jaGFuZ2Vsb2cKLS0tIGZpby0zLjEyL2RlYmlhbi9jaGFuZ2Vsb2cJMjAxOS0wMS0yMSAw
OToyOTozOC4wMDAwMDAwMDAgKzAxMDAKKysrIGZpby0zLjEyL2RlYmlhbi9jaGFuZ2Vsb2cJMjAx
OS0wNS0yNSAxNDoxNDowMy4wMDAwMDAwMDAgKzAyMDAKQEAgLTEsMyArMSwxMyBAQAorZmlvICgz
LjEyLTIuMSkgVU5SRUxFQVNFRDsgdXJnZW5jeT1tZWRpdW0KKworICAqIE5vbi1tYWludGFpbmVy
IHVwbG9hZC4KKyAgKiBGaXggRlRDQkZTOiAoQ2xvc2VzOiAjLTEpCisgICAgKyBFeHBvcnQgQ1JP
U1NfQ09NUElMRS4KKyAgICArIGNyb3NzLnBhdGNoOiBBcHBseSAkQ1JPU1NfQ09NUElMRSB0byBw
a2ctY29uZmlnIGFuZCBhdm9pZCBydW5uaW5nCisgICAgICBjb21waWxlZCBjb2RlLgorCisgLS0g
SGVsbXV0IEdyb2huZSA8aGVsbXV0QHN1YmRpdmkuZGU+ICBTYXQsIDI1IE1heSAyMDE5IDE0OjE0
OjAzICswMjAwCisKIGZpbyAoMy4xMi0yKSB1bnN0YWJsZTsgdXJnZW5jeT1tZWRpdW0KIAogICAq
IGNvbnRyb2w6IERlcGVuZCBvbiBsaWJnbHVzdGVyZnMtZGV2IGluc3RlYWQgb2YgZ2x1c3RlcmZz
LWNvbW1vbgpkaWZmIC0tbWluaW1hbCAtTnJ1IGZpby0zLjEyL2RlYmlhbi9wYXRjaGVzL2Nyb3Nz
LnBhdGNoIGZpby0zLjEyL2RlYmlhbi9wYXRjaGVzL2Nyb3NzLnBhdGNoCi0tLSBmaW8tMy4xMi9k
ZWJpYW4vcGF0Y2hlcy9jcm9zcy5wYXRjaAkxOTcwLTAxLTAxIDAxOjAwOjAwLjAwMDAwMDAwMCAr
MDEwMAorKysgZmlvLTMuMTIvZGViaWFuL3BhdGNoZXMvY3Jvc3MucGF0Y2gJMjAxOS0wNS0yNSAx
NDoxNDowMy4wMDAwMDAwMDAgKzAyMDAKQEAgLTAsMCArMSw0MiBAQAorLS0tIGZpby0zLjEyLm9y
aWcvY29uZmlndXJlCisrKysgZmlvLTMuMTIvY29uZmlndXJlCitAQCAtMTMzNiwzMSArMTMzNiwz
MCBAQAorICAgcmV0dXJuIEdUS19DSEVDS19WRVJTSU9OKDIsIDE4LCAwKSA/IDAgOiAxOyAvKiAw
IG9uIHN1Y2Nlc3MgKi8KKyB9CisgRU9GCistR1RLX0NGTEFHUz0kKHBrZy1jb25maWcgLS1jZmxh
Z3MgZ3RrKy0yLjAgZ3RocmVhZC0yLjApCisrR1RLX0NGTEFHUz0kKCR7Y3Jvc3NfcHJlZml4fXBr
Zy1jb25maWcgLS1jZmxhZ3MgZ3RrKy0yLjAgZ3RocmVhZC0yLjApCisgT1JHX0xERkxBR1M9JExE
RkxBR1MKKyBMREZMQUdTPSQoZWNobyAkTERGTEFHUyB8IHNlZCBzLyItc3RhdGljIi8vZykKKyBp
ZiB0ZXN0ICIkPyIgIT0gIjAiIDsgdGhlbgorICAgZWNobyAiY29uZmlndXJlOiBndGsgYW5kIGd0
aHJlYWQgbm90IGZvdW5kIgorICAgZXhpdCAxCisgZmkKKy1HVEtfTElCUz0kKHBrZy1jb25maWcg
LS1saWJzIGd0aystMi4wIGd0aHJlYWQtMi4wKQorK0dUS19MSUJTPSQoJHtjcm9zc19wcmVmaXh9
cGtnLWNvbmZpZyAtLWxpYnMgZ3RrKy0yLjAgZ3RocmVhZC0yLjApCisgaWYgdGVzdCAiJD8iICE9
ICIwIiA7IHRoZW4KKyAgIGVjaG8gImNvbmZpZ3VyZTogZ3RrIGFuZCBndGhyZWFkIG5vdCBmb3Vu
ZCIKKyAgIGV4aXQgMQorIGZpCistaWYgY29tcGlsZV9wcm9nICIkR1RLX0NGTEFHUyIgIiRHVEtf
TElCUyIgImdmaW8iIDsgdGhlbgorLSAgJFRNUEUKKy0gIGlmIHRlc3QgIiQ/IiA9ICIwIiA7IHRo
ZW4KKytpZiAhICR7Y3Jvc3NfcHJlZml4fXBrZy1jb25maWcgLS1hdGxlYXN0LXZlcnNpb24gMi4x
OC4wIGd0aystMi4wOyB0aGVuCisrICBlY2hvICJHVEsgZm91bmQsIGJ1dCBuZWVkIHZlcnNpb24g
Mi4xOCBvciBoaWdoZXIiCisrICBnZmlvPSJubyIKKytlbHNlCisrICBpZiBjb21waWxlX3Byb2cg
IiRHVEtfQ0ZMQUdTIiAiJEdUS19MSUJTIiAiZ2ZpbyIgOyB0aGVuCisgICAgIGdmaW89InllcyIK
KyAgICAgR0ZJT19MSUJTPSIkTElCUyAkR1RLX0xJQlMiCisgICAgIENGTEFHUz0iJENGTEFHUyAk
R1RLX0NGTEFHUyIKKyAgIGVsc2UKKy0gICAgZWNobyAiR1RLIGZvdW5kLCBidXQgbmVlZCB2ZXJz
aW9uIDIuMTggb3IgaGlnaGVyIgorKyAgICBlY2hvICJQbGVhc2UgaW5zdGFsbCBndGsgYW5kIGdk
ayBsaWJyYXJpZXMiCisgICAgIGdmaW89Im5vIgorICAgZmkKKy1lbHNlCistICBlY2hvICJQbGVh
c2UgaW5zdGFsbCBndGsgYW5kIGdkayBsaWJyYXJpZXMiCistICBnZmlvPSJubyIKKyBmaQorIExE
RkxBR1M9JE9SR19MREZMQUdTCisgZmkKZGlmZiAtLW1pbmltYWwgLU5ydSBmaW8tMy4xMi9kZWJp
YW4vcGF0Y2hlcy9zZXJpZXMgZmlvLTMuMTIvZGViaWFuL3BhdGNoZXMvc2VyaWVzCi0tLSBmaW8t
My4xMi9kZWJpYW4vcGF0Y2hlcy9zZXJpZXMJMjAxOC0xMS0yOCAxODowOToxOS4wMDAwMDAwMDAg
KzAxMDAKKysrIGZpby0zLjEyL2RlYmlhbi9wYXRjaGVzL3NlcmllcwkyMDE5LTA1LTI1IDE0OjE0
OjAzLjAwMDAwMDAwMCArMDIwMApAQCAtMywzICszLDQgQEAKIGZpbzJnbnVwbG90LW1hbnBhZ2UK
IGNvbmZpZ3VyZS1uby1jb25maWdsb2cKIGdlbmZpby1pbnRlcnByZXRlcgorY3Jvc3MucGF0Y2gK
ZGlmZiAtLW1pbmltYWwgLU5ydSBmaW8tMy4xMi9kZWJpYW4vcnVsZXMgZmlvLTMuMTIvZGViaWFu
L3J1bGVzCi0tLSBmaW8tMy4xMi9kZWJpYW4vcnVsZXMJMjAxOC0xMS0yOCAxODowOToxOS4wMDAw
MDAwMDAgKzAxMDAKKysrIGZpby0zLjEyL2RlYmlhbi9ydWxlcwkyMDE5LTA1LTI1IDE0OjE0OjAz
LjAwMDAwMDAwMCArMDIwMApAQCAtOSwxMiArOSwxOCBAQAogIyBVbmNvbW1lbnQgdGhpcyB0byB0
dXJuIG9uIHZlcmJvc2UgbW9kZS4KICNleHBvcnQgREhfVkVSQk9TRT0xCiAKK2luY2x1ZGUgL3Vz
ci9zaGFyZS9kcGtnL2FyY2hpdGVjdHVyZS5taworCiBleHBvcnQgREVCX0xERkxBR1NfTUFJTlRf
UFJFUEVORCA6PSAtV2wsLXosZGVmcyAtV2wsLS1hcy1uZWVkZWQKIAogZXhwb3J0IERFQl9CVUlM
RF9NQUlOVF9PUFRJT05TID0gaGFyZGVuaW5nPSthbGwKIAogZXhwb3J0IFYgPSAxCiAKK2lmbmVx
ICgkKERFQl9CVUlMRF9BUkNIKSwkKERFQl9IT1NUX0FSQ0gpKQorZXhwb3J0IENST1NTX0NPTVBJ
TEU9JChERUJfSE9TVF9HTlVfVFlQRSktCitlbmRpZgorCiAlOgogCWRoICRACiAK

--_002_2555177PyF0XoxEVRmerkaba_--

