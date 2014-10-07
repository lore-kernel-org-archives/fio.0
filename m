Return-Path: <Antonio.Jose.Rodrigues.Neto@netapp.com>
From: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: FIO - Client and Server - Suggestion
Date: Tue, 7 Oct 2014 22:09:20 +0000
Message-ID: <D059DCD3.52059%Antonio.Jose.Rodrigues.Neto@netapp.com>
References: <D0599D7A.51F81%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <54345B52.7060306@kernel.dk> <543462BE.3000101@kernel.dk>
In-Reply-To: <543462BE.3000101@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <653A92DB7089C24584F5C841340F6677@hq.netapp.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



On 10/7/14, 6:01 PM, "Jens Axboe" <axboe@kernel.dk> wrote:

>On 10/07/2014 03:29 PM, Jens Axboe wrote:
>> On 10/07/2014 11:38 AM, Neto, Antonio Jose Rodrigues wrote:
>>> Hi All,
>>>
>>> This is neto from Brazil
>>>
>>> How are you?
>>>
>>> One small suggestion:
>>>
>>> Running Client and Server architecture on FIO, we need to have all
>>>config
>>> files "locally" to run it.
>>>
>>>
>>> Nossa Senhora:tools neto$ ls
>>> 151 152 fio
>>>
>>>
>>>
>>> Nossa Senhora:tools neto$ ./fio --client 10.61.109.151 151 --client
>>> 10.61.109.152 152
>>> hostname=3Ds2, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>>>fio=3Dfio-2.1.13-31-g15e3,
>>> flags=3D1
>>> hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>>>fio=3Dfio-2.1.13-31-g15e3,
>>> flags=3D1
>>> <s2> workload: (g=3D0): rw=3Dread, <s1> workload: (g=3D0): rw=3Dread,
>>> bs=3D64K-64K/64K-64K/64K-64K, bs=3D64K-64K/64K-64K/64K-64K,
>>>ioengine=3Dlibaio,
>>> iodepth=3D1
>>> ioengine=3Dlibaio, iodepth=3D1
>>>
>>> If we are doing a test in an HPC environment with hundred of files,
>>> wouldn't be easier to try to point to a single location for the file
>>>and
>>> access it remotely (we won't need to copy it locally).
>>>
>>>
>>> For example:
>>>
>>> ./fio --client 10.61.109.151 --remote-config /root/fio/151 --client
>>> 10.61.109.152 --remote-config /root/fio/152
>>>
>>>
>>> Thoughts?
>>=20
>> That's a good idea, would not be hard to insert that step of having the
>> remote fio server load a local config file. I'll look into that.
>
>Totally untested, but the below is a start. On the client side, you'd do:
>
>fio --client=3Dserver-hostname --remote-config /some/path/to/file
>
>and then the server should attempt to open that. Needs a bit of error
>handling, but the concept should be there.
>
>--=20
>Jens Axboe


Hi Jens,

This is neto from Brazil

How are you?

I think it is not working.... Please see below:

Nossa Senhora:fio.patch neto$ ./fio --client 10.61.109.151 --remote-config
/root/fio.patch/model
hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64, fio=3Dfio-2.1.13-=
31-g15e3,
flags=3D1

Thank you,


neto


