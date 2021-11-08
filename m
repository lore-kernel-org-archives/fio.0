Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48169C433F5
	for <fio@archiver.kernel.org>; Mon,  8 Nov 2021 13:24:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3018061361
	for <fio@archiver.kernel.org>; Mon,  8 Nov 2021 13:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239937AbhKHN1k (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 8 Nov 2021 08:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239934AbhKHN1j (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 8 Nov 2021 08:27:39 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4003C061570
        for <fio@vger.kernel.org>; Mon,  8 Nov 2021 05:24:55 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id c3so5430864iob.6
        for <fio@vger.kernel.org>; Mon, 08 Nov 2021 05:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=IRLldTKGcFKLhAgz/2EhTOsQy1im184GWnEFdKIjhF0=;
        b=6c2uUbRChnQKYdGxueFc+6aryfLYkkclmbVoPn+U2Gam47U2fU6ArSecIWoRRO7N20
         An/I8K4BQzjI37JLksD6ESTODTB4uWPMwhalV759YjxCQsO/j+GVtrbFmmofOU+DiErJ
         W93Zbe86CRjGfnVNKstSdpavUT8bVJifQHR1gM3H6fj/VFksjEnGTsiKvWlsMOHpm93C
         vd5ewXQJ2KjrQl+56md+sXQOcRW/cYX+XfKyI14MnXRHPUMOGt6Hl5Lmp2TZ0/G30Ioq
         Estr29WtWJt3DFrcgn9O0geijDukHOy0CmSbyu9mjaWpH0XhXscmIy5qC3kPdHONfkBs
         9xUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=IRLldTKGcFKLhAgz/2EhTOsQy1im184GWnEFdKIjhF0=;
        b=GkwuGsHlKiJEAozZ/qtavGMY1X8xm/BdFnn/WzT0VJWRRpKxnMZTIwGCMjACH9QSs3
         gfZB5PAVrOfVUP4r3TvrfeRk2mP+i4183xjMsY+aedQsxbbpBdifYjMcdU3/LOCrGMkB
         EiHgrqLujKnBSBEP19oxgxIMin5ss/Ie7I00fbi6EwJ0ORPnJjrWVeJtxIbkUhncXI+3
         OAdjG8L8vRQOZLUnyJrz9fLzQ1HI8O3sI7i1ZXauvmVVVADtnlJrRuRnNwgcfHM7EchW
         TN4T4OSDQmTddutQF6VWYllCOnTTUVemIrwYPMOh16yHvOFZgiCfNuSTVdN8+k/kEazT
         qLew==
X-Gm-Message-State: AOAM531K45q879iK89VsZhK7an9mWqZeVi7NQZtADBh7sWc50tJAcW8N
        /Z8Y5lMQv/Oi5c/RDVxMtS1UO0i7gLG2og==
X-Google-Smtp-Source: ABdhPJxlaoUl3LSTfwBeVxc8Xz523racZ3Eq5nnaovGhBkKh6lp2p2Gc4HBgnu+3JSXYNBPGWbosSQ==
X-Received: by 2002:a05:6602:3c2:: with SMTP id g2mr13220482iov.1.1636377894912;
        Mon, 08 Nov 2021 05:24:54 -0800 (PST)
Received: from [127.0.1.1] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id m10sm9962166ila.13.2021.11.08.05.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 05:24:54 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>, fio@vger.kernel.org
In-Reply-To: <20211108131143.80158-1-Niklas.Cassel@wdc.com>
References: <20211108131143.80158-1-Niklas.Cassel@wdc.com>
Subject: Re: [PATCH] stat: create a init_thread_stat_min_vals() helper
Message-Id: <163637789309.316137.11821147634914478848.b4-ty@kernel.dk>
Date:   Mon, 08 Nov 2021 06:24:53 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Mon, 8 Nov 2021 13:12:09 +0000, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Create a init_thread_stat_min_vals() helper so that we can remove
> duplicated code.
> 
> 

Applied, thanks!

[1/1] stat: create a init_thread_stat_min_vals() helper
      commit: 6619fc32c413c4ff3a24c819037fb9227af3f876

Best regards,
-- 
Jens Axboe


