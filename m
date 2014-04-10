Return-Path: <axboe@kernel.dk>
Message-ID: <5346A3FE.10106@kernel.dk>
Date: Thu, 10 Apr 2014 08:00:30 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio on AIX - fallocate error
References: <E2B4022DB0264A4B90C5F1B01B8E677D733225E0@LIVP3MMBX13.mail.aig.net>
In-Reply-To: <E2B4022DB0264A4B90C5F1B01B8E677D733225E0@LIVP3MMBX13.mail.aig.net>
Content-Type: multipart/mixed;
 boundary="------------040409050909070801080403"
To: "Carino, Mario" <Mario.Carino@AIG.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------040409050909070801080403
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 2014-04-09 20:52, Carino, Mario wrote:
> Hi.
> We're trying to run fio 2.1.7 on AIX 6 and we can't seem to eliminate these errors:
>
> fio: posix_fallocate fails: Invalid argument

This one you can ignore, or you can get rid of it by adding:

fallocate=none

to the job file.

> fio: pid=0, err=22/file:filesetup.c:418, func=invalidate_cache, error=Invalid argument

Fio should probably just ignore these flush-cache warnings and continue 
on, it's not really a fatal condition. I have attached a patch for you, 
can you apply that and give it a go?

> we always get one or the other. It doesn't matter too much what command we run,
> what options,  etc. We saw a web page which indicates that fio requires an
> Asynch IO package to be installed and running on AIX. Is that correct? We're
 > trying to find out if we have it installed on our test box.

You'd get a different error if that was your issue.

> (We're lowly non-root
 > DBA's so getting anything done requires a committee.)

Isn't that always the case with AIX? :-)

-- 
Jens Axboe


--------------040409050909070801080403
Content-Type: text/x-patch;
 name="fio-make-cache-flush-just-warn.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fio-make-cache-flush-just-warn.patch"

diff --git a/filesetup.c b/filesetup.c
index abea1e60b726..e1e48203f660 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -395,9 +395,6 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 	dprint(FD_IO, "invalidate cache %s: %llu/%llu\n", f->file_name, off,
 								len);
 
-	/*
-	 * FIXME: add blockdev flushing too
-	 */
 	if (f->mmap_ptr) {
 		ret = posix_madvise(f->mmap_ptr, f->mmap_sz, POSIX_MADV_DONTNEED);
 #ifdef FIO_MADV_FREE
@@ -419,6 +416,11 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 	} else if (f->filetype == FIO_TYPE_CHAR || f->filetype == FIO_TYPE_PIPE)
 		ret = 0;
 
+	if (ret) {
+		log_info("fio: cache flush failed: %s\n", strerror(errno));
+		ret = 0;
+	}
+
 	if (ret < 0) {
 		td_verror(td, errno, "invalidate_cache");
 		return 1;
@@ -427,7 +429,7 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 		return 1;
 	}
 
-	return ret;
+	return 0;
 
 }
 

--------------040409050909070801080403--

