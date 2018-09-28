Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58620 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbeI1SXw (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Sep 2018 14:23:52 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g5rRY-0006Gj-7s
        for fio@vger.kernel.org; Fri, 28 Sep 2018 12:00:25 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180928120001.AA4FD2C030F@kernel.dk>
Date: Fri, 28 Sep 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d60be7d51cbb601cc59dccc9f2a418072046a985:

  zbd: Remove unused function and variable (2018-09-26 08:26:01 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 152529ae26d1167779138b6cd30d4de10623da1b:

  gettime: slightly improve CPU clock calibration (2018-09-27 17:38:21 -0600)

----------------------------------------------------------------
Bart Van Assche (1):
      zbd: Fix zbd_zone_nr()

Jens Axboe (3):
      Merge branch 'master' of https://github.com/bvanassche/fio
      server: be locally vocal about communication issues
      gettime: slightly improve CPU clock calibration

 gettime.c | 5 ++---
 server.c  | 4 ++++
 zbd.c     | 2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/gettime.c b/gettime.c
index c0f2638..7702193 100644
--- a/gettime.c
+++ b/gettime.c
@@ -237,12 +237,11 @@ static unsigned long get_cycles_per_msec(void)
 	c_s = get_cpu_clock();
 	do {
 		__fio_gettime(&e);
+		c_e = get_cpu_clock();
 
 		elapsed = utime_since(&s, &e);
-		if (elapsed >= 1280) {
-			c_e = get_cpu_clock();
+		if (elapsed >= 1280)
 			break;
-		}
 	} while (1);
 
 	fio_clock_source = old_cs;
diff --git a/server.c b/server.c
index b966c66..1c07501 100644
--- a/server.c
+++ b/server.c
@@ -296,6 +296,8 @@ static int verify_convert_cmd(struct fio_net_cmd *cmd)
 	if (crc != cmd->cmd_crc16) {
 		log_err("fio: server bad crc on command (got %x, wanted %x)\n",
 				cmd->cmd_crc16, crc);
+		fprintf(f_err, "fio: server bad crc on command (got %x, wanted %x)\n",
+				cmd->cmd_crc16, crc);
 		return 1;
 	}
 
@@ -310,6 +312,8 @@ static int verify_convert_cmd(struct fio_net_cmd *cmd)
 		break;
 	default:
 		log_err("fio: bad server cmd version %d\n", cmd->version);
+		fprintf(f_err, "fio: client/server version mismatch (%d != %d)\n",
+				cmd->version, FIO_SERVER_VER);
 		return 1;
 	}
 
diff --git a/zbd.c b/zbd.c
index 9c52587..aa08b81 100644
--- a/zbd.c
+++ b/zbd.c
@@ -606,7 +606,7 @@ static int zbd_reset_range(struct thread_data *td, const struct fio_file *f,
 static unsigned int zbd_zone_nr(struct zoned_block_device_info *zbd_info,
 				struct fio_zone_info *zone)
 {
-	return (uintptr_t) zone - (uintptr_t) zbd_info->zone_info;
+	return zone - zbd_info->zone_info;
 }
 
 /**

