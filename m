Return-Path: <Antonio.Jose.Rodrigues.Neto@netapp.com>
From: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: FIO - Client and Server - Suggestion
Date: Mon, 13 Oct 2014 01:09:56 +0000
Message-ID: <83B8F273-B74B-4B42-9894-4AB3E4423A59@netapp.com>
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
 <D05AC6A2.521D3%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <54354FB7.1010907@kernel.dk>
 <D05D578B.52714%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <54395AAA.2010109@kernel.dk> <54395B3E.3040404@kernel.dk>
 <D06015CE.528F5%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <543AD2B0.2070307@kernel.dk>,<543AD621.90404@kernel.dk>
 <83C9DF5B-B222-465E-98B4-D2F1D083E710@netapp.com>,<543B1C60.5000006@kernel.dk>
In-Reply-To: <543B1C60.5000006@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>





> On Oct 12, 2014, at 8:27 PM, Jens Axboe <axboe@kernel.dk> wrote:
>=20
>> On 2014-10-12 14:28, Neto, Antonio Jose Rodrigues wrote:
>>=20
>>=20
>>=20
>>=20
>>>> On Oct 12, 2014, at 3:26 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>=20
>>>>> On 2014-10-12 13:12, Jens Axboe wrote:
>>>>> On 2014-10-12 09:26, Neto, Antonio Jose Rodrigues wrote:
>>>>> Just applied the patch and it's perfect.
>>>>>=20
>>>>> Please see below:
>>>>>=20
>>>>> Nossa Senhora:fiop neto$ ./fio --client 10.61.109.151 --remote-config
>>>>> /root/fiop/iotest --client 10.61.109.152 --remote-config /root/fio/io=
test
>>>>> hostname=3Ds2, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>>>>> fio=3Dfio-2.1.13-59-gaa7bc, flags=3D1
>>>>> hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>>>>> fio=3Dfio-2.1.13-59-gaa7bc, flags=3D1
>>>>> <s2> fio: unable to open '/root/fio/iotest' job file
>>>>> <s1> workload: (g=3D0): rw=3Dwrite, bs=3D32K-32K/32K-32K/32K-32K,
>>>>> ioengine=3Dlibaio, iodepth=3D4
>>>>> <s1> ...
>>>>> <s1> Starting 64 threads
>>>>> Jobs: 64 (f=3D1024): [W(64)] [43.3% done] [882.5M/0K/0K /s] [27.6K/0/=
0
>>>>> iops]
>>>>> [eta 00m:34s]
>>>>=20
>>>> Great, at least that took care of that issue. As to missing output fro=
m
>>>> one client, I've seen that here before, I will look into that. It's a
>>>> separate issue.
>>>=20
>>> For the above one, s2 never started since it could not find the config =
file you gave it. Have you seen missing final output for cases where the jo=
bs did all start? This particular one does not look valid.
>>>=20
>>> --
>>> Jens Axboe
>>=20
>>=20
>> Yes. I did.
>>=20
>> I ran using both servers but the output was showing the latest client - =
s2
>=20
> Odd. Can you reproduce and send the output of such a run?
>=20
> --=20
> Jens Axboe
>=20

Yes, tomorrow morning I will send it over.



