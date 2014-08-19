Return-Path: <fio-owner@vger.kernel.org>
Received: from mailsrv.s3group.com ([193.120.90.35]:41163 "EHLO
	mailsrv.s3group.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbaHSQXN (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 19 Aug 2014 12:23:13 -0400
Message-ID: <53F379E4.3030409@s3group.com>
Date: Tue, 19 Aug 2014 17:23:00 +0100
From: John OCallaghan <john.ocallaghan@s3group.com>
MIME-Version: 1.0
Subject: Re: runtime and status-interval
References: <53ECAAB8.7040205@s3group.com> <53EE3B4F.1090501@s3group.com> <94D0CD8314A33A4D9D801C0FE68B402958C0C317@G9W0745.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C0C317@G9W0745.americas.hpqcorp.net>
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>


Thanks Rob

I have made the suggested changes and these appear to be working OK.

John

On 18/08/14 20:54, Elliott, Robert (Server Storage) wrote:
> 
> 
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
>> Behalf Of John OCallaghan
>> Sent: Friday, 15 August, 2014 11:55 AM
>> To: fio@vger.kernel.org
>> Subject: Re: runtime and status-interval
>>
>>
>>
>> FYI I found the problem in fio/backend.c. Seems to be working fine now.
>>
>>
>> The fix I put together is this:
>>
>> 		if (td_read(td) && td->io_bytes[DDIR_READ]) {
>> 			elapsed = utime_since_now(&td->start);
>> 			td->ts.runtime[DDIR_READ] += elapsed/1000;
>> 		}
>> 		if (td_write(td) && td->io_bytes[DDIR_WRITE]) {
>> 			elapsed = utime_since_now(&td->start);
>> 			td->ts.runtime[DDIR_WRITE] += elapsed/1000;
>> 		}
>> 		if (td_trim(td) && td->io_bytes[DDIR_TRIM]) {
>> 			elapsed = utime_since_now(&td->start);
>> 			td->ts.runtime[DDIR_TRIM] += elapsed/1000;
>> 		}
> 
> 
>>
>> The problem is is that runtime is holding milliseconds but
>> utime_since_now() returns microseconds. I added the "/1000" to make the
>> conversion.
>>
>> My change is a simple fix but quite possibly there are other places
>> within fio making the same mistake?
> 
> These lines could just call mtime_since_now rather than utime_since_now.
> 
> There's one more a few lines down:
>                 fio_gettime(&td->start, NULL);
> 
>                 do_verify(td, verify_bytes);
> 
>                 td->ts.runtime[DDIR_READ] += utime_since_now(&td->start);
> 
> 
> ---
> Rob Elliott    HP Server Storage
> 
> 
> 
> 
-----

The information contained in this e-mail and in any attachments is confidential and is designated solely for the attention of the intended recipient(s). If you are not an intended recipient, you must not use, disclose, copy, distribute or retain this e-mail or any part thereof. If you have received this e-mail in error, please notify the sender by return e-mail and delete all copies of this e-mail from your computer system(s). Please direct any additional queries to: communications@s3group.com. Thank You. Silicon and Software Systems Limited (S3 Group). Registered in Ireland no. 378073. Registered Office: South County Business Park, Leopardstown, Dublin 18.

