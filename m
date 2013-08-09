Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758614Ab3HISVA (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 9 Aug 2013 14:21:00 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r79IL0DT002533
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <fio@vger.kernel.org>; Fri, 9 Aug 2013 14:21:00 -0400
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r79IKxRc019237
	for <fio@vger.kernel.org>; Fri, 9 Aug 2013 14:20:59 -0400
From: Jeff Moyer <jmoyer@redhat.com>
Subject: fio verify will actually punch a hole in a file
Date: Fri, 09 Aug 2013 14:20:59 -0400
Message-ID: <x49y58a3eus.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi, Jens, all,

Our QE team noticed fio failures on recent kernels.  I simplified the
job file to the following:

[global]
name=fio-mmap
rw=write
bs=4K
direct=1
end_fsync=1
verify=crc32

[file3]
size=100M
ioengine=mmap
mem=malloc
direct=1

After fio completes (and returns verify errors), the file is completely
full of zeroes.

Here is what the verify logic is doing:

static void do_verify(struct thread_data *td, uint64_t verify_bytes)
{
...
        /*
         * sync io first and invalidate cache, to make sure we really
         * read from disk.
         */
        for_each_file(td, f, i) {
                if (!fio_file_open(f))
                        continue;
                if (fio_io_sync(td, f))
                        break;
                if (file_invalidate_cache(td, f)) <--------
                        break;
        }

That invalidate cache call looks like so:

static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
                                   unsigned long long off,
                                   unsigned long long len)
{
...
        /*
         * FIXME: add blockdev flushing too
         */
        if (f->mmap_ptr) {
                ret = posix_madvise(f->mmap_ptr, f->mmap_sz, POSIX_MADV_DONTNEED);
#ifdef FIO_MADV_FREE
                (void) posix_madvise(f->mmap_ptr, f->mmap_sz, FIO_MADV_FREE); <-------
#endif

FIO_MADV_FREE can be defined as MADV_REMOVE, which will actually punch a
hole in the file (a hole the size of the entire file, btw).  Of course,
unallocated blocks are returned as zeroes by the file system, so that
explains that!

Jens, I'm sure you can take it from here.  ;-)  If you want to see the
strace logs I've collected, or any other information, let me know.

Cheers,
Jeff


