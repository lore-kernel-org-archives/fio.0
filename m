Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 1/3] filesetup: improve LFSR init failure error message
Date: Mon, 11 Nov 2019 11:30:53 -0500
Message-Id: <20191111163055.7358-2-vincentfu@gmail.com>
In-Reply-To: <20191111163055.7358-1-vincentfu@gmail.com>
References: <20191111163055.7358-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Especially with small sample spaces, the LFSR random generator
occasionally fails to initialize successfully. When this occurs, the
error message refers to problems allocating a random map. Change the
error message to explicitly mention the LFSR failure.

OLD BEHAVIOR
$ ./fio --name=test --ioengine=null --size=4k --random_generator=lfsr --rw=randread --randrepeat=0
test: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=null, iodepth=1
fio-3.16-13-g998b-dirty
Starting 1 process
fio: failed allocating random map. If running a large number of jobs, try the 'norandommap' option or set 'softrandommap'. Or give a larger --alloc-size to fio.

NEW BEHAVIOR
$ ./fio --name=test --ioengine=null --size=4k --random_generator=lfsr --rw=randread --randrepeat=0
test: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=null, iodepth=1
fio-3.16-37-g65ee
Starting 1 process
fio: failed initializing LFSR
---
 filesetup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/filesetup.c b/filesetup.c
index 1d3094c1..7d54c9f1 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1354,6 +1354,9 @@ bool init_random_map(struct thread_data *td)
 			if (!lfsr_init(&f->lfsr, blocks, seed, 0)) {
 				fio_file_set_lfsr(f);
 				continue;
+			} else {
+				log_err("fio: failed initializing LFSR\n");
+				return false;
 			}
 		} else if (!td->o.norandommap) {
 			f->io_axmap = axmap_new(blocks);
-- 
2.17.1


