Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7133EC04A6A
	for <fio@archiver.kernel.org>; Wed,  9 Aug 2023 14:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbjHIOyp (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 9 Aug 2023 10:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbjHIOyp (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Aug 2023 10:54:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDBCDC
        for <fio@vger.kernel.org>; Wed,  9 Aug 2023 07:54:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 505AD63D1E
        for <fio@vger.kernel.org>; Wed,  9 Aug 2023 14:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C9BC433C7;
        Wed,  9 Aug 2023 14:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691592883;
        bh=6MMmMelZD6HUbEDuNBnEJMDxlvwCVfuQA436UMGchlc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lPqpg8N8jkqv6UTjXTAP3cpUMAV4lS/gsU6QJp5nh29HIs7reICEvBWWpQ3g4BWpG
         Jq4Xsh8V50D74jqra1cZs2JY9oEifhSc901wdgZNnQHBLmi/Fy+slebHZfGnCqF4eP
         3JqmSLJjcOJkqW7Nyq4ihYOP/u3Lj5qmOxYRxRIxXF55OY3eKnZ4ZZOfbyLjnnrFej
         pSxfF4yV6nHMtkvN6n5ltrQHdHgvLIRqL8kubvvkuw0TbP6IsiGrLmwK94rbAOjFJT
         HcZKBST0Rr8cvp7dck0i91pg70QXiqMyHmPlxL5fkX4hd08vErir0rvQfzQj8NkKIe
         UG+CC0B2vgJBg==
Date:   Wed, 9 Aug 2023 08:54:40 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Ankit Kumar <ankit.kumar@samsung.com>
Cc:     axboe@kernel.dk, vincentfu@gmail.com, fio@vger.kernel.org,
        joshi.k@samsung.com, martin.petersen@oracle.com
Subject: Re: [PATCH 08/10] crc: pull required rocksoft crc64 apis from linux
 kernel
Message-ID: <ZNOosEhtV/H3ZuQt@kbusch-mbp>
References: <20230809111314.76947-1-ankit.kumar@samsung.com>
 <CGME20230809055423epcas5p3dc7782753e9e60522b4adc749edc8426@epcas5p3.samsung.com>
 <20230809111314.76947-9-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809111314.76947-9-ankit.kumar@samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, Aug 09, 2023 at 04:43:12PM +0530, Ankit Kumar wrote:
> Pull the required rocksoft crc64 apis from the linux kernel. This
> is required to generate and verify 64 bit guard tag for nvme backend
> of io_uring_cmd ioengine.

Just FYI, the table from the spec is named "64-bit CRC Rocksoft", but
that's only refering to the way the parameters are presented. This crc
is actually called "NVMe 64b CRC", and I messed up when submitting the
equivalent to linux kernel.
