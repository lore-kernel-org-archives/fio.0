Return-Path: <Antonio.Jose.Rodrigues.Neto@netapp.com>
From: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: Helping to model this workload
Date: Thu, 25 Jul 2013 16:52:22 +0000
Message-ID: <CE16CF2A.12CB3%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <20130725164518.GG29296@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6E9CA0FED7001543B1E3F4ED3CB7B96D@hq.netapp.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>


On 7/25/13 12:45 PM, "Jens Axboe" <axboe@kernel.dk> wrote:

>On Tue, Jul 23 2013, Neto, Antonio Jose Rodrigues wrote:
>> Hi All
>>=20
>> This is neto from Brazil
>>=20
>> How are you?
>>=20
>> I need to model the following workload:
>>=20
>> Sequential Read % 35.0
>> Sequential Write % 5.0
>> Random Read % 50.0
>> Random Write % 10.0
>> Random Read Working Set(GB) 1000.0
>> Random Write Working Set(GB) 1000.0
>> Sequential Read Size(KB) 64KB
>> Sequential Write Size(KB) 64KB
>> Random Read Size(KB) 8KB
>> Random Write Size(KB) 8KB
>
>So that's 85% reads and 15% writes, first part:
>
>rw=3Drandrw
>rwmixread=3D85
>
>and then you have 50/85 reads random and 35/85 reads sequential. That's
>roughly 59% reads random. On the writes, you have 10/15 random and 5/15
>sequential. That's roughly 67% writes random:
>
>percentage_random=3D59,67
>
>The latter I just added support for, before it only support a single
>setting for reads and writes.
>
>Fio does not support splitting block sizes on a random/sequential basis.
>You will have to improvise there.
>
>--=20
>Jens Axboe
>
>--
>To unsubscribe from this list: send the line "unsubscribe fio" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi Jens

This is neto from Brazil

How are you?

Thank you very much.

So basically the option right now is to use either 8KB or 64KB right?

Something like:

[workload]
bs=3D8k
ioengine=3Dlibaio
iodepth=3D2
numjobs=3D64
direct=3D1
runtime=3D2400
size=3D2000g
filename=3D\\.\PhysicalDrive9
filename=3D\\.\PhysicalDrive10
rw=3Drandrw
rwmixread=3D85
percentage_random=3D59,67

thread
unified_rw_reporting=3D1
group_reporting=3D1


Would be nice to have something like:

block_mixed=3D8192,65536 (random, sequential)


Thank you

neto


>


