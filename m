Return-Path: <fio-owner@vger.kernel.org>
Received: from smtprelay0100.hostedemail.com ([216.40.44.100]:58136 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753280Ab3KSXyH (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 19 Nov 2013 18:54:07 -0500
Message-ID: <528BF8BD.4080208@nellans.org>
Date: Tue, 19 Nov 2013 17:48:13 -0600
From: David Nellans <david@nellans.org>
MIME-Version: 1.0
Subject: Re: fio results show sequential reads and writes better for network
 block device than local block device?
References: <1384903429.33093.YahooMailNeo@web120804.mail.ne1.yahoo.com> <1384903569.45715.YahooMailNeo@web120806.mail.ne1.yahoo.com>
In-Reply-To: <1384903569.45715.YahooMailNeo@web120806.mail.ne1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "K.R Kishore" <krkishore@yahoo.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 11/19/2013 05:26 PM, K.R Kishore wrote:
> Hi
> I am trying to compare the performance of locally attached block device (SSD) with a network attached block device SSD)and I am seeing results for sequential reads and writes using that I cannot explain. The other results (random reads, writes etc) are as expected, i.e. local is better than remote.
>
> Here is my setup
> - Two machines connected back-to-back by a 10G link
> - Running RHEL 6.4 (Santiago), 2.6.32-358.6.1.el6.x86_64
> - Running nbd v2.9.20 (http://nbd.sourceforge.net/)
> - Running fio v2.1.2
> - Using identical SSD on both machines - Samsung 840 PRO, 128G
> - all 128G exported as rw volume
>
> I have my fio commands and output (only relevant portions) below. I cannot understand how the network device can have high throughput than local device. I see that when I use smaller block sizes to measure iops, the numbers are as expected (local > remote).
> Has anyone tried fio on nbd? does fio measure a transaction done when it sees the block-io request handed off to the virtual device and assume TCP will take care of completing the transaction? I can see that it might do so for posted operations such as writes, but reads?
>
> Any clues?
> thx,
> Kishore

278MB/s read bandwidth to a locally attached samsung 840 pro on 1M 
sequential reads is very low unless you have it accidentally plugged 
into a SATA 3Gb/s port instead of a 6Gb/s.  I'd sort out why you're not 
seeing 500 MB+ on this as starting point for your investigation.

Also, Sequential performance probably isn't what you want to look at for 
a long latency block device (as opposed to without the network in the 
way) as io merging could become the dominant factor for performance even 
when using large block sizes to start.

your latency data from the runs looks funny too - with the NBD latency 
being lower than the locally attached on writes, but not for reads. 
that would seem to indicate there is some buffering going on in the 
system that you're not aware of that is making your results noisy (and 
confusing)
