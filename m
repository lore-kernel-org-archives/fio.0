Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55490
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038Ab3AHUBJ (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 8 Jan 2013 15:01:09 -0500
Message-ID: <50EC7B02.7040901@kernel.dk>
Date: Tue, 08 Jan 2013 21:01:06 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Segfault on OS X
References: <CA+6NFoBAhy8jR8jg8_MqDH8WP_e+Y2BVFxCysKo2Nqhkj8cmZw@mail.gmail.com>
In-Reply-To: <CA+6NFoBAhy8jR8jg8_MqDH8WP_e+Y2BVFxCysKo2Nqhkj8cmZw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Niraj Tolia <ntolia@maginatics.com>
Cc: fio@vger.kernel.org

On Tue, Jan 08 2013, Niraj Tolia wrote:
> I am running fio (HEAD:a28b019) on OS X (10.8.2) and just ran into a
> segfault after more than an hour of running the benchmark. Will dig
> into this more but wanted to check if someone else had run into this.
> I did manage to get a core though. There were three threads running
> with two sitting in __semwait_signal () (via usleep) and the third
> was:
> 
> [Switching to thread 3 (core thread 2)]
> 0x000000010fcf7910 in thread_main (data=0x1105fe000) at backend.c:510
> 510            if (break_on_this_error(td, io_u->ddir, &ret))
> (gdb) where
> #0  0x000000010fcf7910 in thread_main (data=0x1105fe000) at backend.c:510
> #1  0x00007fff885d1742 in _pthread_start ()
> #2  0x00007fff885be181 in thread_start ()
> 
> It seems like io_u is null here.

My first thought was "impossible", but looking at the code, we do
clear io_u on requeue events. So that dereference below the
main switch is a bug. The below should fix it, I've committed it.

diff --git a/backend.c b/backend.c
index 225d8a3..099bd9b 100644
--- a/backend.c
+++ b/backend.c
@@ -422,6 +422,7 @@ static void do_verify(struct thread_data *td)
 
 	io_u = NULL;
 	while (!td->terminate) {
+		enum fio_ddir ddir;
 		int ret2, full;
 
 		update_tv_cache(td);
@@ -456,6 +457,8 @@ static void do_verify(struct thread_data *td)
 		else
 			io_u->end_io = verify_io_u;
 
+		ddir = io_u->ddir;
+
 		ret = td_io_queue(td, io_u);
 		switch (ret) {
 		case FIO_Q_COMPLETED:
@@ -507,7 +510,7 @@ sync_done:
 			break;
 		}
 
-		if (break_on_this_error(td, io_u->ddir, &ret))
+		if (break_on_this_error(td, ddir, &ret))
 			break;
 
 		/*

-- 
Jens Axboe

