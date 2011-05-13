Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:52045 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755870Ab1EMTbJ (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 13 May 2011 15:31:09 -0400
Message-ID: <4DCD8436.6080906@fusionio.com>
Date: Fri, 13 May 2011 21:19:18 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: reading tmpfs with splice ioengine
References: <BANLkTimcc9d-kfsgSqfsbSS=ffG5OMK_jA@mail.gmail.com>
In-Reply-To: <BANLkTimcc9d-kfsgSqfsbSS=ffG5OMK_jA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vasilis Liaskovitis <vliaskov@gmail.com>
Cc: fio@vger.kernel.org

On 2011-05-13 18:07, Vasilis Liaskovitis wrote:
> Hi,
> 
> I am trying to use the splice ioengine to read/write from/to tmpfs (/dev/shm).
> 
> Writing works fine e.g. with the following fio config:
> [sw]
> rw=write
> size=1g
> directory=/dev/shm
> iodepth=32
> direct=0
> blocksize=512k
> numjobs=1
> nrfiles=1
> ioengine=splice
> loops=1
> group_reporting
> create_on_open=1
> create_serialize=0
> 
> But reading the same file afterwards with the splice ioengine fails:
> [sw]
> rw=read
> size=1g
> directory=/dev/shm
> iodepth=32
> direct=0
> blocksize=512k
> numjobs=1
> nrfiles=1
> ioengine=splice
> loops=1
> group_reporting
> 
> root@server1:~/fio# ./fio  /root/fior_splice.fio
> sw: (g=0): rw=read, bs=512K-512K/512K-512K, ioengine=splice, iodepth=32
> fio 1.53
> Starting 1 process
> fio: pid=17504, err=22/file:filesetup.c:502,
> func=open(/dev/shm/sw.1.0), error=Invalid argument
> Run status group 0 (all jobs):
> 
> Is something misconfigured in the fio read config?
> The --debug=all output is:

It's a bug in fio. We used to set O_DIRECT just in case vmsplice could
map into user address space, which is why it fails (/dev/shm/ does not
do O_DIRECT). There's actually a way to set this correctly now, the
below patch will work for you.

I'll commit it now.

diff --git a/engines/splice.c b/engines/splice.c
index be16cbb..aa00234 100644
--- a/engines/splice.c
+++ b/engines/splice.c
@@ -284,7 +284,7 @@ static int fio_spliceio_init(struct thread_data *td)
 	 * buffers. Just set ->odirect to force that.
 	 */
 	if (td_read(td))
-		td->o.odirect = 1;
+		td->o.mem_align = 1;
 
 	td->io_ops->data = sd;
 	return 0;

-- 
Jens Axboe

