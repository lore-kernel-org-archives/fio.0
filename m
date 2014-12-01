Return-Path: <axboe@kernel.dk>
Message-ID: <547C9ACA.6060507@kernel.dk>
Date: Mon, 01 Dec 2014 09:43:54 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: 32-bit values are too small for disk stats
References: <94D0CD8314A33A4D9D801C0FE68B4029593D61CD@G9W0745.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029593D61CD@G9W0745.americas.hpqcorp.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/01/2014 09:07 AM, Elliott, Robert (Server Storage) wrote:
> A long run can result in wrapping in the disk stats
> (ios, merge, ticks, in_queue).
>
> In this example, there were 212,245,615,134 read IOs
> (that is from uint64_t total_io_u[3]):
> 	  read : io=101207GB, bw=491309KB/s, iops=982618, runt=216000016msec
> 	  cpu          : usr=0.09%, sys=4.33%, ctx=152784302066, majf=0, minf=2928
> 	  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.5%, 16=0.5%, 32=1.0%, >=64=1.0%
> 	     submit    : 0=0.0%, 4=18.0%, 8=6.6%, 16=8.5%, 32=0.0%, 64=0.0%, >=64=0.0%
> 	     complete  : 0=0.0%, 4=0.0%, 8=0.0%, 16=15.0%, 32=0.1%, 64=0.1%, >=64=0.1%
> 	     issued    : total=r=212245615134/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
> 	     latency   : target=0, window=0, percentile=100.00%, depth=96
>
> 	Run status group 0 (all jobs):
> 	   READ: io=101207GB, aggrb=491309KB/s, minb=491309KB/s, maxb=491309KB/s, mint=216000016msec, maxt=216000016msec
>
> All the disk stats, however, wrap at ios=4,294,967,295 (32 bit).
> In this case it caught sdi falling a bit behind the others,
> but all of them have wrapped multiple times.
>
> 	Disk stats (read/write):
> 	  sdb: ios=796157304/0, merge=0/0, ticks=722039638/0, in_queue=735284999, util=100.00%
> 	  sdc: ios=725235994/0, merge=0/0, ticks=725893305/0, in_queue=738790349, util=100.00%
> 	  sdd: ios=722370867/0, merge=0/0, ticks=724540972/0, in_queue=738926102, util=100.00%
> 	  sde: ios=722490025/0, merge=0/0, ticks=724775894/0, in_queue=745581851, util=100.00%
> 	  sdf: ios=719665329/0, merge=0/0, ticks=724281840/0, in_queue=740201203, util=100.00%
> 	  sdg: ios=721386377/0, merge=0/0, ticks=725529483/0, in_queue=740729310, util=100.00%
> 	  sdh: ios=720461888/0, merge=0/0, ticks=724759222/0, in_queue=741212131, util=100.00%
> 	  sdi: ios=3280272329/0, merge=0/0, ticks=3337080572/0, in_queue=3340290775, util=81.57%
> 	  sdj: ios=717395167/0, merge=0/0, ticks=723762993/0, in_queue=739136654, util=100.00%
> 	  sdk: ios=824804416/0, merge=0/0, ticks=722973383/0, in_queue=734915061, util=100.00%
> 	  sdl: ios=787317365/0, merge=0/0, ticks=720963594/0, in_queue=736506238, util=100.00%
> 	  sdm: ios=791112845/0, merge=0/0, ticks=723371287/0, in_queue=745590636, util=100.00%
> 	  sdn: ios=786009870/0, merge=0/0, ticks=721111447/0, in_queue=733786474, util=100.00%
> 	  sdo: ios=787226466/0, merge=0/0, ticks=722200707/0, in_queue=737673635, util=100.00%
> 	  sdp: ios=789062478/0, merge=0/0, ticks=723648481/0, in_queue=737820918, util=100.00%
> 	  sdq: ios=786121713/0, merge=0/0, ticks=722203635/0, in_queue=752578258, util=100.00%
>
> These structures are the reason:
> 	struct disk_util_stats {
> 	        uint32_t ios[2];
> 	        uint32_t merges[2];
> 	        uint64_t sectors[2];
> 	        uint32_t ticks[2];
> 	        uint32_t io_ticks;
> 	        uint32_t time_in_queue;
> 	        uint64_t msec;
> 	};
> 	struct disk_util_agg {
> 	        uint32_t ios[2];
> 	        uint32_t merges[2];
> 	        uint64_t sectors[2];
> 	        uint32_t ticks[2];
> 	        uint32_t io_ticks;
> 	        uint32_t time_in_queue;
> 	        uint32_t slavecount;
> 	        fio_fp64_t max_util;
> 	};

Thanks, I've bumped the counters to 64-bit to avoid this overflow.

-- 
Jens Axboe


