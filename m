Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi1-f169.google.com ([209.85.167.169]:45929 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404751AbgBNQS2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 14 Feb 2020 11:18:28 -0500
Received: by mail-oi1-f169.google.com with SMTP id v19so9881970oic.12
        for <fio@vger.kernel.org>; Fri, 14 Feb 2020 08:18:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHEKYV6osu9ZK7dZv18r8+2CXZzOc3FCcnBMPGuAUGBLjEH+JQ@mail.gmail.com>
References: <CAHEKYV6osu9ZK7dZv18r8+2CXZzOc3FCcnBMPGuAUGBLjEH+JQ@mail.gmail.com>
From: =?UTF-8?Q?Pedro_Le=C3=A3o_da_Cruz?= <pedro@quarch.com>
Date: Fri, 14 Feb 2020 16:18:27 +0000
Message-ID: <CAC1jp5JZVRvhnFGFMyfsFnVh7CPcHrUJxnxnckXG_HC0_x0OJA@mail.gmail.com>
Subject: Re: Pretty graphs
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mauricio Tavares <raubvogel@gmail.com>
Cc: fio <fio@vger.kernel.org>

I wrote an application note that parses FIO performance data in real
time(ish) and displays it in a nice virtual oscilloscope interface
(QPS): https://youtu.be/LivVBa61ox0?t=113
It currently requires a Quarch power module, but this may be waived in
the future.

Quarch's python package contains a nice parser that should make it
quite straightforward to plot FIO's data (even in real time):
https://quarch.com/products/quarchpy-python-package/
Application note: https://quarch.com/file/an-017-qps-performance-test-with-fio/
QPS: https://quarch.com/products/quarch-power-studio/

