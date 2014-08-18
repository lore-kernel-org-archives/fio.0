Return-Path: <fio-owner@vger.kernel.org>
Received: from mailsrv.s3group.com ([193.120.90.35]:43506 "EHLO
	mailsrv.s3group.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbaHRPqS (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 18 Aug 2014 11:46:18 -0400
Message-ID: <53F21FC4.1010404@s3group.com>
Date: Mon, 18 Aug 2014 16:46:12 +0100
From: John OCallaghan <john.ocallaghan@s3group.com>
MIME-Version: 1.0
Subject: Re: fio usage question
References: <53F215C5.5050207@s3group.com> <53F21DE3.9030402@nellans.org>
In-Reply-To: <53F21DE3.9030402@nellans.org>
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: David Nellans <david@nellans.org>, fio@vger.kernel.org



Thanks David, am not using verify but am curious how this can get affected.

Would it be that job configs that use the same file names would clobber
one anothers data on disk? I could see how that would be an issue for
multi process fio instances alright.




On 18/08/14 16:38, David Nellans wrote:
> On 08/18/2014 10:03 AM, John OCallaghan wrote:
>>
>> Hi All
>>
>> A question on usage of fio. I would like to be able to spin up more than
>> one fio instance running on the same platform concurrently.
>>
>> For example, I would like to run one fio instance in time_based mode
>> doing some stuff. And after a fixed period of time then start a non-time
>> based fio instance doing some other stuff.
>>
>> I have tried it out and to my untrained eyes it looks like its going OK.
>> But I'd love to hear from others with more experience in this area. Is
>> this something that is recommended?
>>
>> Will my data skew in some way because fio expects there to be only one
>> instance of itself playing at any one time?
>>
>> Any advice would be much appreciated!
>>
> Different processes shouldn't run into any issues unless you're doing a
> job with
> verification in which case you'll end up with verify errors due to jobs
> overwriting each
> other's data.
> 
> Unless you want to use multiple processes for some reason versus jobs
> inside a single
> process - you can delay one of your multiple jobs starting using the
> startdelay=N
> parameter in the jobfile.
-----

The information contained in this e-mail and in any attachments is confidential and is designated solely for the attention of the intended recipient(s). If you are not an intended recipient, you must not use, disclose, copy, distribute or retain this e-mail or any part thereof. If you have received this e-mail in error, please notify the sender by return e-mail and delete all copies of this e-mail from your computer system(s). Please direct any additional queries to: communications@s3group.com. Thank You. Silicon and Software Systems Limited (S3 Group). Registered in Ireland no. 378073. Registered Office: South County Business Park, Leopardstown, Dublin 18.

