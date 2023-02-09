Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B46C61DA4
	for <fio@archiver.kernel.org>; Thu,  9 Feb 2023 16:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjBIQVc (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Feb 2023 11:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjBIQVc (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Feb 2023 11:21:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDA45C4B2
        for <fio@vger.kernel.org>; Thu,  9 Feb 2023 08:21:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E694BB821AC
        for <fio@vger.kernel.org>; Thu,  9 Feb 2023 16:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA0BC433EF;
        Thu,  9 Feb 2023 16:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675959687;
        bh=gDCQP3k7ugJN5Odw58dCv5LSViWavDS4+PZD+Mly8jU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tYSbfOgP5QuHJotF58fT7/lbOUDI+7oQMO58/mqy6QeU58mv4TnC2xlDdopKoO6Oo
         xzEUF+L+3YlWAhn/twavYb2pKb+YnaTd6ubTY4x3Bi1G+v5/lM58XkWvHkIyxxri/Z
         43+7T785VNA9nHHQ0/VQb07tcqGPXOs7FeeoWPHo+pnDhh3QRkFvQvGZzTdlkjOVed
         /bbjFR4BbKrK4Lh68y/5br5b/koXmfszsnCbGMN33NmuY3ieT1GhbAg9J/0CHBi5Hn
         xHv+tO7rYTvyyJWwxkQuGtRK4+OHkzZm/wTzFNK0UsHjyp2NiMcfMEIVTj3AeYzXlW
         7Zp7Gq4Fiomew==
Date:   Thu, 9 Feb 2023 09:21:24 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Ankit Kumar <ankit1455@gmail.com>
Cc:     Keith Busch <kbusch@meta.com>, fio@vger.kernel.org,
        axboe@kernel.dk, its@irrelevant.dk,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: Re: [PATCH] fio: add nvme fdp support for io_uring_cmd engine
Message-ID: <Y+UdhHrjGgSvlEkA@kbusch-mbp.dhcp.thefacebook.com>
References: <20230208222023.895024-1-kbusch@meta.com>
 <CAKi7+wdtsrm=NtJceiJ-a5Agg0AJpQB-eSLLyGETvi54jeCaWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKi7+wdtsrm=NtJceiJ-a5Agg0AJpQB-eSLLyGETvi54jeCaWA@mail.gmail.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Feb 09, 2023 at 03:05:53PM +0530, Ankit Kumar wrote:
> Hey Keith,
> 
> Sorry for delaying this.

It's no problem. This one targets io_uring_cmd ioengine rather than xnvme, so
this merely overlaps with your pending changes.

> I recently added a few more checks inside fdp_support, and a way to
> get reclaim unit size for the current fdp configuration.

I'm actually wondering what the point of the checks are. If fdp isn't supported
it'll fail the io-mgmt-recv, which is as good a check as any. The identify and
directives checks are just redundant and make up the bulk of the patch size.
Let's just get rid of it?

> The reclaim unit size will come in handy as we improve the fdp section of FIO.
> I also figured a way to fetch all the available reclaim unit handle
> descriptors instead of 1024.

Nice.
 
> Hope its ok, if I send a v2 on top of this and you can look at it. I
> am not sure how much the fdp specific section of code
> has diverged as those were missing here (fdp.c and fdp.h).

Oops, my mistake. I'll send that out shortly.
