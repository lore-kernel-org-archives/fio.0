Return-Path: <prvs=7094d7b7f=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/2] zbd: avoid zone reset for file reset during asynchronous IOs in-flight
Date: Tue, 23 Mar 2021 10:13:23 +0900
Message-Id: <20210323011324.1365343-2-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20210323011324.1365343-1-shinichiro.kawasaki@wdc.com>
References: <20210323011324.1365343-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

When fio repeats same workload on zoned block devices, zbd_file_reset()
is called before each repetition to reset target zones. If a thread runs
such repeated workload with asynchronous IOs, the thread calls
zbd_file_reset() and reset target zones even when the IOs are in-flight.

This causes write pointer move during in-flight IOs and results in
unexpected IO results. Especially if write requests are in-flight, they
fail with unaligned write command error. A single thread may do both the
zone reset and the write request submit, recursive zone locks can not
prevent the zone reset during the writes in-flight.

To avoid the zone reset during asynchronous IOs, add io_u_quiesce() call
before the zone reset in zbd_file_reset(). This ensures that the in-
flight IOs are completed before the zone reset.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/zbd.c b/zbd.c
index d16b890f..5f0799b0 100644
--- a/zbd.c
+++ b/zbd.c
@@ -991,6 +991,13 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 	swd = zbd_process_swd(td, f, SET_SWD);
 	dprint(FD_ZBD, "%s(%s): swd = %" PRIu64 "\n", __func__, f->file_name,
 	       swd);
+
+	/*
+	 * When the thread repeats workload on the same file, ensure the
+	 * async IOs by previous repetition completed before zone reset.
+	 */
+	io_u_quiesce(td);
+
 	/*
 	 * If data verification is enabled reset the affected zones before
 	 * writing any data to avoid that a zone reset has to be issued while
-- 
2.29.2


