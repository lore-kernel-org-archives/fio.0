Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <VI1PR05MB13433A1D09C1C60B66E2ABBFB1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
References: <VI1PR05MB13437814C9CD31D2CECE7398B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
	<56840F80.4060903@kernel.dk>
	<VI1PR05MB13435F5190D9D9A17C59315BB1FD0@VI1PR05MB1343.eurprd05.prod.outlook.com>
	<5684A8F1.6010105@kernel.dk>
	<VI1PR05MB13439C4033DED096900CDF30B1FE0@VI1PR05MB1343.eurprd05.prod.outlook.com>
	<CANvN+ekwjftjYq=8KFiefRAFmUvZF1qpJ9Y6ohFBdMHH6TEAQg@mail.gmail.com>
	<VI1PR05MB13433A1D09C1C60B66E2ABBFB1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
Date: Fri, 1 Jan 2016 15:54:39 +0300
Message-ID: <CANvN+e=X09zp=HRme4Wwad2_HhmNkOQkL8zXGWozuVWCm+NMYg@mail.gmail.com>
Subject: RE: fio-2c2c93d and with a lot of numjobs causing fio Jobs to Time Out
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Content-Type: multipart/alternative; boundary=001a1146f0de321d440528454641
To: Thierry BERTAUD <tbertaud@conforama.fr>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

--001a1146f0de321d440528454641
Content-Type: text/plain; charset=UTF-8

On Jan 1, 2016 15:43, "Thierry BERTAUD" <tbertaud@conforama.fr> wrote:
>
> Hello Andrey,
>
>
> I tried different options to have symbols for gdb, your suggestion and
others with CFLAGS ( -g, -ggdb) but any seems the right.
>
>
> > Try 'configure --disable-optimizations'.
>
> I tried :
>
>    # ./configure --disable-optimizations
>
>    # gmake CC=gcc
>

It's best to run make clean, configure --disable-optimizations, and then
make. Also, check if you have libpthreads-debug installed so that gdb
tracks libpthread symbols.

Regards,
A.

> I have with gdb the same output:
>
>    (gdb) info threads
>      Id   Target Id         Frame
>    * 1    process 54526172  0xd051d470 in ?? ()
>    (gdb) thread 1
>    [Switching to thread 1 (process 54526172)]
>    #0  0xd051d470 in ?? ()
>    (gdb) bt
>    #0  0xd051d470 in ?? ()
>    #1  0xffffffff in ?? ()
>    #2  0xd011f3e8 in ?? ()
>    #3  0xd011ee38 in ?? ()
>    #4  0x1001ed50 in ?? ()
>    #5  0x1001fcbc in ?? ()
>    #6  0x10020280 in ?? ()
>    #7  0x10000efc in ?? ()
>    #8  0x100001bc in ?? ()
>    (gdb)
>
> After quit gdb the fio load agaisnt CPU come back.
>
> I changed to:
>
>    # ./configure
>    #  CC=gcc CFLAGS='-g'  gmake
>
>    # gdb -p 33095880
>    GNU gdb (GDB) 7.8.1
>    Copyright (C) 2014 Free Software Foundation, Inc.
>    License GPLv3+: GNU GPL version 3 or later <
http://gnu.org/licenses/gpl.html>
>    This is free software: you are free to change and redistribute it.
>    There is NO WARRANTY, to the extent permitted by law.  Type "show
copying"
>    and "show warranty" for details.
>    This GDB was configured as "powerpc-ibm-aix5.1.0.0".
>    Type "show configuration" for configuration details.
>    For bug reporting instructions, please see:
>    <http://www.gnu.org/software/gdb/bugs/>.
>    Find the GDB manual and other documentation resources online at:
>    <http://www.gnu.org/software/gdb/documentation/>.
>    For help, type "help".
>    Type "apropos word" to search for commands related to "word".
>    Attaching to process 33095880
>    0xd0119598 in ?? ()
>    (gdb) info threads
>      Id   Target Id         Frame
>    * 1    process 33095880  0xd0119598 in ?? ()
>    (gdb) thread 1
>    [Switching to thread 1 (process 33095880)]
>    #0  0xd0119598 in ?? ()
>    (gdb) bt
>    #0  0xd0119598 in ?? ()
>    #1  0xffffffff in ?? ()
>    #2  0xd0119bc0 in ?? ()
>    #3  0xd0118f28 in ?? ()
>    #4  0x100625dc in ?? ()
>    #5  0x1006482c in ?? ()
>    #6  0x10064b90 in ?? ()
>    #7  0xd0505c10 in ?? ()
>    #8  0x00000000 in ?? ()
>    (gdb)
>
> I changed to:
>
>    # ./configure
>    #  CC=gcc CFLAGS='-ggdb'  gmake
>
>
>    # gdb -p 12124366
>    GNU gdb (GDB) 7.8.1
>    Copyright (C) 2014 Free Software Foundation, Inc.
>    License GPLv3+: GNU GPL version 3 or later <
http://gnu.org/licenses/gpl.html>
>    This is free software: you are free to change and redistribute it.
>    There is NO WARRANTY, to the extent permitted by law.  Type "show
copying"
>    and "show warranty" for details.
>    This GDB was configured as "powerpc-ibm-aix5.1.0.0".
>    Type "show configuration" for configuration details.
>    For bug reporting instructions, please see:
>    <http://www.gnu.org/software/gdb/bugs/>.
>    Find the GDB manual and other documentation resources online at:
>    <http://www.gnu.org/software/gdb/documentation/>.
>    For help, type "help".
>    Type "apropos word" to search for commands related to "word".
>    Attaching to process 12124366
>    0xd051d470 in ?? ()
>    (gdb) info threads
>      Id   Target Id         Frame
>    * 1    process 12124366  0xd051d470 in ?? ()
>    (gdb) thread 1
>    [Switching to thread 1 (process 12124366)]
>    #0  0xd051d470 in ?? ()
>    (gdb) bt
>    #0  0xd051d470 in ?? ()
>    #1  0xffffffff in ?? ()
>    #2  0xd011f3e8 in ?? ()
>    #3  0xd011ee38 in ?? ()
>    #4  0x10069230 in ?? ()
>    #5  0x10069644 in ?? ()
>    #6  0x100004c4 in ?? ()
>    #7  0x100001bc in ?? ()
>    (gdb)
>
> Regards,
>
> Thierry
>
>
>
> Regards,
>
> Thierry

