Return-Path: <fio-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:49598 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325AbaGDAXA convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 3 Jul 2014 20:23:00 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: lots of closes causing lots of invalidates while running
Date: Fri, 4 Jul 2014 00:20:19 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B83482@G9W0745.americas.hpqcorp.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: "dgilbert@interlog.com" <dgilbert@interlog.com>

Doug Gilbert noticed while running fio to scsi_debug devices
with the scsi-mq.2 tree that it is generating frequent ioctl 
calls (e.g., 35 times per second on my system):

[ 1324.777541] sd 5:0:0:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[ 1324.782543] sd 5:0:4:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[ 1324.800988] sd 5:0:4:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[ 1324.802529] sd 5:0:2:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[ 1324.805116] sd 5:0:5:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[ 1324.811526] sd 5:0:1:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]
[ 1324.813527] sd 5:0:2:0: scsi_debug_ioctl: BLKFLSBUF [0x1261]

They come from fio's invalidate option.

Although the man page says:
       invalidate=bool
              Invalidate buffer-cache for the file prior 
		to starting I/O.  Default: true.

the invalidations are happen on many io_units, not just once 
at startup.  Setting invalidate=0 makes them go away.  However, 
the root cause is a bunch of closes.

This is the call chain (fio-2.1.10-22-g5eba):
do_io
get_io_u /* Return an io_u to be processed. Gets a buflen and offset, sets direction */
set_io_u_file
get_next_file
__get_next_file
get_next_file_rand
td_io_open_file
file_invalidate_cache
__file_invalidate_cache
blockdev_invalidate_cache
	return ioctl(f->fd, BLKFLSBUF);

which causes the linux block layer to run fsync_bdev and 
invalidate_bdev.

The device/file keeps getting closed by backend.c thread_main 
in this loop:
        while (keep_running(td)) {
		...
                if (clear_state)
                        clear_io_state(td);
		...
                if (... 
                else
                        verify_bytes = do_io(td);

               clear_state = 1;
		...
	}

via this call chain:
clear_io_state
close_files
td_io_close_file 

so it keeps having to reopen the file, and asks for a flush 
each time.

Are those clear_io_state/close_files calls really intended?


fio script:
[global]
direct=1
ioengine=libaio
norandommap
randrepeat=0
bs=4096
iodepth=96
numjobs=6
runtime=216000
time_based=1
group_reporting
thread
gtod_reduce=1
iodepth_batch=16
iodepth_batch_complete=16
cpus_allowed=0-5
cpus_allowed_policy=split
rw=randread

[4_KiB_RR_drive_ah]
filename=/dev/sdah

---
Rob Elliott    HP Server Storage


