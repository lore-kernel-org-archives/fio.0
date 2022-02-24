Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A16CC433EF
	for <fio@archiver.kernel.org>; Thu, 24 Feb 2022 02:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiBXC55 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 23 Feb 2022 21:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiBXC5z (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 23 Feb 2022 21:57:55 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0CE175829
        for <fio@vger.kernel.org>; Wed, 23 Feb 2022 18:57:26 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id y4so729480vsd.11
        for <fio@vger.kernel.org>; Wed, 23 Feb 2022 18:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=1W5EcfpUTXgOIe7zwS9NHyG9f5bh83Jeq7sr0UNp3vI=;
        b=YT564xAq2/KVMaZoU1iEjkCTE/qzB2RLCQa+P/I4IJHvyvRBJ8zwkEZUhJ3ujuCB51
         CUCQfe0Lky7tGG6g6VH8+DKE0+Dl/vTx/AphzeHXVg90glbppTJIunBn77273/2FNsbG
         S2CIPFT8zHs3cSQuDShY5k+pX22r1uP9mOXRYqDFVXlESQE/+LiieRy6iylOrZDeDiiJ
         fmm4AJUriW1x8Cp2JUj7UHbzFBW1U1grewGXuatmSx9J7HWF+BnnAEOmrr/V2JuWS/iC
         QGGIICI/RjYBhCfUK4q6gWiifJ31oiaOdXmoZQoRNyBpkfLvmIAOOykarUhsoGnvnA6Y
         jAzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=1W5EcfpUTXgOIe7zwS9NHyG9f5bh83Jeq7sr0UNp3vI=;
        b=pBFrGFBNcY/u4y/Z/zG3qE/YFJE+8ZTcYsQIBdWcQeQ6N9PmAskaCrC7/sMkb21KCE
         ZWqtezWeu2reXHHISwjWM3dP+5Qq0a5wIUEAOuB0wzeXNIERWwXCEi2ePkz9I0M2QYwU
         9fHO+VcxjrwFnXeiofogk+qxm9BDcnYiqwhtifnBmcKxC847+oTmzgL7EFHdsaMW7v0t
         +ENia3/qvyLQa/DIEmNasPMopDeYz6t7raAK671XGn3FiM3LTSSus/kzf9TuAqlxZ8RH
         1CndrolpD72ZK1Xgv/mjyIyapETRbHibkQ5G4DhXPfcs0cKekzSqlJX9MH6scR6u+Sgc
         JuUw==
X-Gm-Message-State: AOAM5304z/2LLZhG7G7JRN4PiIyrpyk2dDPcvvJn63JNaJWaktTeW+bb
        5qByZg+Awa/UJkxNnNV6FrS+15VeP5/PfxPxoFn42Eg1RCU=
X-Google-Smtp-Source: ABdhPJyZB9TqE/SU+P/0ktSh1yKUsaOCwdWBeTUYdDYf39rBHLu3//7958pxcBbL3+pdREFR9XE3XDkMXiwXduuUoEo=
X-Received: by 2002:a67:6744:0:b0:31c:1f10:e93c with SMTP id
 b65-20020a676744000000b0031c1f10e93cmr256192vsc.30.1645671445682; Wed, 23 Feb
 2022 18:57:25 -0800 (PST)
MIME-Version: 1.0
References: <85D5B403-3D47-4F56-809F-E26BE4ECDB18@gmail.com>
In-Reply-To: <85D5B403-3D47-4F56-809F-E26BE4ECDB18@gmail.com>
From:   Lam Nguyen <lamnguyen3801@gmail.com>
Date:   Wed, 23 Feb 2022 21:57:14 -0500
Message-ID: <CAPWcSwsEH0A8v-YG4v6-RNCHy-=f+uacccd2uGf=zFr1OHEX=A@mail.gmail.com>
Subject: Fwd: Replay IO on Windows - failed to flush file buffers
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Replay IO on Windows with error failed to flush file buffers

Hi,

I am having an issue when I verify the previous write job on Windows.
I got an error saying that windowsaio failed to flush file buffers.
When I look at the fio output, there is an error saying Permission
denied.
I'm using FIO 3.27 running on a Windows instance. At first, I write to
a volume and save the data to writeiolog, then I copy the content of
the writeiolog to a readiolog and replace write by read. The readiolog
is used to replay and verify the IO.

It is not running on either the local drive or the drive that has boot volume.

Can someone help me troubleshoot this issue?
Thank you!

Best regards,
Lam Nguyen
