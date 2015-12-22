Return-Path: <fio-owner@vger.kernel.org>
Received: from imx9.toshiba.co.jp ([106.186.93.47]:58336 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbbLVIWB convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 22 Dec 2015 03:22:01 -0500
Received: from imx12.toshiba.co.jp ([133.199.86.110])
	by imx9.toshiba.co.jp  with ESMTP id tBM8GYqs000894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <fio@vger.kernel.org>; Tue, 22 Dec 2015 17:16:34 +0900 (JST)
Received: from tsbmgw-mgw01.tsbmgw-mgw01.toshiba.co.jp ([133.199.232.103])
	by imx12.toshiba.co.jp  with ESMTP id tBM8GWi6027238
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <fio@vger.kernel.org>; Tue, 22 Dec 2015 17:16:32 +0900 (JST)
Received: from tsbmgw-mgw01 (localhost [127.0.0.1])
	by tsbmgw-mgw01.tsbmgw-mgw01.toshiba.co.jp (8.13.8/8.14.5) with ESMTP id tBM8GWWr007997
	for <fio@vger.kernel.org>; Tue, 22 Dec 2015 17:16:32 +0900
Received: from localhost ([127.0.0.1])
          by tsbmgw-mgw01 (JAMES SMTP Server 2.3.1) with SMTP ID 63
          for <fio@vger.kernel.org>;
          Tue, 22 Dec 2015 17:16:32 +0900 (JST)
Received: from arc11.toshiba.co.jp ([133.199.90.127])
	by tsbmgw-mgw01.tsbmgw-mgw01.toshiba.co.jp (8.13.8/8.14.5) with ESMTP id tBM8GWLC007985
	for <fio@vger.kernel.org>; Tue, 22 Dec 2015 17:16:32 +0900
Received: (from root@localhost)
	by arc11.toshiba.co.jp  id tBM8GViT025698
	for fio@vger.kernel.org; Tue, 22 Dec 2015 17:16:31 +0900 (JST)
Received: from mx.toshiba.co.jp (localhost [127.0.0.1])
	by ovp11.toshiba.co.jp  with ESMTP id tBM8GUCa008886
	for <fio@vger.kernel.org>; Tue, 22 Dec 2015 17:16:31 +0900 (JST)
From: <shoichi.sawada@toshiba.co.jp>
Subject: Fix runtime of terse output
Date: Tue, 22 Dec 2015 08:16:24 +0000
Message-ID: <64F25A0F43FA9948AF74033DC846D09D6B730876@TGXML313.toshiba.local>
Content-Language: ja-JP
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: yoshihiro7.tsuchiya@toshiba.co.jp

Hi,

When I used fio with option of '--status-interval=1 --minimal' and 'random_distribution=zipf:1.2', 
'runtime' of 2nd line was 18446744073709551345.
This value is -271 in int_64.

This is because 'runtime' was subtracted in function '__show_running_run_stats'.
If 'td->io_bytes' is 0 when this function was called,
and 'td->io_bytes' is not 0 when '__show_run_stats' returned,
'runtime' is subtracted by 'rt' even though 'runtime' have not added.

I fixed the problem by applying this patch to fio-2.2.13.

Regards
Shoichi

----
diff --git a/stat.c b/stat.c
index ca06617..1c1609e 100644
--- a/stat.c
+++ b/stat.c
@@ -1687,19 +1687,19 @@ void __show_running_run_stats(void)
 	fio_gettime(&tv, NULL);
 
 	for_each_td(td, i) {
-		rt[i] = mtime_since(&td->start, &tv);
-		if (td_read(td) && td->io_bytes[DDIR_READ])
-			td->ts.runtime[DDIR_READ] += rt[i];
-		if (td_write(td) && td->io_bytes[DDIR_WRITE])
-			td->ts.runtime[DDIR_WRITE] += rt[i];
-		if (td_trim(td) && td->io_bytes[DDIR_TRIM])
-			td->ts.runtime[DDIR_TRIM] += rt[i];
-
 		td->update_rusage = 1;
 		td->ts.io_bytes[DDIR_READ] = td->io_bytes[DDIR_READ];
 		td->ts.io_bytes[DDIR_WRITE] = td->io_bytes[DDIR_WRITE];
 		td->ts.io_bytes[DDIR_TRIM] = td->io_bytes[DDIR_TRIM];
 		td->ts.total_run_time = mtime_since(&td->epoch, &tv);
+
+		rt[i] = mtime_since(&td->start, &tv);
+		if (td_read(td) && td->ts.io_bytes[DDIR_READ])
+			td->ts.runtime[DDIR_READ] += rt[i];
+		if (td_write(td) && td->ts.io_bytes[DDIR_WRITE])
+			td->ts.runtime[DDIR_WRITE] += rt[i];
+		if (td_trim(td) && td->ts.io_bytes[DDIR_TRIM])
+			td->ts.runtime[DDIR_TRIM] += rt[i];
 	}
 
 	for_each_td(td, i) {
@@ -1715,11 +1715,11 @@ void __show_running_run_stats(void)
 	__show_run_stats();
 
 	for_each_td(td, i) {
-		if (td_read(td) && td->io_bytes[DDIR_READ])
+		if (td_read(td) && td->ts.io_bytes[DDIR_READ])
 			td->ts.runtime[DDIR_READ] -= rt[i];
-		if (td_write(td) && td->io_bytes[DDIR_WRITE])
+		if (td_write(td) && td->ts.io_bytes[DDIR_WRITE])
 			td->ts.runtime[DDIR_WRITE] -= rt[i];
-		if (td_trim(td) && td->io_bytes[DDIR_TRIM])
+		if (td_trim(td) && td->ts.io_bytes[DDIR_TRIM])
 			td->ts.runtime[DDIR_TRIM] -= rt[i];
 	}


