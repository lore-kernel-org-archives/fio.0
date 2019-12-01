Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f52.google.com ([209.85.221.52]:43112 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbfLANK2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 1 Dec 2019 08:10:28 -0500
Received: by mail-wr1-f52.google.com with SMTP id n1so40758957wra.10
        for <fio@vger.kernel.org>; Sun, 01 Dec 2019 05:10:25 -0800 (PST)
MIME-Version: 1.0
From: Roy Shterman <roys@lightbitslabs.com>
Date: Sun, 1 Dec 2019 15:10:13 +0200
Message-ID: <CACDtTTE-nixBkdVL_NiAviYkAfFxA6yEBb1Ey0HwvWficcMtpw@mail.gmail.com>
Subject: Question regarding load/save_verify state
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Ronen Weiss <ronen@lightbitslabs.com>, Sagi Grimberg <sagi@lightbitslabs.com>

Hi,

I'm running fio job with trigger, and using load/save_verify_state to
run verify phase afterwards.
Both write and read have the same offsets and sizes and both are using
non random patterns.
From time to time I see that the fio read verify actually reads
offsets bigger than the latest offset in the file saved during write
phase.

Both workloads are running with iodepth of 300, I wonder if the
iodepth affect somehow the end offset during read phase?

Could it be that fio during read is reading from last_sector_written + iodepth?

Thanks,
Roy

