Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io1-f53.google.com ([209.85.166.53]:46301 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbfAEAum (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 4 Jan 2019 19:50:42 -0500
Received: by mail-io1-f53.google.com with SMTP id v10so30861442ios.13
        for <fio@vger.kernel.org>; Fri, 04 Jan 2019 16:50:41 -0800 (PST)
MIME-Version: 1.0
References: <CAF+0mvkvfO5Te7yRk4B5x4yndbM=2e+7qMZVwo-W2ZYZVpUfOA@mail.gmail.com>
 <7d6537bd-0ac3-bb7c-f6c3-334406b1fe82@gmail.com>
In-Reply-To: <7d6537bd-0ac3-bb7c-f6c3-334406b1fe82@gmail.com>
From: Matthew Eaton <m.eaton82@gmail.com>
Date: Fri, 4 Jan 2019 16:50:29 -0800
Message-ID: <CAF+0mvmiq=1vgA3rodfik4Cm5XCR8jBnm82SifLdw58+pjuxUg@mail.gmail.com>
Subject: Re: Reporting mixed latency percentiles
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vincent Fu <vincentfu@gmail.com>
Cc: fio@vger.kernel.org

> fio has a unified_rw_reporting option that should get you what you want.
>
> In general, you would need the raw data to calculate percentiles when
> combining two datasets. This can be obtained with output-format=json+

Thanks, I knew about unified_rw_reporting but my issue was that the
min/max/average iops and bw were not getting unified.
Well I just tried again in 3.12 git and they are getting unified now lol.
Anyway thanks again for your help!

