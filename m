Return-Path: <axboe@kernel.dk>
Subject: Re: The number of fio jobs decrease after long time test
References: <74ffbb36-a06a-9875-7c87-f3fd5ab508c1@hisilicon.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <15cde73b-0c79-9977-fe30-7c8c9286ebbc@kernel.dk>
Date: Wed, 20 Jun 2018 11:28:43 -0600
MIME-Version: 1.0
In-Reply-To: <74ffbb36-a06a-9875-7c87-f3fd5ab508c1@hisilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "chenxiang (M)" <chenxiang66@hisilicon.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, John Garry <john.garry@huawei.com>
List-ID: <fio@vger.kernel.org>

On 6/19/18 8:49 PM, chenxiang (M) wrote:
> Hi Jens,
> 
> When i use fio to test 4k READ for 19 disks which are connected with a 
> expander, and find a issue:
> the numbers of jobs decrease after some times, after about 2 days or 3 
> days, there is only one job
> left, but there is no another exception. Part of log is as follows (the 
> attachment is the script i use to run fio
> (./creat_fio_task.sh 4k read 64)):
> 
> Jobs: 19 (f=19): [RRRRRRRRRRRRRRRRRRR] [2.5% done] [7016M/0K /s] 
> [1713K/0  iops] [eta 02d:08h:19m:55s]
> Jobs: 19 (f=19): [RRRRRRRRRRRRRRRRRRR] [2.5% done] [6978M/0K /s] 
> [1704K/0  iops] [eta 02d:08h:19m:55s]
> Jobs: 19 (f=19): [RRRRRRRRRRRRRRRRRRR] [2.5% done] [7008M/0K /s] 
> [1711K/0  iops] [eta 02d:08h:19m:54s]
> Jobs: 18 (f=18): [RRRR_RRRRRRRRRRRRRR] [2.5% done] [5800M/0K /s] 
> [1416K/0  iops] [eta 02d:08h:19m:53s]
> Jobs: 18 (f=18): [RRRR_RRRRRRRRRRRRRR] [2.5% done] [5325M/0K /s] 
> [1300K/0  iops] [eta 02d:08h:19m:51s]
> Jobs: 18 (f=18): [RRRR_RRRRRRRRRRRRRR] [2.5% done] [5354M/0K /s] 
> [1307K/0  iops] [eta 02d:08h:19m:49s]
> Jobs: 18 (f=18): [RRRR_RRRRRRRRRRRRRR] [2.5% done] [5405M/0K /s] 
> [1320K/0  iops] [eta 02d:08h:19m:49s]
> Jobs: 18 (f=18): [RRRR_RRRRRRRRRRRRRR] [2.5% done] [5411M/0K /s] 
> [1321K/0  iops] [eta 02d:08h:19m:48s]
> Jobs: 18 (f=18): [RRRR_RRRRRRRRRRRRRR] [2.5% done] [5525M/0K /s] 
> [1349K/0  iops] [eta 02d:08h:19m:48s]
> Jobs: 18 (f=18): [RRRR_RRRRRRRRRRRRRR] [2.5% done] [5519M/0K /s] 
> [1347K/0  iops] [eta 02d:08h:19m:49s]
> Jobs: 17 (f=17): [RR_R_RRRRRRRRRRRRRR] [2.5% done] [5236M/0K /s] 
> [1278K/0  iops] [eta 02d:08h:19m:49s]
> Jobs: 17 (f=17): [RR_R_RRRRRRRRRRRRRR] [2.5% done] [5085M/0K /s] 
> [1241K/0  iops] [eta 02d:08h:19m:50s]
> Jobs: 17 (f=17): [RR_R_RRRRRRRRRRRRRR] [2.5% done] [5072M/0K /s] 
> [1238K/0  iops] [eta 02d:08h:19m:50s]
> Jobs: 17 (f=17): [RR_R_RRRRRRRRRRRRRR] [2.5% done] [5077M/0K /s] 
> [1240K/0  iops] [eta 02d:08h:19m:51s]
> Jobs: 17 (f=17): [RR_R_RRRRRRRRRRRRRR] [2.5% done] [5373M/0K /s] 
> [1312K/0  iops] [eta 02d:08h:19m:53s]
> Jobs: 17 (f=17): [RR_R_RRRRRRRRRRRRRR] [2.5% done] [5649M/0K /s] 
> [1379K/0  iops] [eta 02d:08h:19m:53s]
> Jobs: 17 (f=17): [RR_R_RRRRRRRRRRRRRR] [2.5% done] [5656M/0K /s] 
> [1381K/0  iops] [eta 02d:08h:19m:54s]
> Jobs: 17 (f=17): [RR_R_RRRRRRRRRRRRRR] [2.5% done] [5595M/0K /s] 
> [1366K/0  iops] [eta 02d:08h:19m:54s]
> Jobs: 17 (f=17): [RR_R_RRRRRRRRRRRRRR] [2.5% done] [4995M/0K /s] 
> [1219K/0  iops] [eta 02d:08h:19m:54s]
> Jobs: 17 (f=17): [RR_R_RRRRRRRRRRRRRR] [2.5% done] [4976M/0K /s] 
> [1215K/0  iops] [eta 02d:08h:19m:52s]
> Jobs: 17 (f=17): [RR_R_RRRRRRRRRRRRRR] [2.5% done] [4996M/0K /s] 
> [1220K/0  iops] [eta 02d:08h:19m:51s]
> Jobs: 17 (f=17): [RR_R_RRRRRRRRRRRRRR] [2.5% done] [4980M/0K /s] 
> [1216K/0  iops] [eta 02d:08h:19m:50s]
> Jobs: 17 (f=17): [RR_R_RRRRRRRRRRRRRR] [2.5% done] [4990M/0K /s] 
> [1218K/0  iops] [eta 02d:08h:19m:51s]
> Jobs: 17 (f=17): [RR_R_RRRRRRRRRRRRRR] [2.5% done] [5007M/0K /s] 
> [1222K/0  iops] [eta 02d:08h:19m:52s]
> Jobs: 17 (f=17): [RR_R_RRRRRRRRRRRRRR] [2.5% done] [5012M/0K /s] 
> [1224K/0  iops] [eta 02d:08h:19m:53s]
> Jobs: 17 (f=17): [RR_R_RRRRRRRRRRRRRR] [2.5% done] [5075M/0K /s] 
> [1239K/0  iops] [eta 02d:08h:19m:54s]
> Jobs: 17 (f=17): [RR_R_RRRRRRRRRRRRRR] [2.5% done] [4994M/0K /s] 
> [1219K/0  iops] [eta 02d:08h:19m:55s]
> Jobs: 16 (f=16): [RR_R_RR_RRRRRRRRRRR] [2.5% done] [4893M/0K /s] 
> [1195K/0  iops] [eta 02d:08h:20m:34s]
> Jobs: 16 (f=16): [RR_R_RR_RRRRRRRRRRR] [2.5% done] [4620M/0K /s] 
> [1128K/0  iops] [eta 02d:08h:20m:35s]
> Jobs: 16 (f=16): [RR_R_RR_RRRRRRRRRRR] [2.5% done] [4600M/0K /s] 
> [1123K/0  iops] [eta 02d:08h:20m:35s]
> Jobs: 16 (f=16): [RR_R_RR_RRRRRRRRRRR] [2.5% done] [4595M/0K /s] 
> [1122K/0  iops] [eta 02d:08h:20m:34s]
> Jobs: 16 (f=16): [RR_R_RR_RRRRRRRRRRR] [2.5% done] [4600M/0K /s] 
> [1123K/0  iops] [eta 02d:08h:20m:33s]
> Jobs: 16 (f=16): [RR_R_RR_RRRRRRRRRRR] [2.5% done] [4603M/0K /s] 
> [1124K/0  iops] [eta 02d:08h:20m:32s]
> Jobs: 16 (f=16): [RR_R_RR_RRRRRRRRRRR] [2.5% done] [4625M/0K /s] 
> [1129K/0  iops] [eta 02d:08h:20m:31s]
> Jobs: 16 (f=16): [RR_R_RR_RRRRRRRRRRR] [2.5% done] [4638M/0K /s] 
> [1132K/0  iops] [eta 02d:08h:20m:29s]
> Jobs: 16 (f=16): [RR_R_RR_RRRRRRRRRRR] [2.5% done] [4626M/0K /s] 
> [1129K/0  iops] [eta 02d:08h:20m:27s]
> Jobs: 16 (f=16): [RR_R_RR_RRRRRRRRRRR] [2.5% done] [4616M/0K /s] 
> [1127K/0  iops] [eta 02d:08h:20m:26s]
> Jobs: 16 (f=16): [RR_R_RR_RRRRRRRRRRR] [2.5% done] [4615M/0K /s] 
> [1127K/0  iops] [eta 02d:08h:20m:25s]
> Jobs: 16 (f=16): [RR_R_RR_RRRRRRRRRRR] [2.5% done] [4624M/0K /s] 
> [1129K/0  iops] [eta 02d:08h:20m:25s]
> Jobs: 16 (f=16): [RR_R_RR_RRRRRRRRRRR] [2.5% done] [4634M/0K /s] 
> [1131K/0  iops] [eta 02d:08h:20m:25s]
> Jobs: 16 (f=16): [RR_R_RR_RRRRRRRRRRR] [2.5% done] [4635M/0K /s] 
> [1132K/0  iops] [eta 02d:08h:20m:25s]
> Jobs: 16 (f=16): [RR_R_RR_RRRRRRRRRRR] [2.5% done] [4626M/0K /s] 
> [1129K/0  iops] [eta 02d:08h:20m:25s]
> Jobs: 16 (f=16): [RR_R_RR_RRRRRRRRRRR] [2.5% done] [4614M/0K /s] 
> [1127K/0  iops] [eta 02d:08h:20m:26s]
> Jobs: 16 (f=16): [RR_R_RR_RRRRRRRRRRR] [2.5% done] [4606M/0K /s] 
> [1125K/0  iops] [eta 02d:08h:20m:27s]
> Jobs: 16 (f=16): [RR_R_RR_RRRRRRRRRRR] [2.5% done] [4595M/0K /s] 
> [1122K/0  iops] [eta 02d:08h:20m:28s]
> Jobs: 16 (f=16): [RR_R_RR_RRRRRRRRRRR] [2.5% done] [4631M/0K /s] 
> [1131K/0  iops] [eta 02d:08h:20m:28s]
> ......
> 
> Is it normal or exception like that? If exception, do you know why?

The jobs are probably finishing. You set a runtime, but didn't make
it time based. If you add time_based=1 it might work closer to
what you expect.

I'm trimming the CC list, you added every linux list except the
list you should have added, which is the fio list...

-- 
Jens Axboe


