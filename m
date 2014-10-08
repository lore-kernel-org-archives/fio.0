Return-Path: <Antonio.Jose.Rodrigues.Neto@netapp.com>
From: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: FIO - Client and Server - Suggestion
Date: Wed, 8 Oct 2014 14:47:55 +0000
Message-ID: <D05AC6A2.521D3%Antonio.Jose.Rodrigues.Neto@netapp.com>
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
 <D05ABE8A.521B6%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <54354B49.8040307@kernel.dk>
In-Reply-To: <54354B49.8040307@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DC17754D6AFB0440B49A827BC3C776EC@hq.netapp.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



On 10/8/14, 10:33 AM, "Jens Axboe" <axboe@kernel.dk> wrote:

>On 10/08/2014 08:13 AM, Neto, Antonio Jose Rodrigues wrote:
>>=20
>>=20
>> On 10/8/14, 12:03 AM, "Jens Axboe" <axboe@kernel.dk> wrote:
>>=20
>>> On 2014-10-07 21:24, Neto, Antonio Jose Rodrigues wrote:
>>>> Nossa Senhora:fio neto$ ./fio --client 10.61.109.151 --remote-config
>>>> /root/fio.patch/fio/model
>>>> hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>>>> fio=3Dfio-2.1.13-42-g3232,
>>>> flags=3D1
>>>> <s1> fio: unable to open '/root/fio.patch/fio/model:70?' job file
>>>> client: host=3D10.61.109.151 disconnected
>>>>
>>>> Any ideas?
>>>
>>> Looks like I just forgot to zero terminate that string. It was never
>>> absolute or relative path, just luck and what was in memory. Try and
>>> pull again, I committed a fix for that.
>>>
>>> --=20
>>> Jens Axboe
>>>
>>> --
>>=20
>>=20
>> Hi Jens,
>>=20
>> This is neto from Brazil
>>=20
>> How are you?
>>=20
>> Seems to me it's working with absolute path now with the latest commit
>>to
>> remote-config branch.
>
>Great, I verified this morning that it was an issue, we'd be looking at
>unitialized/allocated memory without it.
>
>> But, running the workload from my mac (connected to 2 Linux clients) I
>>do
>> not see the progress.
>>=20
>> Nossa Senhora:fiop neto$ ./fio --client 10.61.109.151 --remote-config
>> /root/fiop/model --client 10.61.109.152 --remote-config /root/fiop/model
>> hostname=3Ds2, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64, fio=3Dfio-2.1.=
13,
>>flags=3D1
>> hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>>fio=3Dfio-2.1.13-31-g15e3,
>> flags=3D1
>> <s2> workload: (g=3D0): rw=3Dread, <s1> workload: (g=3D0): rw=3Dread,
>> bs=3D64K-64K/64K-64K/64K-64K, bs=3D64K-64K/64K-64K/64K-64K, ioengine=3Dl=
ibaio,
>> iodepth=3D1
>> ioengine=3Dlibaio, iodepth=3D1
>> <s2> ...
>> <s1> ...
>> <s1> Starting <s2> Starting 128 threads
>> 128 threads
>> Jobs: 0 (f=3D0)
>>=20
>> Any idea why?
>
>Works for me, just tried it from an OSX client. I notice that you don't
>seem to have updated the 's2' fio version, however. So I'd suggest you
>ensure you are running the same thing on all of them.
>
>--=20
>Jens Axboe
>


Hi Jens,

This is neto from Brazil

How are you?

With one client and one server it works

Nossa Senhora:fiop neto$ ./fio --client 10.61.109.151 --remote-config
/root/fiop/model=20
hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64, fio=3Dfio-2.1.13-=
31-g15e3,
flags=3D1
<s1> workload: (g=3D0): rw=3Dread, bs=3D64K-64K/64K-64K/64K-64K,
ioengine=3Dlibaio, iodepth=3D1
<s1> ...
<s1> Starting 128 threads
Jobs: 128 (f=3D2048): [R(128)] [4.4% done] [1770M/0K/0K /s] [27.7K/0/0 iops=
]
[eta 09m:45s]





But with one client and 2 servers it does not work (the progress)


Nossa Senhora:fiop neto$ ./fio --client 10.61.109.151 --remote-config
/root/fiop/model --client 10.61.109.152 --remote-config /root/fiop/model
hostname=3Ds2, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64, fio=3Dfio-2.1.13-=
31-g15e3,
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
<s2> Starting <s1> Starting 128 threads128 threads

Jobs: 0 (f=3D0)
Jobs: 0 (f=3D0)




Jobs: 0 (f=3D0)






