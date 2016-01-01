Return-Path: <tbertaud@conforama.fr>
From: Thierry BERTAUD <tbertaud@conforama.fr>
Subject: RE: fio-2c2c93d and with a lot of numjobs causing fio Jobs to Time
 Out
Date: Fri, 1 Jan 2016 12:43:13 +0000
Message-ID: <VI1PR05MB13433A1D09C1C60B66E2ABBFB1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
References: <VI1PR05MB13437814C9CD31D2CECE7398B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
	<56840F80.4060903@kernel.dk>
	<VI1PR05MB13435F5190D9D9A17C59315BB1FD0@VI1PR05MB1343.eurprd05.prod.outlook.com>
	<5684A8F1.6010105@kernel.dk>
	<VI1PR05MB13439C4033DED096900CDF30B1FE0@VI1PR05MB1343.eurprd05.prod.outlook.com>,<CANvN+ekwjftjYq=8KFiefRAFmUvZF1qpJ9Y6ohFBdMHH6TEAQg@mail.gmail.com>
In-Reply-To: <CANvN+ekwjftjYq=8KFiefRAFmUvZF1qpJ9Y6ohFBdMHH6TEAQg@mail.gmail.com>
Content-Language: fr-FR
Content-Type: multipart/alternative;
	boundary="_000_VI1PR05MB13433A1D09C1C60B66E2ABBFB1FF0VI1PR05MB1343eurp_"
MIME-Version: 1.0
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

--_000_VI1PR05MB13433A1D09C1C60B66E2ABBFB1FF0VI1PR05MB1343eurp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello Andrey,


I tried different options to have symbols for gdb, your suggestion and othe=
rs with CFLAGS ( -g, -ggdb) but any seems the right.


> Try 'configure --disable-optimizations'.

I tried :

   # ./configure --disable-optimizations

   # gmake CC=3Dgcc

I have with gdb the same output:

   (gdb) info threads
     Id   Target Id         Frame
   * 1    process 54526172  0xd051d470 in ?? ()
   (gdb) thread 1
   [Switching to thread 1 (process 54526172)]
   #0  0xd051d470 in ?? ()
   (gdb) bt
   #0  0xd051d470 in ?? ()
   #1  0xffffffff in ?? ()
   #2  0xd011f3e8 in ?? ()
   #3  0xd011ee38 in ?? ()
   #4  0x1001ed50 in ?? ()
   #5  0x1001fcbc in ?? ()
   #6  0x10020280 in ?? ()
   #7  0x10000efc in ?? ()
   #8  0x100001bc in ?? ()
   (gdb)

After quit gdb the fio load agaisnt CPU come back.

I changed to:

   # ./configure
   #  CC=3Dgcc CFLAGS=3D'-g'  gmake

   # gdb -p 33095880
   GNU gdb (GDB) 7.8.1
   Copyright (C) 2014 Free Software Foundation, Inc.
   License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.=
html>
   This is free software: you are free to change and redistribute it.
   There is NO WARRANTY, to the extent permitted by law.  Type "show copyin=
g"
   and "show warranty" for details.
   This GDB was configured as "powerpc-ibm-aix5.1.0.0".
   Type "show configuration" for configuration details.
   For bug reporting instructions, please see:
   <http://www.gnu.org/software/gdb/bugs/>.
   Find the GDB manual and other documentation resources online at:
   <http://www.gnu.org/software/gdb/documentation/>.
   For help, type "help".
   Type "apropos word" to search for commands related to "word".
   Attaching to process 33095880
   0xd0119598 in ?? ()
   (gdb) info threads
     Id   Target Id         Frame
   * 1    process 33095880  0xd0119598 in ?? ()
   (gdb) thread 1
   [Switching to thread 1 (process 33095880)]
   #0  0xd0119598 in ?? ()
   (gdb) bt
   #0  0xd0119598 in ?? ()
   #1  0xffffffff in ?? ()
   #2  0xd0119bc0 in ?? ()
   #3  0xd0118f28 in ?? ()
   #4  0x100625dc in ?? ()
   #5  0x1006482c in ?? ()
   #6  0x10064b90 in ?? ()
   #7  0xd0505c10 in ?? ()
   #8  0x00000000 in ?? ()
   (gdb)


I changed to:

   # ./configure
   #  CC=3Dgcc CFLAGS=3D'-ggdb'  gmake

   # gdb -p 12124366
   GNU gdb (GDB) 7.8.1
   Copyright (C) 2014 Free Software Foundation, Inc.
   License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.=
html>
   This is free software: you are free to change and redistribute it.
   There is NO WARRANTY, to the extent permitted by law.  Type "show copyin=
