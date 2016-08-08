Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 1/6] Use char* for pid_file path
Date: Tue,  9 Aug 2016 02:27:26 +0900
Message-Id: <1470677251-8292-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

since no function expects this to be void*.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init.c b/init.c
index 048bd5d..0a6766e 100644
--- a/init.c
+++ b/init.c
@@ -2302,7 +2302,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 	struct thread_data *td = NULL;
 	int c, ini_idx = 0, lidx, ret = 0, do_exit = 0, exit_val = 0;
 	char *ostr = cmd_optstr;
-	void *pid_file = NULL;
+	char *pid_file = NULL;
 	void *cur_client = NULL;
 	int backend = 0;
 
-- 
2.5.5


