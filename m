Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3946BC3527A
	for <fio@archiver.kernel.org>; Wed, 15 Dec 2021 16:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244070AbhLOPpv (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 15 Dec 2021 10:45:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244074AbhLOPpt (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Dec 2021 10:45:49 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CA2C061574
        for <fio@vger.kernel.org>; Wed, 15 Dec 2021 07:45:49 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id x6so30634901iol.13
        for <fio@vger.kernel.org>; Wed, 15 Dec 2021 07:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=DITgblAHr4x/drN8g01w0JKuMwELWQkOKnVkj5VOJik=;
        b=iz7dKui5/V3csgj/fduLNXYZsFAbeLr2IGUEMoKG9uedxZ9JgxmHzzXYabAK3wMLj4
         JRDTK4K774QrCOKIO8gEItQrXoD8X8v+7PdEYsJhvbJmx1YgJ+uE4Fj0eDIvcJKKjKxD
         OIzucHPC6ITODrQMHZ1eNVhIHnTC7gIGVHJk2mswg4hf/xFj3sqHVPQ48sktUJ1MN/bu
         Q/6Jp29K2UTmuqe5dPqxKLflqPqV74DRcybr9oXZbrZLd+h9+ZPHzI/uslsy3PKf2s84
         htyP6m21F2gbCSmNYyZvURrLXw+nz6v6m9BxGE21d+0jD1MEfzccMQytEnifCuoQ7Nhe
         Tixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=DITgblAHr4x/drN8g01w0JKuMwELWQkOKnVkj5VOJik=;
        b=cKTIQh3VJapxoSfqgqCoWRHD2fsSVD2RaKS60Y/vewGRuKclH6WqS/J8pI8X6JA8Fo
         Hss+2gQfJhdQMQRyPFvbMZBnILFIdcVjwspVvCox9MVKcG7gRcHI/CLNmIhnlhKiEMpv
         73yBcuBpd8z/QDo/3H0NpP6rRCFKrhDtUyy0MX4omYsx+qe5MaLPSEv+nx9Fw4alG19p
         HCVhc9i6E0ao4Hqq57+dz56N4QFZqOEibCA8Izh4Wj8//tTOqqar7fxXLz45rd/OFDAg
         ky8U8s+LrROHzEQXbR+K4xLhK3GXu5b4DII6F9dAlCq/DLLAdo/Cu8uQT9M99vUH2AGU
         MAEw==
X-Gm-Message-State: AOAM533AGNGCNK4NLCVvd5vJhwoRkzWxnDjIuU1WGsNcEVRquugF9fXb
        o/+GRQbOJjnTBzA1cAIqYRfRorGAo4ic8w==
X-Google-Smtp-Source: ABdhPJzN9UjamV2NZXkOYXIUofQMlIBw4No2yqXOIQ/v3PwAYhAYrs6sYhi4gIYIUTp1Asnhk8NJ+g==
X-Received: by 2002:a05:6638:16c5:: with SMTP id g5mr6055618jat.11.1639583148471;
        Wed, 15 Dec 2021 07:45:48 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x13sm1044272ilp.43.2021.12.15.07.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 07:45:48 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     fio@vger.kernel.org
In-Reply-To: <20211215122557.95600-1-Niklas.Cassel@wdc.com>
References: <20211215122557.95600-1-Niklas.Cassel@wdc.com>
Subject: Re: [PATCH] stat: sum sync_stat before reassigning bool first
Message-Id: <163958314734.9796.16913238186742902878.b4-ty@kernel.dk>
Date:   Wed, 15 Dec 2021 08:45:47 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, 15 Dec 2021 12:26:04 +0000, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Currently, sum_stat(&dst->sync_stat, &src->sync_stat, first, false)
> is called after the summing the stats on a per ddir level.
> 
> The for-loop that sums the stats on a per ddir level will reassign
> bool first to false when unified_rw_rep is used.
> 
> [...]

Applied, thanks!

[1/1] stat: sum sync_stat before reassigning bool first
      commit: e86afa536b175a90546e20d7d19f2418ee1bca78

Best regards,
-- 
Jens Axboe


