Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-by2on0064.outbound.protection.outlook.com ([207.46.100.64]:62592
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933116AbbIVRDP convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 22 Sep 2015 13:03:15 -0400
From: Vincent Fu <Vincent.Fu@sandisk.com>
Subject: Re: Latency Output Question
Date: Tue, 22 Sep 2015 15:29:27 +0000
Message-ID: <97C1DC862E22B54781ABC9E892E1331504FD6657@SACMBXIP02.sdcorp.global.sandisk.com>
References: <BLU406-EAS1200B1366C5B77840349795E0580@phx.gbl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jon Tango <cheerios123@outlook.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2015-9-19 1:33 PM, Jon Tango wrote:
> Hello All, I took a measurement with an 4k workload with a 90% mixture of
> reads and 10 % writes.
>
> The latency output in the test result is:
>
> Read lat avg=490.27
> Write lat avg=191.78
>
> Is this the correct way to calculate the latency? 490+192 is 682, and then
> 682/2?
>
> Or, do I need to account for the 90/10 distribution when I calculate
> latency?
>
> Alos, is there a way to just get one average latency output, instead of a
> separate one for read, and write?
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Use the option below to combine reads and writes in the latency output:

unified_rw_reporting=bool
        Fio normally reports statistics on a per
        data direction basis, meaning that read, write, and trim are
        accounted and reported separately. If this option is set,
        the fio will sum the results and report them as "mixed"
        instead.

________________________________

PLEASE NOTE: The information contained in this electronic mail message is intended only for the use of the designated recipient(s) named above. If the reader of this message is not the intended recipient, you are hereby notified that you have received this message in error and that any review, dissemination, distribution, or copying of this message is strictly prohibited. If you have received this communication in error, please notify the sender by telephone or e-mail (as shown above) immediately and destroy any and all copies of this message in your possession (whether hard copies or electronically stored copies).

