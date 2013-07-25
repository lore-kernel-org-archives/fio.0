Return-Path: <Antonio.Jose.Rodrigues.Neto@netapp.com>
From: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: Helping to model this workload
Date: Thu, 25 Jul 2013 19:07:13 +0000
Message-ID: <CE16EF2F.12D53%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <51F1766C.2080908@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28EAB55F88A38243B0A37A1055BB5288@hq.netapp.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>


On 7/25/13 3:03 PM, "Jens Axboe" <axboe@kernel.dk> wrote:

>On 07/25/2013 01:02 PM, Neto, Antonio Jose Rodrigues wrote:
>> Just to confirm..
>>=20
>> bs_is_seq_rand=3D1
>>=20
>> bs=3D64k,4k=20
>>=20
>> It's 64K for sequential and 4K for random
>>=20
>> Right?
>
>Correct. If bs_is_seq_rand is set, any READ block size setting is
>applied to sequential IO, and any WRITE block size setting is applied to
>random IO.
>
>--=20
>Jens Axboe
>

Let me see if I understood:

But Jens, if I want sequential read AND write 64KB and random read AND
write 4KB?


