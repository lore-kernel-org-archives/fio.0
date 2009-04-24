Return-Path: <gurudas.pai@oracle.com>
Message-ID: <49F14771.6040004@oracle.com>
Date: Fri, 24 Apr 2009 10:30:33 +0530
From: Gurudas Pai <gurudas.pai@oracle.com>
MIME-Version: 1.0
Subject: Re: request for job files
References: <20090422132257.GR4593@kernel.dk>
In-Reply-To: <20090422132257.GR4593@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

> The sample job files shipped with fio are (generally) pretty weak, and
> I'd really love for the selection to be better. 

Hi,

Please see if following jobfile is useful. This was used to uncover 2 
kernel bugs with mainline kernel.


# this jobfile was used to uncover 2 mainline kernel bugs.
#OOPS IN BIO_GET_NR_VECS+0X0/0X30, http://lkml.org/lkml/2007/7/31/580
#fix bad unlock_page() in error case, http://lkml.org/lkml/2007/7/20/168

[global]
bs=8k
iodepth=1024
iodepth_batch=60
randrepeat=1
size=1m
#Use any ext3 for <directory>
directory=<directory>
numjobs=20
[job1]
ioengine=sync
bs=1k
direct=1
rw=randread
filename=file1:file2
[job2]
ioengine=libaio
rw=randwrite
direct=1
filename=file1:file2
[job3]
bs=1k
ioengine=posixaio
rw=randwrite
direct=1
filename=file1:file2
[job4]
ioengine=splice
direct=1
rw=randwrite
filename=file1:file2
[job5]
bs=1k
ioengine=sync
rw=randread
filename=file1:file2
[job7]
ioengine=libaio
rw=randwrite
filename=file1:file2
[job8]
ioengine=posixaio
rw=randwrite
filename=file1:file2
[job9]
ioengine=splice
rw=randwrite
filename=file1:file2
[job10]
ioengine=mmap
rw=randwrite
bs=1k
filename=file1:file2
[job11]
ioengine=mmap
rw=randwrite
direct=1
filename=file1:file2


Thanks,
-Guru

