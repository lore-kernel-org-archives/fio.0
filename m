Return-Path: <tbertaud@conforama.fr>
From: Thierry BERTAUD <tbertaud@conforama.fr>
Subject: RE: fio-2c2c93d and with a lot of numjobs causing fio Jobs to Time
 Out
Date: Fri, 1 Jan 2016 12:46:20 +0000
Message-ID: <VI1PR05MB134346FE5EF1B463568C7A5DB1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
References: <VI1PR05MB13437814C9CD31D2CECE7398B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
	<56840F80.4060903@kernel.dk>
	<VI1PR05MB13435F5190D9D9A17C59315BB1FD0@VI1PR05MB1343.eurprd05.prod.outlook.com>
	<5684A8F1.6010105@kernel.dk>
	<VI1PR05MB13439C4033DED096900CDF30B1FE0@VI1PR05MB1343.eurprd05.prod.outlook.com>,<CANvN+ekwjftjYq=8KFiefRAFmUvZF1qpJ9Y6ohFBdMHH6TEAQg@mail.gmail.com>,<VI1PR05MB13433A1D09C1C60B66E2ABBFB1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
In-Reply-To: <VI1PR05MB13433A1D09C1C60B66E2ABBFB1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
Content-Language: fr-FR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hello Andrey,

I=A0tried different options to have symbols for gdb, your suggestion and ot=
hers with CFLAGS=A0( -g, -ggdb)=A0but any seems the right.
>=A0Try 'configure --disable-optimizations'.
Note: After quit gdb the fio load agaisnt CPU come=A0back.

I tried :=20
=A0 =A0# ./configure --disable-optimizations
=A0 =A0# gmake CC=3Dgcc
I have with gdb the same output:

=A0 =A0(gdb) info threads
=A0 =A0 =A0Id =A0 Target Id =A0 =A0 =A0 =A0 Frame
=A0 =A0* 1 =A0 =A0process 54526172 =A00xd051d470 in ?? ()
=A0 =A0(gdb) thread 1
=A0 =A0[Switching to thread 1 (process 54526172)]
=A0 =A0#0 =A00xd051d470 in ?? ()
=A0 =A0(gdb) bt
=A0 =A0#0 =A00xd051d470 in ?? ()
=A0 =A0#1 =A00xffffffff in ?? ()
=A0 =A0#2 =A00xd011f3e8 in ?? ()
=A0 =A0#3 =A00xd011ee38 in ?? ()
=A0 =A0#4 =A00x1001ed50 in ?? ()
=A0 =A0#5 =A00x1001fcbc in ?? ()
=A0 =A0#6 =A00x10020280 in ?? ()
=A0 =A0#7 =A00x10000efc in ?? ()
=A0 =A0#8 =A00x100001bc in ?? ()
=A0 =A0(gdb)

 I changed to:
=A0 =A0# ./configure
=A0 =A0# =A0CC=3Dgcc CFLAGS=3D'-g' =A0gmake

=A0=A0 =A0Attaching to process 33095880
=A0 =A00xd0119598 in ?? ()
=A0 =A0(gdb) info threads
=A0 =A0 =A0Id =A0 Target Id =A0 =A0 =A0 =A0 Frame
=A0 =A0* 1 =A0 =A0process 33095880 =A00xd0119598 in ?? ()
=A0 =A0(gdb) thread 1
=A0 =A0[Switching to thread 1 (process 33095880)]
=A0 =A0#0 =A00xd0119598 in ?? ()
=A0 =A0(gdb) bt
=A0 =A0#0 =A00xd0119598 in ?? ()
=A0 =A0#1 =A00xffffffff in ?? ()
=A0 =A0#2 =A00xd0119bc0 in ?? ()
=A0 =A0#3 =A00xd0118f28 in ?? ()
=A0 =A0#4 =A00x100625dc in ?? ()
=A0 =A0#5 =A00x1006482c in ?? ()
=A0 =A0#6 =A00x10064b90 in ?? ()
=A0 =A0#7 =A00xd0505c10 in ?? ()
=A0 =A0#8 =A00x00000000 in ?? ()
=A0 =A0(gdb)

I changed to:
=A0 =A0# ./configure
=A0 =A0# =A0CC=3Dgcc CFLAGS=3D'-ggdb' =A0gmake

=A0 =A00xd051d470 in ?? ()
=A0 =A0(gdb) info threads
=A0 =A0 =A0Id =A0 Target Id =A0 =A0 =A0 =A0 Frame
=A0 =A0* 1 =A0 =A0process 12124366 =A00xd051d470 in ?? ()
=A0 =A0(gdb) thread 1
=A0 =A0[Switching to thread 1 (process 12124366)]
=A0 =A0#0 =A00xd051d470 in ?? ()
=A0 =A0(gdb) bt
=A0 =A0#0 =A00xd051d470 in ?? ()
=A0 =A0#1 =A00xffffffff in ?? ()
=A0 =A0#2 =A00xd011f3e8 in ?? ()
=A0 =A0#3 =A00xd011ee38 in ?? ()
=A0 =A0#4 =A00x10069230 in ?? ()
=A0 =A0#5 =A00x10069644 in ?? ()
=A0 =A0#6 =A00x100004c4 in ?? ()
=A0 =A0#7 =A00x100001bc in ?? ()
=A0 =A0(gdb)

Regards,
Thierry
       =

