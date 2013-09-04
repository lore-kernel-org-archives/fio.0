Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:34382 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964946Ab3IDRwy (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 4 Sep 2013 13:52:54 -0400
Message-ID: <52277371.5070004@kernel.dk>
Date: Wed, 04 Sep 2013 11:52:49 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: How to loop a timebased job
References: <522639CE.2030705@enovance.com> <20130903223727.GB31170@kernel.dk> <52273BF5.90109@enovance.com>
In-Reply-To: <52273BF5.90109@enovance.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@enovance.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 09/04/2013 07:56 AM, Erwan Velu wrote:
> On 04/09/2013 00:37, Jens Axboe wrote:
>> It should work, if it doesn't, I agree it's a bug. It's not certain
>> than anyone has considered this specific use case before. Feel free to
>> fix! Or I can take a look at it tomorrow. 
> I think I found the issue but my main question is about priority.
> 
> If both time & loops are set, what shall be considered as the key
> element to stop the benchmark.
> 
> Today, time have the priority over loops as keep_running() returns if
> time_based while time is handled in do_io().
> 
> If I do remove this test in keep_running, the first of the two getting
> the limit will stop the job.
> On one hand, we have timebased option to insure time over end of device.
> Shall we put a loopbased on the other hand ?

Good point, yes, that is a problem. Adding a loopbased option would seem
to be the best way to solve the dependency issue.

-- 
Jens Axboe

