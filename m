Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD22C05027
	for <fio@archiver.kernel.org>; Fri, 10 Feb 2023 17:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbjBJRbb (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 10 Feb 2023 12:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbjBJRba (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Feb 2023 12:31:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CB5749A4
        for <fio@vger.kernel.org>; Fri, 10 Feb 2023 09:31:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01874B82566
        for <fio@vger.kernel.org>; Fri, 10 Feb 2023 17:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3309CC433EF;
        Fri, 10 Feb 2023 17:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676050284;
        bh=WB+lOUwaN4TxOtkZMvG2z8V1aYW2cANatrHZg2YPpsY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=smuYS04S4o1i+s7e6/cSsnHvZSmFgukN9dezKsr3SIprMwnz6uXD4jEt6BmFEecJd
         7EbNrCHcRiZPMPmmWw5Eq8owS2BU6yYLvY0gq0nnAUDTvSbLFKKs/yJJelAMyBzJFZ
         QjLX/HPRVjq25AQKpvgIVYTA6U4wludETffSd6FFGAoh3I+Wx10GYertzlH9YoUM68
         h3FQ/FXHjFWxSygCYNzN8rGMwZalutk+mOEmYGbkLuVFr3+ebDzFNHoHyD3aXY7I9P
         PfkH82A9hwYN6iRK2B0gVkIIVO0YMnkFq/gqCj06hzK3j9zxQau1pRa7z2CzjjlL8j
         WjESZ2P0NqJmg==
Date:   Fri, 10 Feb 2023 10:31:19 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Klaus Jensen <its@irrelevant.dk>
Cc:     Keith Busch <kbusch@meta.com>, fio@vger.kernel.org,
        axboe@kernel.dk, damien.lemoal@opensource.wdc.com,
        vincentfu@gmail.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: Re: [PATCHv2] fio: add fdp support for io_uring_cmd nvme engine
Message-ID: <Y+Z/Z0LAuKyc+ZWr@kbusch-mbp.dhcp.thefacebook.com>
References: <20230209171236.1113887-1-kbusch@meta.com>
 <Y+X9XZjsdwz9GpLM@cormorant.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+X9XZjsdwz9GpLM@cormorant.local>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Feb 10, 2023 at 09:16:29AM +0100, Klaus Jensen wrote:
> On Feb  9 09:12, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > Add support for NVMe TP4146 Flexible Data Placemen, allowing placement
> > identifiers in write commands. The user can enabled this with the new
> > "fdp=1" parameter for fio's io_uring_cmd ioengine. By default, the fio
> > jobs will cycle through all the namespace's available placement
> > identifiers for write commands.
> 
> Technically, the namespace has Placement *Handles* associated and when
> writing, a Placement *Identifier* is used to also specify the Reclaim
> Group.

Yep. The details can get a bit confusing, but the placement id is really all
fio needs to construct the write command.
 
> > The user can limit which placement
> > identifiers can be used with additional parameter, "fdp_plis=<list,>",
> > which can be used to separate write intensive jobs from less intensive
> > ones.
> 
> With the above in mind, it might make sense to align with the spec and
> call this "fdp_pids" instead. 

In this implementation, you're just specifying the indices from which to pull
the pids rather than providing a direct list of them, so didn't want to call it
"pids".

> As far as I can tell, fio won't cycle through reclaim groups and create the
> pid on its own, without fdp_plis explicitly indicating it?

If you don't specify any, fio will use all the placement identifiers. The code
handling that in this patch is bit subtle.
