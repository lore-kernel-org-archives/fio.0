Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HDcbEw0O"
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5501993
	for <fio@vger.kernel.org>; Mon, 20 Nov 2023 05:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=BH9RtkvE55IQvMWeqq6fFAqAn27CHtOUaAm1OhIvX8Y=; b=HDcbEw0OslXWW8x8aR2NV0ahrw
	DkHGLsmB33gRY/OvsDy5o8vJTLSzuUchrQNS3Rgab5s7F32jVjCy0C5Erag/QlQwcAd61BCe0XgYZ
	rn2kTim9lEQw7qSju0FmL93W1xyZZoxtCxhrDC0tFMWCZravQjApJxwxynBhhmi5nLcn5H3aGrTV8
	eyIdU3mGx61M0g3jiEtS8FZUbW15wuD0J4fBgnM4UgqqwKbqlD3LA+qbiy46CvPAxyfgxAfdJwqc+
	4P9RgZrV/kG4zCVXsjUe8W5bJpBDXghBcERjDLo5uNSGcgAJyHQsYmppY7DZvwlhvohaTSk2w039W
	wXazp0Dg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1r53sl-00Ay0Y-1U
	for fio@vger.kernel.org;
	Mon, 20 Nov 2023 13:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 5523B1BC0149; Mon, 20 Nov 2023 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20231120130001.5523B1BC0149@kernel.dk>
Date: Mon, 20 Nov 2023 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit afdde534004397ba1fb00ccc6f5906fa50dd667f:

  t/jobs/t0012.fio: make this job time_based (2023-11-07 12:22:40 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to bdf99b6836d75683cba5968c40f321748482ae86:

  Merge branch 'xnvme_includes' of https://github.com/safl/fio (2023-11-20 07:43:16 -0500)

----------------------------------------------------------------
Simon A. F. Lund (1):
      engines/xnvme: only include entry-header ('libxnvme.h')

Vincent Fu (1):
      Merge branch 'xnvme_includes' of https://github.com/safl/fio

 engines/xnvme.c | 4 ----
 1 file changed, 4 deletions(-)

---

Diff of recent changes:

diff --git a/engines/xnvme.c b/engines/xnvme.c
index b7824013..2a0b3520 100644
--- a/engines/xnvme.c
+++ b/engines/xnvme.c
@@ -10,10 +10,6 @@
 #include <stdlib.h>
 #include <assert.h>
 #include <libxnvme.h>
-#include <libxnvme_libconf.h>
-#include <libxnvme_nvm.h>
-#include <libxnvme_znd.h>
-#include <libxnvme_spec_fs.h>
 #include "fio.h"
 #include "zbd_types.h"
 #include "fdp.h"
