Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 2/2] filesetup: honor the offset option
Date: Wed, 11 Sep 2019 10:56:40 -0400
Message-Id: <20190911145640.30005-3-vincentfu@gmail.com>
In-Reply-To: <20190911145640.30005-1-vincentfu@gmail.com>
References: <20190911145640.30005-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Commands like the following do not honor the value given by the offset
option:

./fio --name=test --rw=randread --runtime=10s --offset=90% --time_based --ioengine=null --size=1T --norandommap --randrepeat=0
./fio --name=test --size=8k --offset=4k

In the random case, eventually a random offset will be generated beyond
the 1T file size, leading to a failure.

In the sequential case, a 12k file will be created despite size
specifying the 8k end boundary.

This patch modifies setup_files() so that f->io_size incorporates the
offset for cases like those above.
---
 filesetup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/filesetup.c b/filesetup.c
index 7904d187..b8d1d838 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1047,7 +1047,7 @@ int setup_files(struct thread_data *td)
 			 * doesn't divide nicely with the min blocksize,
 			 * make the first files bigger.
 			 */
-			f->io_size = fs;
+			f->io_size = fs - f->file_offset;
 			if (nr_fs_extra) {
 				nr_fs_extra--;
 				f->io_size += bs;
-- 
2.17.1


