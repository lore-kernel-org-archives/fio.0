Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 5/7] Fix a comment after f227e2b6
Date: Mon, 20 Mar 2017 23:28:45 +0200
Message-Id: <20170320212847.71404-5-tkusumi@tuxera.com>
In-Reply-To: <20170320212847.71404-1-tkusumi@tuxera.com>
References: <20170320212847.71404-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Add "for regular files" since it's true only on regfiles.
Also see below.
http://www.spinics.net/lists/fio/msg05646.html

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/filesetup.c b/filesetup.c
index c9f2b5f..bcf95bd 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -932,10 +932,11 @@ int setup_files(struct thread_data *td)
 			}
 
 			/*
-			 * We normally don't come here, but if the result is 0,
-			 * set it to the real file size. This could be size of
-			 * the existing one if it already exists, but otherwise
-			 * will be set to 0. A new file won't be created because
+			 * We normally don't come here for regular files, but
+			 * if the result is 0 for a regular file, set it to the
+			 * real file size. This could be size of the existing
+			 * one if it already exists, but otherwise will be set
+			 * to 0. A new file won't be created because
 			 * ->io_size + ->file_offset equals ->real_file_size.
 			 */
 			if (!f->io_size) {
-- 
2.9.3


