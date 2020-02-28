Return-Path: <prvs=320bddd21=naohiro.aota@wdc.com>
From: Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH 5/6] io_u: ensure io_u_quiesce() to process all the IOs
Date: Fri, 28 Feb 2020 16:12:47 +0900
Message-Id: <20200228071248.3981623-6-naohiro.aota@wdc.com>
In-Reply-To: <20200228071248.3981623-1-naohiro.aota@wdc.com>
References: <20200228071248.3981623-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
List-ID: <fio@vger.kernel.org>

Currently, when IO have an error io_u_quiesce() stops processing
in-flight IOs there and leaves other IOs non-completed. This is not a
desired behavior for io_u_quiesce(). Fix it by continuing even on
error.

Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 io_u.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_u.c b/io_u.c
index bcb893c5abad..5d62a76cb5a7 100644
--- a/io_u.c
+++ b/io_u.c
@@ -606,7 +606,7 @@ static inline enum fio_ddir get_rand_ddir(struct thread_data *td)
 
 int io_u_quiesce(struct thread_data *td)
 {
-	int ret = 0, completed = 0;
+	int ret = 0, completed = 0, err = 0;
 
 	/*
 	 * We are going to sleep, ensure that we flush anything pending as
@@ -625,7 +625,7 @@ int io_u_quiesce(struct thread_data *td)
 		if (ret > 0)
 			completed += ret;
 		else if (ret < 0)
-			break;
+			err = ret;
 	}
 
 	if (td->flags & TD_F_REGROW_LOGS)
@@ -634,7 +634,7 @@ int io_u_quiesce(struct thread_data *td)
 	if (completed)
 		return completed;
 
-	return ret;
+	return err;
 }
 
 static enum fio_ddir rate_ddir(struct thread_data *td, enum fio_ddir ddir)
-- 
2.25.1


