Return-Path: <fio-owner@vger.kernel.org>
Received: from snt004-omc2s50.hotmail.com ([65.54.61.101]:63420 "EHLO
	SNT004-OMC2S50.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754109AbbIYBoP convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 24 Sep 2015 21:44:15 -0400
From: Cheerio Cheerio <cheerios123@outlook.com>
Subject: RE: Latency Output Question
Date: Fri, 25 Sep 2015 01:39:12 +0000
Message-ID: <SN1PR14MB01590B008D905E88BC64AF15E0420@SN1PR14MB0159.namprd14.prod.outlook.com>
References: <BLU406-EAS1200B1366C5B77840349795E0580@phx.gbl>
 <97C1DC862E22B54781ABC9E892E1331504FD6657@SACMBXIP02.sdcorp.global.sandisk.com>
In-Reply-To: <97C1DC862E22B54781ABC9E892E1331504FD6657@SACMBXIP02.sdcorp.global.sandisk.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <01479711C3CBF046A89B3BCA385008D9@sct-15-1-274-16-msonline-outlook-6cd53.templateTenant>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 'Vincent Fu' <Vincent.Fu@sandisk.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>



-----Original Message-----
From: Vincent Fu [mailto:Vincent.Fu@sandisk.com] 
Sent: Tuesday, September 22, 2015 10:29 AM
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
        instead..
-------------------

Thank you for the guidance. However, I have tested significantly with the
unified_rw_reporting option, and it combines them in the group data outputs
- but it does not combine read/write in the logs created with the
write_iops_log or write_lat_log command. 
When parsing the latency data from the write_lat_log outputs, should I
merely divide the results by 2, or should I use a weighted average that
reflects the read/write mixture?
Also, is there a way to get fio to combine read/write latency in the
write_lat_log outputs?

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