--001a1146f0de321d440528454641
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr"><br>
On Jan 1, 2016 15:43, &quot;Thierry BERTAUD&quot; &lt;<a href=3D"mailto:tbe=
rtaud@conforama.fr">tbertaud@conforama.fr</a>&gt; wrote:<br>
&gt;<br>
&gt; Hello Andrey,<br>
&gt;<br>
&gt;<br>
&gt; I=C2=A0tried different options to have symbols for gdb, your suggestio=
n and others with CFLAGS=C2=A0( -g, -ggdb)=C2=A0but any seems the right.<br=
>
&gt;<br>
&gt;<br>
&gt; &gt;=C2=A0Try &#39;configure --disable-optimizations&#39;.<br>
&gt;<br>
&gt; I tried :<br>
&gt;<br>
&gt; =C2=A0 =C2=A0# ./configure --disable-optimizations<br>
&gt;<br>
&gt; =C2=A0 =C2=A0# gmake CC=3Dgcc<br>
&gt;</p>
<p dir=3D"ltr">It&#39;s best to run make clean, configure --disable-optimiz=
ations, and then make. Also, check if you have libpthreads-debug installed =
so that gdb tracks libpthread symbols.</p>
<p dir=3D"ltr">Regards,<br>
A.</p>
<p dir=3D"ltr">&gt; I have with gdb the same output:<br>
&gt;<br>
&gt; =C2=A0 =C2=A0(gdb) info threads<br>
&gt; =C2=A0 =C2=A0 =C2=A0Id =C2=A0 Target Id =C2=A0 =C2=A0 =C2=A0 =C2=A0 Fr=
ame<br>
&gt; =C2=A0 =C2=A0* 1 =C2=A0 =C2=A0process 54526172 =C2=A00xd051d470 in ?? =
()<br>
&gt; =C2=A0 =C2=A0(gdb) thread 1<br>
&gt; =C2=A0 =C2=A0[Switching to thread 1 (process 54526172)]<br>
&gt; =C2=A0 =C2=A0#0 =C2=A00xd051d470 in ?? ()<br>
&gt; =C2=A0 =C2=A0(gdb) bt<br>
&gt; =C2=A0 =C2=A0#0 =C2=A00xd051d470 in ?? ()<br>
&gt; =C2=A0 =C2=A0#1 =C2=A00xffffffff in ?? ()<br>
&gt; =C2=A0 =C2=A0#2 =C2=A00xd011f3e8 in ?? ()<br>
&gt; =C2=A0 =C2=A0#3 =C2=A00xd011ee38 in ?? ()<br>
&gt; =C2=A0 =C2=A0#4 =C2=A00x1001ed50 in ?? ()<br>
&gt; =C2=A0 =C2=A0#5 =C2=A00x1001fcbc in ?? ()<br>
&gt; =C2=A0 =C2=A0#6 =C2=A00x10020280 in ?? ()<br>
&gt; =C2=A0 =C2=A0#7 =C2=A00x10000efc in ?? ()<br>
&gt; =C2=A0 =C2=A0#8 =C2=A00x100001bc in ?? ()<br>
&gt; =C2=A0 =C2=A0(gdb)<br>
&gt;<br>
&gt; After quit gdb the fio load agaisnt CPU come=C2=A0back.<br>
&gt;<br>
&gt; I changed to:<br>
&gt;<br>
&gt; =C2=A0 =C2=A0# ./configure<br>
&gt; =C2=A0 =C2=A0# =C2=A0CC=3Dgcc CFLAGS=3D&#39;-g&#39; =C2=A0gmake<br>
&gt;<br>
&gt; =C2=A0 =C2=A0# gdb -p 33095880<br>
&gt; =C2=A0 =C2=A0GNU gdb (GDB) 7.8.1<br>
&gt; =C2=A0 =C2=A0Copyright (C) 2014 Free Software Foundation, Inc.<br>
&gt; =C2=A0 =C2=A0License GPLv3+: GNU GPL version 3 or later &lt;<a href=3D=
"http://gnu.org/licenses/gpl.html">http://gnu.org/licenses/gpl.html</a>&gt;=
<br>
&gt; =C2=A0 =C2=A0This is free software: you are free to change and redistr=
ibute it.<br>
&gt; =C2=A0 =C2=A0There is NO WARRANTY, to the extent permitted by law.=C2=
=A0 Type &quot;show copying&quot;<br>
&gt; =C2=A0 =C2=A0and &quot;show warranty&quot; for details.<br>
&gt; =C2=A0 =C2=A0This GDB was configured as &quot;powerpc-ibm-aix5.1.0.0&q=
uot;.<br>
&gt; =C2=A0 =C2=A0Type &quot;show configuration&quot; for configuration det=
ails.<br>
&gt; =C2=A0 =C2=A0For bug reporting instructions, please see:<br>
&gt; =C2=A0 =C2=A0&lt;<a href=3D"http://www.gnu.org/software/gdb/bugs/">htt=
p://www.gnu.org/software/gdb/bugs/</a>&gt;.<br>
&gt; =C2=A0 =C2=A0Find the GDB manual and other documentation resources onl=
ine at:<br>
&gt; =C2=A0 =C2=A0&lt;<a href=3D"http://www.gnu.org/software/gdb/documentat=
ion/">http://www.gnu.org/software/gdb/documentation/</a>&gt;.<br>
&gt; =C2=A0 =C2=A0For help, type &quot;help&quot;.<br>
&gt; =C2=A0 =C2=A0Type &quot;apropos word&quot; to search for commands rela=
ted to &quot;word&quot;.<br>
&gt; =C2=A0 =C2=A0Attaching to process 33095880<br>
&gt; =C2=A0 =C2=A00xd0119598 in ?? ()<br>
&gt; =C2=A0 =C2=A0(gdb) info threads<br>
&gt; =C2=A0 =C2=A0 =C2=A0Id =C2=A0 Target Id =C2=A0 =C2=A0 =C2=A0 =C2=A0 Fr=
ame<br>
&gt; =C2=A0 =C2=A0* 1 =C2=A0 =C2=A0process 33095880 =C2=A00xd0119598 in ?? =
()<br>
&gt; =C2=A0 =C2=A0(gdb) thread 1<br>
&gt; =C2=A0 =C2=A0[Switching to thread 1 (process 33095880)]<br>
&gt; =C2=A0 =C2=A0#0 =C2=A00xd0119598 in ?? ()<br>
&gt; =C2=A0 =C2=A0(gdb) bt<br>
&gt; =C2=A0 =C2=A0#0 =C2=A00xd0119598 in ?? ()<br>
&gt; =C2=A0 =C2=A0#1 =C2=A00xffffffff in ?? ()<br>
&gt; =C2=A0 =C2=A0#2 =C2=A00xd0119bc0 in ?? ()<br>
&gt; =C2=A0 =C2=A0#3 =C2=A00xd0118f28 in ?? ()<br>
&gt; =C2=A0 =C2=A0#4 =C2=A00x100625dc in ?? ()<br>
&gt; =C2=A0 =C2=A0#5 =C2=A00x1006482c in ?? ()<br>
&gt; =C2=A0 =C2=A0#6 =C2=A00x10064b90 in ?? ()<br>
&gt; =C2=A0 =C2=A0#7 =C2=A00xd0505c10 in ?? ()<br>
&gt; =C2=A0 =C2=A0#8 =C2=A00x00000000 in ?? ()<br>
&gt; =C2=A0 =C2=A0(gdb)<br>
&gt;<br>
&gt; I changed to:<br>
&gt;<br>
&gt; =C2=A0 =C2=A0# ./configure<br>
&gt; =C2=A0 =C2=A0# =C2=A0CC=3Dgcc CFLAGS=3D&#39;-ggdb&#39; =C2=A0gmake<br>
&gt;<br>
&gt;<br>
&gt; =C2=A0 =C2=A0# gdb -p 12124366<br>
&gt; =C2=A0 =C2=A0GNU gdb (GDB) 7.8.1<br>
&gt; =C2=A0 =C2=A0Copyright (C) 2014 Free Software Foundation, Inc.<br>
&gt; =C2=A0 =C2=A0License GPLv3+: GNU GPL version 3 or later &lt;<a href=3D=
"http://gnu.org/licenses/gpl.html">http://gnu.org/licenses/gpl.html</a>&gt;=
<br>
&gt; =C2=A0 =C2=A0This is free software: you are free to change and redistr=
ibute it.<br>
&gt; =C2=A0 =C2=A0There is NO WARRANTY, to the extent permitted by law.=C2=
=A0 Type &quot;show copying&quot;<br>
&gt; =C2=A0 =C2=A0and &quot;show warranty&quot; for details.<br>
&gt; =C2=A0 =C2=A0This GDB was configured as &quot;powerpc-ibm-aix5.1.0.0&q=
uot;.<br>
&gt; =C2=A0 =C2=A0Type &quot;show configuration&quot; for configuration det=
ails.<br>
&gt; =C2=A0 =C2=A0For bug reporting instructions, please see:<br>
&gt; =C2=A0 =C2=A0&lt;<a href=3D"http://www.gnu.org/software/gdb/bugs/">htt=
p://www.gnu.org/software/gdb/bugs/</a>&gt;.<br>
&gt; =C2=A0 =C2=A0Find the GDB manual and other documentation resources onl=
ine at:<br>
&gt; =C2=A0 =C2=A0&lt;<a href=3D"http://www.gnu.org/software/gdb/documentat=
ion/">http://www.gnu.org/software/gdb/documentation/</a>&gt;.<br>
&gt; =C2=A0 =C2=A0For help, type &quot;help&quot;.<br>
&gt; =C2=A0 =C2=A0Type &quot;apropos word&quot; to search for commands rela=
ted to &quot;word&quot;.<br>
&gt; =C2=A0 =C2=A0Attaching to process 12124366<br>
&gt; =C2=A0 =C2=A00xd051d470 in ?? ()<br>
&gt; =C2=A0 =C2=A0(gdb) info threads<br>
&gt; =C2=A0 =C2=A0 =C2=A0Id =C2=A0 Target Id =C2=A0 =C2=A0 =C2=A0 =C2=A0 Fr=
ame<br>
&gt; =C2=A0 =C2=A0* 1 =C2=A0 =C2=A0process 12124366 =C2=A00xd051d470 in ?? =
()<br>
&gt; =C2=A0 =C2=A0(gdb) thread 1<br>
&gt; =C2=A0 =C2=A0[Switching to thread 1 (process 12124366)]<br>
&gt; =C2=A0 =C2=A0#0 =C2=A00xd051d470 in ?? ()<br>
&gt; =C2=A0 =C2=A0(gdb) bt<br>
&gt; =C2=A0 =C2=A0#0 =C2=A00xd051d470 in ?? ()<br>
&gt; =C2=A0 =C2=A0#1 =C2=A00xffffffff in ?? ()<br>
&gt; =C2=A0 =C2=A0#2 =C2=A00xd011f3e8 in ?? ()<br>
&gt; =C2=A0 =C2=A0#3 =C2=A00xd011ee38 in ?? ()<br>
&gt; =C2=A0 =C2=A0#4 =C2=A00x10069230 in ?? ()<br>
&gt; =C2=A0 =C2=A0#5 =C2=A00x10069644 in ?? ()<br>
&gt; =C2=A0 =C2=A0#6 =C2=A00x100004c4 in ?? ()<br>
&gt; =C2=A0 =C2=A0#7 =C2=A00x100001bc in ?? ()<br>
&gt; =C2=A0 =C2=A0(gdb)<br>
&gt;<br>
&gt; Regards,<br>
&gt;<br>
&gt; Thierry<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; Regards,<br>
&gt;<br>
&gt; Thierry</p>

--001a1146f0de321d440528454641--

