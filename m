Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:60953 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983Ab0H0HDy (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 27 Aug 2010 03:03:54 -0400
Message-ID: <4C776359.70403@fusionio.com>
Date: Fri, 27 Aug 2010 09:03:53 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: using ioengine=sg
References: <AANLkTimTvSmj-1L80KAyVf7uv9d+vDENsMj-_bFDqRBR@mail.gmail.com>
In-Reply-To: <AANLkTimTvSmj-1L80KAyVf7uv9d+vDENsMj-_bFDqRBR@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Chuck Tuffli <ctuffli@gmail.com>
Cc: fio@vger.kernel.org

On 2010-08-26 21:25, Chuck Tuffli wrote:
> Hi -
> 
> Reading the man page under ioengine, it mentions that sg will do
> asynchronous IO if the target is the sg character device. So I'm
> assuming that means a job file something like
> 
>> cat sgtest.fio
> [global]
> bs=512b
> readwrite=read
> ioengine=sg
> size=1m
> 
> [/dev/sg2]
> 
> but when I run it,
> 
>> uname -srp
> Linux 2.6.34-12-default x86_64
>> ls -l /dev/sg2
> crw-rw---- 1 root disk 21, 2 Aug 26 17:46 /dev/sg2
>> ./fio --version
> fio 1.43.1
>> sudo ./fio sgtest.fio
> /dev/sg2: (g=0): rw=read, bs=512-512/512-512, ioengine=sg, iodepth=1
> Starting 1 process
> fio: pid=3147, got signal=11
> 
> 
> Run status group 0 (all jobs):
> fio: file hash not empty on exit
> 
> Any idea what I'm doing wrong or might be missing on the system? Thanks!

You are not doing anything wrong, it's a bug. This patch will fix
it.

diff --git a/engines/sg.c b/engines/sg.c
index 57c3834..bc82b09 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -274,17 +274,16 @@ static struct io_u *fio_sgio_event(struct thread_data *td, int event)
 static int fio_sgio_get_bs(struct thread_data *td, unsigned int *bs)
 {
 	struct sgio_data *sd = td->io_ops->data;
-	struct io_u *io_u;
+	struct io_u io_u;
 	struct sg_io_hdr *hdr;
 	unsigned char buf[8];
 	int ret;
 
-	io_u = __get_io_u(td);
-	io_u->file = td->files[0];
-	assert(io_u);
+	memset(&io_u, 0, sizeof(io_u));
+	io_u.file = td->files[0];
 
-	hdr = &io_u->hdr;
-	sgio_hdr_init(sd, hdr, io_u, 0);
+	hdr = &io_u.hdr;
+	sgio_hdr_init(sd, hdr, &io_u, 0);
 	memset(buf, 0, sizeof(buf));
 
 	hdr->cmdp[0] = 0x25;
@@ -292,14 +291,11 @@ static int fio_sgio_get_bs(struct thread_data *td, unsigned int *bs)
 	hdr->dxferp = buf;
 	hdr->dxfer_len = sizeof(buf);
 
-	ret = fio_sgio_doio(td, io_u, 1);
-	if (ret) {
-		put_io_u(td, io_u);
+	ret = fio_sgio_doio(td, &io_u, 1);
+	if (ret)
 		return ret;
-	}
 
 	*bs = (buf[4] << 24) | (buf[5] << 16) | (buf[6] << 8) | buf[7];
-	put_io_u(td, io_u);
 	return 0;
 }
 

-- 
Jens Axboe

