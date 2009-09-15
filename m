Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:50834 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238AbZIORyd (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 15 Sep 2009 13:54:33 -0400
Date: Tue, 15 Sep 2009 19:54:36 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Compile error on IA64
Message-ID: <20090915175435.GO23126@kernel.dk>
References: <4AAFB3FB.5080404@nowhere.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAFB3FB.5080404@nowhere.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Allan Willems Joergensen <allan@nowhere.dk>
Cc: fio@vger.kernel.org

On Tue, Sep 15 2009, Allan Willems Joergensen wrote:
> Hi,
>
> I'm trying to compile fio on a Linux/IA64 machine; it fails.

Apparently I'm good at that typo, the below should get you going.


diff --git a/arch/arch-ia64.h b/arch/arch-ia64.h
index 2f92684..a8bb23a 100644
--- a/arch/arch-ia64.h
+++ b/arch/arch-ia64.h
@@ -20,7 +20,7 @@
 
 #define nop		asm volatile ("hint @pause" ::: "memory");
 #define read_barrier()	asm volatile ("mf" ::: "memory")
-#define writebarrier()	asm volatile ("mf" ::: "memory")
+#define write_barrier()	asm volatile ("mf" ::: "memory")
 
 #define ia64_popcnt(x)							\
 ({									\

-- 
Jens Axboe

