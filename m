Return-Path: <fio-owner@vger.kernel.org>
Received: from snt004-omc1s12.hotmail.com ([65.55.90.23]:58359 "EHLO
	SNT004-OMC1S12.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754368AbbIWNAo convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 23 Sep 2015 09:00:44 -0400
From: Cheerio Cheerio <cheerios123@outlook.com>
Subject: RE: Latency Output Question
Date: Wed, 23 Sep 2015 12:52:43 +0000
Message-ID: <SN1PR14MB01590A1A1CAB7DC787AFBB89E0440@SN1PR14MB0159.namprd14.prod.outlook.com>
References: <BLU406-EAS1200B1366C5B77840349795E0580@phx.gbl>
 <97C1DC862E22B54781ABC9E892E1331504FD6657@SACMBXIP02.sdcorp.global.sandisk.com>
In-Reply-To: <97C1DC862E22B54781ABC9E892E1331504FD6657@SACMBXIP02.sdcorp.global.sandisk.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7880E4444AF70C4AB4752CBED8AA255D@sct-15-1-274-16-msonline-outlook-6cd53.templateTenant>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 'Vincent Fu' <Vincent.Fu@sandisk.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Yes, shows them together in one output for the overall test output, but in
the time-based logs it still splits them up into separate outputs even with
unified_rw_reporting.

-----Original Message-----
From: Vincent Fu [mailto:Vincent.Fu@sandisk.com] 
Sent: Wednesday, September 23, 2015 12:29 AM
To: Jon Tango <cheerios123@outlook.com>; fio@vger.kernel.org
Subject: Re: Latency Output Question

On 2015-9-19 1:33 PM, Jon Tango wrote:
> Hello All, I took a measurement with an 4k workload with a 90% mixture 
> of reads and 10 % writes.
>
> The latency output in the test result is:
>
> Read lat avg=490.27
> Write lat avg=191.78
>
> Is this the correct way to calculate the latency? 490+192 is 682, and 
> then 682/2?
>
> Or, do I need to account for the 90/10 distribution when I calculate 
> latency?
>
> Alos, is there a way to just get one average latency output, instead 
> of a separate one for read, and write?
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in the 
> body of a message to majordomo@vger.kernel.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
>
Use the option below to combine reads and writes in the latency output:

unified_rw_reporting=bool
        Fio normally reports statistics on a per
        data direction basis, meaning that read, write, and trim are
        accounted and reported separately. If this option is set,
        the fio will sum the results and report them as "mixed"
        instead.

________________________________

PLEASE NOTE: The information contained in this electronic mail message is
intended only for the use of the designated recipient(s) named above. If the
reader of this message is not the intended recipient, you are hereby
notified that you have received this message in error and that any review,
dissemination, distribution, or copying of this message is strictly
prohibited. If you have received this communication in error, please notify
the sender by telephone or e-mail (as shown above) immediately and destroy
any and all copies of this message in your possession (whether hard copies
or electronically stored copies).

