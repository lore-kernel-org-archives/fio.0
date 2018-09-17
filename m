Return-Path: <sundersmitha@gmail.com>
Return-Path: <sundersmitha@gmail.com>
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: No I/O performed by windowsaio/get_io_u: zero buflen
From: smitha sunder <sundersmitha@gmail.com>
In-Reply-To: <03bc8d3c-a8cb-fcbb-e7ff-f23a511f7908@kernel.dk>
Date: Sun, 16 Sep 2018 20:13:02 -0700
Content-Transfer-Encoding: quoted-printable
Message-Id: <33A4DA56-9857-4EA3-A1E0-259FD1C856C8@gmail.com>
References: <CA+zhgFRR_SMf=CEhU8imgM+F_3hmGJV9+h_yU6qR9yQG6br48w@mail.gmail.com> <CALjAwxhGmEV=G21Vaw0rRgmLy4BFs2Yhqw4K5yNS2MXwGFvUtQ@mail.gmail.com> <CA+zhgFR1V4yKg+gf0QUcuZy47R=-CqyK+_jKVJS4WKDtRb77hQ@mail.gmail.com> <03bc8d3c-a8cb-fcbb-e7ff-f23a511f7908@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



> On Sep 16, 2018, at 8:02 PM, Jens Axboe <axboe@kernel.dk> wrote:
>=20
>> On 9/16/18 5:24 PM, smitha sunder wrote:
>>> On Sun, Sep 16, 2018 at 3:02 PM, Sitsofe Wheeler <sitsofe@gmail.com> wro=
te:
>>>> On Sat, 15 Sep 2018 at 23:14, smitha sunder <sundersmitha@gmail.com> wr=
ote:
>>>>=20
>>>> Hello all,
>>>>=20
>>>> I have a 30TB drive and I am running into an issue with random writes.
>>>> I went through this thread :
>>>> https://www.spinics.net/lists/fio/msg06294.html that seems to be fixed
>>>> already.
>>>=20
>>> I think that was something different regarding different blocksizes
>>> per direction.
>>>=20
>>>> I see the same issue with random reads as well.
>>>> So not sure what is the issue here in my case; any help is greatly appr=
eciated.
>>>>=20
>>>>=20
>>>> Read Capacity results:
>>>>   Protection: prot_en=3D1, p_type=3D1, p_i_exponent=3D0 [type 2 protect=
ion]
>>>>   Logical block provisioning: lbpme=3D1, lbprz=3D1
>>>>   Last logical block address=3D58781073407 (0xdaf9fffff), Number of
>>>> logical blocks=3D58781073408
>>>>   Logical block length=3D512 bytes
>>>>   Logical blocks per physical block exponent=3D3 [so physical block
>>>> length=3D4096 bytes]
>>>>   Lowest aligned logical block address=3D0
>>>> Hence:
>>>>   Device size: 30095909584896 bytes, 2.87017e+007 MiB, 30095.9 GB
>>>>=20
>>>>=20
>>>> C:\Program Files (x86)\fio>fio --ioengine=3Dwindowsaio --group_reportin=
g
>>>> --direct=3D1 --size=3D100% --bs=3D4K --thread --filename=3D\\.\Physical=
Drive1
>>>> --name=3Dprecond --rw=3Drandwrite --iodepth=3D1 --numjobs=3D1
>>>> --debug=3Dio,random
>>>=20
>>> <snip>
>>>=20
>>>> io       3372  fill: io_u 0A458780:
>>>> off=3D0x144365e7d000,len=3D0x0,ddir=3D1,file=3D\\.\PhysicalDrive1
>>>> io       3372  get_io_u: zero buflen on 0A458780
>>>> io       3372  get_io_u failed
>>>> io       3372  drop page cache \\.\PhysicalDrive1
>>>> random   3372  off rand 17311067694306724737
>>>=20
>>> That offset is crazy big - I'm sure it's bigger than a petabyte so my
>>> guess is that something is overflowing. If you use --size=3D27g does the=

>>> job go through?
>>>=20
>>> [...]
>>>=20
>>>> I don=E2=80=99t see this issue if I use bs=3D8K or I use ba=3D512,8K, e=
tc.
>>>=20
>>> --
>>> Sitsofe | http://sucs.org/~sits/
>> Hi Sitsofe,
>>=20
>> Thanks for the reply!
>>=20
>> Yes; If I use --size=3D27G or if provide the exact size that the OS
>> displays, then the job goes through.
>=20
> Are you running a 32-bit or 64-bit build of fio?
>=20
> --=20
> Jens Axboe
>=20
32 bit.

Thanks
Smitha=20=

