Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:57695 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757127AbcIOOXc (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 15 Sep 2016 10:23:32 -0400
From: Fabrice Bacchella <fabrice.bacchella@orange.fr>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: fio and posix_fadvise
Message-Id: <AEA40A07-F002-4E1C-B4E4-991FF6B13F55@orange.fr>
Date: Thu, 15 Sep 2016 16:23:27 +0200
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

fio uses posix_fadvise, but can only take two values :

        if (td->o.invalidate_cache && file_invalidate_cache(td, f))
                goto err;

        if (td->o.fadvise_hint &&
            (f->filetype == FIO_TYPE_BD || f->filetype == FIO_TYPE_FILE)) {
                int flags;

                if (td_random(td))
                        flags = POSIX_FADV_RANDOM;
                else
                        flags = POSIX_FADV_SEQUENTIAL;

                if (posix_fadvise(f->fd, f->file_offset, f->io_size, flags) < 0) {
                        td_verror(td, errno, "fadvise");
                        goto err;
                }
        }


But it can take many values, from linux/fadvise.h:

#define POSIX_FADV_NORMAL       0 /* No further special treatment.  */
#define POSIX_FADV_RANDOM       1 /* Expect random page references.  */
#define POSIX_FADV_SEQUENTIAL   2 /* Expect sequential page references.  */
#define POSIX_FADV_WILLNEED     3 /* Will need these pages.  */
...
#define POSIX_FADV_DONTNEED     4 /* Don't need these pages.  */
#define POSIX_FADV_NOREUSE      5 /* Data will be accessed once.  */


POSIX_FADV_NOREUSE have no effect on current kernel (https://github.com/torvalds/linux/blob/master/mm/fadvise.c#L115) but DONTNEED is interesting as it allow
to flush page cache after use It allows to do bench with machines with huge memory without having to bench huge files, and without using directio that is a strange beast. But it needs to be call right after use.

It's used in file_invalidate_cache but this function seems to be call once, when file is open for the first time.

Is there any plan to support it ?






