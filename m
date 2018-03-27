Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CY1PR0401MB1116E6D05D5F5FCC0283298581AC0@CY1PR0401MB1116.namprd04.prod.outlook.com>
References: <CY1PR0401MB111683B907AEAA34BB0A9A3881A80@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxjzvd7dBTYGBSMaiSWm+v+LgbcrtKdh7EpZdNWtwmcubg@mail.gmail.com>
 <CALjAwxjN890tChPL2cOw2NsU_M-85GcEJKq8XwotYNOoDgxEtA@mail.gmail.com>
 <CY1PR0401MB1116191E688201AE89DA270381AD0@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxhhXogm8x_7RbdOBq0wOEFSrguL2S-qTpN=7ahO=HZ_0g@mail.gmail.com>
 <CY1PR0401MB111665D846A301C108F9694B81AD0@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxibi4Pfy0OtBaWkwnoyYbQm+pZvhdUK_WWGEDPc6+DVdg@mail.gmail.com>
 <CY1PR0401MB1116C049AE98BC39FC9100C281AD0@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxjBiLRoQckkYqa8ywSm1CF5noqptgaZhZb8J3DSjg3dGw@mail.gmail.com> <CY1PR0401MB1116E6D05D5F5FCC0283298581AC0@CY1PR0401MB1116.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 27 Mar 2018 17:48:06 +0100
Message-ID: <CALjAwxiz=7RXoLYDw6yTPs-+6bz4FeBVfNzNdVtrUBVw9RP9xg@mail.gmail.com>
Subject: Re: "No I/O performed by <engine>" reporting bug?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Itay Ben Yaacov <Itay.BenYaacov@wdc.com>, Kris Davis <Kris.Davis@wdc.com>
List-ID: <fio@vger.kernel.org>

(CCing Jens)

On 27 March 2018 at 16:23, Kris Davis <Kris.Davis@wdc.com> wrote:
> Sitsofe,
>
> I'm wondering if I've completely misunderstood the meaning of "looping". =
 I was thinking it basically meant to "repeat" the job specification a numb=
er of times, but from your description of the impacts, that appears to be w=
rong.
>
> Looking at other verbiage in the doc, "loops" say to "repeat same workloa=
d a given number of times".  Under time_based, it says "it will simply loop=
 over the same workload as many times as runtime allows".    I'm wondering =
if the word 'loop' is really means the same thing in these two descriptions=
.  If nothing is really "reset" between loop iterations, then it seems to m=
e that these two uses of 'loop' mean the same thing.
>
> Sorry if I'm missing the point, but if the "loops" option really doesn't =
effect other aspects like the runtime, ramp_time or resetting LBAs and such=
, I'm confused when "loops" would be used - what does it accomplish that is=
n't available through other options?
>
> Thanks
>
> Kris Davis
>
> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Monday, March 26, 2018 2:52 PM
> To: Kris Davis <Kris.Davis@wdc.com>
> Cc: fio@vger.kernel.org; Itay Ben Yaacov <Itay.BenYaacov@wdc.com>
> Subject: Re: "No I/O performed by <engine>" reporting bug?
>
> On 26 March 2018 at 18:40, Kris Davis <Kris.Davis@wdc.com> wrote:
>>
>> I guess I'm was expecting that loops just means to repeat whatever the j=
ob was doing previously that number of times.  I guess that what I conclude=
 from the "loops" description: "Run the specified number of iterations of t=
his job. Used to repeat the same workload a given number of times. Defaults=
 to 1."
>>
>> I was expecting that each loop would start sequential operations back
>> at 0 or the offset, and redo any start_delay or ramp_time each time.
>> If that is not the case, I'm
>
> loops looks like a way to get a job to wrap I/O around to beginning it wh=
en it gets to the end of the file. Certain operations do happen when that w=
raparound/restart occurs (e.g. resetting the map of regions used/offset bei=
ng reset on sequential I/O) but not every job option is impacted (i.e. star=
t_delay and ramp_time will only happen once even when loops>=3D2).
>
>> either missing something in the doc, or it could probably use further cl=
arification.  If io_size is used rather than number_ios - does the starting=
 LBA get reset after each loop?
