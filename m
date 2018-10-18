Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH v2 0/1] fio: reset more counters when ramp time has elapsed
Date: Thu, 18 Oct 2018 16:42:53 -0400
Message-Id: <20181018204254.5350-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org, vincentfu@gmail.com
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Jens, I sent the wrong patch earlier.

This version should be safer since reset_io_stats() is now called in
ramp_time_over() instead of in reset_all_stats().

Vincent Fu (1):
  fio: reset more counters when ramp time has elapsed

 time.c | 1 +
 1 file changed, 1 insertion(+)

-- 
2.17.1


