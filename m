Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2-int.auckland.ac.nz ([130.216.12.41]:25754 "EHLO
	mx2-int.auckland.ac.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab0I3DKB (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 29 Sep 2010 23:10:01 -0400
Received: by yxp4 with SMTP id 4so482998yxp.19
        for <fio@vger.kernel.org>; Wed, 29 Sep 2010 19:57:59 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 30 Sep 2010 15:57:59 +1300
Message-ID: <AANLkTinEQRcw8ZD6_fYZxodaRiOYda6uYLEf6aenKrXq@mail.gmail.com>
Subject: possible fio bug, file not found in hash, cannot open file
From: DongJin Lee <dongjin.lee@auckland.ac.nz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi all.

System: ubuntu 10.04 x32 and x64

I'm trying to use xtreemfs (distributed file system), which I got it
successfully mounted (it uses fusermount, current version I have is
2.8.1),
so I can write, read, (including gnome drap drog, etc) and do some
file benchmarks using dbench (testing windows file server) to that
mounted directory, without any problems.
Also, I've used iozone benchmark without a problem, so it appears that
the filesystem works fine.

However, when I tried to run fio (including the latest version
1.44-rc1), I keep getting an 'Invalid argument error', I have no idea
because this does not happen on other file systems, (e.g., nfs, etc)
I think the error occurs somewhere getting the file information..

randread: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
Starting 1 process
fio: pid=12627, err=22/file:filesetup.c:493,
func=open(/media/xtreemfs/afile), error=Invalid argument


So I've ran the --debug=all , and it appears that files are not found
in 'hash' ?

Starting 1 process
file     12611 setup files
file     12611 get file size for 0x7ff9030be148/0/0x7ff9030be228
diskutil 12611 /media/xtreemfs/afile belongs to maj/min 0/27
process  12611 pid=0: runstate 0 -> 1
process  12611 will fork
mutex    12611 wait on startup_mutex
process  12612 jobs pid=12612 started
process  12612 pid=12612: runstate 1 -> 2
mutex    12612 up startup_mutex
mutex    12612 wait on td->mutex
mutex    12611 done waiting on startup_mutex
process  12611 pid=12612: runstate 2 -> 4
mutex    12612 done waiting on td->mutex
mem      12612 malloc 8191 0x1cb3730
mem      12612 io_u alloc 0x1cb21c0, index 0
mem      12612 io_u 0x1cb21c0, mem 0x1cb4000
file     12612 trying file /media/xtreemfs/afile 10
file     12612 fd open /media/xtreemfs/afile
file     12612 file not found in hash /media/xtreemfs/afile
file     12612 get file /media/xtreemfs/afile, ref=0
io       12612 invalidate cache /media/xtreemfs/afile: 0/2097152
file     12612 fd close /media/xtreemfs/afile
file     12612 error 1 on open of /media/xtreemfs/afile
file     12612 get_next_file_rr: (nil)
fio: pid=12612, got signal=11
process  12611 pid=12612: runstate 4 -> 9
process  12611 terminate group_id=-1
process  12611 setting terminate on randread/12612
diskutil 12611 update io ticks


[global]
bs=4k
iodepth=1
direct=1
runtime=10
size=2M
filename=/media/xtreemfs/afile


I appreciate any suggestions on this. Thanks in advance :)

Regards