g"
   and "show warranty" for details.
   This GDB was configured as "powerpc-ibm-aix5.1.0.0".
   Type "show configuration" for configuration details.
   For bug reporting instructions, please see:
   <http://www.gnu.org/software/gdb/bugs/>.
   Find the GDB manual and other documentation resources online at:
   <http://www.gnu.org/software/gdb/documentation/>.
   For help, type "help".
   Type "apropos word" to search for commands related to "word".
   Attaching to process 12124366
   0xd051d470 in ?? ()
   (gdb) info threads
     Id   Target Id         Frame
   * 1    process 12124366  0xd051d470 in ?? ()
   (gdb) thread 1
   [Switching to thread 1 (process 12124366)]
   #0  0xd051d470 in ?? ()
   (gdb) bt
   #0  0xd051d470 in ?? ()
   #1  0xffffffff in ?? ()
   #2  0xd011f3e8 in ?? ()
   #3  0xd011ee38 in ?? ()
   #4  0x10069230 in ?? ()
   #5  0x10069644 in ?? ()
   #6  0x100004c4 in ?? ()
   #7  0x100001bc in ?? ()
   (gdb)

Regards,

Thierry



Regards,

Thierry

--_000_VI1PR05MB13433A1D09C1C60B66E2ABBFB1FF0VI1PR05MB1343eurp_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style type=3D"text/css" style=3D"display:none;"><!-- P {margin-top:0;margi=
n-bottom:0;} --></style>
</head>
<body dir=3D"ltr">
<div id=3D"divtagdefaultwrapper" style=3D"font-size:12pt;color:#000000;back=
ground-color:#FFFFFF;font-family:Calibri,Arial,Helvetica,sans-serif;">
<p>Hello Andrey,</p>
<p><br>
</p>
<p>I&nbsp;tried different options to have symbols for gdb, your suggestion =
and others with CFLAGS&nbsp;( -g, -ggdb)&nbsp;but any seems the right.</p>
<p><br>
</p>
<p>&gt;&nbsp;<span style=3D"font-size: 12pt;">Try 'configure --disable-opti=
mizations'.</span></p>
<div style=3D"color: rgb(0, 0, 0);">
<div>
<p dir=3D"ltr">I tried : </p>
<p dir=3D"ltr">&nbsp; &nbsp;# ./configure --disable-optimizations<br>
</p>
<p dir=3D"ltr">&nbsp; &nbsp;# gmake CC=3Dgcc<br>
</p>
<p dir=3D"ltr">I have with gdb the same output:</p>
<p dir=3D"ltr"></p>
<div>&nbsp; &nbsp;(gdb) info threads</div>
<div>&nbsp; &nbsp; &nbsp;Id &nbsp; Target Id &nbsp; &nbsp; &nbsp; &nbsp; Fr=
ame</div>
<div>&nbsp; &nbsp;* 1 &nbsp; &nbsp;process 54526172 &nbsp;0xd051d470 in ?? =
()</div>
<div>&nbsp; &nbsp;(gdb) thread 1</div>
<div>&nbsp; &nbsp;[Switching to thread 1 (process 54526172)]</div>
<div>&nbsp; &nbsp;#0 &nbsp;0xd051d470 in ?? ()</div>
<div>&nbsp; &nbsp;(gdb) bt</div>
<div>&nbsp; &nbsp;#0 &nbsp;0xd051d470 in ?? ()</div>
<div>&nbsp; &nbsp;#1 &nbsp;0xffffffff in ?? ()</div>
<div>&nbsp; &nbsp;#2 &nbsp;0xd011f3e8 in ?? ()</div>
<div>&nbsp; &nbsp;#3 &nbsp;0xd011ee38 in ?? ()</div>
<div>&nbsp; &nbsp;#4 &nbsp;0x1001ed50 in ?? ()</div>
<div>&nbsp; &nbsp;#5 &nbsp;0x1001fcbc in ?? ()</div>
<div>&nbsp; &nbsp;#6 &nbsp;0x10020280 in ?? ()</div>
<div>&nbsp; &nbsp;#7 &nbsp;0x10000efc in ?? ()</div>
<div>&nbsp; &nbsp;#8 &nbsp;0x100001bc in ?? ()</div>
<div>&nbsp; &nbsp;(gdb)</div>
<div><br>
</div>
<div>After quit gdb the fio load agaisnt CPU come&nbsp;back.</div>
<div><br>
</div>
I changed to:
<p></p>
<p dir=3D"ltr"></p>
<div>&nbsp; &nbsp;<span style=3D"font-family: Calibri, Arial, Helvetica, sa=
ns-serif, 'Apple Color Emoji', 'Segoe UI Emoji', NotoColorEmoji, 'Segoe UI =
Symbol', 'Android Emoji', EmojiSymbols; font-size: 16px;"># ./configure</sp=
an></div>
<div>&nbsp; &nbsp;# &nbsp;CC=3Dgcc CFLAGS=3D'-g' &nbsp;gmake</div>
<div><br>
</div>
<div>
<div>&nbsp; &nbsp;# gdb -p 33095880</div>
<div>&nbsp; &nbsp;GNU gdb (GDB) 7.8.1</div>
<div>&nbsp; &nbsp;Copyright (C) 2014 Free Software Foundation, Inc.</div>
<div>&nbsp; &nbsp;License GPLv3&#43;: GNU GPL version 3 or later &lt;http:/=
/gnu.org/licenses/gpl.html&gt;</div>
<div>&nbsp; &nbsp;This is free software: you are free to change and redistr=
ibute it.</div>
<div>&nbsp; &nbsp;There is NO WARRANTY, to the extent permitted by law. &nb=
sp;Type &quot;show copying&quot;</div>
<div>&nbsp; &nbsp;and &quot;show warranty&quot; for details.</div>
<div>&nbsp; &nbsp;This GDB was configured as &quot;powerpc-ibm-aix5.1.0.0&q=
uot;.</div>
<div>&nbsp; &nbsp;Type &quot;show configuration&quot; for configuration det=
ails.</div>
<div>&nbsp; &nbsp;For bug reporting instructions, please see:</div>
<div>&nbsp; &nbsp;&lt;http://www.gnu.org/software/gdb/bugs/&gt;.</div>
<div>&nbsp; &nbsp;Find the GDB manual and other documentation resources onl=
ine at:</div>
<div>&nbsp; &nbsp;&lt;http://www.gnu.org/software/gdb/documentation/&gt;.</=
div>
<div>&nbsp; &nbsp;For help, type &quot;help&quot;.</div>
<div>&nbsp; &nbsp;Type &quot;apropos word&quot; to search for commands rela=
ted to &quot;word&quot;.</div>
<div>&nbsp; &nbsp;Attaching to process 33095880</div>
<div>&nbsp; &nbsp;0xd0119598 in ?? ()</div>
<div>&nbsp; &nbsp;(gdb) info threads</div>
<div>&nbsp; &nbsp; &nbsp;Id &nbsp; Target Id &nbsp; &nbsp; &nbsp; &nbsp; Fr=
ame</div>
<div>&nbsp; &nbsp;* 1 &nbsp; &nbsp;process 33095880 &nbsp;0xd0119598 in ?? =
()</div>
<div>&nbsp; &nbsp;(gdb) thread 1</div>
<div>&nbsp; &nbsp;[Switching to thread 1 (process 33095880)]</div>
<div>&nbsp; &nbsp;#0 &nbsp;0xd0119598 in ?? ()</div>
<div>&nbsp; &nbsp;(gdb) bt</div>
<div>&nbsp; &nbsp;#0 &nbsp;0xd0119598 in ?? ()</div>
<div>&nbsp; &nbsp;#1 &nbsp;0xffffffff in ?? ()</div>
<div>&nbsp; &nbsp;#2 &nbsp;0xd0119bc0 in ?? ()</div>
<div>&nbsp; &nbsp;#3 &nbsp;0xd0118f28 in ?? ()</div>
<div>&nbsp; &nbsp;#4 &nbsp;0x100625dc in ?? ()</div>
<div>&nbsp; &nbsp;#5 &nbsp;0x1006482c in ?? ()</div>
<div>&nbsp; &nbsp;#6 &nbsp;0x10064b90 in ?? ()</div>
<div>&nbsp; &nbsp;#7 &nbsp;0xd0505c10 in ?? ()</div>
<div>&nbsp; &nbsp;#8 &nbsp;0x00000000 in ?? ()</div>
<div>&nbsp; &nbsp;(gdb)</div>
<br>
</div>
<div>
<p dir=3D"ltr" style=3D"font-family: Calibri, Arial, Helvetica, sans-serif,=
 'Apple Color Emoji', 'Segoe UI Emoji', NotoColorEmoji, 'Segoe UI Symbol', =
