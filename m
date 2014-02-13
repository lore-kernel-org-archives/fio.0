Return-Path: <fio-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:49811 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaBMHGv (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 13 Feb 2014 02:06:51 -0500
Received: from sits by silver.sucs.swan.ac.uk with local (Exim 4.80)
	(envelope-from <sits@sucs.org>)
	id 1WDqNc-0005rU-KH
	for fio@vger.kernel.org; Thu, 13 Feb 2014 07:06:40 +0000
Date: Thu, 13 Feb 2014 07:06:40 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: [PATCH] io_u_qiter: Fix buffer overrun
Message-ID: <20140213070625.GA9117@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

In io_u_queue.h the io_u_qiter macro is loops around io_u_queue
structures. The problem comes with the end of loop initialisation:
i++, io_u = (q)->io_us[i]
For example, if io_us consists of one element and i is 0 then after the
first iteration is completed i++, io_u = (q)->io_us[i] will access
beyond the end of io_us.

Fix this by moving io_u initialisation to the expression part of the for
loop (yuck).

Found by Dr Memory.

Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>
---
 io_u_queue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_u_queue.h b/io_u_queue.h
index 4f6e8e6..5b6cad0 100644
--- a/io_u_queue.h
+++ b/io_u_queue.h
@@ -29,7 +29,7 @@ static inline int io_u_qempty(struct io_u_queue *q)
 }
 
 #define io_u_qiter(q, io_u, i)	\
-	for (i = 0, io_u = (q)->io_us[0]; i < (q)->nr; i++, io_u = (q)->io_us[i])
+	for (i = 0; i < (q)->nr && (io_u = (q)->io_us[i]); i++)
 
 int io_u_qinit(struct io_u_queue *q, unsigned int nr);
 void io_u_qexit(struct io_u_queue *q);
-- 
1.8.5.3

-- 
Sitsofe | http://sucs.org/~sits/
