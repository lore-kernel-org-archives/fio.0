Return-Path: <axboe@kernel.dk>
Message-ID: <5508A2F9.50701@kernel.dk>
Date: Tue, 17 Mar 2015 15:56:09 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio always writes null bytes whatever I do
References: <4471f819ae264ec8bcb6bb1684effd53@keskonrix.itsystems.ch>
In-Reply-To: <4471f819ae264ec8bcb6bb1684effd53@keskonrix.itsystems.ch>
Content-Type: multipart/mixed;
 boundary="------------020201090906030407080003"
To: Urs Schaltegger <urs.schaltegger@itsystems.ch>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------020201090906030407080003
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/12/2015 08:32 AM, Urs Schaltegger wrote:
> fio always writes null bytes whatever I do. I need random data to avoid interference of deduplication solutions (within SSDs or using ZFS).
>
> Windows 8.1 Enterprise x64
>
> fio-2.2.6 (also tried 2.2.0/2.2.1/2.2.3)
>
> fio --section=fiorandom --runtime=60 <FIOFile>
>
> <FIOFile>:
>
> [global]
> ioengine=windowsaio
> thread
> group_reporting
> time_based
> clocksource=clock_gettime
> direct=1
> refill_buffers
> size=1g
> [fiorandom]
> readwrite=randwrite
> numjobs=4
> iodepth=1
> blocksize=8k
> directory=D\:\

Hmm yes, that looks like a regression. Does the attached work?


-- 
Jens Axboe


--------------020201090906030407080003
Content-Type: text/x-patch;
 name="randfill.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="randfill.patch"

diff --git a/io_u.c b/io_u.c
index 6567e10a5be2..33b8ac347437 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1895,8 +1895,13 @@ void fill_io_buffer(struct thread_data *td, void *buf, unsigned int min_write,
 		} while (left);
 	} else if (o->buffer_pattern_bytes)
 		fill_buffer_pattern(td, buf, max_bs);
-	else
+	else if (o->zero_buffers)
 		memset(buf, 0, max_bs);
+	else {
+		struct frand_state *rs = get_buf_state(td);
+
+		fill_random_buf(rs, buf, max_bs);
+	}
 }
 
 /*

--------------020201090906030407080003--

