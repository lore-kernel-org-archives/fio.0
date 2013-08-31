Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52452 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab3HaEbX (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 31 Aug 2013 00:31:23 -0400
Date: Fri, 30 Aug 2013 22:31:19 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] Adds check for rand_seed during verify phase.
Message-ID: <20130831043119.GU21481@kernel.dk>
References: <1377552162-31741-1-git-send-email-jcasse@chromium.org>
 <1377552162-31741-2-git-send-email-jcasse@chromium.org>
 <CANEJEGuKzZeLfCoNX12Pp_4_Uj8iHjLX221c+qpYzgpWYgA-Pg@mail.gmail.com>
 <521DA341.3050707@enovance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521DA341.3050707@enovance.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@enovance.com>
Cc: Grant Grundler <grundler@chromium.org>, Juan Casse <jcasse@chromium.org>, FIO_list <fio@vger.kernel.org>

On Wed, Aug 28 2013, Erwan Velu wrote:
> On 27/08/2013 00:11, Grant Grundler wrote:
> >Jens, et al,
> >
> >In general I'm ok with this patch...just one issue I'd like to get an
> >opinion on...
> >
> I don't have the skill to make a technical review of it.
> 
> At least, I'm a great fan of well detailed commits.
> At my taste, I do like when a commit does explain what was the problem and
> what is the solution.
> 
> A single line for such commit seems a little bit light for me.

Agree. A good commit message describes the need for the change. It needs
to justify its own inclusion, so to speak. Basically it answers the key
question of why this change is needed.

-- 
Jens Axboe

