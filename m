Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 12/17] Don't set FIO_FILE_extend when create_on_open= option is set
Date: Tue,  7 Mar 2017 22:13:03 +0200
Message-Id: <20170307201308.66814-13-tkusumi@tuxera.com>
In-Reply-To: <20170307201308.66814-1-tkusumi@tuxera.com>
References: <20170307201308.66814-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

FIO_FILE_extend gets set and later cleared only when create_on_open=
is disabled (which is default). If create_on_open=1 is set this flag
could be set for the entire runtime, but this flag is basically
designed to be enabled only during setup time.

(If there's no "Layint out IO file..." message, both FIO_FILE_extend
and need_extend probably aren't even needed, as files can be extended
at the moment when these flag/variable are set)

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/filesetup.c b/filesetup.c
index fab9c5d..f42f5d8 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -966,9 +966,9 @@ int setup_files(struct thread_data *td)
 			if (!o->create_on_open) {
 				need_extend++;
 				extend_size += (f->io_size + f->file_offset);
+				fio_file_set_extend(f);
 			} else
 				f->real_file_size = f->io_size + f->file_offset;
-			fio_file_set_extend(f);
 		}
 	}
 
-- 
2.9.3


