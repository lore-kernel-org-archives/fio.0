Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:42990 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab2LFVGw (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 6 Dec 2012 16:06:52 -0500
Message-ID: <50C108E9.4050408@kernel.dk>
Date: Thu, 06 Dec 2012 22:06:49 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio --direct=1 and Linux page cache effects
References: <6e624hcpo4.fsf@just-testing.permabit.com>
In-Reply-To: <6e624hcpo4.fsf@just-testing.permabit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Ken Raeburn <raeburn@permabit.com>
Cc: fio@vger.kernel.org

On 2012-12-05 01:23, Ken Raeburn wrote:
> 
> (tl;dr summary: Sometimes the Linux page cache slows down fio --direct=1
> tests despite the direct I/O, and whether or not it happens appears to
> depend on a race condition involving multiple fio job threads and udev, as
> well as a quirk of Linux page-cache behavior. As a performance testing
> program, it should be consistent.)
> 
> We've been running some fio tests against a Linux device-mapper driver
> we're working on, and we've found a curious bimodal distribution of
> performance values with "fio --direct=1 --rw=randwrite --ioengine=libaio
> --numjobs=2 --thread --norandommap ..." directly to the device, on the 3.2
> kernel (using the Debian "Squeeze" distro).
> 
> One of our developers found that in the "slow" cases, the kernel is
> spending more time in __lookup in the kernel radix tree library (used by
> the page cache) than in the "fast" cases, even though we're using direct
> I/O.
> 
> After digging into the fio and kernel code a while, and sacrificing a
> couple chickens at the altar of SystemTap [1], this is my current
> understanding of the situation:
> 
> During the do_io call, the target file (in my case, a block device) is
> opened by each "job" thread. There's a hash table keyed by filename. In
> most runs, a job thread either will find the filename in the hash already,
> or will not find it and after opening the file will add an entry to the
> hash table.
> 
> Once in a while, though, a thread will not find the filename in the hash
> table, but after it opens the file and tries to update the hash table, it
> finds the filename is now present, thanks to the other job thread. This
> causes the generic_open_file code to close the file and try again, this
> next time finding the filename in the hash table.
> 
> However, the closing of a file opened with read/write access triggers udev
> to run blkid and sometimes udisks-part-id. These run quickly, but open and
> read the device without using O_DIRECT. This causes some pages (about 25)
> to be inserted into the page cache, and the page count in the file's
> associated mapping structure is incremented. Those entries are only
> discarded when the individual pages are overwritten (unlikely to happen
> for all the pages under randwrite and norandommap unless we write far more
> than the device size), or all at once when the open-handle count on the
> file goes to zero (which won't be until the test finishes), or memory
> pressure gets too high, etc.
> 
> As fio runs its test, the kernel function generic_file_direct_write is
> called, and if page cache mappings exist (mapping->nrpages > 0), it calls
> into the page cache code to invalidate any mappings associated with the
> pages being written. On our test machines, the cost seems to be on the
> microsecond scale per invalidation call, but it adds up; at 1GB/s using
> 4KB pages, for example, we would invalidate 256K pages per second.
> 
> 
> For an easy-to-describe example that highlights the problem, I tested with
> the device-mapper dm-zero module (dmsetup create zzz --table "0
> 4000000000000 zero"; fio --filename=/dev/mapper/zzz ...) which involves no
> external I/O hardware, to see what just the kernel's behavior is. This
> device ignores data on writing and zero-fills on read, just like
> /dev/zero, except it's a block device and thus can interact with the page
> cache.
> 
> I did a set of runs with a 4KB block size[2], and got upwards of 3800MB/s
> when the race condition didn't trigger; the few times when it did, the
> write rate was under 2400MB/s, a drop of over 35%. (Since that's with two
> threads, the individual threads are doing 1900MB/s vs 1200MB/s, or
> 2.2us/block vs 3.4us/block.) A couple of 10x larger test runs got similar
> results, though both fast and slow "modes" were a little bit faster.
> 
> With a 1MB block size, fewer invalidation calls happened but they operated
> on larger ranges of addresses in each call, and the difference was down
> around 2%. The results were in two very tightly grouped clusters, though,
> so the 2% isn't just random run-to-run variance.
> 
> Why each invalidation call should be that expensive with so few pages
> mapped, I don't know, but it appears to be costly, if you've got a device
> that should get GB/s-range performance. (There may be lock contention
> issues exacerbating the problem, since the mapping is shared.)
> 
> Not using --norandommap seems to consistently avoid the problem, probably
> because it calls smalloc in each thread, which allocates and clears the
> random-map memory while holding a global lock; that may stagger processing
> in the threads enough to avoid the race most of the time, but probably
> doesn't guarantee it. Using one job, or not using --thread, would avoid
> the problem because there wouldn't be two threads competing over one
> instance of the hash table.
> 
> I have a few ideas to try to make the behavior more consistent. I tried
> using a global lock in filesetup.c:generic_file_open for file opening and
> hash table updating; it seems to eliminate the "slow" results, but it
> seems rather hackish, so I'm still looking at how to fix the issue.
> 
> (Thanks to Michael Sclafani at Permabit for his help in digging into
> this.)
> 
> Oh yes: I'm also seeing another blkid run triggered at the start of the
> fio invocation, I believe caused by opening and closing the device in
> order to ascertain its size. There's a delay of 0.1s or so before the
> actual test starts, which seems to be long enough for blkid to complete,
> but I don't see anything that ensures that it actually has completed.
> There may be another difficult-to-hit race condition there.
> 
> Ken
> 
> [1] I log calls to __blkdev_get, __blkdev_put, blkdev_close, blkdev_open
> for the target device with process ids and names, and bdev->bd_openers
> values, and periodically report mapping->nrpages with the saved
> filp->f_mapping value from blkdev_open, so I can see when the blkid and
> fio open/close sequences overlap, and when page cache mappings are
> retained. The script is available at http://pastebin.com/gM3kURHp for now.
> 
> [2] My full command line, including some irrelevant options inherited from
> our original test case: .../fio --bs=4096 --rw=randwrite
> --name=generic_job_name --filename=/dev/mapper/zzz --numjobs=2
> --size=26843545600 --thread --norandommap --group_reporting
> --gtod_reduce=1 --unlink=0 --direct=1 --rwmixread=70 --iodepth=1024
> --iodepth_batch_complete=16 --iodepth_batch_submit=16 --ioengine=libaio
> --scramble_buffers=1 --offset=0 --offset_increment=53687091200

Thanks for this nice analysis! For most workloads, adding a global lock
for the duration of the file open is not an issue. So while it seems
like a hack, I don't necessarily think it's a bad solution to the issue.

This isn't the first time where blkid has caused confusing behaviour or
issues for folks. Another approach would be to just disable this
behaviour in the system. But it'd be better if fio could eliminate any
side effects of it at least, as the bi-modal behaviour can be extremely
annoying to find and diagnose (as I'm sure you found above too).

In other words, let me know if you find a great solution for this. If
not, I think we should just do the global file open lock for now.

-- 
Jens Axboe

