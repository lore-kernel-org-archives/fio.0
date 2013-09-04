Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37097 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761170Ab3IDULY (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 4 Sep 2013 16:11:24 -0400
Message-ID: <522793E7.9000505@kernel.dk>
Date: Wed, 04 Sep 2013 14:11:19 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: How to loop a timebased job
References: <522639CE.2030705@enovance.com> <20130903223727.GB31170@kernel.dk> <52273BF5.90109@enovance.com> <52277371.5070004@kernel.dk> <522791D4.3060201@enovance.com>
In-Reply-To: <522791D4.3060201@enovance.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@enovance.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 09/04/2013 02:02 PM, Erwan Velu wrote:
> On 04/09/2013 19:52, Jens Axboe wrote:
>> Good point, yes, that is a problem. Adding a loopbased option would
>> seem to be the best way to solve the dependency issue. 
> Ok, I'm working on this option.
> 
> Here come the kind of usage I'm thinking about :
> 
> [general]
> ....
> loop_based
> loops=5
> 
> [job_1]
> ....
> runtime=10
> 
> [job_2]
> ....
> runtime=20
> 
> 
> That lever the question on where we shall "loop" the jobs ?
> What's the preferred option regarding your experience on fio ?
> The main problem I'm facing is to reinit properly jobs between loops
> (like td->terminate or doing the start_delay,...)
> 
> Shall it be better to manage it inside thread_main() or get it outside ?

I think you want to do it inside thread_main(), similarly to how it's
done for just plain loops or timed based running. The clearing of state
between runs should take care of it.

-- 
Jens Axboe

