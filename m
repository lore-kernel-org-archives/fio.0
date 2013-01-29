Return-Path: <Antonio.Jose.Rodrigues.Neto@netapp.com>
From: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: Group reporting with latency and IOPS
Date: Tue, 29 Jan 2013 13:41:26 +0000
Message-ID: <843E15216120C047928F6879B0E2D9240F6D243A@SACEXCMBX02-PRD.hq.netapp.com>
In-Reply-To: <20130129130212.GB8800@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <60CD9AFF310CF24F8C1BA8641A3C5BEA@tahoe.netapp.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



On 1/29/13 8:02 AM, "Jens Axboe" <axboe@kernel.dk> wrote:

>On Mon, Jan 28 2013, Neto, Antonio Jose Rodrigues wrote:
>> Hi All,
>>=20
>> This is neto from Brazil
>>=20
>> How are you?
>>=20
>> I just need a help to make sure I understood correctly the report (see
>>below --Output).=20
>>=20
>> Trying to generate 80% Read and 20% Write - 8KB block size
>>=20
>> Reads
>> IOPS: 15330
>> Latency: (clat) 628usecs - 0.628ms
>
>Correct. Well 629 really, if rounded properly.
>
>> Writes
>> IOPS: 3827
>> Latency: (clat) 577usecs - 0.577ms
>
>Correct too.
>
>> Am I doing the correct analysis?
>
>Yep.
>
>> One question is: Is it possible to have global IOPS and latency?
>
>You mean for both read and write combined? Fio does not report that, but
>for IOPS you could just add them. For latency, the larger of the two.
>
>--=20
>Jens Axboe
>

Hi Jens

This is neto from Brazil

How are you?

Thank you so much for your answer.

How can I have a combined IOPS reported?

Thank you

neto


>


