Return-Path: <fio-owner@vger.kernel.org>
Received: from gate1.sios.com ([221.241.189.195]:45789 "EHLO
	tenpost3.dc1.sios.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751790AbbAGDiT (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 6 Jan 2015 22:38:19 -0500
Received: from tenisvw (tenisvw.dc1.sios.com [10.20.0.16])
	by tenpost4.dc1.sios.com (Postfix) with ESMTP id 8694F2360061
	for <fio@vger.kernel.org>; Wed,  7 Jan 2015 12:30:36 +0900 (JST)
Received: from mail-qa0-f48.google.com (mail-qa0-f48.google.com [209.85.216.48])
	by tenpost3.dc1.sios.com (Postfix) with ESMTP id 230082360061
	for <fio@vger.kernel.org>; Wed,  7 Jan 2015 12:30:36 +0900 (JST)
Received: by mail-qa0-f48.google.com with SMTP id k15so1198236qaq.7
        for <fio@vger.kernel.org>; Tue, 06 Jan 2015 19:30:35 -0800 (PST)
MIME-Version: 1.0
From: Yoshinori Sato <yo-satoh@sios.com>
Date: Wed, 7 Jan 2015 12:30:15 +0900
Message-ID: <CAL_XjKXUkmDm2kVn3b-PEuRjFP9gyx6hCorVADkUAcfcYM4=BA@mail.gmail.com>
Subject: [PATCH] mmap backend broken
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Program received signal SIGSEGV, Segmentation fault.
0x00000000004345c2 in fio_mmapio_invalidate (td=0x7fffeed6e790,
    f=0x7ffff75dc3d0) at engines/mmap.c:260
warning: Source file is more recent than executable.
260 static struct ioengine_ops ioengine = {
(gdb) bt
#0  0x00000000004345c2 in fio_mmapio_invalidate (td=0x7fffeed6e790,
    f=0x7ffff75dc3d0) at engines/mmap.c:260
#1  0x000000000041b1da in __file_invalidate_cache (td=0x7fffeed6e790,
    f=0x7ffff75dc3d0, off=0, len=1456128) at filesetup.c:402
#2  0x000000000041c465 in setup_files (td=0x7fffeed6e790) at filesetup.c:924
#3  0x0000000000443d7a in run_threads () at backend.c:1892
#4  fio_backend () at backend.c:2197
#5  0x0000003506a1ed1d in __libc_start_main (main=0x453980 <main>, argc=2,
    ubp_av=0x7fffffffe228, init=<value optimized out>,
    fini=<value optimized out>, rtld_fini=<value optimized out>,
    stack_end=0x7fffffffe218) at libc-start.c:226
#6  0x000000000040aa19 in _start ()

madvice before mmap. moved later.

Signed-off-by Yoshinori Sato <yo-satoh@sios.com>
---
 engines/mmap.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/engines/mmap.c b/engines/mmap.c
index 8bcd42c..69add78 100644
--- a/engines/mmap.c
+++ b/engines/mmap.c
@@ -62,6 +62,16 @@ static int fio_mmap_file(struct thread_data *td,
struct fio_file *f,
  goto err;
  }
  }
+ if (posix_madvise(fmd->mmap_ptr, length, POSIX_MADV_DONTNEED) < 0) {
+ td_verror(td, errno, "madvise");
+ goto err;
+ }
+
+#ifdef FIO_MADV_FREE
+ if (f->filetype == FIO_TYPE_BD)
+ (void) posix_madvise(fmd->mmap_ptr, fmd->mmap_sz, FIO_MADV_FREE);
+#endif
+

 err:
  if (td->error && fmd->mmap_ptr)
@@ -252,20 +262,6 @@ static int fio_mmapio_close_file(struct
thread_data *td, struct fio_file *f)
  return generic_close_file(td, f);
 }

-static int fio_mmapio_invalidate(struct thread_data *td, struct fio_file *f)
-{
- struct fio_mmap_data *fmd = FILE_ENG_DATA(f);
- int ret;
-
- ret = posix_madvise(fmd->mmap_ptr, fmd->mmap_sz, POSIX_MADV_DONTNEED);
-#ifdef FIO_MADV_FREE
- if (f->filetype == FIO_TYPE_BD)
- (void) posix_madvise(fmd->mmap_ptr, fmd->mmap_sz, FIO_MADV_FREE);
-#endif
-
- return ret;
-}
-
 static struct ioengine_ops ioengine = {
  .name = "mmap",
  .version = FIO_IOOPS_VERSION,
@@ -274,7 +270,6 @@ static struct ioengine_ops ioengine = {
  .queue = fio_mmapio_queue,
  .open_file = fio_mmapio_open_file,
  .close_file = fio_mmapio_close_file,
- .invalidate = fio_mmapio_invalidate,
  .get_file_size = generic_get_file_size,
  .flags = FIO_SYNCIO | FIO_NOEXTEND,
 };
-- 
1.7.12.4
