Return-Path: <Roger_Hinson@intuit.com>
From: "Hinson, Roger" <Roger_Hinson@intuit.com>
Subject: RE: Confirming test parameters
Date: Mon, 29 Sep 2014 05:50:11 +0000
Message-ID: <cdeb54976b2a45d4b195952023e7525f@BLUPR02MB453.namprd02.prod.outlook.com>
References: <68dcaec92df442db80f34a518dd05cc3@BLUPR02MB453.namprd02.prod.outlook.com>
 <54288BA4.50906@kernel.dk>
In-Reply-To: <54288BA4.50906@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Return-Path: Roger_Hinson@intuit.com
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Sunday, September 28, 2014 3:29 PM
To: Hinson, Roger; fio@vger.kernel.org
Subject: Re: Confirming test parameters

On 2014-09-28 15:45, Hinson, Roger wrote:
> 	Hey all,
>
> 	I'm setting up a test to simulate what we're actually seeing on one of o=
ur storage arrays.  Can you take a look and provide me some feedback?
>
> 	The array usage is for two workload types:
>
> 	Type 1:
> 	Random Read % - 45
> 	Random Write % - 55
> 	Sequential Read % - 1
> 	Sequential Write % - 3
> 	R/W Ratio - 45:55
> 	Random Block Size - 4K
> 	Sequential Block Size - 64K
>
> 	Type 2:
> 	Random Read % - 1
> 	Random Write % - 13
> 	Sequential Read % - 2
> 	Sequential Write % - 84
> 	R/W Ratio - 3:97
> 	Random Block Size - 4K
> 	Sequential Block Size - 32K=09
>
> 	I came up with this:
>
> [global]
> group_reporting=3D1
> thread
> iodepth=3D8
> ioengine=3Dlibaio
> direct=3D1
> refill_buffers
> randrepeat=3D1
> randseed=3D100
> random_distribution=3Dzipf:1.01
> runtime=3D1200
> time_based
> bs_is_seq_rand
>
> [45read55write_dm0_numjobs_2]
> write_bw_log=3D4555_dm0_2
> write_lat_log=3D4555_dm0_2
> write_iops_log=3D4555_dm0_2
> filename=3D/dev/mapper/mpathq
> rw=3Drandrw
> rwmixread=3D45
> rwmixwrite=3D55
> percentage_random=3D96
> bs=3D64K,4K
> buffer_compress_percentage=3D50
> buffer_compress_chunk=3D512
> numjobs=3D2
>
> [3read97write_dm1_numjobs_2]
> write_bw_log=3D397_dm1_2
> write_lat_log=3D397_dm1_2
> write_iops_log=3D397_dm1_2
> filename=3D/dev/mapper/mpathr
> rw=3Drandrw
> rwmixread=3D3
> rwmixwrite=3D97
> percentage_random=3D14
> bs=3D32K,4K
> buffer_compress_percentage=3D50
> buffer_compress_chunk=3D512
> numjobs=3D2

This looks like a pretty good approximation. Note that percentage_random ca=
n take all data directions into account. So if you have a workload that is:

read sequential: 57%
write sequential: 95%

you could do:

percentage_random=3D43,5

and have that just work.

--
Jens Axboe


Making sure I understand that.  I'm not sure if I have the right percentage=
s.

Since I'm using this for my type 2 above:
 rw=3Drandrw
 rwmixread=3D3
 rwmixwrite=3D97
 percentage_random=3D14

Would I list it as percentage_random=3D1,13  because my read sequential is =
2% and write sequential is 84% ?

Thanks,
Roger


