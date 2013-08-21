Return-Path: <jcasse@google.com>
MIME-Version: 1.0
Sender: jcasse@google.com
Date: Wed, 21 Aug 2013 15:02:40 -0700
Message-ID: <CAPet_20pVqmeXS2YeB9dXnwwira3=RTqS1r4MLvxDNJuRuEHsA@mail.gmail.com>
Subject: Data Integrity Test with fio
From: Juan Casse <jcasse@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: grundler@chromium.org
List-ID: <fio@vger.kernel.org>

Hi Jens:

I wanted to let you know what we intend to do in advance in case you
can foresee any problems or have any preferences.

We would like fio to test for data integrity/retention as follows.

Phase 1: Write data to storage device
Run fio with a job file specifying the following options.
readwrite=
 - randwrite
   (does random writes)
 - randrw
   (does random reads and writes)
size=64k or any other size
(specifies the total amount of data that will be written/read)
bs=8192 or any other size
(specifies the size of each data block)
runtime=1 or any other number of seconds
(specifies the duration of the fio run)
time_based
(tells fio to run based on time rather than iops.)
verify=meta
(adds block number, numberio and timestamp to the block header)
verify_pattern=0xffffffffffffffff or any other pattern
(fills the rest of the block with the specified pattern)
verify_dump=1
(writes to a file the data read from disk and the data that was
expected, in case of data corruption)
continue_on_error=verify
(allows fio to continue even if corrupted blocks are found, otherwise
fio will stop execution on the first corrupted block)
random_generator=lfsr
(use lfsr as the random number generator)

Phase 2: Verify data
(Recall that we mentioned adding a "generation" number to the block
header data? Well, we think we can use the existing numberio instead.)
Run fio with the same options as before plus specifying a new option:
 - data_integrity_check
(I already modified the code to accept this option).
When this option is given in the job file, fio will "replay" the
workload (without actually writing data to storage). Once we have done
this, we can read each block back and compare its numberio with the
one obtained by running lfsr in reverse. We run lfsr in reverse
because the numberio that was last written to a block will be found
toward the end of the lfsr sequence when the data is written multiple
times, which is what we want.

The numberio is incremented each time we read or write, so it can
easily be computed going backwards by decrementing its value.

How is the block offset computed from the lfsr? Do you see any
problems trying to compute the offset going backwards with the lfsr?

One way to perform the data integrity check is to verify each block in
order of block number (offset). For each block number, run the lfsr
backwards starting from the end until we hit the block number. We then
compare the numberio obtained by running the lfsr backwards with the
one read from storage.

Any concerns with this?

In the fio code, the function do_io() performs the workload specified,
whether it be writes, reads and writes, or just reads.
The function do_verify() is executed after do_io() only when the
workload does any writes. If the workload does only reads, do_verify()
is not executed. This function reads the blocks back and compares the
offset (block number). I already have code in place that checks for
numberio as well.

However, if the job file specifies to run based on time rather than
total number of bytes (setting runtime= and time_based), then
do_verify() is not performed. We would also need to run do_verify() in
this case to make sure that the correct data was indeed written to
storage.
Note: fio needs to be run based on time if we want numberio
incremented when a block is rewritten. If we set fio to run a number
of iterations instead (by specifying loops=int), the same numberio
will be written every time the block is rewritten.

Thanks,
Juan

