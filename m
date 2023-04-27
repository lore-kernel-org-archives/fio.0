Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 011A4C77B61
	for <fio@archiver.kernel.org>; Thu, 27 Apr 2023 18:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244587AbjD0SjK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Apr 2023 14:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244588AbjD0SjI (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Apr 2023 14:39:08 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4A11FD0
        for <fio@vger.kernel.org>; Thu, 27 Apr 2023 11:39:07 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-32d3c48634bso1103215ab.0
        for <fio@vger.kernel.org>; Thu, 27 Apr 2023 11:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682620746; x=1685212746;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TO1sAe3eiXpeWBcy47qlYZ8czj+gzM5KKe+5XKJU9Wo=;
        b=LZnRaZCOWwHXO0HIMPb2XZMd7KmM0T/AeCqKoh870pgEJODJdoA1g0CxlRMiwZbGca
         CCwnbDOVd13HCA8QlF2cyz9+FrqK6EJqsTde9feOiokLqFXmT5yAhAAo+qqJKnMF8kVG
         xCsZY3ag5srWvOPolTs2eyUjaUvice0ipZDj86ZjPP5dQSvRE3pn9nYd2amNmhyM3AmD
         PtMz67sXW5Na48piUag3m1DyaBxl+A8PRCSjWv/ePho7C8sf0qxEvpGX75mjkTABACSJ
         0KnR6hGc2SwFyc1LORgPzSbBpM5MIYGMeN5YzuOIv4O+m+PYJC6ybxTIN8uqmQKTAwix
         wy1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682620746; x=1685212746;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TO1sAe3eiXpeWBcy47qlYZ8czj+gzM5KKe+5XKJU9Wo=;
        b=fXiBZ2MWaH+tWYckDE6Nz6hLv622/Bzh4jIhp0X/h4Rw5CMOq+mvVJDb+xuOnGiWYC
         1jaR/srAnFZhDhI1+riz3HGtIEvB9MyiJXr7jEDL15XqVhNCLE5PQEN3FUI5n6y/MpMe
         SmSZWXo5sNuSvum8SDoSZCxStS4oAjwJ8zfTqWqgM6LuoeUfXiQb2ZJzcnOW5cObkTlw
         dIGM3TsWnYwzki9V2A8KLkfFsYAvm6TsJE+cuWg9LXiNSHf4AKIB6/a900FBb7rVh746
         B/90waFa0ibW0BKAwykOije6V4vZaT1Y0HZ1y2wKXbCA84o4jAM8XmQjIld2BIhmc3bY
         vnAA==
X-Gm-Message-State: AC+VfDwC7dt9AJzGkOsEBr69Vn5wz3ClcwXA7dmHOL80O19ht0qHEAms
        ZOHm6UvtR7lKcKj9iI7OE+boVKMXpKFDEG9s1bM=
X-Google-Smtp-Source: ACHHUZ6BEc/qblG61LvoODAbKuGjLGReEUsV2ScX0e+rZkQi5N7Q2aG5QKf5QG23fjhiBFnugHtt5A==
X-Received: by 2002:a92:cd82:0:b0:32c:a864:6eb3 with SMTP id r2-20020a92cd82000000b0032ca8646eb3mr1458564ilb.1.1682620746311;
        Thu, 27 Apr 2023 11:39:06 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id w20-20020a056e0213f400b00313ca4be5e1sm4994047ilj.12.2023.04.27.11.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 11:39:05 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Niklas Cassel <nks@flawful.org>
Cc:     fio@vger.kernel.org, dlemoal@kernel.org,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
In-Reply-To: <20230427092423.605250-1-nks@flawful.org>
References: <20230427092423.605250-1-nks@flawful.org>
Subject: Re: [PATCH] Revert "zbd: Report the zone capacity"
Message-Id: <168262074549.63441.9515396089175819733.b4-ty@kernel.dk>
Date:   Thu, 27 Apr 2023 12:39:05 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-00303
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


On Thu, 27 Apr 2023 11:24:23 +0200, Niklas Cassel wrote:
> This reverts commit 067c18eb3700373d029a9f2795d662453fc09cf4.
> 
> In the Linux zoned block devices API (blkzoned.h) (and in the NVMe Zoned
> Namespace Command Set Specification), the zone capacity can be different
> for each zone (unlike zone size, which has to be the same for all zones).
> 
> In order to not mislead the user to think that the zone capacity has to
> be the same for all zones, remove the zone capacity for zone0 from the
> per device print.
> 
> [...]

Applied, thanks!

[1/1] Revert "zbd: Report the zone capacity"
      commit: 9724b4f5ebf0841087c5a56c1d83efe0f4aeb6d7

Best regards,
-- 
Jens Axboe



