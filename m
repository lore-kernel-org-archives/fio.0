Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:45072 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964796AbeFNDgo (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 13 Jun 2018 23:36:44 -0400
Received: by mail-io0-f177.google.com with SMTP id l25-v6so5688431ioh.12
        for <fio@vger.kernel.org>; Wed, 13 Jun 2018 20:36:44 -0700 (PDT)
MIME-Version: 1.0
References: <DE927C68B458BE418D582EC97927A9287FF90FB2@ORSMSX113.amr.corp.intel.com>
In-Reply-To: <DE927C68B458BE418D582EC97927A9287FF90FB2@ORSMSX113.amr.corp.intel.com>
From: Matthew Eaton <m.eaton82@gmail.com>
Date: Wed, 13 Jun 2018 20:36:32 -0700
Message-ID: <CAF+0mvnvnzErPj_a=xH3_xPUaDS6=pQDber8MK=4MLBhRAir5Q@mail.gmail.com>
Subject: Re: latency percentiles labels in fio minimal output
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: joseph.r.gruher@intel.com
Cc: fio@vger.kernel.org

> The reason this is problematic is when doing something like pasting the minimal output into a spreadsheet and then charting the output data I now don't have numerical values for the latency percentiles, I have these text strings instead.  Instead of:
>
> 99.000000%=28704;99.500000%=28966;99.900000%=29229;99.950000%=29491;99.990000%=32112
>
> It seems it would be much more useful if it just printed like this:
>
> 28704,28966,29229,29491,32112

If you must use terse output there is a messy solution:
sed -i 's/;/,/g;s/=/,/g' output.csv
