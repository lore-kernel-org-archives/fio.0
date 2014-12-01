Return-Path: <Elliott@hp.com>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: 32-bit values are too small for disk stats
Date: Mon, 1 Dec 2014 16:07:18 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593D61CD@G9W0745.americas.hpqcorp.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "Jens Axboe <axboe@kernel.dk> (axboe@kernel.dk)" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

A long run can result in wrapping in the disk stats=20
(ios, merge, ticks, in_queue).

In this example, there were 212,245,615,134 read IOs
(that is from uint64_t total_io_u[3]):
	  read : io=3D101207GB, bw=3D491309KB/s, iops=3D982618, runt=3D216000016ms=
ec
	  cpu          : usr=3D0.09%, sys=3D4.33%, ctx=3D152784302066, majf=3D0, m=
inf=3D2928
	  IO depths    : 1=3D0.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.5%, 16=3D0.5%, 32=3D1=
.0%, >=3D64=3D1.0%
	     submit    : 0=3D0.0%, 4=3D18.0%, 8=3D6.6%, 16=3D8.5%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
	     complete  : 0=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D15.0%, 32=3D0.1%, 64=
=3D0.1%, >=3D64=3D0.1%
	     issued    : total=3Dr=3D212245615134/w=3D0/d=3D0, short=3Dr=3D0/w=3D0=
/d=3D0, drop=3Dr=3D0/w=3D0/d=3D0
	     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D96

	Run status group 0 (all jobs):
	   READ: io=3D101207GB, aggrb=3D491309KB/s, minb=3D491309KB/s, maxb=3D4913=
09KB/s, mint=3D216000016msec, maxt=3D216000016msec

All the disk stats, however, wrap at ios=3D4,294,967,295 (32 bit).
In this case it caught sdi falling a bit behind the others,
but all of them have wrapped multiple times.

	Disk stats (read/write):
	  sdb: ios=3D796157304/0, merge=3D0/0, ticks=3D722039638/0, in_queue=3D735=
284999, util=3D100.00%
	  sdc: ios=3D725235994/0, merge=3D0/0, ticks=3D725893305/0, in_queue=3D738=
790349, util=3D100.00%
	  sdd: ios=3D722370867/0, merge=3D0/0, ticks=3D724540972/0, in_queue=3D738=
926102, util=3D100.00%
	  sde: ios=3D722490025/0, merge=3D0/0, ticks=3D724775894/0, in_queue=3D745=
581851, util=3D100.00%
	  sdf: ios=3D719665329/0, merge=3D0/0, ticks=3D724281840/0, in_queue=3D740=
201203, util=3D100.00%
	  sdg: ios=3D721386377/0, merge=3D0/0, ticks=3D725529483/0, in_queue=3D740=
729310, util=3D100.00%
	  sdh: ios=3D720461888/0, merge=3D0/0, ticks=3D724759222/0, in_queue=3D741=
212131, util=3D100.00%
	  sdi: ios=3D3280272329/0, merge=3D0/0, ticks=3D3337080572/0, in_queue=3D3=
340290775, util=3D81.57%
	  sdj: ios=3D717395167/0, merge=3D0/0, ticks=3D723762993/0, in_queue=3D739=
136654, util=3D100.00%
	  sdk: ios=3D824804416/0, merge=3D0/0, ticks=3D722973383/0, in_queue=3D734=
915061, util=3D100.00%
	  sdl: ios=3D787317365/0, merge=3D0/0, ticks=3D720963594/0, in_queue=3D736=
506238, util=3D100.00%
	  sdm: ios=3D791112845/0, merge=3D0/0, ticks=3D723371287/0, in_queue=3D745=
590636, util=3D100.00%
	  sdn: ios=3D786009870/0, merge=3D0/0, ticks=3D721111447/0, in_queue=3D733=
786474, util=3D100.00%
	  sdo: ios=3D787226466/0, merge=3D0/0, ticks=3D722200707/0, in_queue=3D737=
673635, util=3D100.00%
	  sdp: ios=3D789062478/0, merge=3D0/0, ticks=3D723648481/0, in_queue=3D737=
820918, util=3D100.00%
	  sdq: ios=3D786121713/0, merge=3D0/0, ticks=3D722203635/0, in_queue=3D752=
578258, util=3D100.00%

These structures are the reason:
	struct disk_util_stats {
	        uint32_t ios[2];
	        uint32_t merges[2];
	        uint64_t sectors[2];
	        uint32_t ticks[2];
	        uint32_t io_ticks;
	        uint32_t time_in_queue;
	        uint64_t msec;
	};
	struct disk_util_agg {
	        uint32_t ios[2];
	        uint32_t merges[2];
	        uint64_t sectors[2];
	        uint32_t ticks[2];
	        uint32_t io_ticks;
	        uint32_t time_in_queue;
	        uint32_t slavecount;
	        fio_fp64_t max_util;
	};

---
Rob Elliott    HP Server Storage



