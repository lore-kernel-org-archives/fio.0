Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ot1-f43.google.com ([209.85.210.43]:34676 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgAPPU3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 16 Jan 2020 10:20:29 -0500
Received: by mail-ot1-f43.google.com with SMTP id a15so19691146otf.1
        for <fio@vger.kernel.org>; Thu, 16 Jan 2020 07:20:28 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?Q?Pedro_Le=C3=A3o_da_Cruz?= <pedro@quarch.com>
Date: Thu, 16 Jan 2020 15:20:27 +0000
Message-ID: <CAC1jp5+ADfDMGzfqwfWwMhbap7xn=3_CLJfJpVtSA=FnuDv15A@mail.gmail.com>
Subject: Inconsistent results while running jobs with other app on background
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hi everyone, I am running FIO 3.1 on Ubuntu 18.04 testing an Intel
Optane drive. I am getting quite inconsistent results for clat
percentiles depending on whether I run a Java application on the
background or not. With the Java app, which I use to collect some
other data, I get 2-3% worst results. Is there any obvious ways to
mitigate the interference from other applications while running a FIO
job?

Thanks :)

