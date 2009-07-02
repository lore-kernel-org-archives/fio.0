Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:18493 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbZGBB32 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 1 Jul 2009 21:29:28 -0400
Received: from spaceape11.eur.corp.google.com (spaceape11.eur.corp.google.com [172.28.16.145])
	by smtp-out.google.com with ESMTP id n621TTCM015829
	for <fio@vger.kernel.org>; Thu, 2 Jul 2009 02:29:30 +0100
Received: from qyk35 (qyk35.prod.google.com [10.241.83.163])
	by spaceape11.eur.corp.google.com with ESMTP id n621TRje010195
	for <fio@vger.kernel.org>; Wed, 1 Jul 2009 18:29:27 -0700
Received: by qyk35 with SMTP id 35so1931293qyk.6
        for <fio@vger.kernel.org>; Wed, 01 Jul 2009 18:29:27 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 1 Jul 2009 18:29:27 -0700
Message-ID: <66dfd3fe0907011829i50ac24b3s787f33c77287a7d9@mail.gmail.com>
Subject: Fix issue related to continue_on_error option
From: Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>

Hi,
I added a change so when both the continue_on_error and fill_device
option is on, when it hits ENOSPC issue the code ignores the error.

>git diff
diff --git a/fio.c b/fio.c
index fa5deab..3365bb1 100644
--- a/fio.c
+++ b/fio.c
@@ -388,21 +388,29 @@ static int break_on_this_error(struct
thread_data *td, int *retptr)
                else
                        err = td->error;

-               update_error_count(td, err);
-
                if (td_non_fatal_error(err)) {
                        /*
                         * Continue with the I/Os in case of
                         * a non fatal error.
                         */
+                       update_error_count(td, err);
                        td_clear_error(td);
                        *retptr = 0;
                        return 0;
+               } else if (td->o.fill_device && err == ENOSPC) {
+                       /*
+                        * We expect to hit this error if
+                        * fill_device option is set.
+                        */
+                       td_clear_error(td);
+                       td->terminate = 1;
+                       return 1;
                } else {
                        /*
                         * Stop the I/O in case of a fatal
                         * error.
                         */
+                       update_error_count(td, err);
                        return 1;
                }
        }

thanks
-radha
