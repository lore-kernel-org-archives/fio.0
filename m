Return-Path: <Antonio.Jose.Rodrigues.Neto@netapp.com>
From: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: FIO - Client and Server - Suggestion
Date: Sun, 12 Oct 2014 19:22:34 +0000
Message-ID: <CA8285D0-3F7E-4FB4-86F5-05DBF8D40ACC@netapp.com>
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
 <D06015CE.528F5%Antonio.Jose.Rodrigues.Neto@netapp.com>,<543AD2B0.2070307@kernel.dk>
In-Reply-To: <543AD2B0.2070307@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>





> On Oct 12, 2014, at 3:11 PM, Jens Axboe <axboe@kernel.dk> wrote:
>=20
>> On 2014-10-12 09:26, Neto, Antonio Jose Rodrigues wrote:
>> Just applied the patch and it's perfect.
>>=20
>> Please see below:
>>=20
>> Nossa Senhora:fiop neto$ ./fio --client 10.61.109.151 --remote-config
>> /root/fiop/iotest --client 10.61.109.152 --remote-config /root/fio/iotes=
t
>> hostname=3Ds2, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>> fio=3Dfio-2.1.13-59-gaa7bc, flags=3D1
>> hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>> fio=3Dfio-2.1.13-59-gaa7bc, flags=3D1
>> <s2> fio: unable to open '/root/fio/iotest' job file
>> <s1> workload: (g=3D0): rw=3Dwrite, bs=3D32K-32K/32K-32K/32K-32K,
>> ioengine=3Dlibaio, iodepth=3D4
>> <s1> ...
>> <s1> Starting 64 threads
>> Jobs: 64 (f=3D1024): [W(64)] [43.3% done] [882.5M/0K/0K /s] [27.6K/0/0 i=
ops]
>> [eta 00m:34s]
>=20
> Great, at least that took care of that issue. As to missing output from o=
ne client, I've seen that here before, I will look into that. It's a separa=
te issue.
>=20
> --=20
> Jens Axboe
>=20

Thank you so much, Jens.=

