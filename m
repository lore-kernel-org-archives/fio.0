Return-Path: <prvs=60033e2b9=bart.vanassche@wdc.com>
From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] filesetup: Initialize all members of struct fio_file
Date: Fri,  9 Mar 2018 16:46:36 -0800
Message-Id: <20180310004636.5853-1-bart.vanassche@wdc.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>
List-ID: <fio@vger.kernel.org>

This patch avoids that Valgrind reports complaints like the following:

==10492== Conditional jump or move depends on uninitialised value(s)
==10492==    at 0x43BF19: fio_file_reset (filesetup.c:1872)
==10492==    by 0x43AB7F: alloc_new_file (filesetup.c:1496)
==10492==    by 0x43AED4: add_file (filesetup.c:1581)
==10492==    by 0x4528D3: str_filename_cb (options.c:1276)
==10492==    by 0x44D83A: __handle_option (parse.c:722)
==10492==    by 0x44E303: handle_option (parse.c:941)
==10492==    by 0x44E68B: parse_cmd_option (parse.c:1061)
==10492==    by 0x4541DD: fio_cmd_option_parse (options.c:4966)
==10492==    by 0x427C6D: parse_cmd_line (init.c:2652)
==10492==    by 0x428685: parse_options (init.c:2924)
==10492==    by 0x4920AC: main (fio.c:47)

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 filesetup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/filesetup.c b/filesetup.c
index dd8f6eb2b0f6..1a187ff2648d 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1481,7 +1481,7 @@ static struct fio_file *alloc_new_file(struct thread_data *td)
 	if (td_ioengine_flagged(td, FIO_NOFILEHASH))
 		f = calloc(1, sizeof(*f));
 	else
-		f = smalloc(sizeof(*f));
+		f = scalloc(1, sizeof(*f));
 	if (!f) {
 		assert(0);
 		return NULL;
-- 
2.16.2


