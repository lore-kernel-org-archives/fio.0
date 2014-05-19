Return-Path: <xanpeng@gmail.com>
MIME-Version: 1.0
Date: Tue, 20 May 2014 01:38:03 +0800
Message-ID: <CA+8ZFngfLhzUopzPznyQ-ZwZgqMuDiEPhUpK5c20HkWNe0nz6w@mail.gmail.com>
Subject: Fix a bug of rbd engine when specify invalidate=1 or fadvise_hint=1
From: "xan.peng" <xanpeng@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>, daniel.gollub@gmail.com, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

When specify invalidate=1 or fadvise_hint=1, fio will call
posix_fadvise(2), which will return -EBADF and prevent fio librbd
engine acting normally.
Here is the call path: ... > td_io_open_file() >
file_invalidate_cache() > __file_invalidate_cache() > posix_fadvise(fd
= -1) > ...

The patch work-around this problem by setting file type to
FIO_TYPE_CHAR in fio_rbd_open().

Here the GitHub pull request: https://github.com/axboe/fio/pull/11.

Signed-off-by: Xan Peng xanpeng@gmail.com
---
diff --git a/engines/rbd.c b/engines/rbd.c
index dc6e7db..f5f7a06 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -401,6 +401,16 @@ cleanup:

 static int fio_rbd_open(struct thread_data *td, struct fio_file *f)
 {
+       /*
+        * This is to work-around mandatory setting of "invalidate=0".
+        *
+        * As files used in rbd engine is artificial (fd equals -1), with
+        * "invalidte=1" or "fadvise_hint=1" set, fio will call posix_fadvise(2)
+        * and EBADF will be returned.
+        *
+        * Set file type to FIO_TYPE_CHAR will work-around call of
posix_fadvise(2).
+        */
+       f->filetype = FIO_TYPE_CHAR;
        return 0;
 }

diff --git a/examples/rbd.fio b/examples/rbd.fio
index fcb494a..aa34a99 100644
--- a/examples/rbd.fio
+++ b/examples/rbd.fio
@@ -15,7 +15,8 @@ ioengine=rbd
 clientname=admin
 pool=rbd
 rbdname=fio_test
-invalidate=0   # mandatory
+invalidate=0   # not mandatory, but set to 1 with no effect
+fadvise_hint=0 # not mandatory, but set to 1 with no effect
 rw=randwrite
 bs=4k

