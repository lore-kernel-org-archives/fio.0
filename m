Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C680BC433FE
	for <fio@archiver.kernel.org>; Mon, 10 Oct 2022 06:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiJJGv1 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 10 Oct 2022 02:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbiJJGvY (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 10 Oct 2022 02:51:24 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD351149
        for <fio@vger.kernel.org>; Sun,  9 Oct 2022 23:51:24 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id hh9so5995876qtb.13
        for <fio@vger.kernel.org>; Sun, 09 Oct 2022 23:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zhYQrvtaSeK+nEL1XUnKd1XlSyT9LqhUy5ORgmAOO2k=;
        b=Uv5IPphI1js2foaqN0ZMDYhtNJYxiCR3+OA/CyML0QvjBAfPm5T7gCSgx1rWLin/IZ
         0CwICWWTR4NdLUmvf/TzblntGy7xWzxA1B+m3vG3IHiUA7M2AnpEGMGreYUpl8JDnpdt
         m9c98GWUtHVh2EWWedzucgsO/jcV9zCWD3qeeMGnRbqgfjqek+8Ek6iWVhFX4QP4XBaZ
         doJNeilITqgwVShoW7XhC+RDAQVtFItIyLM8liFYzuR8XEH2dTujnWovawjPgEaPC1/A
         5ZFVQo4HMAvFN+VhsfdN3bCLSgcq9HSRrbrIx/9OAYNwnGHnM33JWMvm5G/e2k0a4r6d
         Om5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zhYQrvtaSeK+nEL1XUnKd1XlSyT9LqhUy5ORgmAOO2k=;
        b=j1lwXqHdQSqrO5UZPj2dVxwdZhlz1MhTfQLqJUa519RD+MxZ02nOEkz8EvUCcsJV9U
         00PsEipFvXUGkDgPgMzML85doviJZ/kmEARKzCji7lPiamQDaU1aIVSfXzBrF/zxEpN8
         7jtyBFI0ILbcW8C3nyREs2SqAUBMqqUxtNGOtaypTn1gCAfF5Jm8T16M3TRebL0iC9Ur
         psgwfFcPLRaeRWNbkVKe46WPrfY5Vpnr7XEo0enhCzH3vbGkIua6rsmgpxc8WVzzc8i2
         ZysoHjNNYgtUZyZ7vK9kISOMGgKFxmppFnNC6FdxudbMjTFuoKaYdIKSF77DmHcl7XFD
         ANJQ==
X-Gm-Message-State: ACrzQf0hP3yj1p5vm7HTDqMGQUlVyGlsJotu6kRGhRyeLKfwISlVUjdQ
        HTQZCVXvMVA5E1VulxqUjCQ=
X-Google-Smtp-Source: AMsMyM4CzHfPrppLPrztrtHVZSS2UgvWNTzWpMlGK4jx4eDMet6fBTDPc7wDQ5J+7Hqmf0ncddACfQ==
X-Received: by 2002:a05:622a:10c:b0:35d:4d0f:fead with SMTP id u12-20020a05622a010c00b0035d4d0ffeadmr13625444qtw.325.1665384683229;
        Sun, 09 Oct 2022 23:51:23 -0700 (PDT)
Received: from localhost ([185.206.224.42])
        by smtp.gmail.com with ESMTPSA id m14-20020a05620a290e00b006cf19068261sm9636822qkp.116.2022.10.09.23.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Oct 2022 23:51:22 -0700 (PDT)
Date:   Mon, 10 Oct 2022 08:51:19 +0200
From:   Pankaj Raghav <pankydev8@gmail.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Pankaj Raghav <p.raghav@samsung.com>, fio@vger.kernel.org,
        gost.dev@samsung.com
Subject: Re: [PATCH] examples: uring-cmd-zoned: expand the reasoning behind
 QD1
Message-ID: <20221010065119.3l4vrmh2wqciibz3@quentin>
References: <CGME20221007120530eucas1p16e2b45344e7148a39789645352a5aba8@eucas1p1.samsung.com>
 <20221007120528.58106-1-p.raghav@samsung.com>
 <aeb87504-4427-0ecd-2527-35ed0f881418@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeb87504-4427-0ecd-2527-35ed0f881418@opensource.wdc.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi Damien,
> > +# NOTE:
> > +# Regular writes against a zone should be limited to QD1, as the device can
> > +# reorder the requests.
> > +#
> > +# As the passthrough path do not use an IO scheduler (such as mq-deadline),
> > +# the queue depth should be limited to 1 to avoid zone invalid writes.
> 
> Since all the writes issued by fio are "valid" in the first place, I would
> have phrased this: "...to avoid reordering of sequential write commands in
> the IO stack."
> 
Block IO stack does not reorder the requests with uring-cmd. As the spec 
(at least ZNS) does not guarantee the order of execution even if we submit
it in order, I expanded the comment here about device reordering the
requests.

As you said, writes issues by fio are valid, and IO stack submits the
requests in order but still we can get a WP violation because the device
can reorder the request during execution.
-- 
Pankaj
