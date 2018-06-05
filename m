Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38332 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751644AbeFEMAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 5 Jun 2018 08:00:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fQAdC-0003qP-Hw
        for fio@vger.kernel.org; Tue, 05 Jun 2018 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180605120002.28F542C0311@kernel.dk>
Date: Tue,  5 Jun 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c397ab3aac3d4ed1660d9cd4d820f31a4375306e:

  Fio 3.7 (2018-06-01 13:21:56 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 182cab24328ab22a5b76ba1edac2c801b83aeffb:

  Fix issue with rate_process=poisson and ramp time (2018-06-04 13:51:47 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Fix issue with rate_process=poisson and ramp time

 backend.c | 2 ++
 libfio.c  | 1 +
 2 files changed, 3 insertions(+)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 033d5a7..180348f 100644
--- a/backend.c
+++ b/backend.c
@@ -892,6 +892,8 @@ static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir)
 			over = (usperop - total) / usperop * -bs;
 
 		td->rate_io_issue_bytes[ddir] += (missed - over);
+		/* adjust for rate_process=poisson */
+		td->last_usec[ddir] += total;
 	}
 }
 
diff --git a/libfio.c b/libfio.c
index 6faf32a..674bc1d 100644
--- a/libfio.c
+++ b/libfio.c
@@ -92,6 +92,7 @@ static void reset_io_counters(struct thread_data *td, int all)
 			td->bytes_done[ddir] = 0;
 			td->rate_io_issue_bytes[ddir] = 0;
 			td->rate_next_io_time[ddir] = 0;
+			td->last_usec[ddir] = 0;
 		}
 	}
 
