Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.32.201]:62012 "EHLO mail.cs.umn.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbbGIDKp (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 8 Jul 2015 23:10:45 -0400
Received: from mail-vn0-f46.google.com (mail-vn0-f46.google.com [209.85.216.46])
	by mail.cs.umn.edu (Postfix) with ESMTPSA id 62D0D3DEF4F
	for <fio@vger.kernel.org>; Wed,  8 Jul 2015 21:54:43 -0500 (CDT)
Received: by vnbg129 with SMTP id g129so26823819vnb.11
        for <fio@vger.kernel.org>; Wed, 08 Jul 2015 19:54:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEg8mkz7MdEjZHukGX4AiaMF4hGKVPYcX3U3xszqAjjSFYEL4Q@mail.gmail.com>
References: <CAEg8mkz7MdEjZHukGX4AiaMF4hGKVPYcX3U3xszqAjjSFYEL4Q@mail.gmail.com>
From: Alireza Haghdoost <alireza@cs.umn.edu>
Date: Wed, 8 Jul 2015 21:54:03 -0500
Message-ID: <CAB-428mD-eRWaEPCJ3fW4DYZG-ZjSdpZn=r=aVcWOMUCL-CK4A@mail.gmail.com>
Subject: Re: ask a question about fio
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: john gong <johngong0791@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Just define 4 jobs with these access patterns in a job file.

On Wed, Jul 8, 2015 at 8:55 PM, john gong <johngong0791@gmail.com> wrote:
> hello All,
>
> I wonder whether FIO can do below things in the same job?
> 1) sequential write
> 2) sequential read
> 3) randomly write
> 4) randomly read
>
> Namely FIO do not need to spawn other processes to do the things respectively.
> All things will be done in the same process.
>
> Thanks in advance!
>
> John.Gong
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
