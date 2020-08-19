Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728493AbgHSM4T (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Aug 2020 08:56:19 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3B0C061345
        for <fio@vger.kernel.org>; Wed, 19 Aug 2020 05:56:13 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id k8so2098560wma.2
        for <fio@vger.kernel.org>; Wed, 19 Aug 2020 05:56:13 -0700 (PDT)
Date: Wed, 19 Aug 2020 15:56:09 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] zbd: remove reset_zone flag from fio_zone_info
Message-ID: <20200819125609.GA278226@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: dmitry.fomichev@wdc.com
Cc: fio@vger.kernel.org

> The reset_zone flag that is defined in fio_zone_info structure is
> only referenced in zbd_adjust_block() function. Convert this flag
> to a local variable and save some room in zbd_info array which can
> be pretty large when running fio against high capacity zoned devices.

This flag should be kept.

Test can crash or be interrupted leaving hw in indeterminate state,
it must be restarted from clean state. Or test can be precondition and
zone should not be reset.

Can't distinguish these two cases from write pointers alone.

Given that precondition and real workload can be in different fio
instances, this information must be somehow given to fio process
and either force or not force zone reset (config option obviously)

> @@ -41,7 +40,6 @@ struct fio_zone_info {
>  	enum zbd_zone_type	type:2;
>  	enum zbd_zone_cond	cond:4;
>  	unsigned int		open:1;
> -	unsigned int		reset_zone:1;

Does it save space? Bitfields stick together after all.

