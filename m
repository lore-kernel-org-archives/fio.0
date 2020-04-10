Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ed1-f44.google.com ([209.85.208.44]:41386 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbgDJDeL (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Apr 2020 23:34:11 -0400
Received: by mail-ed1-f44.google.com with SMTP id v1so869113edq.8
        for <fio@vger.kernel.org>; Thu, 09 Apr 2020 20:34:09 -0700 (PDT)
MIME-Version: 1.0
From: Shridhar Sahukar <shridhar.sahukar2@gmail.com>
Date: Thu, 9 Apr 2020 20:33:56 -0700
Message-ID: <CAD7DgVVmfHVZg6s8H9sDyMGrg-fx5KBhbE8v73hV=Gn=MG1e7A@mail.gmail.com>
Subject: what is the unit for usr_cpu and sys_cpu in fio3.16? Inbox x
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

I have a bunch of benchmark results from fio-3.16 in json format and I
am unable to find the units for sys_cpu and usr_cpu fields.

For example, the output shows

"sys_cpu": 1.560156
"usr_cpu": 0.420997

Is this in seconds?

Thanks,
Shridhar

