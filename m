Return-Path: <fio-owner@vger.kernel.org>
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35811 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727004AbfLCPZM (ORCPT
        <rfc822;fio@vger.kernel.org>); Tue, 3 Dec 2019 10:25:12 -0500
Received: by mail-ot1-f70.google.com with SMTP id o14so1658068otp.4
        for <fio@vger.kernel.org>; Tue, 03 Dec 2019 07:23:58 -0800 (PST)
MIME-Version: 1.0
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Tue, 3 Dec 2019 16:23:46 +0100
Message-ID: <CAHc6FU7ai7HPQA8PP31wkJzz6LYJEn97Z-nJXn=EgvDy0LoBtA@mail.gmail.com>
Subject: fio verify and short writes
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I've run into a verify issue with fio in xfstest generic/300 [*]:

* The aio-dio-verifier thread in that test case writes 4k buffers and
then reads them back in.
* The filesystem has a block size if 1k.
* The test case is designed to run the filesystem out of space. When
that happens, some writes can end up short before they all fail with
-ENOSPC. (That doesn't seem to happen on ext4 or xfs filesystems with
a 1k block size --- possibly just because the test always runs on a
scratch filesystem --- but it does trigger on gfs2.)
* When the aio-dio-verifier thread reads a short 4k buffer back in,
part of the buffer will be zero-filled, so verification will fail.

This is with a current fio and kernel.

Any thoughts?

Thanks,
Andreas

[*] https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/tests/gener=
ic/300


