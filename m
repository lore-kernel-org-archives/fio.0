Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:35166 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752703AbcHXRcD (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 24 Aug 2016 13:32:03 -0400
Received: by mail-qk0-f180.google.com with SMTP id v123so21924935qkh.2
        for <fio@vger.kernel.org>; Wed, 24 Aug 2016 10:32:03 -0700 (PDT)
MIME-Version: 1.0
From: Karl Cronburg <kcronbur@redhat.com>
Date: Wed, 24 Aug 2016 13:32:01 -0400
Message-ID: <CAJ9yE1D8JXLgmbmx5_PXfiPM33vHyMZpVTK4sAinccEvMKX8yg@mail.gmail.com>
Subject: client/server histograms
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

What would be the best way to get an fio server to send the histogram
samples to a client? i.e.:

- Should I make a new FIO_NET_CMD or can I easily modify the existing
IOLOG one? Presently each sample has a pointer to a histogram array in
place of the sample value.

- The histograms compress nicely (because sparseness), but should I be
compressing them immediately after compressing the time/direction/size
values of the sample? I tried doing it after all the io_sample structs
are compressed, but then samples in one pdu need the histogram values
in a not-yet-parsed pdu.

-Karl Cronburg-
