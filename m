Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhFXSk7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 24 Jun 2021 14:40:59 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99774C061574
        for <fio@vger.kernel.org>; Thu, 24 Jun 2021 11:38:39 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id x12so4038195vsp.4
        for <fio@vger.kernel.org>; Thu, 24 Jun 2021 11:38:39 -0700 (PDT)
MIME-Version: 1.0
From: Sunil Vettukalppurathu <sunilvm@gmail.com>
Date: Thu, 24 Jun 2021 11:38:27 -0700
Message-ID: <CAP6uPsW0SF-0BuLkx8aC8X9xuqju4C-+9wknxMP3JiOqB6_QRg@mail.gmail.com>
Subject: random buffer_compress_percentage instead of static
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

Currently we can=E2=80=99t vary % of compressible data from block to block =
(as
far as I know). The value provided  for buffer_compress_percentage is
used for all blocks.

"""
buffer_compress_percentage=3Dint
If this is set, then fio will attempt to provide I/O buffer content
(on WRITEs) that compresses to the specified
level. Fio does this by providing a mix of random data followed by
fixed pattern data. """

As we have a requirement to test with random compression %, we
modified the code to accept a range of values for
buffer_compress_percentage instead of one number so that the
percentage changes from block to block =E2=80=93 random value between min a=
nd
max.

Not sure if  it=E2=80=99s useful for others; if so, will send the patch for=
 review.

Thanks,
--Sunil

