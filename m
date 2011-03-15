Return-Path: <hussein@cscs.ch>
MIME-Version: 1.0
From: "N. Harake" <hussein@cscs.ch>
Date: Tue, 15 Mar 2011 14:46:14 -0600
Subject: RE: memory caching
Message-ID: <8512BC127909424EB483ED236E6AC3C003D6E6@MBX20.d.ethz.ch>
References: <C9A519EC.108B4%hussein@cscs.ch>,<4D7FCBDE.2080206@fusionio.com>
In-Reply-To: <4D7FCBDE.2080206@fusionio.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>


Thanks for your reply, indeed my interest to get the max iops but on a file=
system not a raw device,=20
I understand the penalty but that would be more realstic for production sys=
tems. I will try these changes and keep you updated .

All the best
H. N. Harake

________________________________________
From: Jens Axboe [jaxboe@fusionio.com]
Sent: Tuesday, March 15, 2011 9:28 PM
To: N. Harake
Cc: fio@vger.kernel.org
Subject: Re: memory caching

On 2011-03-15 13:36, N. Harake wrote:
>
> I noticed when I am using --sync=3D1, IOPS go down to 15K and throughput =
to
> 53MB (That=B9s horrible for the HW I am using), removing --sync I got 150=
K
> IOPS and almost 800MB, which make more sense. What does --sync does, and
> hope what I am doing should be enough to avoid any kind of memory caching=
..
>
> Regards
> H. N. Harake
>
> fio --name=3Djob --directory=3D/lvm --size=3D1G --iodepth=3D1 --sync=3D1
> --filesize=3D1G --direct=3D1 --numjobs=3D64 --bs=3D4096 --rw=3Drandwrite
> --group_reporting

If your goal is to maximize iops for testing, use the raw block device.
Use direct=3D1, and ioengine=3Dlibaio. Set depth large, ala:

--iodepth=3D128 --iodepth_batch_complete=3D8 --iodepth_batch_submit=3D8


--
Jens Axboe=

