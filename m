Return-Path: <fio-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39970 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726250AbfLFPce (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 6 Dec 2019 10:32:34 -0500
Received: by mail-ot1-f70.google.com with SMTP id m26so3900837otk.12
        for <fio@vger.kernel.org>; Fri, 06 Dec 2019 07:32:32 -0800 (PST)
MIME-Version: 1.0
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 6 Dec 2019 16:32:20 +0100
Message-ID: <CAHc6FU6ZbWL_LhZ_p1c=gAiD9VAjkPCMT01pqkcTSO0V9s9OgQ@mail.gmail.com>
Subject: Fwd: fio verify and short writes (resend)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fstests <fstests@vger.kernel.org>
Cc: fio@vger.kernel.org

Hi,

[This basically is a resend of https://www.spinics.net/lists/fio/msg08165.h=
tml.]

I've run into a verify issue with fio in xfstest generic/300 [*]:

The filesystem I'm running this on has a block size of 1k, on a
current mainline kernel and with current fio.

The aio-dio-verifier thread in that test case writes 4k buffers and
then reads them back in.

The test case is designed to run the filesystem out of space. When
that happens, some writes can end up short. That doesn't seem to
happen on ext4 or xfs filesystems with a block size of 1k, possibly
just because the test always runs on a scratch filesystem, but it
does happen on gfs2.

When the aio-dio-verifier thread reads the buffer of such a short write
back in, part of the buffer will lie in a hole and be zero-filled, so
verification will fail.

Any thoughts?

Thanks,
Andreas

[*] https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/tests/gener=
ic/300


