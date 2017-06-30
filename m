Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-000fd501.pphosted.com ([67.231.144.242]:35976 "EHLO
        mx0a-000fd501.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751778AbdF3RCO (ORCPT
        <rfc822;fio@vger.kernel.org>); Fri, 30 Jun 2017 13:02:14 -0400
From: "Forrest, Jon" <Jon.Forrest@dolby.com>
Subject: Re: Strange Uncorrectable Section Count Produced By Fio
Date: Fri, 30 Jun 2017 16:42:51 +0000
Message-ID: <e358e9567d614a21ad24827c6de4e27d@DLB-XCHPW05.dolby.net>
References: <ece2c605-f015-6479-2b3b-ad30f07b447c@dolby.com>
 <CY4PR10MB1477786895ADFF04303497739DD20@CY4PR10MB1477.namprd10.prod.outlook.com>
 <5965d266-6101-47dc-ec97-e7c8466293f2@dolby.com>
 <CALjAwxhBN_ErQePyyM3emSB6PBuhm8cNZ69YiYCR8aK74n724Q@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 6/29/2017 7:45 PM, Sitsofe Wheeler wrote:

First of all, thanks for following up on this.

> That output looks like it comes from SMART monitoring of your disks
> (i.e. you have a script regularly monitoring for changes in smartctl
> output and sending the results to logwatch or emailing you). Further,
> it looks like in your case smartctl doesn't know how to correctly
> interpret the "Offline uncorrectable sectors" value - perhaps because
> you're disks are "new" you need a more recent smartctl?

This is a newly installed CentOS 7.3 system so everything is in the
state that RedHat supplies.

> However, I'd be somewhat worried that the "Offline uncorrectable
> sectors" are changing at all. It is one of the few values that has a
> strong predictive power of a spinning disk being faulty (see
> https://www.backblaze.com/blog/what-smart-stats-indicate-hard-drive-failures/
> ) but since you're on an SSD I don't know if it's predictive power is
> as good.

If the uncorrectable error count were real, then I'd agree with
you 100%. However, since those values appear only once during the
early stages of a 24 hour fio job and don't appear again later with
higher numbers of erros, and because the ddcli interface to the flash
card shows no errors at all, I'm inclined to ignore them. The fio job
finished fine.

Jon Forrest
Dolby Labs


