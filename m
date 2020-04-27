Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbgD0SpE (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 27 Apr 2020 14:45:04 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CC4C0610D5
        for <fio@vger.kernel.org>; Mon, 27 Apr 2020 11:45:03 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id i10so21764119wrv.10
        for <fio@vger.kernel.org>; Mon, 27 Apr 2020 11:45:03 -0700 (PDT)
Date: Mon, 27 Apr 2020 21:45:00 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 5/5] zbd: Introduce thread zbd operations
Message-ID: <20200427184500.GA29918@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: damien.lemoal@wdc.com
Cc: fio@vger.kernel.org

> -	if (td->o.zone_mode == ZONE_MODE_ZBD) {
> -		ret = zbd_adjust_block(td, io_u);
> -		if (ret == io_u_eof)
> -			return 1;
> -	}
> +	ret = zbd_adjust_block(td, io_u);
> +	if (ret == io_u_eof)
> +		return 1;

This is cleaner code but probably won't result in performance changes
because it is trading a branch and a regular function call to a branch
and indirect function call.

