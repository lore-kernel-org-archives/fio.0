Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59793 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab3HTO1o (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 20 Aug 2013 10:27:44 -0400
Message-ID: <52137C99.8070006@kernel.dk>
Date: Tue, 20 Aug 2013 08:26:33 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Using LFSR
References: <CAPet_21dehFMKwU25L+ho1uRWOO6w_p7LqxxyJe5gQ5a9G0M5A@mail.gmail.com>
In-Reply-To: <CAPet_21dehFMKwU25L+ho1uRWOO6w_p7LqxxyJe5gQ5a9G0M5A@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040405090704060602020202"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Juan Casse <jcasse@chromium.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------040405090704060602020202
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 08/19/2013 05:11 PM, Juan Casse wrote:
> Hi,
> 
> How is LFSR used?
> 
> When running the job file:
> 
> [global]
> readwrite=randwrite
> size=64k
> bs=8192
> random_generator=lfsr
> [test_job]
> 
> fio returns:
> 
> "fio: failed allocating random map. If running a large number of jobs,
> try the 'norandommap' option or set 'softrandommap'. Or give a larger
> --alloc-size to fio."
> 
> I tried the recommendations in the message above to no avail. I also
> tried other combinations of size, bs, and readwrite.

That's very odd. Is it a clean compile? The error isn't that great,
since it could trigger for LFSR init failure too. Can you try with the
attached patch?

-- 
Jens Axboe


--------------040405090704060602020202
Content-Type: text/x-patch;
 name="lfsr-debug-fail.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lfsr-debug-fail.patch"

diff --git a/lib/lfsr.c b/lib/lfsr.c
index b10ba7a..290829d 100644
--- a/lib/lfsr.c
+++ b/lib/lfsr.c
@@ -233,18 +233,24 @@ int lfsr_init(struct fio_lfsr *fl, uint64_t nums, unsigned long seed,
 	uint8_t *lfsr_taps;
 
 	lfsr_taps = find_lfsr(nums);
-	if (!lfsr_taps)
+	if (!lfsr_taps) {
+		printf("failed finding tap\n");
 		return 1;
+	}
 
 	fl->max_val = nums - 1;
 	fl->xormask = lfsr_create_xormask(lfsr_taps);
 	fl->cached_bit = 1UL << (lfsr_taps[0] - 1);
 
-	if (prepare_spin(fl, spin))
+	if (prepare_spin(fl, spin)) {
+		printf("prepare spin failed\n");
 		return 1;
+	}
 
-	if (lfsr_reset(fl, seed))
+	if (lfsr_reset(fl, seed)) {
+		printf("lfsr reset failed\n");
 		return 1;
+	}
 
 	return 0;
 }

--------------040405090704060602020202--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


