Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yb0-f174.google.com ([209.85.213.174]:36298 "EHLO
        mail-yb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751681AbdELRp5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 12 May 2017 13:45:57 -0400
Received: by mail-yb0-f174.google.com with SMTP id s22so15683628ybe.3
        for <fio@vger.kernel.org>; Fri, 12 May 2017 10:45:57 -0700 (PDT)
MIME-Version: 1.0
From: Spencer Hayes <spencer@jshayesinc.com>
Date: Fri, 12 May 2017 13:45:56 -0400
Message-ID: <CACgm0dh1M1-3xMMzzPm5FbQAnY+WLeuucmOjRL=5H6eJs+BVEg@mail.gmail.com>
Subject: ZFS Testing Methodology
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Howdy all,

We're attempting to run some performance tests on a Solaris 11.2
system with ZFS. The system has a sizable amount of memory which is
currently more than the available space left in ZFS. Given that ZFS
does not provide for direct IO, we're looking for options on how to
exhaust the caching and actually test the throughput of the underlying
disks.

I've looked through several of the fio options but so far have not
been able to find a mix that would let us do more total IO than is
actually used as space on disk. The idea we had was to lay down say a
100GB file, but do 200-300GB of actual IO within that single (or
multiple) file(s).

Does anyone have experience perf testing ZFS and might have some
suggestions to tackle this scenario?

Thanks!

-Spencer
