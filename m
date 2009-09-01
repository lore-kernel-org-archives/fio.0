Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:47126 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbZIAFih (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 1 Sep 2009 01:38:37 -0400
Date: Tue, 1 Sep 2009 07:38:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: FIO for MIPS
Message-ID: <20090901053838.GK12579@kernel.dk>
References: <7efa8a7d0908311900o2f0bfbb8t52a8b518782e2bdc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7efa8a7d0908311900o2f0bfbb8t52a8b518782e2bdc@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Learner Study <learner.study@gmail.com>
Cc: fio@vger.kernel.org

On Mon, Aug 31 2009, Learner Study wrote:
> Hello:
> 
> I checked README for FIO and apparently it isn't yet supported on MIPS64
> platform yet (atleast until version 1.30)
> Does someone have a patch I could use to do this? Any other ideas...

I just checked in the below patch. I haven't checked the memory ordering
defines yet, not sure if any of the mips cpus are weaker ordered. I'll
check that later, this should at least get you started.

commit c28b912f77c3dafbdcdcf4def2c8c1f9c127100c
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Tue Sep 1 07:23:57 2009 +0200

    MIPS support
    
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/arch/arch-mips.h b/arch/arch-mips.h
new file mode 100644
index 0000000..759d3a9
--- /dev/null
+++ b/arch/arch-mips.h
@@ -0,0 +1,25 @@
+#ifndef ARCH_MIPS64_H
+#define ARCH_MIPS64_H
+
+#define ARCH	(arch_mips)
+
+#ifndef __NR_ioprio_set
+#define __NR_ioprio_set		314
+#define __NR_ioprio_get		315
+#endif
+
+#ifndef __NR_fadvise64
+#define __NR_fadvise64		215
+#endif
+
+#ifndef __NR_sys_splice
+#define __NR_sys_splice		263
+#define __NR_sys_tee		265
+#define __NR_sys_vmsplice	266
+#endif
+
+#define read_barrier()		__asm__ __volatile__("": : :"memory")
+#define write_barrier()		__asm__ __volatile__("": : :"memory")
+#define nop			__asm__ __volatile__("": : :"memory")
+
+#endif
diff --git a/arch/arch.h b/arch/arch.h
index 28c6632..87db222 100644
--- a/arch/arch.h
+++ b/arch/arch.h
@@ -31,6 +31,8 @@ enum {
 #include "arch-sparc64.h"
 #elif defined(__arm__)
 #include "arch-arm.h"
+#elif defined(__mips__) || defined(__mips64__)
+#include "arch-mips.h"
 #else
 #error "Unsupported arch"
 #endif

-- 
Jens Axboe

