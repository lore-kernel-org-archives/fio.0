Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56376 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab2IUMUg (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 21 Sep 2012 08:20:36 -0400
Message-ID: <505C5B7C.1060803@kernel.dk>
Date: Fri, 21 Sep 2012 14:20:12 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] core: Actually EIO is a fatal error
References: <1348225456-21811-1-git-send-email-dmonakhov@openvz.org> <505C4EB1.4090800@kernel.dk> <87haqry538.fsf@openvz.org> <505C56D2.7070209@kernel.dk> <87ehlvy3ns.fsf@openvz.org>
In-Reply-To: <87ehlvy3ns.fsf@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: fio@vger.kernel.org

On 09/21/2012 02:13 PM, Dmitry Monakhov wrote:
> On Fri, 21 Sep 2012 14:00:18 +0200, Jens Axboe <axboe@kernel.dk> wrote:
>> On 09/21/2012 01:42 PM, Dmitry Monakhov wrote:
>>> On Fri, 21 Sep 2012 13:25:37 +0200, Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 09/21/2012 01:04 PM, Dmitry Monakhov wrote:
>>>>> As soon as i understand this is just a mistype.
>>>>
>>>> It's not a typo. By that logic, EILSEQ is fatal too, since it is a
>>>> verification failure of read data (so might as well have been an EIO).
>>>> Fatal, in this context, means errors that fio can recover from and
>>>> continue doing work.
>>> Ohh i ment to say that both errors are fatal, but function called
>>
>> And I'm saying that NEITHER of them are fatal.
>>
>>> td_NON_fatal_error, and it result true in case of EIO or EILSEQ
>>> this result continue_on_error logic broken because 
>>> io_u.c 1440:
>>>        if (icd->error && td_non_fatal_error(icd->error) &&
>>>            (td->o.continue_on_error & td_error_type(io_u->ddir,
>>>            icd->error))) {
>>
>> Right, so if error and error is non-fatal, we continue on that error
>> unless told otherwise. It is logged and we continue on our business.
> Please dint get me wrong .... but please take a look more carefully
> 
> Original code: ((e) == EIO || (e) == EILSEQ)
> True for fatal errors, and false for non fatal ones
> But function called td_NON_fatal_error()
> And it should result opposite result
> 
> so my code: (!((e) == EIO || (e) == EILSEQ)) is equivalent of
>              (err != EIO) && (err != EILSEQ)

You keep not reading my point. EIO and EILSEQ are are not fatal errors!!
These are "expected" in the sense that we know what conditions trigger
them.

Also see the HOWTO, continue_on_error option.

-- 
Jens Axboe

