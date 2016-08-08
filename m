Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34410 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbcHHR1w (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 8 Aug 2016 13:27:52 -0400
Received: by mail-pf0-f193.google.com with SMTP id g202so25423184pfb.1
        for <fio@vger.kernel.org>; Mon, 08 Aug 2016 10:27:52 -0700 (PDT)
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 2/6] Change --output-format argument from optional to required
Date: Tue,  9 Aug 2016 02:27:27 +0900
Message-Id: <1470677251-8292-2-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1470677251-8292-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1470677251-8292-1-git-send-email-kusumi.tomohiro@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>

Not sure if there were any reason d10983d7 chose to add if(!optarg)
conditional, but this is what other fio options (or in general) do.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 init.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/init.c b/init.c
index 0a6766e..fb07daa 100644
--- a/init.c
+++ b/init.c
@@ -114,7 +114,7 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 	},
 	{
 		.name		= (char *) "output-format",
-		.has_arg	= optional_argument,
+		.has_arg	= required_argument,
 		.val		= 'F' | FIO_CLIENT_FLAG,
 	},
 	{
@@ -2352,12 +2352,6 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			output_format = FIO_OUTPUT_TERSE;
 			break;
 		case 'F':
-			if (!optarg) {
-				log_err("fio: missing --output-format argument\n");
-				exit_val = 1;
-				do_exit++;
-				break;
-			}
 			if (parse_output_format(optarg)) {
 				log_err("fio: failed parsing output-format\n");
 				exit_val = 1;
-- 
2.5.5

