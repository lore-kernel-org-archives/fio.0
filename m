Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pg1-f174.google.com ([209.85.215.174]:44629 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgIEETM (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 5 Sep 2020 00:19:12 -0400
Received: by mail-pg1-f174.google.com with SMTP id 7so5302915pgm.11
        for <fio@vger.kernel.org>; Fri, 04 Sep 2020 21:19:11 -0700 (PDT)
From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: Inconsistent Status Intervals
References: <BYAPR04MB56568021114303501613DB1AEA2D0@BYAPR04MB5656.namprd04.prod.outlook.com>
 <BYAPR04MB5656DD4B26ACBCEDD6074E82EA2D0@BYAPR04MB5656.namprd04.prod.outlook.com>
Message-ID: <872c21cc-901c-9537-15be-dd1b609756e1@acm.org>
Date: Fri, 4 Sep 2020 21:19:09 -0700
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB5656DD4B26ACBCEDD6074E82EA2D0@BYAPR04MB5656.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeffrey Lien <Jeff.Lien@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Siriporn Swart <Siriporn.Swart@wdc.com>, Jeff Furlong <jeff.furlong@wdc.com>, Kris Davis <Kris.Davis@wdc.com>

On 2020-09-04 13:16, Jeffrey Lien wrote:
> An issue with fio version 3.20 was reported to me by our performance team where the status intervals for the iops and bw values gradually increase over the run time of the job.  Eventually, the delta gets large enough that it causes issues with the python script that formats and summarizes the fio output.  I included an example of the output at the bottom of this email.
> 
> I found this commit from Bart in version 3.18 that introduces the status interval variability:
> https://github.com/axboe/fio/commit/31eca641ad91634e5ffcf369cd756b0506a700c1
> And then this commit from Vincent that makes it better but doesn't completely resolve the issue:
> https://github.com/axboe/fio/commit/0f77d30d90b809fbf233b9474cc5d17c6bf73541
> 
> I looked at both of these patches but am not familiar enough with the fio code to know how best to resolve the issue.  Does anyone have any suggestions on what could be done to make the status intervals consistent?  

A candidate fix is available on the master branch of
https://github.com/bvanassche/fio. If the fix on that branch
helps I will send a pull request to Jens.

Thanks,

Bart.

