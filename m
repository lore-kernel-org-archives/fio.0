Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pj1-f50.google.com ([209.85.216.50]:35278 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbgIXBMR (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 23 Sep 2020 21:12:17 -0400
Received: by mail-pj1-f50.google.com with SMTP id jw11so682961pjb.0
        for <fio@vger.kernel.org>; Wed, 23 Sep 2020 18:12:17 -0700 (PDT)
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
 <313a3503-8335-999f-9e18-00f8a2152bdb@acm.org>
 <BYAPR04MB5656202B6D075BA5A7F157BFEA380@BYAPR04MB5656.namprd04.prod.outlook.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <2c9fed07-7ded-2b09-a214-ef876eea39c9@acm.org>
Date: Wed, 23 Sep 2020 18:12:14 -0700
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB5656202B6D075BA5A7F157BFEA380@BYAPR04MB5656.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
List-Id: fio@vger.kernel.org
To: Jeffrey Lien <Jeff.Lien@wdc.com>, Siriporn Swart <Siriporn.Swart@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Jeff Furlong <jeff.furlong@wdc.com>, Kris Davis <Kris.Davis@wdc.com>

On 2020-09-23 10:07, Jeffrey Lien wrote:
> Hi Bart,
> I would be willing to work on the latency logging issue in the IO threads, but don't know where to start.  Do you know which parts and/or functions to start looking at?  

Hi Jeff,

Please take a look at add_lat_sample() and add_clat_sample() in stat.c. I
think these are called from the I/O path (account_io_completion()). The
__add_log_sample() function is called by these functions and records a
sample in a data structure.
 Bart.