'Android Emoji', EmojiSymbols; font-size: 16px;">
I changed to:</p>
<p dir=3D"ltr" style=3D"font-family: Calibri, Arial, Helvetica, sans-serif,=
 'Apple Color Emoji', 'Segoe UI Emoji', NotoColorEmoji, 'Segoe UI Symbol', =
'Android Emoji', EmojiSymbols; font-size: 16px;">
</p>
<div>&nbsp; &nbsp;<span style=3D"font-family: Calibri, Arial, Helvetica, sa=
ns-serif, 'Apple Color Emoji', 'Segoe UI Emoji', NotoColorEmoji, 'Segoe UI =
Symbol', 'Android Emoji', EmojiSymbols; font-size: 16px;"># ./configure</sp=
an></div>
<div>&nbsp; &nbsp;# &nbsp;CC=3Dgcc CFLAGS=3D'-ggdb' &nbsp;gmake</div>
<p></p>
<br>
</div>
<div>
<div>&nbsp; &nbsp;# gdb -p 12124366</div>
<div>&nbsp; &nbsp;GNU gdb (GDB) 7.8.1</div>
<div>&nbsp; &nbsp;Copyright (C) 2014 Free Software Foundation, Inc.</div>
<div>&nbsp; &nbsp;License GPLv3&#43;: GNU GPL version 3 or later &lt;http:/=
/gnu.org/licenses/gpl.html&gt;</div>
<div>&nbsp; &nbsp;This is free software: you are free to change and redistr=
ibute it.</div>
<div>&nbsp; &nbsp;There is NO WARRANTY, to the extent permitted by law. &nb=
sp;Type &quot;show copying&quot;</div>
<div>&nbsp; &nbsp;and &quot;show warranty&quot; for details.</div>
<div>&nbsp; &nbsp;This GDB was configured as &quot;powerpc-ibm-aix5.1.0.0&q=
uot;.</div>
<div>&nbsp; &nbsp;Type &quot;show configuration&quot; for configuration det=
ails.</div>
<div>&nbsp; &nbsp;For bug reporting instructions, please see:</div>
<div>&nbsp; &nbsp;&lt;http://www.gnu.org/software/gdb/bugs/&gt;.</div>
<div>&nbsp; &nbsp;Find the GDB manual and other documentation resources onl=
ine at:</div>
<div>&nbsp; &nbsp;&lt;http://www.gnu.org/software/gdb/documentation/&gt;.</=
div>
<div>&nbsp; &nbsp;For help, type &quot;help&quot;.</div>
<div>&nbsp; &nbsp;Type &quot;apropos word&quot; to search for commands rela=
ted to &quot;word&quot;.</div>
<div>&nbsp; &nbsp;Attaching to process 12124366</div>
<div>&nbsp; &nbsp;0xd051d470 in ?? ()</div>
<div>&nbsp; &nbsp;(gdb) info threads</div>
<div>&nbsp; &nbsp; &nbsp;Id &nbsp; Target Id &nbsp; &nbsp; &nbsp; &nbsp; Fr=
ame</div>
<div>&nbsp; &nbsp;* 1 &nbsp; &nbsp;process 12124366 &nbsp;0xd051d470 in ?? =
()</div>
<div>&nbsp; &nbsp;(gdb) thread 1</div>
<div>&nbsp; &nbsp;[Switching to thread 1 (process 12124366)]</div>
<div>&nbsp; &nbsp;#0 &nbsp;0xd051d470 in ?? ()</div>
<div>&nbsp; &nbsp;(gdb) bt</div>
<div>&nbsp; &nbsp;#0 &nbsp;0xd051d470 in ?? ()</div>
<div>&nbsp; &nbsp;#1 &nbsp;0xffffffff in ?? ()</div>
<div>&nbsp; &nbsp;#2 &nbsp;0xd011f3e8 in ?? ()</div>
<div>&nbsp; &nbsp;#3 &nbsp;0xd011ee38 in ?? ()</div>
<div>&nbsp; &nbsp;#4 &nbsp;0x10069230 in ?? ()</div>
<div>&nbsp; &nbsp;#5 &nbsp;0x10069644 in ?? ()</div>
<div>&nbsp; &nbsp;#6 &nbsp;0x100004c4 in ?? ()</div>
<div>&nbsp; &nbsp;#7 &nbsp;0x100001bc in ?? ()</div>
<div>&nbsp; &nbsp;(gdb)</div>
<div><br>
</div>
</div>
<div></div>
Regards,
<p></p>
<p dir=3D"ltr">Thierry</p>
<p dir=3D"ltr"><br>
</p>
<p dir=3D"ltr"><br>
</p>
<p dir=3D"ltr">Regards,</p>
<p dir=3D"ltr">Thierry</p>
</div>
</div>
</div>
</body>
</html>

--_000_VI1PR05MB13433A1D09C1C60B66E2ABBFB1FF0VI1PR05MB1343eurp_--

