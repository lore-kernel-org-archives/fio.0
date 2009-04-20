Return-Path: <fio-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:16360 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbZDTBHU (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 19 Apr 2009 21:07:20 -0400
Received: by fk-out-0910.google.com with SMTP id 18so791018fkq.5
        for <fio@vger.kernel.org>; Sun, 19 Apr 2009 18:07:18 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 20 Apr 2009 03:07:18 +0200
Message-ID: <ed038eb20904191807h6ff3427dn83684a723c95e13c@mail.gmail.com>
Subject: [bug] Crash with multiple file names
From: Carl Henrik Lunde <chlunde@ping.uio.no>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi!  fio crashed with this configuration.  I notice there are a
multiple variables counting the number of files, so I don't know which
one to use.  nr_files *seems* safe?

diff --git a/filesetup.c b/filesetup.c
index af23191..eb8774a 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -685,8 +685,8 @@ int add_file(struct thread_data *td, const char *fname)

        f->fd = -1;

-       if (td->files_size <= td->files_index) {
-               int new_size = td->o.nr_files;
+       if (td->files_size <= td->o.nr_files) {
+               int new_size = td->o.nr_files + 1;

                dprint(FD_FILE, "resize file array to %d files\n", new_size);


Test config:

[global]
directory=/media/ext4

[a]
filename=large-001:large-002:large-003:large-004:large-005:large-006
bs=1M
rw=read


x86_64, fio 1.25.1

-- 
mvh
Carl Henrik
