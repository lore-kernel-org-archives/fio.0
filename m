Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 05/17] Fix debug print format of file ->file_name
Date: Tue,  7 Mar 2017 22:12:56 +0200
Message-Id: <20170307201308.66814-6-tkusumi@tuxera.com>
In-Reply-To: <20170307201308.66814-1-tkusumi@tuxera.com>
References: <20170307201308.66814-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This should be %s.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/filesetup.c b/filesetup.c
index edc56a3..ae7f817 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -693,7 +693,7 @@ static int get_file_sizes(struct thread_data *td)
 	int err = 0;
 
 	for_each_file(td, f, i) {
-		dprint(FD_FILE, "get file size for %p/%d/%p\n", f, i,
+		dprint(FD_FILE, "get file size for %p/%d/%s\n", f, i,
 								f->file_name);
 
 		if (td_io_get_file_size(td, f)) {
-- 
2.9.3


