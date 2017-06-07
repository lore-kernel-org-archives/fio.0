Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/5] use enum error_type_bit for ignore_error index
Date: Wed,  7 Jun 2017 23:18:47 +0300
Message-Id: <20170607201849.9448-4-tkusumi@tuxera.com>
In-Reply-To: <20170607201849.9448-1-tkusumi@tuxera.com>
References: <20170607201849.9448-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 options.c  | 6 ++++--
 td_error.h | 3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/options.c b/options.c
index 4214f24..6d799bf 100644
--- a/options.c
+++ b/options.c
@@ -270,7 +270,8 @@ static int str2error(char *str)
 	return 0;
 }
 
-static int ignore_error_type(struct thread_data *td, int etype, char *str)
+static int ignore_error_type(struct thread_data *td, enum error_type_bit etype,
+				char *str)
 {
 	unsigned int i;
 	int *error;
@@ -331,7 +332,8 @@ static int str_ignore_error_cb(void *data, const char *input)
 {
 	struct thread_data *td = cb_data_to_td(data);
 	char *str, *p, *n;
-	int type = 0, ret = 1;
+	int ret = 1;
+	enum error_type_bit type = 0;
 
 	if (parse_dryrun())
 		return 0;
diff --git a/td_error.h b/td_error.h
index 1133989..1b38a53 100644
--- a/td_error.h
+++ b/td_error.h
@@ -2,7 +2,8 @@
 #define FIO_TD_ERROR_H
 
 /*
- * What type of errors to continue on when continue_on_error is used
+ * What type of errors to continue on when continue_on_error is used,
+ * and what type of errors to ignore when ignore_error is used.
  */
 enum error_type_bit {
 	ERROR_TYPE_READ_BIT = 0,
-- 
2.9.4


