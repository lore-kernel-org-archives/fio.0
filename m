Return-Path: <Antonio.Jose.Rodrigues.Neto@netapp.com>
From: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: FIO - Client and Server - Suggestion
Date: Wed, 8 Oct 2014 14:13:13 +0000
Message-ID: <D05ABE8A.521B6%Antonio.Jose.Rodrigues.Neto@netapp.com>
References: <D0599D7A.51F81%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <54345B52.7060306@kernel.dk> <543462BE.3000101@kernel.dk>
 <D059DCD3.52059%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <D059DD71.5205D%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <54346A66.6000509@kernel.dk>
 <40C9565A-0AB9-413A-B342-F5EF247686E5@netapp.com>
 <D05A0624.520A1%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <D05A0920.520A9%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <54349A4E.3080207@kernel.dk>
 <D05A265C.5210C%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <5434B79F.4030700@kernel.dk>
In-Reply-To: <5434B79F.4030700@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B25A59839C2E7143938229DBDA07F625@hq.netapp.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



On 10/8/14, 12:03 AM, "Jens Axboe" <axboe@kernel.dk> wrote:

>On 2014-10-07 21:24, Neto, Antonio Jose Rodrigues wrote:
>> Nossa Senhora:fio neto$ ./fio --client 10.61.109.151 --remote-config
>> /root/fio.patch/fio/model
>> hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>>fio=3Dfio-2.1.13-42-g3232,
>> flags=3D1
>> <s1> fio: unable to open '/root/fio.patch/fio/model:70?' job file
>> client: host=3D10.61.109.151 disconnected
>>
>> Any ideas?
>
>Looks like I just forgot to zero terminate that string. It was never
>absolute or relative path, just luck and what was in memory. Try and
>pull again, I committed a fix for that.
>
>--=20
>Jens Axboe
>
>--


Hi Jens,

This is neto from Brazil

How are you?

Seems to me it's working with absolute path now with the latest commit to
remote-config branch.

But, running the workload from my mac (connected to 2 Linux clients) I do
not see the progress.

Nossa Senhora:fiop neto$ ./fio --client 10.61.109.151 --remote-config
/root/fiop/model --client 10.61.109.152 --remote-config /root/fiop/model
hostname=3Ds2, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64, fio=3Dfio-2.1.13,=
 flags=3D1
hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64, fio=3Dfio-2.1.13-=
31-g15e3,
flags=3D1
<s2> workload: (g=3D0): rw=3Dread, <s1> workload: (g=3D0): rw=3Dread,
bs=3D64K-64K/64K-64K/64K-64K, bs=3D64K-64K/64K-64K/64K-64K, ioengine=3Dliba=
io,
iodepth=3D1
ioengine=3Dlibaio, iodepth=3D1
<s2> ...
<s1> ...
<s1> Starting <s2> Starting 128 threads
128 threads
Jobs: 0 (f=3D0)

Any idea why?


Thanks

neto


