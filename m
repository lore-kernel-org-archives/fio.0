Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io1-f43.google.com ([209.85.166.43]:43013 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbfKLAfr (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 11 Nov 2019 19:35:47 -0500
Received: by mail-io1-f43.google.com with SMTP id c11so16716473iom.10
        for <fio@vger.kernel.org>; Mon, 11 Nov 2019 16:35:46 -0800 (PST)
MIME-Version: 1.0
From: Shivam Dhir <dhirs1@uci.edu>
Date: Mon, 11 Nov 2019 16:35:35 -0800
Message-ID: <CAKaVHqeWbV67BF1chqihOpnfwuUcgzC4M1C755C7n-JK9U52vQ@mail.gmail.com>
Subject: Logging using "write_bw_log" seems off
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi

I was trying to draw some performance graphs executing a sequence like

1 Sequential write
3 Random writes
25% trim command
3 Sequential writes

I observed a discrepancy in the bandwidth logging for last two
sequential writes.
I notice that the last two sequential writes differ by 300 MB/s but
the last individual reading of these logs indicate that the slower
sequential write actually took slightly less time to complete.
Capacity is 4TB.

Can you provide some inputs if this is a known issue?
I am using fio-2.2.10.

Thanks,
Shivam

