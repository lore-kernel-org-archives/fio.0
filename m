Return-Path: <prvs=81407a9e8=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 03/11] tools: fiograph: do not overwrite input script file
Date: Tue,  6 Jul 2021 09:17:35 +0900
Message-Id: <20210706001743.10818-4-damien.lemoal@wdc.com>
In-Reply-To: <20210706001743.10818-1-damien.lemoal@wdc.com>
References: <20210706001743.10818-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

In fiograph.py, the setup_commandline() function mistakenly initializes
the output_file variable to the input fio script file, causing this file
to always be overwritten, even if an output file is specified using the
--output option. Fix this by properly initialzing the output_file
variable using the --output option argument value. If an output file
name is not provided, the input script file name is used by default.

Also fix fiograph configuration file to remove the cmdprio_percentage
option repeated entry for io_uring and libaio.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 tools/fiograph/fiograph.conf | 4 ++--
 tools/fiograph/fiograph.py   | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/fiograph/fiograph.conf b/tools/fiograph/fiograph.conf
index 7b851e19..1d50d141 100644
--- a/tools/fiograph/fiograph.conf
+++ b/tools/fiograph/fiograph.conf
@@ -48,10 +48,10 @@ specific_options=https  http_host  http_user  http_pass  http_s3_key  http_s3_ke
 specific_options=ime_psync  ime_psyncv
 
 [ioengine_io_uring]
-specific_options=hipri  cmdprio_percentage  cmdprio_percentage  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  uncached  nowait  force_async
+specific_options=hipri  cmdprio_percentage  fixedbufs  registerfiles  sqthread_poll  sqthread_poll_cpu  nonvectored  uncached  nowait  force_async
 
 [ioengine_libaio]
-specific_options=userspace_reap  cmdprio_percentage  cmdprio_percentage  nowait
+specific_options=userspace_reap  cmdprio_percentage  nowait
 
 [ioengine_libcufile]
 specific_options=gpu_dev_ids  cuda_io
diff --git a/tools/fiograph/fiograph.py b/tools/fiograph/fiograph.py
index 7695c964..b5669a2d 100755
--- a/tools/fiograph/fiograph.py
+++ b/tools/fiograph/fiograph.py
@@ -292,9 +292,11 @@ def setup_commandline():
 def main():
     global config_file
     args = setup_commandline()
-    output_file = args.file
     if args.output is None:
+        output_file = args.file
         output_file = output_file.replace('.fio', '')
+    else:
+        output_file = args.output
     config_file = configparser.RawConfigParser(allow_no_value=True)
     config_file.read(args.config)
     fio_to_graphviz(args.file, args.format).render(output_file, view=args.view)
-- 
2.31.1


