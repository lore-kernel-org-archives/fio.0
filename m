Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pf1-f176.google.com ([209.85.210.176]:34287 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbgIUBss (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 20 Sep 2020 21:48:48 -0400
Received: by mail-pf1-f176.google.com with SMTP id k13so7398415pfg.1
        for <fio@vger.kernel.org>; Sun, 20 Sep 2020 18:48:48 -0700 (PDT)
Subject: Re: Inconsistent Status Intervals
References: <BYAPR04MB56568021114303501613DB1AEA2D0@BYAPR04MB5656.namprd04.prod.outlook.com>
 <BYAPR04MB5656DD4B26ACBCEDD6074E82EA2D0@BYAPR04MB5656.namprd04.prod.outlook.com>
 <872c21cc-901c-9537-15be-dd1b609756e1@acm.org>
 <BYAPR04MB5656BA79FE46C0D779AEEC1AEA290@BYAPR04MB5656.namprd04.prod.outlook.com>
 <BYAPR04MB5656C2818681CB9DD399945EEA290@BYAPR04MB5656.namprd04.prod.outlook.com>
 <6036b8e0-7c85-968e-33f2-8a0407445eb0@acm.org>
 <BYAPR04MB5656F5F283A53CA86DF8A803EA290@BYAPR04MB5656.namprd04.prod.outlook.com>
 <BYAPR04MB5656B50E661238035BC380BCEA240@BYAPR04MB5656.namprd04.prod.outlook.com>
 <cdcbe4eb-1051-358f-b35f-15b19209dcaf@acm.org>
 <CH2PR04MB66205B5D7642E5FD50AAE9668A230@CH2PR04MB6620.namprd04.prod.outlook.com>
 <CH2PR04MB6620B788915918E953333A958A3F0@CH2PR04MB6620.namprd04.prod.outlook.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <313a3503-8335-999f-9e18-00f8a2152bdb@acm.org>
Date: Sun, 20 Sep 2020 18:48:45 -0700
MIME-Version: 1.0
In-Reply-To: <CH2PR04MB6620B788915918E953333A958A3F0@CH2PR04MB6620.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
List-Id: fio@vger.kernel.org
To: Siriporn Swart <Siriporn.Swart@wdc.com>, Jeffrey Lien <Jeff.Lien@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Jeff Furlong <jeff.furlong@wdc.com>, Kris Davis <Kris.Davis@wdc.com>

On 2020-09-18 12:24, Siriporn Swart wrote:
> I got addition test results from https://github.com/bvanassche/fio.   Timestamp issue is fixed when running in single job ( --numjobs=1), however on a test with multiple jobs, each logging latency at 1s, there are sporadic deltas of 0.240 - 0.250s in iops and bw log.
> Second issue, there are +1 second in lat log of the intended runtime.  I was able to recreate the problem with fio command line in below including snippet of output from my test bench.
> 
> fio --name=multijobs_noramp --filename=/dev/nvme1n1 --ioengine=libaio  --rw=randread --bs=4k --direct=1 --iodepth=64 --numjobs=4 --runtime=20m --write_iops_log=multijobs_noramp --write_lat_log=multijobs_noramp --group_reporting=1 --log_avg_msec=1000 --output=multijobs_noramp

Hi Siriporn,

Thank you for the detailed report. I have done something this weekend that I
should have done much earlier, namely analyze on the context of which thread
the latency logging happens. My conclusion is that this happens on the
context of the I/O threads. Or in other words, the sporadic deltas can't be
a side effect of the changes I made in the helper thread. If someone else
wants to work on eliminating these latency logging deltas I will be happy to
assist.

Bart.

