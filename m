Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH] client: support --status-interval option in client/server mode
Date: Sun,  5 Aug 2018 09:30:14 -0700
Message-Id: <1533486614-14022-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

This fixes "FIO client/server periodic stats" for non JSON output
(the reporter is using JSON output).
https://www.spinics.net/lists/fio/msg07204.html

Mark -L/--status-interval option with FIO_CLIENT_FLAG, so that the
command line string is sent to the server side.

The client can now control the server to periodically show status,
and each status is sent to the client via fio_server_text_output()
(FIO_NET_CMD_TEXT socket event) in log_info_buf().

Reported-by: Mark Beierl <Mark.Beierl@dell.com>
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init.c b/init.c
index ede0a8b..06f6971 100644
--- a/init.c
+++ b/init.c
@@ -258,7 +258,7 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 	{
 		.name		= (char *) "status-interval",
 		.has_arg	= required_argument,
-		.val		= 'L',
+		.val		= 'L' | FIO_CLIENT_FLAG,
 	},
 	{
 		.name		= (char *) "trigger-file",
-- 
1.7.1


