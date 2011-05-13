Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44058 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab1EMQHq (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 13 May 2011 12:07:46 -0400
Received: by gyd10 with SMTP id 10so928122gyd.19
        for <fio@vger.kernel.org>; Fri, 13 May 2011 09:07:46 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 13 May 2011 18:07:45 +0200
Message-ID: <BANLkTimcc9d-kfsgSqfsbSS=ffG5OMK_jA@mail.gmail.com>
Subject: reading tmpfs with splice ioengine
From: Vasilis Liaskovitis <vliaskov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I am trying to use the splice ioengine to read/write from/to tmpfs (/dev/shm).

Writing works fine e.g. with the following fio config:
[sw]
rw=write
size=1g
directory=/dev/shm
iodepth=32
direct=0
blocksize=512k
numjobs=1
nrfiles=1
ioengine=splice
loops=1
group_reporting
create_on_open=1
create_serialize=0

But reading the same file afterwards with the splice ioengine fails:
[sw]
rw=read
size=1g
directory=/dev/shm
iodepth=32
direct=0
blocksize=512k
numjobs=1
nrfiles=1
ioengine=splice
loops=1
group_reporting

root@server1:~/fio# ./fio  /root/fior_splice.fio
sw: (g=0): rw=read, bs=512K-512K/512K-512K, ioengine=splice, iodepth=32
fio 1.53
Starting 1 process
fio: pid=17504, err=22/file:filesetup.c:502,
func=open(/dev/shm/sw.1.0), error=Invalid argument
Run status group 0 (all jobs):

Is something misconfigured in the fio read config?
The --debug=all output is:

Starting 1 process
file     17517 setup files
file     17517 get file size for 0x7f2f87451028/0/0x7f2f87451108
diskutil 17517 /dev/shm/sw.1.0 belongs to maj/min 0/17
process  17517 pid=0: runstate 0 -> 1
process  17517 will fork
mutex    17517 wait on startup_mutex
process  17519 jobs pid=17519 started
process  17519 pid=17519: runstate 1 -> 2
mutex    17519 up startup_mutex
mutex    17519 wait on td->mutex
mutex    17517 done waiting on startup_mutex
process  17517 pid=17519: runstate 2 -> 4
mutex    17519 done waiting on td->mutex
mem      17519 Alloc 16777216 for buffers
[...]
file     17519 trying file /dev/shm/sw.1.0 10
file     17519 fd open /dev/shm/sw.1.0
file     17519 file not found in hash /dev/shm/sw.1.0
file     17519 get file /dev/shm/sw.1.0, ref=0
io       17519 invalidate cache /dev/shm/sw.1.0: 0/1073741824
file     17519 fd close /dev/shm/sw.1.0
file     17519 error 1 on open of /dev/shm/sw.1.0
file     17519 get_next_file_rr: (nil)
fio: pid=17519, got signal=11
process  17517 pid=17519: runstate 4 -> 9
process  17517 terminate group_id=-1
process  17517 setting terminate on sw/17519
diskutil 17517 update io ticks


Other fio ioengines (sync, vsync) work fine for both reading/writing
on tmpfs. Also, other splice tests can do both reads and writes to
tmpfs (e.g. splice-cp).

This happens with current fio-master or fio-1.38-1 (debian package)
thanks for any comments,

- Vasilis
