Return-Path: <bruce@cran.org.uk>
Message-ID: <507550DB.2000301@cran.org.uk>
Date: Wed, 10 Oct 2012 11:41:31 +0100
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: FIO 2.0.9 for Windows Server 2008 RC1 SP2 reports extreme latencies
References: <C8CA972100601A41AE302914E9CE194655F89024@NTXBOIMBX03.micron.com> <50605FEF.5020103@cran.org.uk> <C8CA972100601A41AE302914E9CE194655F9BAB5@NTXBOIMBX03.micron.com> <50632E0D.4090003@cran.org.uk> <506693F8.3010903@kernel.dk> <5066FBC0.5040508@cran.org.uk> <DD67A461-16D4-496A-BA7C-4F91F07A0B5D@kernel.dk> <C8CA972100601A41AE302914E9CE194655F9DEF4@NTXBOIMBX03.micron.com> <507548FE.9010106@cran.org.uk>
In-Reply-To: <507548FE.9010106@cran.org.uk>
Content-Type: multipart/mixed;
 boundary="------------080900010107090009020002"
To: "Jeffrey McVay (jmcvay)" <jmcvay@micron.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------080900010107090009020002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 10/10/2012 11:07, Bruce Cran wrote:
> The problem is that windowsaio iterates over the list of outstanding 
> IOs (busylist), but that list has the most recent first.

The attached patch appears to fix the problem:

Add outstanding IOs to the tail of io_u_busylist, not the head.

-- 
Bruce Cran

--------------080900010107090009020002
Content-Type: text/plain; charset=windows-1252;
 name="aio_queue.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="aio_queue.diff"

diff --git a/io_u.c b/io_u.c
index a2c583d..e047677 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1096,7 +1096,7 @@ again:
 
 		io_u->error = 0;
 		flist_del(&io_u->list);
-		flist_add(&io_u->list, &td->io_u_busylist);
+		flist_add_tail(&io_u->list, &td->io_u_busylist);
 		td->cur_depth++;
 		io_u->flags |= IO_U_F_IN_CUR_DEPTH;
 	} else if (td->o.verify_async) {

--------------080900010107090009020002--


