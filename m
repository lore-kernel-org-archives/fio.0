Return-Path: <fio-owner@vger.kernel.org>
Received: from g9t1613g.houston.hpe.com ([15.241.32.99]:26531 "EHLO
        g9t1613g.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752500AbdGAClw (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 30 Jun 2017 22:41:52 -0400
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com [15.241.140.75])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g9t1613g.houston.hpe.com (Postfix) with ESMTPS id 917EA61C9E
        for <fio@vger.kernel.org>; Sat,  1 Jul 2017 02:41:46 +0000 (UTC)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: Strange Uncorrectable Section Count Produced By Fio
Date: Sat, 1 Jul 2017 02:41:37 +0000
Message-ID: <AT5PR84MB0082BE9124E9B1AB5F4B0AC6ABD00@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
References: <ece2c605-f015-6479-2b3b-ad30f07b447c@dolby.com>
 <CY4PR10MB1477786895ADFF04303497739DD20@CY4PR10MB1477.namprd10.prod.outlook.com>
 <5965d266-6101-47dc-ec97-e7c8466293f2@dolby.com>
 <CALjAwxhBN_ErQePyyM3emSB6PBuhm8cNZ69YiYCR8aK74n724Q@mail.gmail.com>
 <e358e9567d614a21ad24827c6de4e27d@DLB-XCHPW05.dolby.net>
In-Reply-To: <e358e9567d614a21ad24827c6de4e27d@DLB-XCHPW05.dolby.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Forrest, Jon" <Jon.Forrest@dolby.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Sitsofe Wheeler <sitsofe@gmail.com>

> > However, I'd be somewhat worried that the "Offline uncorrectable
> > sectors" are changing at all. It is one of the few values that has a
> > strong predictive power of a spinning disk being faulty (see
> > https://www.backblaze.com/blog/what-smart-stats-indicate-hard-drive-
> failures/
> > ) but since you're on an SSD I don't know if it's predictive power is
> > as good.
> 
> If the uncorrectable error count were real, then I'd agree with
> you 100%. However, since those values appear only once during the
> early stages of a 24 hour fio job and don't appear again later with
> higher numbers of erros, and because the ddcli interface to the flash
> card shows no errors at all, I'm inclined to ignore them. The fio job
> finished fine.

and
> > Device: /dev/sdb [SAT], 37009733189632 Offline uncorrectable sectors
> > WARNING: Your hard drive is failing
> > Device: /dev/sdc [SAT], 54275501719552 Offline uncorrectable sectors
> > WARNING: Your hard drive is failing
> > Device: /dev/sdd [SAT], 71987946848256 Offline uncorrectable sectors

In hex, those are:
21A9_0000_0000
315D_0000_0000
4179_0000_0000

so they're clearly not real count values.  Some program might be
parsing fields incorrectly (e.g., off by 4 bytes).


---
Robert Elliott, HPE Persistent Memory


