Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:52573 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334Ab1FQHOc (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 17 Jun 2011 03:14:32 -0400
Message-ID: <4DFAFED6.3070305@kernel.dk>
Date: Fri, 17 Jun 2011 09:14:30 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH v2] Add ability to invoke fallocate() FALLOC_FL_KEEP_SIZE.
References: <1308080427-31011-1-git-send-email-egouriou@google.com> <1308257826-3342-1-git-send-email-egouriou@google.com>
In-Reply-To: <1308257826-3342-1-git-send-email-egouriou@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Eric Gouriou <egouriou@google.com>
Cc: fio@vger.kernel.org, Nauman Rafique <nauman@google.com>, Daniel Ehrenberg <dehrenberg@google.com>

On 2011-06-16 22:57, Eric Gouriou wrote:
> Hi Jens, all,
> 
> This is version 2 of the patch submitted earlier this week. Compared
> to the initial version I removed the "fallocate_keep_size" option and,
> as suggested, changed "fallocate" to be a string option. I elected
> to provide both descriptive and numeric compatibility values for the
> old boolean values. Let me know if you disagree with that choice.
> 
> I removed the weak version of fallocate(). It is not required at this
> point and not having it removed the problem of figuring what semantics
> it should have if invoked.
> 
> As always, feedback is appreciated.

Thanks Eric, this looks good! Applied.

-- 
Jens Axboe

