Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43685 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760947Ab3ICWiz (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 3 Sep 2013 18:38:55 -0400
Date: Tue, 3 Sep 2013 16:38:52 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] Adds check for rand_seed during verify phase.
Message-ID: <20130903223852.GD31170@kernel.dk>
References: <1377552162-31741-1-git-send-email-jcasse@chromium.org>
 <1377552162-31741-2-git-send-email-jcasse@chromium.org>
 <CANEJEGuKzZeLfCoNX12Pp_4_Uj8iHjLX221c+qpYzgpWYgA-Pg@mail.gmail.com>
 <521DA341.3050707@enovance.com>
 <20130831043119.GU21481@kernel.dk>
 <52244E75.5070405@enovance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52244E75.5070405@enovance.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@enovance.com>
Cc: Grant Grundler <grundler@chromium.org>, Juan Casse <jcasse@chromium.org>, FIO_list <fio@vger.kernel.org>

On Mon, Sep 02 2013, Erwan Velu wrote:
> On 31/08/2013 06:31, Jens Axboe wrote:
> >[...]
> >Agree. A good commit message describes the need for the change. It needs
> >to justify its own inclusion, so to speak. Basically it answers the key
> >question of why this change is needed.
> >
> 
> I don't know how you play with fio, but on my project I'm working on, that's
> a good reason to refuse a patch even if the code is correct :o)

I tend to be (too) nice and provide the missing commit log, especially
if it's for a feature and needs a description. But I have been known to
push back as well and just ask for a description. Usually has not been a
problem.

-- 
Jens Axboe

