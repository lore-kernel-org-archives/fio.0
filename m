Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A8FC77B7E
	for <fio@archiver.kernel.org>; Thu, 27 Apr 2023 18:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244273AbjD0SjL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Apr 2023 14:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244589AbjD0SjJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Apr 2023 14:39:09 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829B819C
        for <fio@vger.kernel.org>; Thu, 27 Apr 2023 11:39:08 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id e9e14a558f8ab-32b625939d4so3470475ab.1
        for <fio@vger.kernel.org>; Thu, 27 Apr 2023 11:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682620748; x=1685212748;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Os7BtORo0Njqh9cuKink/KCtoV1m3eTGiS8cLXO8/w=;
        b=cUtN2ekb+lZJSWHHCV3ZdISZDblwfedqck6kkt7STRhAQOfSPCIYmnVlIzhh8okcAo
         gFy+YXR8pQ5SNIYUVaQSOY+k1oIsfFcNAmHRvJXDuq2T33tvGZCLYO0YM/025HJn3wYD
         EAzP968K3wF7P6gxSwzEkr8ov3n1GCS21acRXkd6UyIpg2T1wdhcouoPEZIqr6EW2OwC
         vCPpPMQs4+IqU6oIAC5QPz5/XxpL9soPRMT4TRymcQSU0SOIva3w96hIG4dVrcZcbGRT
         VsDhwFBP8Cy6T8C4tkJZXFpS+8yGE1c82G7ROjnnEGrWi2FTMRGrDcUE5b3nO9uXaapq
         ZaqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682620748; x=1685212748;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Os7BtORo0Njqh9cuKink/KCtoV1m3eTGiS8cLXO8/w=;
        b=ca6cDX5I/43dzJPMPrEI2GRvycceorYafNf1Nj3FWagqs+BzQ756Dt5WJ4UAb0NtVi
         XsJe1nB0hZqD0by1unzSXxHMI+QZROvZlhwzf5Xrnc3rAP2W5Kb9QsPAREE7nP8+lWsr
         7LXnqkuyEvawtiO3iWbeBopE5mDKISzVSzvi+TBOb1G/l4SI+Zh0wTJOOrnBYZXYHn+n
         jA2NfYpeUYgjiQuIiwI2t/kiqd8CtciIjglkx++KNeYbj3Zu8rvTmura0G4MQjUAOO0s
         Yf9aQjnJvtDnSlRp2Ji5u4y7oDbk4+PJLt2wMqmy/plZ4VZHiVPCaH6qI8O+uUQam3kO
         dGnQ==
X-Gm-Message-State: AC+VfDzn+/XYd7+D2KxEnhIXl2wLyJ6zwwmg5rCKixY1xRpFa51eDlI0
        6IPkj/kz+0Ym6C5Vo+cWwEj18w==
X-Google-Smtp-Source: ACHHUZ6V2pUH1mGJpm/VpWEqG8jpps375jGH25PGntVhUhcz1DfjHbm3tuVco9uxf6PJ677gDmBqmA==
X-Received: by 2002:a05:6e02:1d1d:b0:32a:dbbf:5707 with SMTP id i29-20020a056e021d1d00b0032adbbf5707mr1575083ila.0.1682620747884;
        Thu, 27 Apr 2023 11:39:07 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id w20-20020a056e0213f400b00313ca4be5e1sm4994047ilj.12.2023.04.27.11.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 11:39:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Anuj Gupta <anuj20.g@samsung.com>
Cc:     vincent.fu@samsung.com, fio@vger.kernel.org,
        ankit.kumar@samsung.com, anuj1072538@gmail.com
In-Reply-To: <20230427194415.1160701-1-anuj20.g@samsung.com>
References: <CGME20230427142401epcas5p1613b998c03d8f635c6942d92c7ae7ee0@epcas5p1.samsung.com>
 <20230427194415.1160701-1-anuj20.g@samsung.com>
Subject: Re: [PATCH] t/io_uring: avoid null-ptr dereference incase
 setup_ring fails
Message-Id: <168262074642.63441.2248159527671257871.b4-ty@kernel.dk>
Date:   Thu, 27 Apr 2023 12:39:06 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-00303
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


On Fri, 28 Apr 2023 01:14:15 +0530, Anuj Gupta wrote:
> s->sq_ring.ring_entries and s->cq_ring.ring_entries will be NULL,
> incase setup_ring fails. This will cause a segmentation fault. Avoid
> dereferencing them in such a scenario.
> 
> 

Applied, thanks!

[1/1] t/io_uring: avoid null-ptr dereference incase setup_ring fails
      commit: bea469e86ba2bd4a5b6a5af18455b0b01da2b67b

Best regards,
-- 
Jens Axboe



