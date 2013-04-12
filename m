Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35897
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724Ab3DLFxT (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 12 Apr 2013 01:53:19 -0400
Date: Fri, 12 Apr 2013 07:52:54 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] fix warning on 32-bit systems
Message-ID: <20130412055254.GD12244@kernel.dk>
References: <CAKCZDg=H1ry20d8sxcHaod3=Z0SfJDzj0Z4sDo2aSvnMAk=R8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKCZDg=H1ry20d8sxcHaod3=Z0SfJDzj0Z4sDo2aSvnMAk=R8A@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Aaron Carroll <xaaronc@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Fri, Apr 12 2013, Aaron Carroll wrote:
> Casting a uint64_t to a pointer emits a warning on 32 bit systems.
> This patch fixes the warning, but seems a bit suspicious. Should the
> type of 'tag' be uintptr_t ?

Thanks, applied. The tag is out of a command, so it's always 64-bits.

-- 
Jens Axboe

