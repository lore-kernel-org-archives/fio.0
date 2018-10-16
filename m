Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 2/2] init: force threads when checking overlap in offload mode
Date: Tue, 16 Oct 2018 11:26:50 -0400
Message-Id: <20181016152650.7784-3-vincentfu@gmail.com>
In-Reply-To: <20181016152650.7784-1-vincentfu@gmail.com>
References: <20181016152650.7784-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

serialize_overlap combined with io_submit_mode=offload requires
threads. Print a warning and force the use of threads if the user
did not specify threads.
---
 init.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/init.c b/init.c
index a2b70c4a..224eb8ab 100644
--- a/init.c
+++ b/init.c
@@ -751,6 +751,14 @@ static int fixup_options(struct thread_data *td)
 	    o->io_submit_mode != IO_MODE_OFFLOAD)
 		o->serialize_overlap = 0;
 
+	if (o->serialize_overlap && o->io_submit_mode == IO_MODE_OFFLOAD && !o->use_thread) {
+		o->use_thread = 1;
+		log_info("fio: threads must be used when overlap checking is"
+			 " enabled in offload mode. Use the 'thread' option"
+			 " to get rid of this warning.\n");
+		ret |= warnings_fatal;
+	}
+
 	if (o->nr_files > td->files_index)
 		o->nr_files = td->files_index;
 
-- 
2.17.1