>
> Looking at some examples I see this:
>
> $ ./fio --name=3Dtest-loops --filename=3D/tmp/fio.tmp --size=3D4 --bs=3D1
> --loops=3D2 --io_size=3D3 --debug=3Dio | grep 'complete:\|cache'
> io       7649  declare unneeded cache /tmp/fio.tmp: 0/4
> io       7649  complete: io_u 0xb78500: off=3D0x0,len=3D0x1,ddir=3D0,file=
=3D/tmp/fio.tmp
> io       7649  complete: io_u 0xb78500: off=3D0x1,len=3D0x1,ddir=3D0,file=
=3D/tmp/fio.tmp
> io       7649  complete: io_u 0xb78500: off=3D0x2,len=3D0x1,ddir=3D0,file=
=3D/tmp/fio.tmp
> io       7649  complete: io_u 0xb78500: off=3D0x3,len=3D0x1,ddir=3D0,file=
=3D/tmp/fio.tmp
> io       7649  declare unneeded cache /tmp/fio.tmp: 0/4
> io       7649  complete: io_u 0xb78500: off=3D0x0,len=3D0x1,ddir=3D0,file=
=3D/tmp/fio.tmp
> io       7649  complete: io_u 0xb78500: off=3D0x1,len=3D0x1,ddir=3D0,file=
=3D/tmp/fio.tmp
>
> $ $ ./fio --name=3Dtest-loops --filename=3D/tmp/fio.tmp --size=3D4 --bs=
=3D1
> --loops=3D3 --number_ios=3D2 --debug=3Dio | grep 'complete:\|cache'
> io       7657  declare unneeded cache /tmp/fio.tmp: 0/4
> io       7657  complete: io_u 0x2310500:
> off=3D0x0,len=3D0x1,ddir=3D0,file=3D/tmp/fio.tmp
> io       7657  complete: io_u 0x2310500:
> off=3D0x1,len=3D0x1,ddir=3D0,file=3D/tmp/fio.tmp
> io       7657  complete: io_u 0x2310500:
> off=3D0x2,len=3D0x1,ddir=3D0,file=3D/tmp/fio.tmp
> io       7657  complete: io_u 0x2310500:
> off=3D0x3,len=3D0x1,ddir=3D0,file=3D/tmp/fio.tmp
> io       7657  declare unneeded cache /tmp/fio.tmp: 0/4
> io       7657  complete: io_u 0x2310500:
> off=3D0x0,len=3D0x1,ddir=3D0,file=3D/tmp/fio.tmp
> io       7657  complete: io_u 0x2310500:
> off=3D0x1,len=3D0x1,ddir=3D0,file=3D/tmp/fio.tmp
>
> Basically a loop only ends when I/O gets to the end of the file (and we s=
ee the cache being declared unneeded when the loop starts) but the interact=
ion with number_ios/io_size seems limited to just multiplying them by loops=
.
>
> Jens: originally number_ios/io_size would just end the entire job early r=
egardless of what loop you were on but that seems to have changed since cf8=
a46a75f38afe07ebf823210f95543999e3116 ("Make 'loops'
> honor full write+verify loops"). Is the intent for number_ios/io_size to =
be invariant of loops or to be per loop? What does it mean for a loop if io=
_size is bigger than the size of the file?
>
>> I don't really have any strong opinion on how number_ios works (we can u=
se io_size instead), it just seems like it was working differently before, =
and otherwise could just use further clarification. Do you know of any othe=
r "quantity" type of options would operate independent of the loops option?=
  (I think this is the first time I've seen loop used).
>
> runtime is the other one (we've covered io_size, number_ios and loops) an=
d that's loop invariant. In fact runtime with time_based essentially disabl=
es looking at the loop counter.


--=20
Sitsofe | http://sucs.org/~sits/

