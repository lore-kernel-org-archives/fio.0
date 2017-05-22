Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:34786 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759935AbdEVWci (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 22 May 2017 18:32:38 -0400
Received: by mail-ua0-f181.google.com with SMTP id u10so68085321uaf.1
        for <fio@vger.kernel.org>; Mon, 22 May 2017 15:32:33 -0700 (PDT)
MIME-Version: 1.0
From: Matthew Eaton <m.eaton82@gmail.com>
Date: Mon, 22 May 2017 15:32:27 -0700
Message-ID: <CAF+0mvkqR953QypN3dRxuiG4fgbQxoMsGfft2YpZezfc0M4spg@mail.gmail.com>
Subject: SSD Test Recommendation
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi guys,

I want to run a quality of service test on SSDs with bs=4k and bs=8k
but I need some help.
I'm wondering if it's okay to test both 4k then 8k like this:

purge
precondition with 128k write
run 4k read test
run 8k read test
precondition to steady state with 4k write
run 4k write test
run 8k write test

Will the 8k test results be invalid due to the 4k write history?

Thanks!
