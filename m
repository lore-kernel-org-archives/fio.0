Return-Path: <Antonio.Jose.Rodrigues.Neto@netapp.com>
From: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: Helping to model this workload
Date: Fri, 26 Jul 2013 14:22:20 +0000
Message-ID: <CE17FDFB.12F1B%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <CE16F954.12DA8%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2FFE44C31AC2A448A64B447C79B3E96B@hq.netapp.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

>>>>>
>>>>>Just to confirm..
>>>>>
>>>>> bs_is_seq_rand=3D1
>>>>>
>>>>> bs=3D64k,4k=20
>>>>>
>>>>> It's 64K for sequential and 4K for random
>>>>>
>>>>> Right?
>>>>
>>>> Correct. If bs_is_seq_rand is set, any READ block size setting is
>>>> applied to sequential IO, and any WRITE block size setting is applied
>>>>to
>>>> random IO.
>>>>
>>>> --=20
>>>> Jens Axboe
>>>>
>>>=20
>>> Let me see if I understood:
>>>=20
>>> But Jens, if I want sequential read AND write 64KB and random read AND
>>> write 4KB?
>>
>>Then you'd do:
>>
>>bs=3D64k,4k
>>bs_is_seq_rand=3D1
>>
>>any ANY sequential IO will be 64kb, and ANY random IO will be 4kb.
>>
>>--=20
>>Jens Axboe
>>
>
>This?
>
>[workload]
>bs=3D64k,4k
>
>bs_is_seq_rand=3D1
>
>ioengine=3Dlibaio
>iodepth=3D2
>numjobs=3D64
>direct=3D1
>runtime=3D2400
>size=3D2000g
>filename=3D\\.\PhysicalDrive9:\\.\PhysicalDrive10
>rw=3Drandrw
>rwmixread=3D85
>percentage_random=3D59,67
>thread
>unified_rw_reporting=3D1
>group_reporting=3D1


Jens

Would be nice if we could specify?
Iodepth for sequential and random
Numjobs for sequential and random (for example: I would like to have 16
jobs doing random and 1 job only doing sequential)

Thanks for considering it in the future

All the best my friend

neto


