Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f42.google.com ([209.85.128.42]:55207 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfIOWKj (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 15 Sep 2019 18:10:39 -0400
Received: by mail-wm1-f42.google.com with SMTP id p7so7947632wmp.4
        for <fio@vger.kernel.org>; Sun, 15 Sep 2019 15:10:38 -0700 (PDT)
MIME-Version: 1.0
References: <CABO+gV-fpuOi6u8w8-L5G+sZ7KhvPy9SC3hqXh+q6PReVTxbCA@mail.gmail.com>
 <CALjAwxi3L-N1-fW5PNJbMU0SjY6G2eRXrL4=5Z7egL3w=apPcQ@mail.gmail.com>
In-Reply-To: <CALjAwxi3L-N1-fW5PNJbMU0SjY6G2eRXrL4=5Z7egL3w=apPcQ@mail.gmail.com>
From: Elliott Balsley <elliott@altsystems.com>
Date: Sun, 15 Sep 2019 15:10:26 -0700
Message-ID: <CABO+gV-uxLsURnoVBS1QcPPadwBVL2rm1Fo1OeG_PHB_0E16eQ@mail.gmail.com>
Subject: Re: Disk slows down while empting write buffer
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

Thanks for your suggestions.  Unfortunately, now I'm not confident in
these results, because today this behavior is not happening, even with
the same zpool on the same system.  Now it's writing at a steady rate
to disks the whole time, instead of starting out very high (3GBps to
memory) and then dropping to zero at the end.  So essentially the
fsync doesn't have to sync anything at the end.  Is there some way to
control this behavior?  I'm not sure if it's fio or the filesystem,
but why does it write at disk speed today, while it wrote at memory
speed before?

