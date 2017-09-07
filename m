Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 7 Sep 2017 07:35:50 +0100
Message-ID: <CALjAwxgccGY6rvxqWQgtF8Mn0hp9V56Wch51_1Q+WbwuyvnkwQ@mail.gmail.com>
Subject: madvise and FIO_MADV_FREE
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi,

I've just been looking at the following in engines/mmap.c:
 69 #ifdef FIO_MADV_FREE
 70         if (f->filetype == FIO_TYPE_BLOCK)
 71                 (void) posix_madvise(fmd->mmap_ptr, fmd->mmap_sz,
FIO_MADV_FREE);
 72 #endif

I'm wondering about the rationale. On Linux FIO_MADV_FREE maps to
MADV_REMOVE which worryingly has this to say (from
http://man7.org/linux/man-pages/man2/madvise.2.html ):
"MADV_REMOVE (since Linux 2.6.16)

              Free up a given range of pages and its associated backing
              store.  This is equivalent to punching a hole in the
              corresponding byte range of the backing store (see
              fallocate(2)). [...]"

So it's basically saying "this does a TRIM operation".
https://github.com/axboe/fio/commit/3e10fb832645e3ab3ef006f589f0459dc567cb53
added the guard for only block devices because it was noticed that the
posix_madvise call was punching holes but nonetheless do we still want
to keep it for block devices. Things get even tricker on other
platforms. On Solaris FIO_MADV_FREE maps to MADV_FREE and the man page
from https://docs.oracle.com/cd/E36784_01/html/E36874/madvise-3c.html
says this:

"MADV_FREE

Tell the kernel that contents in the specified address range are no
longer important and the range will be overwritten. [...]

This value cannot be used on mappings that have underlying file objects."

So we really shouldn't be making this call on that platform. If you
look at Linux's implementation of MADV_FREE it says this:

MADV_FREE (since Linux 4.5)

[...]

The MADV_FREE operation can be applied only to private
              anonymous pages (see mmap(2)). [...]

which seems to back up the warning it shouldn't be used with backing files.

For the record this piece of code seems to have arrived with
https://github.com/axboe/fio/commit/a1c58075279454a91ec43366846b93e8dcf9753c
("Add strong madvise() hint for cache pruning"). Would a patch just
removing it be sensible?

-- 
Sitsofe | http://sucs.org/~sits/

