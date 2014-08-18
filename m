Return-Path: <fio-owner@vger.kernel.org>
Received: from smtprelay0108.hostedemail.com ([216.40.44.108]:36118 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751773AbaHRPoa (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 18 Aug 2014 11:44:30 -0400
Received: from smtprelay.hostedemail.com (ff-bigip1 [10.5.19.254])
	by smtpgrave06.hostedemail.com (Postfix) with ESMTP id 13D46173451
	for <fio@vger.kernel.org>; Mon, 18 Aug 2014 15:38:28 +0000 (UTC)
Message-ID: <53F21DE3.9030402@nellans.org>
Date: Mon, 18 Aug 2014 10:38:11 -0500
From: David Nellans <david@nellans.org>
MIME-Version: 1.0
Subject: Re: fio usage question
References: <53F215C5.5050207@s3group.com>
In-Reply-To: <53F215C5.5050207@s3group.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: John OCallaghan <john.ocallaghan@s3group.com>, fio@vger.kernel.org

On 08/18/2014 10:03 AM, John OCallaghan wrote:
>
> Hi All
>
> A question on usage of fio. I would like to be able to spin up more than
> one fio instance running on the same platform concurrently.
>
> For example, I would like to run one fio instance in time_based mode
> doing some stuff. And after a fixed period of time then start a non-time
> based fio instance doing some other stuff.
>
> I have tried it out and to my untrained eyes it looks like its going OK.
> But I'd love to hear from others with more experience in this area. Is
> this something that is recommended?
>
> Will my data skew in some way because fio expects there to be only one
> instance of itself playing at any one time?
>
> Any advice would be much appreciated!
>
Different processes shouldn't run into any issues unless you're doing a 
job with
verification in which case you'll end up with verify errors due to jobs 
overwriting each
other's data.

Unless you want to use multiple processes for some reason versus jobs 
inside a single
process - you can delay one of your multiple jobs starting using the 
startdelay=N
parameter in the jobfile.
