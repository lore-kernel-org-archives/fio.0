Return-Path: <tbertaud@conforama.fr>
From: Thierry BERTAUD <tbertaud@conforama.fr>
Subject: RE: fio-2c2c93d and with a lot of numjobs causing fio Jobs to Time
 Out
Date: Fri, 1 Jan 2016 17:31:51 +0000
Message-ID: <VI1PR05MB13431DA43361FC9F4F55FC95B1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
References: <VI1PR05MB13437814C9CD31D2CECE7398B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
	<56840F80.4060903@kernel.dk>
	<VI1PR05MB13435F5190D9D9A17C59315BB1FD0@VI1PR05MB1343.eurprd05.prod.outlook.com>
	<5684A8F1.6010105@kernel.dk>
	<VI1PR05MB13439C4033DED096900CDF30B1FE0@VI1PR05MB1343.eurprd05.prod.outlook.com>
	<CANvN+ekwjftjYq=8KFiefRAFmUvZF1qpJ9Y6ohFBdMHH6TEAQg@mail.gmail.com>
	<VI1PR05MB13433A1D09C1C60B66E2ABBFB1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
	<CANvN+e=X09zp=HRme4Wwad2_HhmNkOQkL8zXGWozuVWCm+NMYg@mail.gmail.com>
	<VI1PR05MB1343810AF909BB41065666C9B1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
	<CANvN+e=cxWLEnu3Ve7RQKTh4TQubWMzkt0fkZ_AyKbNPAt21QQ@mail.gmail.com>
	<VI1PR05MB13430232A50B8818A220B23DB1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>,<CANvN+emwcrcVpuGsHBuNiw28WDKyyuNQvVd7G3QJFuy5siXqYw@mail.gmail.com>
In-Reply-To: <CANvN+emwcrcVpuGsHBuNiw28WDKyyuNQvVd7G3QJFuy5siXqYw@mail.gmail.com>
Content-Language: fr-FR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Andrey,

>> How to have sure gcc take the option via configure : configure --disable=
-optimizations because it's not work for me with gdb?
>No options involved, --disable-optimizations simply doesn't strip debug in=
fo (as gcc usually does with -O3). Unless gcc on aix does something weird, =
that should just happen by itself.

But i have symbols in the binary.=20
   # file fio
   fio: executable (RISC System/6000) or object module not stripped
   #
if i check with nm:
   # nm fio=20
   :T1000=3DeIO_LOG_TYPE_LAT:1,IO_LOG_TYPE_CLAT:2,IO_LOG_TYPE_SLAT:3,IO_LOG=
_TYPE_BW:4,IO_LOG_TYPE_IOPS:5,; -           0
    :T1001=3DeIO_LOG_TYPE_LAT:1,IO_LOG_TYPE_CLAT:2,IO_LOG_TYPE_SLAT:3,IO_LO=
G_TYPE_BW:4,IO_LOG_TYPE_IOPS:5,; -           0
    :T1001=3DeIO_LOG_TYPE_LAT:1,IO_LOG_TYPE_CLAT:2,IO_LOG_TYPE_SLAT:3,IO_LO=
G_TYPE_BW:4,IO_LOG_TYPE_IOPS:5,; -           0
    :T1002=3DeIP_F_ONRB:1,IP_F_ONLIST:2,IP_F_TRIMMED:4,IP_F_IN_FLIGHT:8,; -=
           0
    ...

> You reported 128 threads in the original problem report. Is the below a d=
iffernt one?
When i launch fio with: HDISK=3Dhdisk6 RWTYPE=3Drw RRATIO=3D0 BS=3D65536 QD=
=3D128 NJ=3D128 /home/padmin/fio/fio-5f3bd0f/fio myfio.fio
Form unix with ps,  i have 129 fio process running. When fio is stucking, i=
t staying alive only 1 the main process that fork the 128 process.

>> =A0 =A0(dbx) thread
>> =A0 =A0 thread =A0state-k =A0 =A0 wchan =A0 =A0state-u =A0 =A0k-tid =A0 =
mode held scope function
>> =A0 =A0>$t1 =A0 =A0 run =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0running =A084=
803767 =A0 =A0 k =A0 no =A0 sys =A0_p_nsleep
>> =A0 =A0 $t2 =A0 =A0 run =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0running =A011=
0231691 =A0 =A0 u =A0 no =A0 sys =A0__ioctl
> Thread 2 sleeps in the ioctl that the trace reports as failed. May be thi=
s is the root cause behind your issue?

Perhaps but i don't know how to progress againt it?

Regards,
Thierry=

