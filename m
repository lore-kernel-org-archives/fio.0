Return-Path: <fio-owner@vger.kernel.org>
Received: from smtprelay0125.hostedemail.com ([216.40.44.125]:52703 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753959Ab3K0WLd (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 27 Nov 2013 17:11:33 -0500
Message-ID: <52966E21.6020607@nellans.org>
Date: Wed, 27 Nov 2013 16:11:45 -0600
From: David Nellans <david@nellans.org>
MIME-Version: 1.0
Subject: Re: fio results show sequential reads and writes better for network
 block device than local block device?
References: <1384903429.33093.YahooMailNeo@web120804.mail.ne1.yahoo.com> <1384903569.45715.YahooMailNeo@web120806.mail.ne1.yahoo.com> <528BF8BD.4080208@nellans.org> <1384913761.82415.YahooMailNeo@web120803.mail.ne1.yahoo.com>
In-Reply-To: <1384913761.82415.YahooMailNeo@web120803.mail.ne1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "K.R Kishore" <krkishore@yahoo.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Yes 3.0Gb/s means that you're only getting 1/2 the throughput from that 
particular drive as it should be able to give you - if they're not 
recognized as 6Gb ports then something in the bios might need to be 
swizzled, upgraded, something...

You say you ran random tests as well already - does the same result hold 
for random as sequential?  The NBD still gives you higher throughput 
than the native device?  while you certainly could have a really high 
latency SAS/SATA controller it seems unlikely that nbd could
both do a network round trip + get through the userspace ndb-client in
a lower latency than the local controller.

doing synchronous q-depth one, I/O's of a small block (512) will give 
you a good picture on the minimum latency you can get from the local 
controller versus the ndb based disk to try and sort out the latency issue.


On 11/19/2013 08:16 PM, K.R Kishore wrote:
>
>
> David
> Thanks for the response..
>
>
>
>> 278MB/s read bandwidth to a locally attached samsung 840 pro on 1M
>> sequential reads is very low unless you have it accidentally plugged
>> into a SATA 3Gb/s port instead of a 6Gb/s.  I'd sort out why you're not
>> seeing 500 MB+ on this as starting point for your investigation.
>
> I thought this was a good catch..so I tried
> hdparm -I /dev/sdb|egrep -i "Model|speed" and I get the same on both machines..
>
>
> [root@lab-sj1-141 uc]# hdparm -I /dev/sdb|egrep -i "Model|speed"
>      Model Number:       Samsung SSD 840 PRO Series
>             *    Gen1 signaling speed (1.5Gb/s)
>             *    Gen2 signaling speed (3.0Gb/s)
> [root@lab-sj1-141 uc]#
>
> Does this imply they are running @3.0Gb/s with a peak rate of 300MB/s?
> I am using Dell Precision workstation T3600 and according to the specs it has 6G SAS ports which is where these drives are connected. I am not sure if this needs to be enabled some way. I rebooted and went through BIOS setting and did not see anything in the drives/storage sections.
>
> I ran the test on both machines and both got ~279MB/s for sequential reads. This does not explain why fio gives a higher number when one of the drives is exported over the network?!
>
>> Also, Sequential performance probably isn't what you want to look at for
>> a long latency block device (as opposed to without the network in the
>> way) as io merging could become the dominant factor for performance even
>> when using large block sizes to start.
>
> Your point noted. I ran all combinations of tests (read,write,readwrite,randread,randwrite,randrw) and did so with 1M and 512. I was looking for some consistency and trying to quantify the effect of latency on performance.
>
>
>> your latency data from the runs looks funny too - with the NBD latency
>> being lower than the locally attached on writes, but not for reads.
>> that would seem to indicate there is some buffering going on in the
>> system that you're not aware of that is making your results noisy (and
>> confusing)
>
>
> I agree that the latency number is confusing. I am trying to understand how fio is measuring the latency for a NBD and maybe that will help sort this out.
>
> thx,
> Kishore
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

