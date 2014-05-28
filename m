Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:43575 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaE1UYl (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 28 May 2014 16:24:41 -0400
Received: by mail-ob0-f182.google.com with SMTP id wn1so11384662obc.41
        for <fio@vger.kernel.org>; Wed, 28 May 2014 13:24:41 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 28 May 2014 16:24:41 -0400
Message-ID: <CAGw_T3o=eAEHYbQ68a+OodruxEuX0EDE9gihinb+zBkDWU_dcg@mail.gmail.com>
Subject: ETA no longer works when -o specified
From: Rik Faith <rickard.faith@nutanix.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Regarding fio version fio-2.1.9-17-gd9b1 (after April 11, 2014):

A recent change (5e1d8745471d1f315113c5c3fd8b93809d9ddff9) caused stdout
to be closed when -o was specified, which prevents ETA output from showing
up on stdout even when, e.g., json is being saved in the file.

This patch continues to close f_out so that there is no leak if multiple -o
options are specified, but doesn't close stdout.  Hence, ETA works again
when it should.

diff --git a/init.c b/init.c
index 4c5a8dd..a546861 100644
--- a/init.c
+++ b/init.c
@@ -1739,7 +1739,7 @@ int parse_cmd_line(int argc, char *argv[], int
client_type)
                        write_bw_log = 1;
                        break;
                case 'o':
-                       if (f_out)
+                       if (f_out && f_out != stdout)
                                fclose(f_out);
