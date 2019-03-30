Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ot1-f42.google.com ([209.85.210.42]:36022 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730666AbfC3WuF (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 30 Mar 2019 18:50:05 -0400
Received: by mail-ot1-f42.google.com with SMTP id o74so5390576ota.3
        for <fio@vger.kernel.org>; Sat, 30 Mar 2019 15:50:04 -0700 (PDT)
MIME-Version: 1.0
From: Surendar Chandra <surendar@acm.org>
Date: Sat, 30 Mar 2019 15:49:49 -0700
Message-ID: <CAKRObaZ5N=trawpfu3fj8xAP6+3mLHp8Lgo0DZ6Aac56O6epww@mail.gmail.com>
Subject: Help with HTTP engine with S3
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I’m following the example script to use http driver for S3. My write script is:

[create]
filename=/data.dat
rw=readwrite
bs=2m
size=50g
io_size=10m

The PUT goes to /data.dat_0_2097152 signifying offset (0) and
xfer_buflen of 2M. Except, AWS seems to create the file
/data.dat_0_2097152. How do I make AWS understand this format?
Shouldn’t we be using RANGE requests?

Thanks much

