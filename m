Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ot1-f48.google.com ([209.85.210.48]:36727 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbgBNPlk (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 14 Feb 2020 10:41:40 -0500
Received: by mail-ot1-f48.google.com with SMTP id j20so9552741otq.3
        for <fio@vger.kernel.org>; Fri, 14 Feb 2020 07:41:40 -0800 (PST)
MIME-Version: 1.0
From: Mauricio Tavares <raubvogel@gmail.com>
Date: Fri, 14 Feb 2020 10:41:28 -0500
Message-ID: <CAHEKYV6osu9ZK7dZv18r8+2CXZzOc3FCcnBMPGuAUGBLjEH+JQ@mail.gmail.com>
Subject: Pretty graphs
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Somewhat-related fio question: how do you make graphs of you results?
For instance, I would like to show, say iops for 4K from write,
randwrite, read, randread on the same drive comparing fio+libaio,
fio+spdk, spdk+perf. This smells like a 3D graph thingie, but my lack
of skills on excel/libre office does not help me. gnuplot?

