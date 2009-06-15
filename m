Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:39958 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZFOXSf (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 15 Jun 2009 19:18:35 -0400
Received: from wpaz33.hot.corp.google.com (wpaz33.hot.corp.google.com [172.24.198.97])
	by smtp-out.google.com with ESMTP id n5FNIa1b016529
	for <fio@vger.kernel.org>; Tue, 16 Jun 2009 00:18:36 +0100
Received: from qw-out-2122.google.com (qwd5.prod.google.com [10.241.193.197])
	by wpaz33.hot.corp.google.com with ESMTP id n5FNIYNW022950
	for <fio@vger.kernel.org>; Mon, 15 Jun 2009 16:18:34 -0700
Received: by qw-out-2122.google.com with SMTP id 5so2578104qwd.53
        for <fio@vger.kernel.org>; Mon, 15 Jun 2009 16:18:34 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 15 Jun 2009 16:18:33 -0700
Message-ID: <66dfd3fe0906151618r472be916ubfb771d714cc851f@mail.gmail.com>
Subject: Alter the order of checking time exceeded vs getting an io_u
From: Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,
I was hitting a case where fio would loop for ever even though the
runtime was exceeded if it had difficulty getting the io_u struct, so
I suggest this change to the code so it wld not loop forever:

>git diff
diff --git a/fio.c b/fio.c
index bb26062..4927f1c 100644
--- a/fio.c
+++ b/fio.c
@@ -442,18 +442,17 @@ static void do_verify(struct thread_data *td)
        while (!td->terminate) {
                int ret2, full;

-               io_u = __get_io_u(td);
-               if (!io_u)
-                       break;
-
                update_tv_cache(td);

                if (runtime_exceeded(td, &td->tv_cache)) {
-                       put_io_u(td, io_u);
                        td->terminate = 1;
                        break;
                }

+               io_u = __get_io_u(td);
+               if (!io_u)
+                       break;
+
                if (get_next_verify(td, io_u)) {
                        put_io_u(td, io_u);
                        break;
@@ -580,18 +579,17 @@ static void do_io(struct thread_data *td)
                if (td->terminate)
                        break;

-               io_u = get_io_u(td);
-               if (!io_u)
-                       break;
-
                update_tv_cache(td);

                if (runtime_exceeded(td, &td->tv_cache)) {
-                       put_io_u(td, io_u);
                        td->terminate = 1;
                        break;
                }

+               io_u = get_io_u(td);
+               if (!io_u)
+                       break;
+
                /*
                 * Add verification end_io handler, if asked to verify
                 * a previously written file.


thanks
-radha
