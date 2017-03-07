Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 06/17] Fixup for a minor 0 byte file size case
Date: Tue,  7 Mar 2017 22:12:57 +0200
Message-Id: <20170307201308.66814-7-tkusumi@tuxera.com>
In-Reply-To: <20170307201308.66814-1-tkusumi@tuxera.com>
References: <20170307201308.66814-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

When a file size calculated by (size / nrfiles) happens to be 0 in
setup_files(), it simply sets ->file_size to ->real_file_size which
means the size is set to the existing file size (if any) or 0.

Add log_info() to show that it's been set that way, and also 0 byte
file isn't likely to be created in the first place. Also add a check
to avoid negative file size.

This usually doesn't happen unless one tries to make it happen by
for e.g. using a small size= and large nrfiles= options.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO       |  2 +-
 filesetup.c | 21 ++++++++++++++++++---
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/HOWTO b/HOWTO
index 04752d5..018800a 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1513,7 +1513,7 @@ I/O size
 	Fio will divide this size between the available files determined by options
 	such as :option:`nrfiles`, :option:`filename`, unless :option:`filesize` is
 	specified by the job. If the result of division happens to be 0, the size is
-	set to the physical size of the given files or devices.
+	set to the physical size of the given files or devices if they exist.
 	If this option is not specified, fio will use the full size of the given
 	files or devices.  If the files do not exist, size must be given. It is also
 	possible to give size as a percentage between 1 and 100. If ``size=20%`` is
diff --git a/filesetup.c b/filesetup.c
index ae7f817..9388bfc 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -904,8 +904,7 @@ int setup_files(struct thread_data *td)
 		if (!o->file_size_low) {
 			/*
 			 * no file size or range given, file size is equal to
-			 * total size divided by number of files. If that is
-			 * zero, set it to the real file size. If the size
+			 * total size divided by number of files. If the size
 			 * doesn't divide nicely with the min blocksize,
 			 * make the first files bigger.
 			 */
@@ -915,8 +914,24 @@ int setup_files(struct thread_data *td)
 				f->io_size += bs;
 			}
 
-			if (!f->io_size)
+			/*
+			 * We normally don't come here, but if the result is 0,
+			 * set it to the real file size. This could be size of
+			 * the existing one if it already exists, but otherwise
+			 * will be set to 0. A new file won't be created because
+			 * ->io_size + ->file_offset equals ->real_file_size.
+			 */
+			if (!f->io_size) {
+				if (f->file_offset > f->real_file_size)
+					goto err_offset;
 				f->io_size = f->real_file_size - f->file_offset;
+				log_info("fio: forcing file %s size to %llu\n",
+					f->file_name,
+					(unsigned long long)f->io_size);
+				if (!f->io_size)
+					log_info("fio: file %s may be ignored\n",
+						f->file_name);
+			}
 		} else if (f->real_file_size < o->file_size_low ||
 			   f->real_file_size > o->file_size_high) {
 			if (f->file_offset > o->file_size_low)
-- 
2.9.3


