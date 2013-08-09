Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45379 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030485Ab3HIS5v (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 9 Aug 2013 14:57:51 -0400
Date: Fri, 9 Aug 2013 12:57:48 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: fio verify will actually punch a hole in a file
Message-ID: <20130809185748.GB6629@kernel.dk>
References: <x49y58a3eus.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49y58a3eus.fsf@segfault.boston.devel.redhat.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: fio@vger.kernel.org

On Fri, Aug 09 2013, Jeff Moyer wrote:
> Hi, Jens, all,
> 
> Our QE team noticed fio failures on recent kernels.  I simplified the
> job file to the following:
> 
> [global]
> name=fio-mmap
> rw=write
> bs=4K
> direct=1
> end_fsync=1
> verify=crc32
> 
> [file3]
> size=100M
> ioengine=mmap
> mem=malloc
> direct=1
> 
> After fio completes (and returns verify errors), the file is completely
> full of zeroes.
> 
> Here is what the verify logic is doing:
> 
> static void do_verify(struct thread_data *td, uint64_t verify_bytes)
> {
> ...
>         /*
>          * sync io first and invalidate cache, to make sure we really
>          * read from disk.
>          */
>         for_each_file(td, f, i) {
>                 if (!fio_file_open(f))
>                         continue;
>                 if (fio_io_sync(td, f))
>                         break;
>                 if (file_invalidate_cache(td, f)) <--------
>                         break;
>         }
> 
> That invalidate cache call looks like so:
> 
> static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
>                                    unsigned long long off,
>                                    unsigned long long len)
> {
> ...
>         /*
>          * FIXME: add blockdev flushing too
>          */
>         if (f->mmap_ptr) {
>                 ret = posix_madvise(f->mmap_ptr, f->mmap_sz, POSIX_MADV_DONTNEED);
> #ifdef FIO_MADV_FREE
>                 (void) posix_madvise(f->mmap_ptr, f->mmap_sz, FIO_MADV_FREE); <-------
> #endif
> 
> FIO_MADV_FREE can be defined as MADV_REMOVE, which will actually punch a
> hole in the file (a hole the size of the entire file, btw).  Of course,
> unallocated blocks are returned as zeroes by the file system, so that
> explains that!
> 
> Jens, I'm sure you can take it from here.  ;-)  If you want to see the
> strace logs I've collected, or any other information, let me know.

Hah, yeah that's not great. The below should ensure that we only do this
for blockdevices, though I haven't checked whether it's even needed
there. At least it removes the problem with doing it on files and
punching holes. Are we mapping MADV_FREE to trim yet? :-)

Alternatively, it should just be killed. I don't want it punching holes,
nor trimming.


diff --git a/filesetup.c b/filesetup.c
index 6427f3e..7d3a061 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -388,7 +388,8 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 	if (f->mmap_ptr) {
 		ret = posix_madvise(f->mmap_ptr, f->mmap_sz, POSIX_MADV_DONTNEED);
 #ifdef FIO_MADV_FREE
-		(void) posix_madvise(f->mmap_ptr, f->mmap_sz, FIO_MADV_FREE);
+		if (f->filetype == FIO_TYPE_BD)
+			(void) posix_madvise(f->mmap_ptr, f->mmap_sz, FIO_MADV_FREE);
 #endif
 	} else if (f->filetype == FIO_TYPE_FILE) {
 		ret = posix_fadvise(f->fd, off, len, POSIX_FADV_DONTNEED);

-- 
Jens Axboe

