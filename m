Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 30 Dec 2017 17:56:33 +0000
Message-ID: <CALjAwxh+0x55c=Erok51RFD7YmnwxPeV1TFcAbYW8pD6xw66VA@mail.gmail.com>
Subject: madvise(,, FIO_MADV_FREE) behaviour in mmap.c
Content-Type: text/plain; charset="UTF-8"
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi,

Over on https://github.com/axboe/fio/blob/df4bf1178ed773986129da6038961388af926971/engines/mmap.c#L71
there is the following:
 30 static int fio_mmap_file(struct thread_data *td, struct fio_file *f,
 31                          size_t length, off_t off)
 32 {
[...]
 69 #ifdef FIO_MADV_FREE
 70         if (f->filetype == FIO_TYPE_BLOCK)
 71                 (void) posix_madvise(fmd->mmap_ptr, fmd->mmap_sz,
FIO_MADV_FREE);
 72 #endif

On Linux, FIO_MADV_FREE is defined as MADV_REMOVE. My understanding is
that MADV_REMOVE will turn into a hole punch when used on files and
this was the problem reported over on
https://www.spinics.net/lists/fio/msg02324.html ("fio verify will
actually punch a hole in a file"). However it looks like block devices
have picked up support for fallocate punching and can issue
blkdev_issue_zeroout() in response to it so while the above will
invalidate the cached regions it looks like it could also end up
generating writes of zero (or trims)...

If my reading above is correct then it looks like the best that you
could define FIO_MADV_FREE to is MADV_FREE if it exists but even then
is it needed? An madvise(,, MADV_DONTNEED) is done a few lines prior
which will throw away away mmaped pages (dirty or clean) and isn't
cache invalidation handled elsewhere in fio anyway for normal files?

A secondary point is that POSIX doesn't actually define MADV_FREE (or
MADV_REMOVE) for posix_madvise() so strictly speaking that
posix_madvise() call should just be madvise() which should be OK as
it's behind and ifdef guard.

FWIW it looks like this change originally landed with
https://github.com/axboe/fio/commit/a1c58075279454a91ec43366846b93e8dcf9753c
("Add strong madvise() hint for cache pruning") and has jumped around
a bit to it's current location.

-- 
Sitsofe | http://sucs.org/~sits/

