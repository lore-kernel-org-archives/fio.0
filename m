Return-Path: <sbradshaw@micron.com>
Message-ID: <50D26157.5020802@micron.com>
Date: Wed, 19 Dec 2012 16:52:39 -0800
From: Sam Bradshaw <sbradshaw@micron.com>
MIME-Version: 1.0
Subject: [PATCH] gettime: minimize integer division
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


This patch generally converts a division to a subtraction in fio_gettime().

Shows ~1% better iops with synthetic benchmarking at roughly the same cpu 
time spent in fio_gettime().

Signed-off-by: Sam Bradshaw <sbradshaw@micron.com>

diff --git a/gettime.c b/gettime.c
index 248f146..e2a6241 100644
--- a/gettime.c
+++ b/gettime.c
@@ -163,17 +163,23 @@ void fio_gettime(struct timeval *tp, void fio_unused *caller)
 		}
 #ifdef ARCH_HAVE_CPU_CLOCK
 	case CS_CPUCLOCK: {
-		unsigned long long usecs, t;
+		unsigned long long usecs, t, delta = 0;

 		t = get_cpu_clock();
 		if (tv && t < tv->last_cycles) {
 			dprint(FD_TIME, "CPU clock going back in time\n");
 			t = tv->last_cycles;
-		} else if (tv)
+		} else if (tv) {
+			if (tv->last_tv_valid)
+				delta = t - tv->last_cycles;
 			tv->last_cycles = t;
+		}

 		usecs = t / cycles_per_usec;
-		tp->tv_sec = usecs / 1000000;
+		if (delta > 1000000)
+			tp->tv_sec = tv->last_tv.tv_sec;
+		else
+			tp->tv_sec = usecs / 1000000;
 		tp->tv_usec = usecs % 1000000;
 		break;
 		}

