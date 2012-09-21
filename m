Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:33427 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab2IUMAn (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 21 Sep 2012 08:00:43 -0400
Message-ID: <505C56D2.7070209@kernel.dk>
Date: Fri, 21 Sep 2012 14:00:18 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] core: Actually EIO is a fatal error
References: <1348225456-21811-1-git-send-email-dmonakhov@openvz.org> <505C4EB1.4090800@kernel.dk> <87haqry538.fsf@openvz.org>
In-Reply-To: <87haqry538.fsf@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: fio@vger.kernel.org

On 09/21/2012 01:42 PM, Dmitry Monakhov wrote:
> On Fri, 21 Sep 2012 13:25:37 +0200, Jens Axboe <axboe@kernel.dk> wrote:
>> On 09/21/2012 01:04 PM, Dmitry Monakhov wrote:
>>> As soon as i understand this is just a mistype.
>>
>> It's not a typo. By that logic, EILSEQ is fatal too, since it is a
>> verification failure of read data (so might as well have been an EIO).
>> Fatal, in this context, means errors that fio can recover from and
>> continue doing work.
> Ohh i ment to say that both errors are fatal, but function called

And I'm saying that NEITHER of them are fatal.

> td_NON_fatal_error, and it result true in case of EIO or EILSEQ
> this result continue_on_error logic broken because 
> io_u.c 1440:
>        if (icd->error && td_non_fatal_error(icd->error) &&
>            (td->o.continue_on_error & td_error_type(io_u->ddir,
>            icd->error))) {

Right, so if error and error is non-fatal, we continue on that error
unless told otherwise. It is logged and we continue on our business.

So I'm a little confused as to why you think the test is reverted...

> FYI right after i've changed this my test which continuously hit ENOSPC
> goes forward and provoke panic :)
> WARNING: at lib/list_debug.c:62 __list_del_entry+0x1ee/0x250()

Heh, always great to trigger kernel bugs with fio :-)

-- 
Jens Axboe

