Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF418C0015E
	for <fio@archiver.kernel.org>; Wed, 26 Jul 2023 08:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbjGZIzK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 26 Jul 2023 04:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbjGZIyo (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Jul 2023 04:54:44 -0400
Received: from mail.lichtvoll.de (lichtvoll.de [IPv6:2001:67c:14c:12f::11:100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305647EE6
        for <fio@vger.kernel.org>; Wed, 26 Jul 2023 01:48:03 -0700 (PDT)
Received: from 127.0.0.1 (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
        (No client certificate requested)
        by mail.lichtvoll.de (Postfix) with ESMTPSA id F1242756C61;
        Wed, 26 Jul 2023 10:47:58 +0200 (CEST)
Authentication-Results: mail.lichtvoll.de;
        auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From:   Martin Steigerwald <martin@lichtvoll.de>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: gfio and GTK-3
Date:   Wed, 26 Jul 2023 10:47:58 +0200
Message-ID: <1950739.PYKUYFuaPT@lichtvoll.de>
In-Reply-To: <817148c6-67ff-f3bd-12b0-21e2e7b03748@kernel.dk>
References: <2016694.B2NXdZ3Yii@merkaba> <817148c6-67ff-f3bd-12b0-21e2e7b03748@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi Jens.

Jens Axboe - 20.08.20, 13:52:40 CEST:
> On 8/20/20 1:43 AM, Martin Steigerwald wrote:
> > Is gfio compatible with GTK-3?
> > 
> > I am asking due to Debian wanting to get rid of GTK-2 at some time:
> > 
> > fio: depends on deprecated GTK 2: https://bugs.debian.org/967339
> > 
> > If not, are there plans to make it compatible? Or are there plans to
> > drop it instead?
> 
> I'm tempted to just drop it. gfio never really got what I consider
> finished, and I don't think it's in widespread use.
>
> Maybe I'm wrong and there are in fact people out there using it. I
> know someone had a patch at some point to convert it to gtk3, and
> if that's still the case, I would not mind applying that and making
> it continue to live in the repo.

Did anyone submit a patch for GTK-3 support in gfio?

If not, I agree, probably best to just drop it. Especially after almost 
3 years and as GTK-4 is around the corner. In case anyone would like to 
port it they can resurrect it from git history.

Best,
-- 
Martin


