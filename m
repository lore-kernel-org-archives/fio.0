Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:36946 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751076AbeCZTwD (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 26 Mar 2018 15:52:03 -0400
Received: by mail-ua0-f170.google.com with SMTP id q12so12878301uae.4
        for <fio@vger.kernel.org>; Mon, 26 Mar 2018 12:52:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CY1PR0401MB1116C049AE98BC39FC9100C281AD0@CY1PR0401MB1116.namprd04.prod.outlook.com>
References: <CY1PR0401MB111683B907AEAA34BB0A9A3881A80@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxjzvd7dBTYGBSMaiSWm+v+LgbcrtKdh7EpZdNWtwmcubg@mail.gmail.com>
 <CALjAwxjN890tChPL2cOw2NsU_M-85GcEJKq8XwotYNOoDgxEtA@mail.gmail.com>
 <CY1PR0401MB1116191E688201AE89DA270381AD0@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxhhXogm8x_7RbdOBq0wOEFSrguL2S-qTpN=7ahO=HZ_0g@mail.gmail.com>
 <CY1PR0401MB111665D846A301C108F9694B81AD0@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxibi4Pfy0OtBaWkwnoyYbQm+pZvhdUK_WWGEDPc6+DVdg@mail.gmail.com> <CY1PR0401MB1116C049AE98BC39FC9100C281AD0@CY1PR0401MB1116.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 26 Mar 2018 20:51:31 +0100
Message-ID: <CALjAwxjBiLRoQckkYqa8ywSm1CF5noqptgaZhZb8J3DSjg3dGw@mail.gmail.com>
Subject: Re: "No I/O performed by <engine>" reporting bug?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kris Davis <Kris.Davis@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Itay Ben Yaacov <Itay.BenYaacov@wdc.com>

On 26 March 2018 at 18:40, Kris Davis <Kris.Davis@wdc.com> wrote:
>
> I guess I'm was expecting that loops just means to repeat whatever the jo=
b was doing previously that number of times.  I guess that what I conclude =
from the "loops" description: "Run the specified number of iterations of th=
is job. Used to repeat the same workload a given number of times. Defaults =
to 1."
>
> I was expecting that each loop would start sequential operations back at =
0 or the offset, and redo any start_delay or ramp_time each time.  If that =
is not the case, I'm

loops looks like a way to get a job to wrap I/O around to beginning it
when it gets to the end of the file. Certain operations do happen when
that wraparound/restart occurs (e.g. resetting the map of regions
used/offset being reset on sequential I/O) but not every job option is
impacted (i.e. start_delay and ramp_time will only happen once even
when loops>=3D2).

> either missing something in the doc, or it could probably use further cla=
rification.  If io_size is used rather than number_ios - does the starting =
LBA get reset after each loop?

Looking at some examples I see this:

$ ./fio --name=3Dtest-loops --filename=3D/tmp/fio.tmp --size=3D4 --bs=3D1
--loops=3D2 --io_size=3D3 --debug=3Dio | grep 'complete:\|cache'
io       7649  declare unneeded cache /tmp/fio.tmp: 0/4
io       7649  complete: io_u 0xb78500: off=3D0x0,len=3D0x1,ddir=3D0,file=
=3D/tmp/fio.tmp
io       7649  complete: io_u 0xb78500: off=3D0x1,len=3D0x1,ddir=3D0,file=
=3D/tmp/fio.tmp
io       7649  complete: io_u 0xb78500: off=3D0x2,len=3D0x1,ddir=3D0,file=
=3D/tmp/fio.tmp
io       7649  complete: io_u 0xb78500: off=3D0x3,len=3D0x1,ddir=3D0,file=
=3D/tmp/fio.tmp
io       7649  declare unneeded cache /tmp/fio.tmp: 0/4
io       7649  complete: io_u 0xb78500: off=3D0x0,len=3D0x1,ddir=3D0,file=
=3D/tmp/fio.tmp
io       7649  complete: io_u 0xb78500: off=3D0x1,len=3D0x1,ddir=3D0,file=
=3D/tmp/fio.tmp

$ $ ./fio --name=3Dtest-loops --filename=3D/tmp/fio.tmp --size=3D4 --bs=3D1
--loops=3D3 --number_ios=3D2 --debug=3Dio | grep 'complete:\|cache'
io       7657  declare unneeded cache /tmp/fio.tmp: 0/4
io       7657  complete: io_u 0x2310500:
off=3D0x0,len=3D0x1,ddir=3D0,file=3D/tmp/fio.tmp
io       7657  complete: io_u 0x2310500:
off=3D0x1,len=3D0x1,ddir=3D0,file=3D/tmp/fio.tmp
io       7657  complete: io_u 0x2310500:
off=3D0x2,len=3D0x1,ddir=3D0,file=3D/tmp/fio.tmp
io       7657  complete: io_u 0x2310500:
off=3D0x3,len=3D0x1,ddir=3D0,file=3D/tmp/fio.tmp
io       7657  declare unneeded cache /tmp/fio.tmp: 0/4
io       7657  complete: io_u 0x2310500:
off=3D0x0,len=3D0x1,ddir=3D0,file=3D/tmp/fio.tmp
io       7657  complete: io_u 0x2310500:
off=3D0x1,len=3D0x1,ddir=3D0,file=3D/tmp/fio.tmp

Basically a loop only ends when I/O gets to the end of the file (and
we see the cache being declared unneeded when the loop starts) but the
interaction with number_ios/io_size seems limited to just multiplying
them by loops.

Jens: originally number_ios/io_size would just end the entire job
early regardless of what loop you were on but that seems to have
changed since cf8a46a75f38afe07ebf823210f95543999e3116 ("Make 'loops'
honor full write+verify loops"). Is the intent for number_ios/io_size
to be invariant of loops or to be per loop? What does it mean for a
loop if io_size is bigger than the size of the file?

> I don't really have any strong opinion on how number_ios works (we can us=
e io_size instead), it just seems like it was working differently before, a=
nd otherwise could just use further clarification. Do you know of any other=
 "quantity" type of options would operate independent of the loops option? =
 (I think this is the first time I've seen loop used).

runtime is the other one (we've covered io_size, number_ios and loops)
and that's loop invariant. In fact runtime with time_based essentially
disables looking at the loop counter.

--=20
Sitsofe | http://sucs.org/~sits/
