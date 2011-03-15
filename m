Return-Path: <hussein@cscs.ch>
MIME-Version: 1.0
From: "N. Harake" <hussein@cscs.ch>
Date: Tue, 15 Mar 2011 14:54:06 -0600
Subject: RE: memory caching
Message-ID: <8512BC127909424EB483ED236E6AC3C003D6F4@MBX20.d.ethz.ch>
References: <C9A519EC.108B4%hussein@cscs.ch>,<4D7FCBDE.2080206@fusionio.com>
In-Reply-To: <4D7FCBDE.2080206@fusionio.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>


Things improved but maybe too much :), I was expecting a 100K IOPS not more

server1:~ # fio --name=3Djob --directory=3D/lvm --size=3D1G --filesize=3D1G=
 --iodepth=3D128 --iodepth_batch_complete=3D8 --iodepth_batch_submit=3D8 --=
ioengine=3Dlibaio --direct=3D1 --numjobs=3D64 --bs=3D 4096 --rw=3Drandwrite=
 --group_reporting
Jobs: 50 (f=3D50): [wwwwww_wwwwwww_wwwwwwwwww_wwwwwwwwwww_www_www_ww_www___=
ww_w__w_w] [98.3% done] [0K/570.8M /s] [0 /143K iops] [eta 00m:02s]

  write: io=3D65536MB, bw=3D584771KB/s, iops=3D146192 , runt=3D114761msec

H. Harake

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

