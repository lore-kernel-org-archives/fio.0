Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D49C61DA4
	for <fio@archiver.kernel.org>; Thu,  9 Feb 2023 16:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBIQtz (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Feb 2023 11:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbjBIQty (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Feb 2023 11:49:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E135B75F
        for <fio@vger.kernel.org>; Thu,  9 Feb 2023 08:49:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 549CFB82235
        for <fio@vger.kernel.org>; Thu,  9 Feb 2023 16:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366F5C433EF;
        Thu,  9 Feb 2023 16:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675961390;
        bh=9c3Y/4AxUo68wFSr4u1oUpuqDmQFbqwlWOnJzK3zSrE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZpKkTDFcDAwZLJRzZgzbeSGRJ2hGHl69czs7kSaCM08XS0s2R5q+KcgQbxdF0+8lE
         DBO1351PRvE2KFcYrPWVd97CPEmFMGqB170m5T1P5jRN99kNQA5xqmFr24sboNX343
         6dbnhMZDm+0vimDiYLXDB2vGPgr1oa8BnMtl7qC8wKv5TqlCCTQ8RL2bcDJzY3bPDo
         o6BDwOEXcKIQwP0ESahw4oSOC1KMuYUhMXax9SJZUE4A/rEaxDt1Bd88VRuIrp2xHy
         FjQyKntsVgdxLRseM7odbOXGW0cxQRfzk+1SM8zHirSA6gpM+sLCChENZ+5KvTNTaB
         hPo4YeSlS8GIA==
Date:   Thu, 9 Feb 2023 09:49:47 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Keith Busch <kbusch@meta.com>, fio@vger.kernel.org,
        axboe@kernel.dk, its@irrelevant.dk,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: Re: [PATCH] fio: add nvme fdp support for io_uring_cmd engine
Message-ID: <Y+UkK+ZWS3gH1a1+@kbusch-mbp.dhcp.thefacebook.com>
References: <20230208222023.895024-1-kbusch@meta.com>
 <29a27af4-f74a-5e80-f1f0-41fcd4fb6d4f@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29a27af4-f74a-5e80-f1f0-41fcd4fb6d4f@opensource.wdc.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Feb 09, 2023 at 09:59:00AM +0900, Damien Le Moal wrote:
> On 2/9/23 07:20, Keith Busch wrote:
> 
> > diff --git a/io_u.h b/io_u.h
> > index 206e24fe..13b26d37 100644
> > --- a/io_u.h
> > +++ b/io_u.h
> > @@ -117,6 +117,9 @@ struct io_u {
> >  	 */
> >  	int (*end_io)(struct thread_data *, struct io_u **);
> >  
> > +	uint32_t dtype;
> > +	uint32_t dspec;
> 
> Nit: may be call these fdp_dtype and fdp_dspec to clarify these are for fdp ?

These could also be used for stream ids since they occupy the same space in an
nvme command, so the generic name sounded "ok". But perhaps no one cares about
such use cases...
