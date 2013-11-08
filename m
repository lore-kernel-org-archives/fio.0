Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55599 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757426Ab3KHR4l (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 8 Nov 2013 12:56:41 -0500
Date: Fri, 8 Nov 2013 10:56:39 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Warnings from gcc 4.9 (on FreeBSD)
Message-ID: <20131108175639.GC3195@kernel.dk>
References: <527CE300.8010300@cran.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527CE300.8010300@cran.org.uk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Fri, Nov 08 2013, Bruce Cran wrote:
> Building using gcc 4.9 (on FreeBSD 11-CURRENT) generates a few warnings
> about undefined behaviour:
> 
>     CC cconv.o
> In file included from thread_options.h:5:0,
>                  from cconv.c:3:
> cconv.c: In function 'convert_thread_options_to_cpu':
> os/os.h:197:16: warning: iteration 2u invokes undefined behavior
> [-Waggressive-loop-optimizations]
>   __le32_to_cpu(*__val);   \
>                 ^
> os/os.h:176:28: note: in definition of macro '__le32_to_cpu'
>  #define __le32_to_cpu(x)  (x)
>                             ^
> cconv.c:78:17: note: in expansion of macro 'le32_to_cpu'
>    o->rwmix[i] = le32_to_cpu(top->rwmix[i]);
>                  ^
> cconv.c:63:2: note: containing loop
>   for (i = 0; i < DDIR_RWDIR_CNT; i++) {
>   ^

Wow, gcc is really outdoing itself in making warnings obtuse. The below
should fix it up. We don't really use rwmix with TRIM, but lets just
extend it since that basically should be supported.


diff --git a/server.h b/server.h
index aefd41832483..5d9b6ccadae3 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 25,
+	FIO_SERVER_VER			= 26,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 
diff --git a/thread_options.h b/thread_options.h
index 3f345c56b3ba..484b16a56e75 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -157,7 +157,7 @@ struct thread_options {
 #endif
 	unsigned int iolog;
 	unsigned int rwmixcycle;
-	unsigned int rwmix[2];
+	unsigned int rwmix[DDIR_RWDIR_CNT];
 	unsigned int nice;
 	unsigned int ioprio;
 	unsigned int ioprio_class;
@@ -362,7 +362,7 @@ struct thread_options_pack {
 	uint32_t verify_cpumask_set;
 	uint32_t iolog;
 	uint32_t rwmixcycle;
-	uint32_t rwmix[2];
+	uint32_t rwmix[DDIR_RWDIR_CNT];
 	uint32_t nice;
 	uint32_t ioprio;
 	uint32_t ioprio_class;

-- 
Jens Axboe

