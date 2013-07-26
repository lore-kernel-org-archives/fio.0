Return-Path: <Antonio.Jose.Rodrigues.Neto@netapp.com>
From: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: Helping to model this workload
Date: Fri, 26 Jul 2013 14:28:18 +0000
Message-ID: <CE17FF2B.12F28%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <51F28685.1050307@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6CF8D3A8667946478B6EE907712710B9@hq.netapp.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>


On 7/26/13 10:24 AM, "Jens Axboe" <axboe@kernel.dk> wrote:

>On 07/26/2013 08:22 AM, Neto, Antonio Jose Rodrigues wrote:
>> Would be nice if we could specify?
>> Iodepth for sequential and random
>
>That would be easy enough to add.
>
>> Numjobs for sequential and random (for example: I would like to have 16
>> jobs doing random and 1 job only doing sequential)
>
>That's pretty easy to do manually by just having the two sections in the
>job file.
>
>--=20
>Jens Axboe
>
>--

Something like this? Do you have an example? I am confused with 2 sections
and the percentage of the distribution of sequential and random plus the
difference of block size

>[random]
>bs=3D64k,4k
>bs_is_seq_rand=3D1
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

>[sequential]
>bs=3D64k,4k
>bs_is_seq_rand=3D1
>ioengine=3Dlibaio
>iodepth=3D1
>numjobs=3D1
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







