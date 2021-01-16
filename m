Return-Path: <glqinhongwei@gmail.com>
MIME-Version: 1.0
From: Hongwei Qin <glqinhongwei@gmail.com>
Date: Sun, 17 Jan 2021 02:45:56 +0800
Message-ID: <CAKvRR0Sch-xwyoG+MuyPANHD5Y+Gzd+o7m0gK27sCveKyXe_ig@mail.gmail.com>
Subject: [PATCH] Fix a rate limit issue.
Content-Type: text/plain; charset="UTF-8"
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, HongweiQin <glqinhongwei@gmail.com>
List-ID: <fio@vger.kernel.org>

In the current implementation, should_check_rate() returns false
if ddir_rw_sum(td->bytes_done)==0. Therefore, a thread may violate
the rate if iodepth*bs > rate.

This patch addresses the issue by not checking td->bytes_done in
should_check_rate.

An example of the issue:

[root@localhost test]# cat fio_randwrite
[global]
thread
kb_base=1000
direct=1
size=28GiB
group_reporting
io_size=16384
ioengine=libaio
iodepth=2
bs=4096
iodepth_batch_submit=1
iodepth_batch_complete=1
filename=/dev/qblkdev

[fio_randwrite]
rw=randwrite
rate_iops=,1
iodepth_batch_submit=1
thinktime_blocks=1
rate_cycle=1000
thinktime=3s
rate_ignore_thinktime=1

[root@localhost test]# fio fio_randwrite

blktrace output:
259,1   11        1     0.100550729  6135  Q  WS 3541608 + 8 [fio]
259,1   11        2     0.100552183  6135  G  WS 3541608 + 8 [fio]
259,1   11        3     0.100560373  6135  D  WS 3541608 + 8 [fio]
259,1   11        4     0.100570436  6135  C  WS 3541608 + 8 [0]
259,1   11        5     0.100599816  6135  Q  WS 43470024 + 8 [fio]
259,1   11        6     0.100600513  6135  G  WS 43470024 + 8 [fio]
259,1   11        7     0.100601579  6135  D  WS 43470024 + 8 [fio]
259,1   11        8     0.100612750  6135  C  WS 43470024 + 8 [0]
259,1   11        9     3.101034407  6135  Q  WS 49511928 + 8 [fio]
259,1   11       10     3.101036067  6135  G  WS 49511928 + 8 [fio]
259,1   11       11     3.101054487  6135  D  WS 49511928 + 8 [fio]
259,1   11       12     3.101068699  6135  C  WS 49511928 + 8 [0]
259,1   11       13     6.101267480  6135  Q  WS 27599368 + 8 [fio]
259,1   11       14     6.101269216  6135  G  WS 27599368 + 8 [fio]
259,1   11       15     6.101277050  6135  D  WS 27599368 + 8 [fio]
259,1   11       16     6.101287956  6135  C  WS 27599368 + 8 [0]

Signed-off-by: HongweiQin <glqinhongwei@gmail.com>
---
 fio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fio.h b/fio.h
index 4d439d9..f5b3990 100644
--- a/fio.h
+++ b/fio.h
@@ -767,7 +767,7 @@ static inline bool should_check_rate(struct thread_data *td)
     if (!__should_check_rate(td))
         return false;

-    return ddir_rw_sum(td->bytes_done) != 0;
+    return true;
 }

 static inline unsigned long long td_max_bs(struct thread_data *td)
--
1.8.3.1

